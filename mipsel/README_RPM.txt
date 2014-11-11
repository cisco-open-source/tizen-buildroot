
=============================
	Known Issues
=============================

---------------------------
1. LibCap RPM build
---------------------------
Libcap tries to build and install pam_cap library. 
In case when pam_cap has been installed previously needs to skip its compilation.
As workarround please move file 
/usr/include/security/pam_modules.h 
to some temporary folder, build LibCap and then move pam_modules.h back to 
original location.
