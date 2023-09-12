# Title......: .bashrc
# Description: My setting file for bash
# Author.....: Mitchell Johnston
# Contact....: mitch@crn.hopto.org
# Updated....: Tue 15 Aug 2023 05:46:41 AM CDT
# ==============================================

# If not running interactively, don't do anything
#---------------------------
[ -z "$PS1" ] && return

# Install check
# -------------
# This is part of my auto-install system. Most of my scripts and environment self
# configure.
[ ! -f ~/.install.log ] && bash ~/bin/config|tee -a ~/.install.log

# Environment variables
# =====================

# Colors - uncomment if needed
# ----------------------------
R=$(tput setaf 1)                          # red
BR=$(tput setaf 1; tput bold)              # bold red
G=$(tput setaf 2)                          # green
BG=$(tput setaf 2; tput bold)              # bold green
Y=$(tput setaf 3)                          # yellow
BY=$(tput setaf 3; tput bold)              # bold yellow
B=$(tput setaf 4)                          # blue
BM=$(tput setaf 5; tput bold)              # bold magenta
BC=$(tput setaf 6; tput bold)              # bold cyan
BL=$(tput setaf 7; tput bold)              # bold light grey
BLD=$(tput bold)                           # bold
N=$(tput sgr0)                             # normal
SIT=$(tput sitm)                           # italics
RIT=$(tput ritm)                           # remove italics
UL=$(tput smul)                            # turn underline on
NL=$(tput rmul)                            # turn underline off
RV=$(tput rev)                             # turn on reverse mode
ROWS=$(tput lines)
COLS=$(tput cols)

# colorize man
# ------------
export LESS_TERMCAP_md=$(tput setaf 4; tput bold) # enter double-bright mode - bold blue
export LESS_TERMCAP_me=$(tput sgr0) # leave double-bright, reverse, dim modes
export LESS_TERMCAP_so=$(tput setaf 6; tput bold) # enter standout mode - bold cyan on blue background
export LESS_TERMCAP_se=$(tput rmso)  # leave standout mode
export LESS_TERMCAP_us=$(tput sitm ;tput setaf 3) # enter underline mode - italics, yellow
export LESS_TERMCAP_ue=$(tput ritm) # leave underline mode
export LESS_TERMCAP_mr=$(tput rev) # enter reverse mode
export LESS_TERMCAP_mh=$(tput dim) # enter half-bright mode
export LESS_TERMCAP_ZN=$(tput ssubm) # enter subscript mode
export LESS_TERMCAP_ZV=$(tput rsubm) # leave subscript mode
export LESS_TERMCAP_ZO=$(tput ssupm) # enter superscript mode
export LESS_TERMCAP_ZW=$(tput rsupm) # leave superscript mode
export MANWIDTH=$(tput cols) # check the number of columns and set to that
export MANPAGER='less -s -M +Gg'

# grep colors for match
# ---------------------
export GREP_COLOR='1;37;42'

# System
# ------
PATH=~/bin:~/.local/bin:$PATH
HISTCONTROL=ignoredups:erasedups          # Ignore and remove dupes from history
HISTTIMEFORMAT="%F %T "                   # Add time stamp to history
JAVA_HOME="$(readlink -f `which java`)"   # Fixes issues w/ some tools
LESSCHARDEF=8bcccbcc13b.4b95.33b.         # show colours in ls -l | less
EDITOR='vim'
CDPATH="~/dev"
if [ -z $DISPLAY ]
    then
        BROWSER='lynx'
        OFFICE=lesspipe.sh #https://www.zeuthen.desy.de/~friebel/unix/lesspipe.html
        PICS=lesspipe.sh
        PDF=lesspipe.sh
    else
        BROWSER='brave-browser'
        OFFICE=xdg-open
        PICS=xdg-open
        PDF=xdg-open
