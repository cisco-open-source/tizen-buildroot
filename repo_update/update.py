#
# Copyright (C) 2009 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from __future__ import print_function
import sys
import os
import xml.dom.minidom
import itertools

from command import Command, MirrorSafeCommand
from project import Project
from git_command import git, GitCommand
from git_refs import HEAD


def print_with_number(num, message, project_name):
  print("[", num, "] ", message, project_name)


class ProjectUpd(object):

  def __init__(self,
               project,
               current_sha1,
               old_sha1,
               new_sha1):
    self.project = project
    self.current_sha1 = current_sha1
    self.old_sha1 = old_sha1
    self.new_sha1 = new_sha1

class Update(Command, MirrorSafeCommand):
  wrapper_version = None
  wrapper_path = None

  common = True
  helpSummary = "Update repo to new manifest and rebase your changes"
  helpDescription = """
Each snapshot should be marked by tag in each repository. '%prog' compare old_tag with new_tag and current tizen-ua branch for each project and then one of the following action is performed:\n
  * for projects without our changes repo just moves tizen-ua branch to version as in new manifest;\n
  * for projects where are only our changes repo does nothing;\n
  * for projects where are both our changes and changes made by Tizen repo rebases our changes (or performs git rebase onto if old and new revision of project placed on different branches );\n
  * for projects where current tizen-ua branch is not on top of old_tag repo just moves tizen-ua branch to version as in new manifest;\n
Actually for each repository temporary branch (by default '_upd_tzn_') is created and repo update do all work with this branch. repo update --push command push this branch into tizen-ua branch on server.
If for some reason need to update some project manually you could do all merging in temporary branch (_upd_tzn_) and then repo update --push command push your changes with other projects.
"""

  def _Options(self, p):
    p.add_option('-b', '--branch',
                 dest='branch', action='store',
                 help='current working branch with your changes',
                 default = 'tizen-ua',
                 metavar='BRANCH-NAME')
    p.add_option('-t', '--temp-branch',
                 dest='tmp_upd_branch', action='store',
                 help='temporary local branch needed for update repos',
                 default = '_upd_tzn_',
                 metavar='BRANCH-NAME')
    p.add_option('-r', '--remote',
                 dest='remote_name', action='store',
                 help='name of current remote',
                 default = 'tizen-update',
                 metavar='REMOTE-NAME')
    p.add_option('-o', '--old-tag',
                 dest='old_tag', action='store',
                 help='tag of previous snapshot',
                 metavar='TAG-NAME')
    p.add_option('-m', '--mark',
                 dest='mark', action='store',
                 help='only add tag with given name for new snapshot',
                 default = '',
                 metavar='TAG-NAME')
    p.add_option('-n', '--new-tag',
                 dest='new_tag', action='store',
                 help='tag of new snapshot',
                 metavar='TAG-NAME')
    p.add_option('-v', '--verify',
                 dest='verify', action='store_true',
                 help='don\'t upgrage only check if there is unmerged changes and some packages weren\'t updgraded')
    p.add_option('-s', '--statistic',
                 dest='statistic', action='store_true',
                 help='show statistic about repos')
    p.add_option('-p', '--push',
                 dest='push', action='store_true',
                 help='push merged repositories to server')
    p.add_option('-g', '--push-tag',
                 dest='push_tag', action='store_true',
                 help='push tag to the server (use only with --mark)',)

  def _MakeProjectList(self, old_tag, new_tag):
    for project in self.projects:
      current_sha1 = self._gitGetExprSHA1(project, self.remote_name + '/' + self.branch)
      old_sha1 = self._gitGetExprSHA1(project, old_tag+"^0")
      new_sha1 = self._gitGetExprSHA1(project, new_tag+"^0")

      projectUpd = ProjectUpd(project, current_sha1, old_sha1, new_sha1)

      self.projectsUpd.append(projectUpd)

  def _UpdateRepos(self):
    print("Total projects to merge:", len(self.projects))
    no_changes = only_our = need_rebase = branch_changed = 0
    counter = 0
    for projectUpd in self.projectsUpd:
      branch_sha1 = projectUpd.current_sha1
      project = projectUpd.project
      old_sha1 = projectUpd.old_sha1
      new_sha1 = projectUpd.new_sha1

      counter = counter + 1

      # no our changes, just move pointer to branch
      if branch_sha1 == old_sha1 or (not old_sha1 and branch_sha1):
        print_with_number(counter, "Moving pointer to branch (no our changes): ", project.name)
        no_changes = no_changes + 1
        self._gitCreateBranch(project, self.tmp_upd_branch, new_sha1)
        
      # only our changes in repo
      if (old_sha1 != branch_sha1) and (old_sha1 == new_sha1):
        only_our = only_our +1
        print_with_number(counter, "Only our changes no need to move branch: ", project.name)
        self._gitCreateBranch(project, self.tmp_upd_branch, branch_sha1)

      if (old_sha1 != branch_sha1) and (old_sha1 != new_sha1) and old_sha1:
        # try to find merge-base
        merge_base_sha1 = self._gitGetMergeBase(project, branch_sha1, new_sha1 )

        if merge_base_sha1 == old_sha1:
          print_with_number(counter, "Need to rebase:", project.name)
          need_rebase = need_rebase +1
          if self._gitCreateBranch(project, self.tmp_upd_branch, branch_sha1):
            self._gitRebaseCurrent(project, new_sha1)
        
        else:
          merge_base_sha1 = self._gitGetMergeBase(project, branch_sha1, old_sha1 )
          if merge_base_sha1 == old_sha1:
            branch_changed = branch_changed + 1
            print_with_number(counter, "Need to rebase onto:", project.name)

            if self._gitCreateBranch(project, self.tmp_upd_branch, branch_sha1):
              self._gitRebaseOnto(project, new_sha1, old_sha1, self.tmp_upd_branch)
          else:
            print_with_number(counter, "Current branch is not on old manifest branch, Moving pointer to new branch despite our changes:", project.name)
            self._gitCreateBranch(project, self.tmp_upd_branch, new_sha1)


    print("Repos we didn't change:", no_changes)
    print("Repos have only our change:", only_our)
    print("Repo require rebasing:", need_rebase)
    print("Branch was changed and we have our commit:", branch_changed)


  def _Verify(self):
    print("Total projects to merge:", len(self.projects))

    not_ready = []
    unchanged = []
    only_our = []
    rebased = []
    bad_merge = []
    branch_changed_2 = []

    for projectUpd in self.projectsUpd:
      project = projectUpd.project
      current_branch = self._gitGetCurrentBranch(project)
      if current_branch != self.tmp_upd_branch:
        not_ready.append(project.name)
      else:
        old_sha1 = projectUpd.old_sha1
        new_sha1 = projectUpd.new_sha1
        branch_sha1 = projectUpd.current_sha1
        tmp_branch_sha1 = self._gitGetExprSHA1(project, self.tmp_upd_branch)
        #no our changes:
        if branch_sha1 == old_sha1:
          if tmp_branch_sha1 == new_sha1 :
            unchanged.append(project.name)
          else:
            bad_merge.append(project.name)
        #only our changes:
        if (old_sha1 != branch_sha1) and (old_sha1 == new_sha1):
          if tmp_branch_sha1 == branch_sha1 :
            only_our.append(project.name)
          else:
            bad_merge.append(project.name)

        #rebased:
        if (old_sha1 != branch_sha1) and (old_sha1 != new_sha1) and old_sha1:
          if (tmp_branch_sha1 != branch_sha1) and (tmp_branch_sha1 != new_sha1) and (tmp_branch_sha1 != old_sha1) :
            rebased.append(project.name)
          elif (tmp_branch_sha1 == new_sha1):
            branch_changed_2.append(project.name)
          else:
            bad_merge.append(project.name)       

    print("Unchanged projects (without our changes): ")
    for project in unchanged:
      print('\t', project)
    print("Total:\t", len(unchanged)) 


    print("\nProjects contain only our changes: ")
    for project in only_our:
      print('\t', project)
    print("Total:\t", len(only_our)) 

    print("\nProjects that was rebased: ")
    for project in rebased:
      print('\t', project)
    print("Total:\t", len(rebased)) 

    print("\nProjects that have changed branch two times: ")
    for project in branch_changed_2:
      print('\t', project)
    print("Total:\t", len(branch_changed_2)) 

    if len(not_ready) > 0 :
      print("\nProjects don't ready to be pushed to server:")
      for project in not_ready: 
        print(project)
      print("Total:\t", len(not_ready))
      print("Probably you need to resolve conflicts and run \"git rebase --continue\" in listen repos")

    if len(bad_merge) > 0 :
      print("Something whent wrong, next projects wasn't properly updated:")
      for project in bad_merge: 
        print(project)
      print("Probably you need to fix this issue and try again") 
    
    if (len(bad_merge) == 0) and (len(not_ready) == 0):
      print("All projects ready to be pushed to server. Use option \'-p\' or \'--push\'")


  def _Statistic(self):
    print("Total projects to merge:", len(self.projects))
    branch_changed_2 = []
    unchanged = []
    only_our = []
    rebased = []
    rebasedonto = []
    undefined = []
    for projectUpd in self.projectsUpd:
      branch_sha1 = projectUpd.current_sha1
      project = projectUpd.project
      old_sha1 = projectUpd.old_sha1
      new_sha1 = projectUpd.new_sha1

      #no our changes:
      if branch_sha1 == old_sha1:
        unchanged.append(project.name)

      #only our changes:
      if (old_sha1 != branch_sha1) and (old_sha1 == new_sha1):
        only_our.append(project.name)
        
      #rebased:
      if (old_sha1 != branch_sha1) and (old_sha1 != new_sha1) and old_sha1:
        merge_base_sha1 = self._gitGetMergeBase(project, branch_sha1, new_sha1 )
        if merge_base_sha1 == old_sha1:
          rebased.append(project.name)
        else:
          merge_base_sha1 = self._gitGetMergeBase(project, branch_sha1, old_sha1 )
          if merge_base_sha1 == old_sha1:
            rebasedonto.append(project.name)
          else:
            branch_changed_2.append(project.name)
      
      if not old_sha1 and branch_sha1:
        undefined.append(project.name)


    print("Unchanged projects (without our changes): ")
    for project in unchanged:
      print('\t', project)
    print("Total:\t", len(unchanged))  

    print("\nProjects contain only our changes: ")
    for project in only_our:
      print('\t', project)
    print("Total:\t", len(only_our))

    print("\nProjects to rebase: ")
    for project in rebased:
      print('\t', project)
    print("Total:\t", len(rebased))

    print("\nProjects to rebase onto: ")
    for project in rebasedonto:
      print('\t', project)
    print("Total:\t", len(rebasedonto))

    print("Project had been removed and then returned: ")
    for project in undefined:
      print('\t', project)
    print("Total:\t", len(undefined))

    print("Project need fix: ")
    for project in branch_changed_2:
      print('\t', project)
    print("Total:\t", len(branch_changed_2))


  def _Push(self):
    print("Total projects to push:", len(self.projects))
    not_pushed = []
    for projectUpd in self.projectsUpd:
      project = projectUpd.project
      current_branch = self._gitGetCurrentBranch(project)
      if current_branch != self.tmp_upd_branch:
        not_pushed.append(project.name)
      else:
        branch_str = self.tmp_upd_branch + ":" + self.branch
        p = GitCommand(project, ['push', '--force', self.remote_name, branch_str],
                    capture_stdout = True,
                    capture_stderr = True)
        if p.Wait() != 0:
          err_msg = p.stderr
          print("Could not retrive current branch info from", project.name, ":")
          print(err_msg, file=sys.stderr)

    for project in not_pushed: 
      print("Not pushed", project)

  def _gitPushTag(self, project, tag_name):
    p = GitCommand(project, ['push', self.remote_name, tag_name],
                    capture_stdout = True,
                    capture_stderr = True)
    if p.Wait() != 0:
      err_msg = p.stderr
      print("Could not push tag for ", project.name)
      print(err_msg, file=sys.stderr)

  def _gitCreateBranch(self, project, branch_name, sha1):
    p = GitCommand(project, ['checkout', '-b', branch_name, sha1],
                    capture_stdout = True,
                    capture_stderr = True)
    if p.Wait():
      err_msg = p.stderr
      print(project.name, err_msg, file=sys.stderr)
      return False
    else:
      return True;

  def _gitRebaseCurrent(self, project, sha1):
    p = GitCommand(project,['rebase', sha1],
                    capture_stdout = True,
                    capture_stderr = True)
    if p.Wait():
      err_msg = p.stderr
      print(project.name, err_msg, file=sys.stderr)
      return False
    else:
      return True;

  def _gitRebaseOnto(self, project, dest_sha1, begin_sha1, end_sha1):
    p = GitCommand(project,['rebase', '--onto', dest_sha1, begin_sha1, end_sha1],
                    capture_stdout = True,
                    capture_stderr = True)
    if p.Wait():
      err_msg = p.stderr
      print(project.name, err_msg, file=sys.stderr)
      return False
    else:
      return True;

  def _gitGetMergeBase(self, project, first_sha1, second_sha1):
    p = GitCommand(project, ['merge-base', first_sha1, second_sha1 ],
                    capture_stdout = True,
                    capture_stderr = True)
    if p.Wait() == 0:
      merge_base_sha1 = p.stdout.rstrip()
      return merge_base_sha1
    else:
      err_msg = p.stderr
      print(project.name, err_msg, file=sys.stderr)
      return ""


  def _gitGetExprSHA1(self, project, expr):
    p = GitCommand(project, ['rev-parse', expr],
                  capture_stdout = True,
                  capture_stderr = True)
    if p.Wait() == 0:
      sha1 = p.stdout.rstrip()
      return sha1
    else:
      err_msg = p.stderr
      print(project.name, err_msg, file=sys.stderr)
      return ""

  def _gitGetCurrentBranch(self, project):
    p = GitCommand(project, ['rev-parse', '--abbrev-ref', 'HEAD'],
                    capture_stdout = True,
                    capture_stderr = True)
    if p.Wait() == 0:
      current_branch = p.stdout.rstrip()
      return current_branch
    else:
      err_msg = p.stderr
      print(project.name, err_msg, file=sys.stderr)
      return ""

  def _gitCreateTag(self, project, tag_name, sha1):
    p = GitCommand(project, ['tag', tag_name, sha1],
                    capture_stdout = True,
                    capture_stderr = True)
    if p.Wait():
      err_msg = p.stderr
      print(project.name, err_msg, file=sys.stderr)
      return False
    else:
      return True;

  def __MarkSnapshot(self, tag_name):
    for project in self.projects:
      print("Add tag ", tag_name, " in project ", project.name)
      self._gitCreateTag(project, tag_name, project.GetCommitRevisionId())

  def __PushTags(self, tag_name):
    for project in self.projects:
      print("Push tag ", tag_name, " for ", project.name)
      self._gitPushTag(project, tag_name)


  def Execute(self, opt, args):
    self.topdir = os.path.dirname(self.repodir)
    self.projects = self.manifest.projects
    self.projectsUpd = []

    self.branch = opt.branch
    self.remote_name = opt.remote_name

    # work with tag
    if opt.mark:
      if opt.push_tag:
        self.__PushTags(opt.mark)
      else:
        self.__MarkSnapshot(opt.mark)
      sys.exit(0)  
    
    # work with update
    if not opt.old_tag and not opt.new_tag:
      print('error: you need to pass old and new manifest to the command', file=sys.stderr)
      sys.exit(1)

    self.tmp_upd_branch = opt.tmp_upd_branch

    print ('{0:20}    {1:10}'.format('Branch for merge:', self.branch))
    print ('{0:20}    {1:10}'.format('Remote server:', self.remote_name))
    print ('{0:20}    {1:10}'.format('Temporary branch:', self.tmp_upd_branch))

    self._MakeProjectList(opt.old_tag, opt.new_tag)

    if len(self.projects) == 0:
      print('error: no project to update, please check current manifest file', file=sys.stderr)
      sys.exit(0)

    if opt.statistic:
      self._Statistic()
    elif opt.verify:
      self._Verify()
    elif opt.push:
      print("push changes to server")
      self._Push()
    else:
      self._UpdateRepos()