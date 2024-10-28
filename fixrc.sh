#!/usr/bin/env bash
# ############################################################################
# # PATH: bash_scripts/sourcepath_installer  AUTHOR: Hoefkens.J@gmail.com
# # FILE: install.sh                                   0v7 - 2023.04.26
# ############################################################################
#
NAME=SourcePath
DIRRC=/etc/bash/bashrc.d/
DIRENV=/etc/environment.d/
VER=0.67


function append_sourcebashrcd(){
	cat <<- "EOF" | > $1
	# --- added by SourcePath 
	# the folder at /etc/bash/bashrc.d was also created 
	for sh in /etc/bash/bashrc.d/* ; do
		[[ -r ${sh} ]] && source "${sh}"
	done
	EOF
}

function fixrc(){
	RCFILE=$( find /etc -type f -iname *'bash*rc'* 2>/dev/null |grep -v skel|head -n 1)
	[[ -n $RCFILE ]] echo "bash rc found: $RCFILE" || echo "could not detect any bash rc file ... "
	install -m 755 -dv "${DIRRC}"
	echo '#SourcePath' > "${DIRRC}/.createdby"
	append_sourcebashrcd $RCFILE
}

function findrc(){
	[[ -d $DIRRC ]] && DST=$DIRRC
	[[ -z $DST ]] && [[ -d $DIRENV ]] && DST=$DIRENV
	[[ -z $DST ]] && fixrc || printf "${DST}"

}

RCDIR="$(findrc)"
[[ -z $RCDIR ]] && RCDIR="$(findrc)"
printf "%s" $RCDIR