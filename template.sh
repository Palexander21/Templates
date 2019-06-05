#! /usr/bin/bash

##################################################################################################
# Author: Paxton Alexander (With the help of Github and StackOverflow)
# Version: 1.0
# Description: A template to be used for quick creation of bash scripts.
##################################################################################################


######################################### Globals ################################################
NC='\e[0m'
GRAY='\e[0;90m'
RED='\e[0;91m'
GREEN='\e[0;92m'
YELLOW='\e[0;93m'
BLUE='\e[0;94m'
PASS='\u2714' # ✔
FAIL='\u274c' # ✖
WARN='\u26A0' # ⚠
INFO='\u2757' # ℹ

VERBOSITY=3
declare -A LOG_LEVELS
LOG_LEVELS=(
    [0]="[${GREEN}${PASS} ${NC}]"
    [1]="[${RED}${FAIL} ${NC}]"
    [2]="[${YELLOW}WARN${NC}]"
    [3]="[${BLUE}INFO${NC}]"
    [4]="[${GRAY}DEBUG${NC}]"
)

######################################### FUNCTIONS ###############################################
banner() { # Args: Title
    echo "# ========================================================"
    echo "# "
    echo "# $@ "
    echo "# "
    echo "# ========================================================"
}

log() { # Args: log_level[0-4], Message
    local LEVEL=${1}
    shift
    if [ ${VERBOSITY} -ge ${LEVEL} ]; then
        echo -e "${LOG_LEVELS[$LEVEL]} $@"
    fi
}

# https://gist.github.com/davejamesmiller/1965569
ask() {
    local prompt default reply

    if [ "${2:-}" = "Y" ]; then
        prompt="Y/n"
        default=Y
    elif [ "${2:-}" = "N" ]; then
        prompt="y/N"
        default=N
    else
        prompt="y/n"
        default=
    fi

    while true; do

        # Ask the question (not using "read -p" as it uses stderr not stdout)
        echo -n "$1 [$prompt] "

        # Read the answer (use /dev/tty in case stdin is redirected from somewhere else)
        read reply </dev/tty

        # Default?
        if [ -z "$reply" ]; then
            reply=$default
        fi

        # Check if the reply is valid
        case "$reply" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac
    done
}

menu() 
{
    while true; do
        cat<<EOF
==============================
        Program Menu
------------------------------
  Please enter your choice:

  1) Option 1
  2) Option 2
  Q) Quit
------------------------------
EOF
        read -n1 -s
        case "$REPLY" in
            "1")  echo 1 ;;
            "2")  echo 2 ;;
            "Q"|"q")  exit 1  ;;
            * )  echo "invalid option" ;;
        esac
done
}

######################################### START ###############################################
for arg in "$@"; do
    shift
    case "$arg" in
        "--verbose") set -- "$@" "-v" ;;
        *) set -- "$@" "$arg"
    esac
done

if [ $# -eq 0 ]; then
    menu
else
    while getopts "v:h" OPTION; do
        case $OPTION in
            h)
                usage
                exit 1
                ;;
            v)
                VERBOSITY=$OPTARG
                ;;
            *)
                usage
                exit 1
                ;;
        esac
    done
fi

# Example of how to log output
log 0 "Success"
log 1 "Error"
log 2 "Warn"
log 3 "Info"
log 4 "Debug"

# Ask() Examples
if ask "Do you want to do such-and-such?"; then
    echo "Yes"
else
    echo "No"
fi

# Default to Yes if the user presses enter without giving an answer:
if ask "Do you want to do such-and-such?" Y; then
    echo "Yes"
else
    echo "No"
fi


# Default to No if the user presses enter without giving an answer:
if ask "Do you want to do such-and-such?" N; then
    echo "Yes"
else
    echo "No"
fi

# Only do something if you say Yes
if ask "Do you want to do such-and-such?"; then
    echo "yes"
fi

# Only do something if you say No
if ! ask "Do you want to do such-and-such?"; then
    echo "no"
fi

# Or if you prefer the shorter version:
ask "Do you want to do such-and-such?" && echo "yes"

ask "Do you want to do such-and-such?" || echo "no"