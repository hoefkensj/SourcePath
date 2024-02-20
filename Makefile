NAME=SourcePath
SRC=src/${NAME}
DST=/etc/bash/bashrc.d/
VER=0.66
install:
	chmod 664   $(SRC)/$(NAME)-$(VER).sh
	install -Dv $(SRC)/$(NAME)-$(VER).sh $(DST)/${NAME}.sh


uninstall:
	rm -v $(DST)/$(NAME).sh