fi
S_COLORS=auto
NAME=${0##*/}                              # name of the script
MORIA_SAV="/home/mitch/moria.sav"

# PS1 Prompt
# ----------
# Status of last command
# L: Shell level
# J: Number of jobs
# user@host
# emoji (edir) and sets window title 
# current directory
#
# 😎 (L:1 J:0) [mitch@mitch-ideapad] 🔽 ~/Downloads
# $ 

function success_indicator() { ## displays the status of last command
    ES=$?
    if [ $ES -eq 0 ] ; then
        echo "🤓"
    else
        echo "🚧 ${BR}${ES}$N"
    fi
}

PS1='$(success_indicator) $(printf "\033]0;(L:$SHLVL J:\j) [\u@\h] \w \007")(L:${BY}$SHLVL${N} J:${BY}\j${N}) ${BC}[\u🌀\h] $(edir)\w${N}\n\$ '

# Make them available to sub-shells
# ---------------------------------
export PATH LOCATION EDITOR HISTCONTROL JAVA_HOME LESSCHARDEF S_COLORS PAGER BROWSER OFFICE PICS PDF CDPATH MORIA_SAV

# Additional setting
# ==================
export NMON=cdnt
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
umask 027
export NO_AT_BRIDGE=1        # fix for gvim issue
export WWW_HOME=http://crn.hopto.org
xdg-mime  default brave-browser.desktop x-scheme-handler/https
xdg-mime  default brave-browser.desktop x-scheme-handler/http
export FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {} 2>/dev/null'"

# perl setup
#-----------
PERL5LIB="/home/mitch/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/mitch/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/mitch/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/mitch/perl5"; export PERL_MM_OPT;

# Personal aliases
# ================
[ "" != "$(which cdu)" ] && alias du='cdu -si -d h $(\ls -d [^.*]*)'
[ "" != "$(which btop)" ] && alias top='xtitle top;$(which btop)'
[ "" != "$(which vimdiff)" ] && alias diff=$(which vimdiff)
[ "" != "$(which bat)" ] && PAGER='bat -p'
if [ "" != "$(which grc)" ]
then
    alias configure='grc ./configure'
    alias curl='grc curl'
    alias df='grc df -h -x tmpfs 2>/dev/null;:'
    alias dig='grc dig'
    alias env='grc env'
    alias free='grc \free -ht'
    alias gcc='grc gcc'
    alias id='grc id'
    alias ifconfig='grc ifconfig'
    alias last='grc last'
    alias ls='grc ls --color'
    alias lsof='grc lsof'
    alias make='grc make'
    alias nestat='grc netstat'
    alias nmap='grc nmap'
    alias ping='grc ping'
    alias ps='grc ps'
    alias ss='grc ss'
    alias stat='grc stat'
    alias traceroute='grc traceroute'
    alias uptime='grc uptime'
    alias vmstat='grc vmstat'
    alias w='grc w'
    alias whois='grc whois'
fi

# Common options to save time
# ---------------------------
alias ddg='/usr/local/bin/ddgr -x -n 5'    # duck duck go with options
alias grep='grep --color'                  # Only works with GNU version
alias gvim='gvim -p'                       # Open multiple files in tabs
alias j='jobs -l'                          # Displays background jobs
alias l='grc ls --color --group-directories-first -hlF'                  # quick long file listing
alias lsd='\ls --color -d */ 2>/dev/null || echo "None"'
alias rm='gio trash'
alias vi='vi -p '                         # Use tabs
alias wget='wget -c'                       # Allows restart

# Navigations
# -----------
alias ..="cd .. && lsd"                     # drop one level
alias aq='asciiquarium;exit'
alias clock='tty-clock -sxtrB -C $(( ( RANDOM % 6 ) + 1 ));exit'
alias av='cd ~/Documents/av-bible;ls'
alias c='cd ~/Downloads;clear;quote;bl;[ ! -f get.txt ] && lm -t||today' # I work in this directory a lot
alias gd='cd /var/gopher;ls'               # go to gopher root end do listing
alias include='cd /var/www/include'
alias jd='cd ~/Documents/jots;ls'          # go to jots directory
#alias mc='. /usr/lib/mc/mc-wrapper.sh'     # Midnight commander
alias mp3s='cd /var/www/include/mp3s'
alias news='cd /var/www/include/vids/clips/$(( ( $(date +%w) ) + 1 ))-$(date +%a)/'
alias notes='vi ~/etc/notes.md'
alias pics='cd /var/www/include/pics'
alias S='cd ~/Downloads;s'
alias t='cd ~/Temp;clear;quote;bl;l' # I work in this directory a lot
alias vids='cd /var/www/include/vids'
alias wd='cd /var/www'

# New commands
# ------------
alias contacts='cd ~/db/;vd contacts.csv;cd - ' # contact list 
alias dark='transset -a --inc 0.15'
alias gt='fmt -s -w 40 <'                  # format text for gopher
alias index='site -m index'                # edit main index page
alias light='transset -a --dec 0.15'
alias links='site -m links'                # For quick updates
alias pd='jot -e my-kt.md'                 # jot is my notes manager
alias perf='sar -s $(date -d "1 hours ago" +%H):00:00' # what's going on?
alias please='sudo $(fc -ln -1)'           # if it did not work, say please
alias quote='~/bin/quote'                  # hack, you should not need this
alias r='fc -s'                            # run command matching pattern, or old=new pattern
alias rm-clips='[[ $(pwd) == *"$(date +%a|tr [A-Z] [a-z])"* ]] && gio trash $(ls |grep -v header.md|tr "\n" " ") ; files -u'
alias space='duf -only local'
alias spider='wget --random-wait -r -p -e robots=off -U mozilla' # spider a site
alias sp='jot -e scratch.md'               # scratch pad
alias sqlite=sqlite3
alias task=tasks                           # because sometimes I am human
alias temp='watch sensors -f'
alias trash='gio list trash://;read -p "Remove? " -n 1 TRASH;[ "$TRASH" = "y" ] && gio trash --empty'
alias tt='xfconf-query --channel=xfwm4 --property=/general/use_compositing --type=bool --toggle'
alias epy='/home/mitch/.local/bin/epy' # rewrite into function
alias x=exit                               # quick exit
alias weather='inxi -W 58054 --weather-unit i; ansiweather -l 5060162 -u imperial -s tru -f 3'

# Bash options
# ============
shopt -s cmdhist        # Save all lines of a multiple-line command in the same history entry
shopt -s cdspell        # Fix minor spelling error's in 'cd' command
shopt -s checkwinsize   # Handle xterm resizing
shopt -s dotglob        # Allow tab-completion of '.' filenames
shopt -s extglob        # Bonus regex globbing!
shopt -s hostcomplete   # Tab-complete words containing @ as hostnames
shopt -s execfail       # Failed execs don't exit shell
set -o notify           # Show status of terminated programs immediately

# Tab (readline) completion settings
# ----------------------------------
set show-all-if-ambiguous on    # Show more w/ 1 <tab>   {new}
set visible-stats on            # Appends files to <tab> completes {new}
set completion-ignore-case on   # Ignor case in completion
set match-hidden-files off       # Allow matching on hidden files

# History
# -------
set bashhistfile=1000 # Number of history file entries
set dunique           # Removes duplicate entries in the dirstack
set histdup=prev      # Do not allow consecutive duplicate history entries

# General
# -------
set ulimit -c 0       # Turn off core dumps
set notify            # Notifies when a job completes

# Command line completion
# -----------------------
complete -A hostname   rsh rcp telnet rlogin r ftp ping disk ssh
complete -A command    nohup exec eval trace gdb
complete -A command    command type which
complete -A export     printenv
complete -A variable   export local readonly unset
complete -A enabled    builtin
complete -A alias      alias unalias
complete -A function   function
complete -A user       su mail finger
complete -A directory  mkdir rmdir
complete -A directory   -o default cd
complete -f -d -X '*.gz'  gzip extract
complete -f -d -X '*.bz2' bzip2 extract
complete -f -o default -X '!*.gz'  gunzip extract
complete -f -o default -X '!*.bz2' bunzip2 extract
complete -f -o default -X '!*.pl'  perl perl5
complete -f -o default -X '!*.ps'  gs ghostview ps2pdf ps2ascii
complete -f -o default -X '!*.dvi' dvips dvipdf xdvi dviselect dvitype
complete -f -o default -X '!*.pdf' acroread pdf2ps
complete -f -o default -X '!*.texi*' makeinfo texi2dvi texi2html texi2pdf
complete -f -o default -X '!*.tex' tex latex slitex
complete -f -o default -X '!*.lyx' lyx
complete -f -o default -X '!*.+(jpg|gif|xpm|png|bmp)' xv gimp
complete -f -o default -X '!*.+(epub|epub3|fb2|mobi|azw3)' v epy
complete -f -o default -X '!*.+(avi|mp4|mpv|flv|wma|mkv)' vlc mp dr pi rc
complete -f -o default -X '!*.mp3' vlc mp
complete -f -o default -X '!*.ogg' vlc mp
complete -f -o default -X '!*.md' site vim gvim retext e mdv

# FUNCTION DEFINITIONS
# ====================
tips(){ # Selection of bash tips to make it easier to remember them 
    less <<END
${BY}(this is not complete, just the 'good' stuff)${N}
${G}Completion:${N}
~<tab><tab>  # User names
@<tab><tab>  # Hosts (think ssh)
$<tab><tab>  # Variables

${G}Edit Control:${N}
Ctrl-a       # Move to the start of the line.
Ctrl-e       # Move to the end of the line.
Alt-b        # Move back one word.
Alt-f        # Move forward one word.
Ctrl-u       # Delete from the cursor to the beginning of the line.
Ctrl-k       # Delete from the cursor to the end of the line.
Ctrl-y       # Pastes text from the clipboard.
Ctrl-l       # Clear the screen leaving the current line at the top of the screen.
Ctrl-x Ctrl-u# Undo the last changes. Ctrl-_ does the same
Alt-r        # Undo all changes to the line.

!!           # Execute last command in history
!abc         # Execute last command in history beginning with abc
!abc:p       # Print last command in history beginning with abc
!n           # Execute nth command in history
!$           # Last argument of last command
!^           # First argument of last command
^abc^xyz     # Replace first occurance of abc with xyz in last command and execute it

${BR}reset${N} will fix currupted terminals sessions

And bash has a built in 'help', type 'help' for a listing commands and 'help cmd' for help on a paticular command. Also see 'tldr'.

END

echo Alias >/tmp/$$
alias  >>/tmp/$$

bl >>/tmp/$$
echo Fuctions >>/tmp/$$
grep -h -A 1 ' ##' ~/.bashrc |sed 's/(){//'|grep -v sed >>/tmp/$$
more /tmp/$$ && \rm /tmp/$$
}

bl(){ ## write a blank line
    # Use: bl
    [ "$DEBUG" == "1" ] && set -x
    echo ""
}

bm(){ ## view bookmarks from shell
    # Use: bm
export-chrome-bookmarks ~/.config/BraveSoftware/Brave-Browser/Default/Bookmarks ~/etc/bookmarks.html
lynx ~/etc/bookmarks.html
}

bold(){ ## add file to .bold
    # Use: bold {file}
echo $1 >>.bold
files
}

check(){ ## check for entry
    cd /var/www
    for MD in $(find . -name '*.md' -print)
    do
        grep -Hc "$1" $MD |egrep -v '0$'
    done
    echo "${BY} $(find . -name "$1" -print)${N}"
    cd - >/dev/null
}

ct(){ ## Coffee timer or cooking timer
    # Use: ct {time} 
    if [ "$#" -gt 0 ]
    then
        echo -n "${BG}Cooking timer $1${N} ⏳ " ;spinit sleep $1
    else
        # French press timer (default action)
        echo -n "${BG}Making Coffee${N} ☕ " ;spinit sleep 4m
    fi
    if [ -z $DISPLAY ]
    then
        clear
        if [ "$#" -gt 0 ]
            then
                echo "⏳${BR}Done${N}^G"
            else
                echo "☕${BR}Coffee ready${N}^G"
        fi
        bl
    else
        if [ "$#" -gt 0 ]
            then
                notify-send -u critical "⏳ Done!"
            else
                notify-send -u critical "☕ Coffee ready!"
        fi
        mpv ~/Music/sounds/chime.wav >/dev/null 2>&1
    fi
}

display(){ ## show display settings
    # Use: display (no options)
    [ "$DEBUG" == 1 ] && set -x
    if [ -z $DISPLAY ]
    then
        echo "$(w|tail -1|awk '{print $3}') $TERM $(tput lines)r x $(tput cols)c"
    else
        echo "$DISPLAY $TERM $(tput lines)r x $(tput cols)c"
    fi
}


edir(){ ## emoji directory used in PS1
    # Use: See $PS1 at top of this file
    [ "$#" -ne 0 ] && grep -A 1 \^edir ~/.bashrc && return
    case $PWD in # Order is important, stops on 1st match
        *Archives*) echo -n "📦 ";;
        *bin*) echo -n "🔧 ";;
        *etc*) echo -n "⌨  ";;
        *Documents*) echo -n "📃 ";;
        *Downloads*) echo -n "🔽 ";;
        *jots*) echo -n "📝 ";;
        *Music*) echo -n "🎧 ";;
        *pics*|*Pictures*) echo -n "📸 ";;
        *gopher*) echo -n "🐹 ";;
        *tmp*|*Temp*) echo -n "🚽 ";;
        *vids*|*Videos*) echo -n "🎬 ";;
        *web*|*www*) echo -n "🚧 ";;
        /home/mitch) echo -n "🏠 ";;
        *) echo -n "📂 ";;
    esac
}

