NAME=SourcePath
PKG_NAME=SourcePath
REPO_NAME=hoefkensj/sourcepath

SRC=src/${NAME}
OPT=/opt/local/scripts/bash/$(NAME)
DST=$(find /etc/ 2>/dev/null |grep bashrc.d$  2>/dev/null)
VER=0.67

install:
	chmod 664   $(SRC)/$(NAME)-$(VER).sh
	install -Dv $(SRC)/$(NAME)-$(VER).sh  $(OPT)/$(NAME)-$(VER).sh
	ln -sv $(OPT)/$(NAME)-$(VER).sh  $(OPT)/$(NAME).sh
	ln -sv $(OPT)/$(NAME).sh  $(DST)/$(NAME).sh



uninstall:
	rm -v $(DST)/$(NAME).sh
	rm -v $(OPT)/$(NAME)-$(VER).sh
	rm -v $(OPT)/$(NAME).sh