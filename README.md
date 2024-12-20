# SourcePath

## INSTALLATION::
```sh
git clone https://github.com/hoefkensj/SourcePath
cd SourcePath
# as root :
make install
````
## USAGE:
### after installing:
- log out and in again
    or
```sh
source /etc/profile
```

#### Use from commandline:
```sh
sourcepath [directory]
```
#### Use from  ~/.bashrc
```bash
sourcepath ~/.config/bash/rc/
```

this means you can split your bashrc into multiple files:
    - only files with errors will not load everything else will
    - gives feedback on wich files did not load if any.

if everything loaded as expected :

   ![image](https://github.com/user-attachments/assets/60d71b06-3728-4657-8c19-2e155c0d8731)

if something went wrong , in this case the 5th file out of 8, (7/8 still loaded successfully) 
    
   ![image](https://github.com/user-attachments/assets/da166203-19c7-4c28-98c0-30cf362e0b68)

invoked directly from commandline:

   ![image](https://github.com/user-attachments/assets/a7bd26a3-4b4b-4666-818a-8e8808bb97e6)

```sh
sourcepath --help
```


## HELP:
```help
${FUNCNAME[0]} [-h]|[-iqd] [DIR] [MATCH]

ARGS:

<DIR>             Directory to source files from.

<MATCH>           Regex to match Files against. Globbing and Expansion follow Bash Settings

OPTIONS:

-h   --help       Show this help text
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

EXAMPLES:

- Source files in ~/.config/bashrc/ that end in '.bashrc'
    ...and (-q) do not produce any output:

sourcepath -q ~/.config/bashrc/ '.*\.bashrc'

- Source all files in '.env' starting with 'config' , Case-Insensitive
    ...this inlcudes 'CONFIG.cfg' 'conFig.conf' but not 'mycfg.config'

sourcepath -i .env '^config.*'

- Source all files in '~/.bash_aliasses/' starting with 2 numbers,
...followed by an '_'. this matches '00_file.alias' but not '99file'

sourcepath ~/.bash_aliasses/ '\/[0-9]{2}_.*$'  :

DEFAULTS:

-MATCH: '/[0-9]+[_-]*.*\.(sh|bash|bashrc|rc|conf|cfg)$'
-DIR: '\$PWD'

gitrepo : github.com/hoefkensj/SourcePath (CC) Hoefkens Jeroen
${FUNCNAME[0]} v ${VERSION}
```