emoji(){ ## search and display emoji
    # Use: emoji -h or --help for use
case $1 in
    -s) # search
        grep -i --color $2 ~/etc/emoji.txt
        ;;
    -r) # random
        shuf -n 1 <~/etc/emoji.txt|cut -d' ' -f1
        ;;
    -R) # random
        shuf -n 1 <~/etc/emoji.txt|cut -d' ' -f1| tr -d \\n
        ;;
    -d) # dump
        for SMILE in $(cut -d' ' -f1 <~/etc/emoji.txt)
        do
            echo -n $SMILE
        done
        ;;
    *) # help
        fmt -s -w $(tput cols)<<END
${BG}emoji${N} {option}
-s {text}  # search
-r         # random
-R         # random, no new line
-d         # dump
END
        ;;
esac
}

extract(){ ## handy archive extraction
    # Use: extract {file}
    [ "$DEBUG" == 1 ] && set -x
    if [ -f $1 ]
    then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "${BR}$1 ${N}cannot be extracted via >extract<"
                        file $1;;
        esac
    else
        echo "${BR}$1 $N is not a valid file"
    fi
}

gmt(){ ## display GMT (for radio stuff)
    # Use: gmt    (ft is a script to display text in fun ways)
    ft "$(date -u +%r%t%D)"
}

