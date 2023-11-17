#!/usr/bin/env bash
# ############################################################################
# # PATH: /etc/profile.d                        AUTHOR: Hoefkens.J@gmail.com #
# # FILE: sourcepath.sh                                0v99 - 2023.05.22 #
# ############################################################################
#
function sourcepath {
	local EXENAME="sourcepath"
	local VERSION="0.99"
	local WARNING="WARNING: This File Needs to be Sourced not Executed ! ";
	local HELP="""${FUNCNAME[0]} [-h]|[-iqd] [DIR] [MATCH]

ARGS:

<DIR>             Directory to source files from.

<MATCH>           Regex to match Files against. Globbing and Expansion follow Bash Settings

OPTIONS:

-h   --help       Show this help text
-a   --ask        Ask so source before every match [Y/n]
-i   --nocase     Ignore Case when matching
-q   --quiet      Quiet/Silent/Script, Dont produce any output
-d   --debug      Enable xtrace for this script
-w   --warning    Shows $WARNING

DIR:
    First argument to the function, the path to the directory holding the files
    to be sourced into the current env. This folder is searched recursively.
    for Matches (see [MATCH])

MATCH:
    Second Argument to the function , is fed directly into 'grep -E ' for 
    matching filenames found in <DIR>, see [EXAMPLES] for common use cases.
    the string that is matched against is the full (real) path of the files
    
    WARNING: this is of consern if the dir you specified is a symlink or is
    in the subtree of a symlink. if you want to source all files ending in 
    "config" in a folder <~/myproj/user/> wich is a symlink to 
    /home/[username]/.config/myproj/, using a match regex of '.*config.*'
    wil match everyfile in the direcory allong with every file in potential 
    subdirectories , because 'config' is part of the real path of the directory -> 
    .../.config/..., you can test the paht used by running in your shell:
    realpath [path]
    wich would reveal the fully resolved path of [path] that is used to match against

EXAMPLES:

- Source files in ~/.config/bashrc/ that end in '.bashrc'
    ...and (-q) do not produce any output:

sourcedir -q ~/.config/bashrc/ '.*\.bashrc'

- Source all files in '.env' starting with "config" case insensitive
    ...this inlcudes 'CONFIG.cfg' 'conFig.conf' but not 'mycfg.config'

sourcedir -i .env '^config.*'

- Source all files in '~/.bash_aliasses/' starting with 2 numbers,
...followed by an '_'. this matches '00_file.alias' but not '99file'

sourcedir ~/.bash_aliasses/ '\/[0-9]{2}_.*$'  :

DEFAULTS:

-MATCH: '/[0-9]+[_-]*.*\.(sh|bash|bashrc|rc|conf|cfg)$'
-DIR: '$PWD'

""";
# set -o errexit
# set -o nounset
# set -o xtrace

function batcat () {
	function _bat() {
		local theme paging batopts
		theme="Monokai Extended Origin"
		paging="never"

		echo "$@" |bat  --plain --paging="$paging" --theme="$theme" --language="$lang"
	};
	local lang
	lang="$1"
	shift 1 #remove that from the args as cat doesnt need it
	[[ -n "$( which bat )" ]] &&   _bat "$@"
	[[ -z "$( which bat )" ]] && echo $( printf '%s' "$@" ) | $( printf '%s' "$(which cat)"  )
};

function _main (){
	function _sourcefile () {
		[[ "$ASK" == "1" ]] &&  
		source "$1" &>/dev/null
		SUCCESS=$?
		if [[ "$SUCCESS" -eq 0 ]] ; then
			_DONE=$(($_DONE+1))
		else
			FAIL=$(($_FAIL+1))
		fi
		[[ "$SUCCESS" == "0" ]] && _progress "$1" "$GC" 2 "$2"
		[[ "$SUCCESS" != "0" ]] && _failfile "$1"
	};
	function _failfile() {
		ERRN=$((ERRN+1))
		echo "" #newline
		_mask 0 "$GP" "$GS" "$GN" "$N" 1 1 "Failed  :" #mask
		_progress "$1" "$GC" 1 "$ERRN"
		printf '\x1b[F'
	};


	function _sourcefiles () {
		_DONE=0
		_FAIL=0
		for CONF in $SELECTED;
		do
			[[ -e "$CONF" ]] && _sourcefile "$CONF" "$I" ;
		done
	};


};
function bash_shorten_path() {
	local $_PATH $_LEN
	_PATH=$1
	_LEN=$2
	while true  ; do
		[[ ${#_PATH} >  $_LEN ]]  && _PATH=".../${_PATH#*/*/}" 
		[[ ${#_PATH} <  $_LEN ]]  && _PATH="${_PATH} "
		[[ ${#_PATH} == $_LEN ]]  && break;
	done
	printf '%S' "${_PATH}"	
}

function _mask () {
#   |  G |  m | string
_Gm "${1}" "${6}" "${7}" "${8}";
_Gm "${2}" 1 7 "[";
_Gm "${3}" 1 7 "/";
_Gm "${4}" 1 2 "${5}";
_m 1 7 "]"
};
function _progress () {
#~       G   m  m   STRING
local toprint
toprint=$1
while true  ; do
[[ ${#toprint} > 50 ]]  && toprint=".../${toprint#*/*/}"
[[ ${#toprint} < 51 ]] && break ;
done
_Gm  12  1  3   "$toprint  "
_Gm "$2" 1 "$3" "$4"
_G 80
};

local MATCH SRC N W GP GS GC GN ERRN FILEN CORIG;
_m='\x1b[%s;3%sm%s\x1b[m'
_Gm="\x1b[%sG${_m}\x1b[G"
_YGm="\x1b[%sE${_Gm}\x1b[%sF"
SRC=$(realpath "${1}");
[[ -n "$2" ]] && MATCH="$2" || MATCH='/[0-9]+[_-]*.*\.(sh|bash|bashrc|rc|conf|cfg)$';
I=0;
SELECTED=$( find "$SRC" 2>/dev/null |grep -E "$MATCH" );
[[ -n "$SELECTED" ]] && N=$( echo "$SELECTED" |wc -l );
W="${#N}";
GP=$((80-10-W*2))
GC=$((GP+1))
GS=$((GP+W+1))
GN=$((GP+W+2))
ERRN=0
echo && echo && printf '\x1b[2F'


_SRC_SHORT="$( bash_shorten_path $SRC 50 )"
printf $_YGm 1 1 0 7 "Source Dir:" 1;
printf $_YGm 1 12 0 3 $_SRC_SHORT 1;
printf $_YGm 1 "$GS" 0 7 "[" 1; 
printf $_YGm 1 "$GN" 1 2 "$N" 1;
printf $_YGm 1 80 0 7 "]" 1;


printf $_YGm 2 1 0 7 "Sourcing:" 1;
printf $_YGm 2 12 0 3 $_SRC_SHORT 1;
printf $_YGm 2 "$GP" 0 7 "[" 1; 
printf $_YGm 2 "$GS" 0 7 "/" 1;
printf $_YGm 2 "$GN" 0 2 "$N" 1;
printf $_YGm 2 80 0 7 "]" 1;


_sourcefiles ;
_mask 0 "$GP" "$GS" "$GN" "$N" 0 7 "Sourced :"
_progress "$SRC" "$GC" 2
_Gm "$((80-5))" 1 32 "DONE"
[[ "ERRN" != 0 ]] && printf '\x1b[E'
echo
};
local CASE SELECTED I;
case "$1" in
-h | --help | '')
batcat help "$HELP"
;;
-d | --debug)
shift && set -o xtrace && ${FUNCNAME[0]} "$@"
;;
-q | --quiet)
shift 1 && ${FUNCNAME[0]} "$@" &> /dev/null
;;
-i | --nocase)
shift 1 && CASE="-i" && ${FUNCNAME[0]} "$@"
;;
-w | --warning)
batcat  help  "\x1b[1;31m$WARNING" >> /dev/stderr
;;
*)
_main "$@"
;;
esac;
unset _m _G _progress _mask _state _sourcefiles _main _cat
}
function sourcepath_cli() {
	case "$1" in
		-h | --help | '')
			batcat help "$HELP"
			;;
		-d | --debug)
			shift && set -o xtrace && ${FUNCNAME[0]} "$@"
			;;
		-q | --quiet)
			shift 1 && ${FUNCNAME[0]} "$@" &> /dev/null
			;;
		-i | --nocase)
			shift 1 && CASE="-i" && ${FUNCNAME[0]} "$@"
			;;
		-w | --warning)
			batcat  help  "\x1b[1;31m$WARNING" >> /dev/stderr
			;;
		*)
			_main "$@"
			;;
	esac;
} 



#make sure its sourced not executed
(return 0 2>/dev/null) || sourcepath --warningbash: bash_history: command not found