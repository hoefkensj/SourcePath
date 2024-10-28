NAME=SourcePath
PKG_NAME=SourcePath
REPO_NAME=hoefkensj/sourcepath

SRC=src/$(PKG_NAME)
OPT=/opt/local/scripts/bash/$(NAME)

DST=/etc/bash/bashrc.d
VER=0.67



checkrc:
	DST=$(shell ./fixrc.sh)

install: checkrc
	echo "installing"
	chmod  -v 664 $(SRC)/$(NAME)-$(VER).sh
	install -Dv $(SRC)/$(NAME)-$(VER).sh $(OPT)/$(NAME)-$(VER).sh
	ln -sv $(OPT)/$(NAME)-$(VER).sh $(OPT)/$(NAME).sh
	ln -sv $(OPT)/$(NAME).sh $(DST)/$(NAME).sh

uninstall: checkrc
	rm -v $(DST)/$(NAME).sh
	rm -v $(OPT)/$(NAME)-$(VER).sh
	rm -v $(OPT)/$(NAME).sh
