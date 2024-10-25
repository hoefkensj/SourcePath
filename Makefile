NAME=SourcePath
PKG_NAME=SourcePath
REPO_NAME=hoefkensj/sourcepath

SRC=src/$(PKG_NAME)
OPT=/opt/local/scripts/bash/$(NAME)/

RCD=/etc/bash/bashrc.d/
END=/etc/environment.d/
VER=0.67

RCD_EXISTS := $(shell [ -d "$(RCD)" ] && echo "yes" || echo "no")
END_EXISTS := $(shell [ -d "$(END)" ] && echo "yes" || echo "no")

ifeq ($(RCD_EXISTS),yes)
	DST=$(RCD)
else ifeq ($(END_EXISTS),yes)
	DST=$(END)
else
    ifneq ("$(wildcard /etc/bash/bashrc /etc/bash/bashrc.bashrc /etc/bashrc.bashrc)","")
        FALLBACK_FILE := $(firstword $(wildcard /etc/bash/bashrc /etc/bash/bashrc.bashrc /etc/bashrc.bashrc))
        
        $(shell grep -qxF 'for sh in /etc/bash/bashrc.d/* ; do [[ -r $$sh ]] && source "$$sh" ; done' $(FALLBACK_FILE) || \
            echo 'for sh in /etc/bash/bashrc.d/* ; do [[ -r $$sh ]] && source "$$sh" ; done' >> $(FALLBACK_FILE))

        $(shell mkdir -p $(RCD))
    else
        $(error "No valid destination directory or file found to source scripts.")
    endif
endif

install: checkrc
	chmod 664 $(SRC)/$(NAME)-$(VER).sh
	install -Dv $(SRC)/$(NAME)-$(VER).sh $(OPT)/$(NAME)-$(VER).sh
	ln -sv $(OPT)/$(NAME)-$(VER).sh $(OPT)/$(NAME).sh
	ln -sv $(OPT)/$(NAME).sh $(DST)/$(NAME).sh

uninstall: checkrcd
	rm -v $(DST)/$(NAME).sh
	rm -v $(OPT)/$(NAME)-$(VER).sh
	rm -v $(OPT)/$(NAME).sh