goa(){ ## run go-access with no filters
cd /var/log/lighttpd
zcat access.log.*.gz |goaccess access.log access.log.1 --log-format=COMBINED -e DeviceDHCP.Home -e "192.168.1.5" -e "192.168.1.1"  --ignore-crawlers
cd -
}

h(){ ## enhanced history command
    # Use: h
    \grep -v '#' ~/.bash_history|sort -u | fzf --prompt "${BY}History:${N} ">/tmp/$$ && \vim /tmp/$$;eval $(cat /tmp/$$);rm /tmp/$$
}

html(){ ## mark up code
    vim -f +"syn on" +"colorscheme gruvbox" +"set nonu" +"set foldenable!" +"set nospell" +"run! syntax/2html.vim" +"wq" +"q" $1
}

hping(){ ## httping with favorite options
    # Use: hping {name}    (defaults to my site)
    PINGHOST="$1"
    httping ${PINGHOST:=crn.hopto.org} -c 10 -S -Y -Z -s --offset-yellow 370 --offset-red 380 -K
}

log(){ ## creates a basic log entry $LOG must be defined
    # Use: log {entry}  
    [ "$DEBUG" == "1" ] && set -x
    logger -i -t "$NAME" "$*"
}

md2pdf(){ ## covert markdown to pdf
pandoc ${1%.md}.md -o ${1%.md}.html
cat  ${1%.md}.html |htmldoc --cont --headfootsize 8.0 --linkcolor blue --linkstyle plain --format pdf14 - >  ${1%.md}.pdf && gio trash ${1%.md}.html
}

