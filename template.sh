#! /usr/bin/env bash

##################################################################################################
# Author: Paxton Alexander (With the help of Github and StackOverflow)
# Version: 1.0
# Description: A template to be used for quick creation of bash scripts.
##################################################################################################


set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

######################################### Globals ################################################
readonly __DESC="A template to be used for quick creation of bash scripts."
readonly __VERSION="v1.0"
readonly __SCRIPT_NAME=$(basename "${0}" .sh)
readonly __LOCAL_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

readonly __NC='\e[0m'
readonly __GRAY='\e[0;90m'
readonly __RED='\e[0;91m'
readonly __GREEN='\e[0;92m'
readonly __YELLOW='\e[0;93m'
readonly __BLUE='\e[0;94m'
readonly __PASS='\u2714' # ✔
readonly __FAIL='\u274c' # ✖
# readonly WARN='\u26A0' # ⚠
# readonly INFO='\u2757' # ℹ

__VERBOSITY=3
readonly __LOG_LEVELS=(
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
    if [[ "${__VERBOSITY}" -ge "${_level}" ]]; then
        echo -e "${__LOG_LEVELS[${_level}]} $@"
    fi
}

# https://gist.github.com/davejamesmiller/1965569
ask() { # Args: Message, [OPTIONAL] default answer
    local _prompt _default _reply _message=${1}

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
        echo -n "${_message} [${_prompt}] "
        # Read the answer (use /dev/tty in case stdin is redirected from somewhere else)
        read _reply </dev/tty

        if [ -z "${_reply}" ]; then
            _reply="${_default}"
        fi

        case "${_reply}" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac
    done
}

menu() {
    while true; do
        cat<<MENU
==============================
        Program Menu
------------------------------
  Please enter your choice:

  1) Option 1
  2) Option 2
  Q) Quit
------------------------------
MENU
        local _reply
        read -n1 -s _reply
        case "${_reply}" in
            "1")  ask "Test Menu Optins?" Y ;;
            "2")  echo 2 ;;
            "Q"|"q")  exit 0  ;;
            * )  echo "invalid option" ;;
        esac
done
}

help() {
    local _desc="Show this help screen"
    cat <<HELP
NAME
    ${__SCRIPT_NAME} - template bash script

USAGE
    template --verbose 4

DESCRIPTION
    ${__DESC}

    -h, --help
            ${_desc}
    
    -V, --verbose
            Specify the verbosity of the script. [0-4]
                0 - success
                1 - error
                2 - warn
                3 - info
                4 - debug

    -v, --version
            Shows the current version of the program

HELP
}

usage() {
    local _desc="Displays an inline message invalid args are given"
    echo "Try '${__SCRIPT_NAME} -h' for more information."
}

version() {
    local _desc="Shows the current version of the program"
    echo "${__SCRIPT_NAME} ${__VERSION}"
}
######################################### START ###############################################
main () {
    for __ARG in "${@}"; do
        shift
        case "${__ARG}" in
            "--help") set -- "${@}" "-h" ;;
            "--verbose") set -- "${@}" "-V" ;;
            "--version") set -- "${@}" "-v" ;;
            *) set -- "$@" "${__ARG}"
        esac
    done

    if [[ "$#" = "0" ]]; then
        menu
    else
        while getopts "hV:v-:" __OPTION; do
            case ${__OPTION} in
                h)
                    help
                    exit 0
                    ;;
                V)
                    __VERBOSITY="${OPTARG}"
                    ;;
                v)
                    version
                    exit 0
                    ;;
                *)
                    usage
                    exit 0
                    ;;
            esac
        done
        readonly __VERBOSITY
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

finish() {
    local _result=$?
    # Your cleanup code

    echo # Print a Newline
    log 4 "Cleaning up..."
    log 4 "Exited with code ${_result}"

    exit "${_result}"
}
trap finish EXIT ERR

main "${@}"