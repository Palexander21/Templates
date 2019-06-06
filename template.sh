#! /usr/bin/bash

##################################################################################################
# Author: Paxton Alexander (With the help of Github and StackOverflow)
# Version: 1.0
# Description: A template to be used for quick creation of bash scripts.
##################################################################################################


######################################### Globals ################################################
__NC='\e[0m'
__GRAY='\e[0;90m'
__RED='\e[0;91m'
__GREEN='\e[0;92m'
__YELLOW='\e[0;93m'
__BLUE='\e[0;94m'
__PASS='\u2714' # ✔
__FAIL='\u274c' # ✖
# WARN='\u26A0' # ⚠
# INFO='\u2757' # ℹ

__VERBOSITY=3
declare -A __LOG_LEVELS
__LOG_LEVELS=(
    [0]="[${__GREEN}${__PASS} ${__NC}]"
    [1]="[${__RED}${__FAIL} ${__NC}]"
    [2]="[${__YELLOW}WARN${__NC}]"
    [3]="[${__BLUE}INFO${__NC}]"
    [4]="[${__GRAY}DEBUG${__NC}]"
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
    local _level=${1}
    shift
    if [ ${__VERBOSITY} -ge ${_level} ]; then
        echo -e "${__LOG_LEVELS[${_level}]} $@"
    fi
}

# https://gist.github.com/davejamesmiller/1965569
ask() {
    local _prompt _default _reply

    if [ "${2:-}" = "Y" ]; then
        _prompt="Y/n"
        _default=Y
    elif [ "${2:-}" = "N" ]; then
        _prompt="y/N"
        _default=N
    else
        _prompt="y/n"
        _default=
    fi

    while true; do

        # Ask the question (not using "read -p" as it uses stderr not stdout)
        echo -n "$1 [${_prompt}] "

        # Read the answer (use /dev/tty in case stdin is redirected from somewhere else)
        read _reply </dev/tty

        # Default?
        if [ -z "${_reply}" ]; then
            _reply=${default}
        fi

        # Check if the reply is valid
        case "${_reply}" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac
    done
}

menu() {
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
            "1")  ask "What?" Y ;;
            "2")  echo 2 ;;
            "Q"|"q")  exit 1  ;;
            * )  echo "invalid option" ;;
        esac
done
}

usage() {
cat <<EOF
NAME
    template - template bash script

USAGE
    template --verbose 4

DESCRIPTION
    This is a template for quick creation of bash scripts.

    -h, --help
            show this help screen
    
    -v, --verbose
            specify the verbosity of the script. [0-4]
                0 - success
                1 - error
                2 - warn
                3 - info
                4 - debug

EOF
}
######################################### START ###############################################
main () {
    for arg in "$@"; do
        shift
        case "${arg}" in
            "--help") set -- "$@" "-h" ;;
            "--verbose") set -- "$@" "-v" ;;
            *) set -- "$@" "${arg}"
        esac
    done

    if [ $# -eq 0 ]; then
        menu
    else
        while getopts "v:h" OPTION; do
            case ${OPTION} in
                h)
                    usage
                    exit 1
                    ;;
                v)
                    VERBOSITY=${OPTARG}
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
}

main "$@"