more(){ ## updated to set title bar
    # Use: more {file}
    xtitle "more $*"
    bat -p $*
}

mp(){ ## media player front end
FZF_DEFAULT_OPTS="--ansi "
    # Use: mp {optional file}
    [ "$1" == "-d" ] && cd ~/Downloads  # jump to download directory
    [ -z $DISPLAY ] || WINDOW=$(xdotool getactivewindow 2>/dev/null) # get window ID
    clear
    if [ -f "$1" ]  # if you give it a file run it, else display a list
    then
        CHOICE="$1"
    else
        if [ "$1" != "-n" ] # option for time sort in rev
            then
                xtitle "mp: $PWD {Time sort}"
                CHOICE=$(lm |fzf --ansi --reverse --color fg:-1,bg:-1,hl:46,fg+:40,bg+:233,hl+:46 --color prompt:166,border:46 --height 70%  --border=sharp --prompt="➤  " --pointer="➤ " --marker="➤ ")
            else
                xtitle "mp: Name sort"
                CHOICE=$(lm|fzf --ansi --color fg:-1,bg:-1,hl:46,fg+:40,bg+:233,hl+:46 --color prompt:166,border:46 --height 70%  --border=sharp --prompt="➤  " --pointer="➤ " --marker="➤ ")
        fi
    fi
    FILE=$(echo $CHOICE|awk '{print $1}'|tr -d ':')
    if [ ! -z $FILE ]
    then
        if [ ! -z $DISPLAY ]
        then
            xtitle "$FILE"
            echo "Playing: $FILE"
            xdotool windowminimize $WINDOW
            xfconf-query --channel=xfwm4 --property=/general/use_compositing --type=bool --toggle
            spinit vlc --play-and-exit $FILE 1>&2 2>/dev/null
            xdotool windowactivate $WINDOW
            xfconf-query --channel=xfwm4 --property=/general/use_compositing --type=bool --toggle
            if [ -f $FILE -a "$(pwd)" == "/home/mitch/Downloads" ]
            then
                clear
                read -p "${BR}Remove:${BY} ${FILE}?${N} " -n 1 DEL
                [ "$DEL" == "y" ] && gio trash $FILE
                if [ -f $FILE ]
                then
                    bl
                    read -p "${BY}mv${N} $FILE to ~/Temp? " -n 1 MV
                    [ "$MV" == "y" ] && mv $FILE ~/Temp
                fi
            fi
            if [ "$1" == "-n" ]
                then
                    clear
                    [[ $(\ls -A *.mp? 2>/dev/null) ]] && lm || echo "No files"
                else
                    clear
                    [[ $(\ls -A *.mp? 2>/dev/null) ]] && lm -t || echo "No files"
            fi
        else
            echo "$FILE not played, no DISPLAY"
        fi
    fi
}

