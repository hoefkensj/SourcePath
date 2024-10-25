NAME=SourcePath
PKG_NAME=SourcePath
REPO_NAME=hoefkensj/sourcepath

SRC=src/${PKG_NAME}
OPT=/opt/local/scripts/bash/$(NAME)/

RCD=/etc/bash/bashrc.d/
END=/etc/environment.d/
VER=0.67

RCD_EXISTS := $(shell [ -d "$(RCD)" ] && echo "yes" || echo "no")
END_EXISTS := $(shell [ -d "$(END)" ] && echo "yes" || echo "no")

CHECKRCD:
ifeq ($(RCD_EXISTS),yes)
	DST=/etc/bash/bashrc.d/
else
	CHECKEND
endif

CHECKEND:
ifeq ($(END_EXISTS),yes)
	DST=/etc/environment.d/
else
	CHECKEND
endif


install:CHECKRCD
	chmod 664   $(SRC)/$(NAME)-$(VER).sh
	install -Dv $(SRC)/$(NAME)-$(VER).sh  $(OPT)/$(NAME)-$(VER).sh
	ln -sv $(OPT)/$(NAME)-$(VER).sh  $(OPT)/$(NAME).sh
	ln -sv $(OPT)/$(NAME).sh  $(DST)/$(NAME).sh



uninstall:CHECKRCD
	rm -v $(DST)/$(NAME).sh
	rm -v $(OPT)/$(NAME)-$(VER).sh
	rm -v $(OPT)/$(NAME).sh