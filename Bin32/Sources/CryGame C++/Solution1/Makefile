# visit these subsystems in this order
MODULES =	CryGame \
			
CLEANMODULES = $(MODULES)\
							
all: buildpartsrelease
allclean: buildpartscleanrelease

buildpartsrelease:
	-@for dir in ${MODULES}; do \
		(cd $$dir; mkdir ReleaseLinux32; mkdir ReleaseLinux32O0; ${MAKE} all); \
	done
  
cleanrelease:
	@for dir in ${CLEANMODULES}; do \
		(cd $$dir; ${MAKE} cleanrelease); \
	done

buildpartscleanrelease:
	@for dir in ${CLEANMODULES}; do \
		(cd $$dir; ${MAKE} cleanrelease); \
	done
	-@for dir in ${MODULES}; do \
		(cd $$dir; mkdir ReleaseLinux32; mkdir ReleaseLinux32O0; ${MAKE} all); \
	done
  