recover(){ ## vim recover from backup dir
    # Use: recover {no-options}
    OLDDIR=$(pwd)
    cd ~/.vim/backup
    CHOICE=$(ls |fzf -m --ansi --color fg:-1,bg:-1,hl:46,fg+:40,bg+:233,hl+:46 --color prompt:166,border:46 --height 70%  --border=sharp --prompt="➤  " --pointer="➤ " --marker="➤ " --preview '(highlight -O ansi {} || bat -p {}) 2> /dev/null | head -500')
    cp ${CHOICE} ${OLDDIR}
    cd -
}

rs(){ ## restart shell with option to edit .bashrc
    # Use: rs (if anything is passed it will edit .bashrc file 1st)
    if [ $# -gt 0 ]
    then
        vim ~/.bashrc
        sed -i -e "5s/.*/# Updated....: $(date)/" ~/.bashrc
        # bashrc
        log "Updated ~/.bashrc"
        html ~/.bashrc
        cp  ~/.bashrc /var/www/unix/bashrc
        mv  ~/.bashrc.html /var/www/unix/bashrc.html
        cp ~/.bashrc /var/gopher/scripts/my.bashrc

        # vimrc - Added to make sure the Gopher and Web versions were up to date.
        sed -i -e "5s/.*/\" Updated....: $(date)/" ~/.vimrc
        html ~/.vimrc
        cp  ~/.vimrc /var/www/unix/vimrc
        mv  ~/.vimrc.html /var/www/unix/vimrc.html
        cp ~/.vimrc /var/gopher/scripts/my.vimrc

        # conkyrc - Added to make sure the Gopher and Web versions were up to date.
        html ~/.conkyrc
        cp  ~/.conkyrc /var/www/unix/conkyrc
        mv  ~/.conkyrc.html /var/www/unix/conkyrc.html
        cp ~/.conkyrc /var/gopher/scripts/my.conkyrc

        # Other config files - Added to make sure the Gopher and Web versions were up to date.
        cp ~/.newsboat/urls /var/www/unix/urls.txt
        cp ~/.newsboat/config /var/www/unix/config.txt

        log "Restart: $$"
        exec bash
    else
        log "Restart: $$"
        reset; exec bash
    fi
}

sconky(){ ## re-start conky
    # Use: sconky (if anything is passed it will edit config file 1st)
    pkill conky
    spinit sleep 3
    nohup conky -d -c ~/.conkyrc >/dev/null 2>&1
}

tasks(){ ## task list front end
    # Use: tasks {Optional text to add to task list}
    if [ "$#" -eq 0 ]
    then
        vim ~/etc/tasks.md
    else
        if [[ "$*" == *"http"* ]]
        then
            echo "$*" >>~/etc/tasks.md
        else
            echo "- [ ] $*" >>~/etc/tasks.md
        fi
        log "New task: $*"
    fi
    today
}

today(){ ## display today's tasks and stuff
    # Use: today  {-c to edit calendar file}
    [ "$1" == "-c" ] && vim ~/.calendar/calendar && today
    clear
    echo "⏰ ${BG}${UL}$(fclock)${N}"
    echo "$BC"
    cal -A 1
    echo "$BY"
    calendar -f ~/.calendar/calendar -A 3 -w
    [ $(calendar -f ~/.calendar/calendar -A 3| wc -l ) -gt 0 ] && bl
    bl
    if [ $(grep -cE '^-' ~/etc/tasks.md) -gt 0 ]
    then
        echo "✅ ${BY}Tasks:${N}"
        cat ~/etc/tasks.md|grep -vE 'Enter:|http|https'>/tmp/$$.md
        bat -p /tmp/$$.md
        echo ${N}
    fi
    if [ $(grep -cE 'http|https' ~/etc/tasks.md) -gt 0 ]
    then
        echo "🔗 ${BY}Links:${N}"
        echo -n "$UL"
        \grep -iE 'http|https' ~/etc/tasks.md
        echo ${N}
    fi
}

wi(){ ## watch it - Monitor downloads from 'get' or youtubedl, maily for nohup starts
    # Use: wi (no options)
    if [ -d ~/Downloads/dl ] # I sometimes create this to keep them separate
    then
        cd ~/Downloads/dl
    fi
    while :
    do
        clear
        echo "$BC $(date)$BY"
        [ ! -f get.txt ] && break
        ls -sh *part 2>/dev/null && xtitle "wi: $(ls -sh *part|cut -d' ' -f1)"
        [ -f nohup.out ] && tail -5 nohup.out && bl
        echo "$BR"
        spinit sleep 5     # display some fun while waiting
    done
}

xtitle(){ ## set window title
    # Use: xtitle "Text to display"
    printf "\033]0;%s\007" "$*"
}

# Ending
# ======
clear
if [ "$LOGNAME" == "mitch" ]
then
    [ -f nohup.out ] && gio trash nohup.out
    ansiweather -l 5060162 -u imperial -s true
    neofetch --color_blocks off
    SSH_CT=$(grep "$(date +"%b %d")" /var/log/auth.log | grep -cE 'reset|Unable|refused|Failed')
    if [ $SSH_CT -gt 0 ]
    then
        echo "${BR}SSH:${N} ${BY}$SSH_CT${N}"
    fi
    calendar  -A 5 2>/dev/null
else
    log "Switching to root"
    echo "${BY}sudo: ${BR}switched to root$N"
    HISTFILE=/.root.hist        # keeps it out of mine
    TMOUT=600                   # Close terminal after 10 minutes of inactivity
    echo "Window timeout in: ${BY}$TMOUT seconds${N}"
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash