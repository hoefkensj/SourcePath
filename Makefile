NAME=SourcePath
PKG_NAME=SourcePath
REPO_NAME=hoefkensj/sourcepath

SRC=src/$(PKG_NAME)
OPT=/opt/local/scripts/bash/$(NAME)/

RCD=/etc/bash/bashrc.d/
VER=0.67

RCD_EXISTS := $(shell [ -d "$(RCD)" ] && echo "yes" || echo "no")

checkrc:
	echo "checkrc"
	ifeq ($(RCD_EXISTS),yes)
		echo "$(RCD) found"
		DST=$(RCD)
	else 
		echo "$(RCD) missing"	
		DST=$(shell fixrc.sh)
		echo " using : $(DST)"
	endif

install: checkrc
	echo "installing"
	chmod  -v 664 $(SRC)/$(NAME)-$(VER).sh
	install -Dv $(SRC)/$(NAME)-$(VER).sh $(OPT)/$(NAME)-$(VER).sh
	ln -sv $(OPT)/$(NAME)-$(VER).sh $(OPT)/$(NAME).sh
	ln -sv $(OPT)/$(NAME).sh $(DST)/$(NAME).sh

uninstall: checkrcd
	rm -v $(DST)/$(NAME).sh
	rm -v $(OPT)/$(NAME)-$(VER).sh
	rm -v $(OPT)/$(NAME).sh
