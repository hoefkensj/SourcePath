#!/usr/bin/env bash
# ############################################################################
# # PATH: bash_scripts/Bash_SourceDir_installer  AUTHOR: Hoefkens.J@gmail.com
# # FILE: install.sh                                   0v7 - 2023.04.26
# ############################################################################
#

latest=$(ls "$PWD/src/bash_sourcedir-"*|sort -n |tail -n 1 )
ln -rsvf "$latest" "$PWD/bash_sourcedir.sh"
ln -svf "$PWD/src/bash_sourcedir.sh" "/etc/profile.d/sourcedir.sh"
source "/etc/profile.d/bash_sourcedir.sh"
bash_sourcedir
echo "Symlink installed in : /etc/profile.d/" 
unset latest
