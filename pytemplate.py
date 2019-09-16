#! /usr/bin/env python

##################################################################################################
# Author: Paxton Alexander (With the help of Github and StackOverflow)
# Version: 1.0
# Description: A template to be used for quick creation of python scripts.
##################################################################################################

from __future__ import print_function

import os
import sys
import subprocess
import argparse
import signal
######################################## Globals #################################################
__version__ = "v1.0"
SCRIPT_NAME = sys.argv[0].strip("./")
LOCAL_DIR = os.getcwd()

NC='\033[0m'
GRAY='\033[0;90m'
RED='\033[0;91m'
GREEN='\033[0;92m'
YELLOW='\033[0;93m'
BLUE='\033[0;94m'
PASS=u'\u2714' 
FAIL=u'\u274c'

VERBOSITY = 3
LOG_LEVELS = [
    u"[{} {} {}]".format(GREEN, PASS , NC).encode('utf-8'),
    u"[{} {} {}]".format(RED, FAIL , NC).encode('utf-8'),
    "[{} {} {}]".format(YELLOW, "WARN", NC),
    "[{} {} {}]".format(BLUE, "INFO", NC),
    "[{} {} {}]".format(GRAY, "DEBUG", NC),
]
###################################### Functions ################################################

def log(level, msg):
    if level <= VERBOSITY:
        print("{} {}".format(LOG_LEVELS[level], msg))
        sys.stdout.flush()

def banner(msg):
    print("# ========================================================")
    print("# ")
    print("# {} ".format(msg))
    print("# ")
    print("# ========================================================")
    sys.stdout.flush()

def menu():
    menu_options = {
        '1' : 'Option 1',
        '2' : 'Option 2',
        'Q' : 'Quit'
    }
    reply = True
    while reply:
        print("==============================")
        print("        Program Menu          ")
        print("------------------------------")
        print("  Please enter your choice:   ")
        print("                              ")
        options = menu_options.keys()
        options.sort()
        for option in options:
            print ("  {}) {}".format(option, menu_options[option]))
        print("------------------------------")

        sys.stdout.flush()
        reply = raw_input()
        if reply == "1":
            print("Option 1")
            break
        elif reply == "2":
            print("Option 2")
            break
        elif reply == "Q" or reply == "q":
            cleanup(0)
        else:
            print("Invalid option...")
            reply = True

def run(command, ret=True):      # set ret to false if you want output as it's available, 
    log(3, "Running {}".format(command))  # ... otherwise the result of the command is returned.
    p = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

    if ret:
        return p.stdout.read()
    else:
        print("------------ Result ------------------")
        while True:
            line = p.stdout.readline()
            if not line:
                print("--------------------------------------")
                log(3, "Done!")
                break
            print("\t{}".format(line.strip()))
            sys.stdout.flush()

def ask(msg, default="Y"):
    if default == 'Y':
        prompt = '[Y/n]'
    elif default == 'N':
        prompt = '[y/N]'
    else:
        default = None
        prompt = '[y/n]'
    
    reply = True
    while reply:
        print("{} {} ".format(msg, prompt), end='')
        sys.stdout.flush()
        reply = raw_input()
        if reply == '':
            if default is not None:
                reply = default
            else:
                reply = True

        if reply == 'Y' or reply == "y":
            return True
        elif reply == 'N' or reply == 'n':
            return False

def cleanup(code):
    log(4, "Cleaning up...")
    # cleanup code here

    log(4, "Exited with code {}".format(code))
    sys.exit(code)

def signal_handler(sig, frame):
    log(2, "Caught Ctrl-C")
    cleanup(sig)

######################################## Main ####################################################

if __name__ == "__main__":
    signal.signal(signal.SIGINT, signal_handler)

    if len(sys.argv) == 1:
        menu()
    else:
        parser = argparse.ArgumentParser(version=__version__)
        parser.add_argument('-V', '--verbose', help="Set the verbosity level of the script [0-4]", action="store", dest="verbosity", type=int)
        # Add more args here

        args = parser.parse_args()
        VERBOSITY = args.verbosity

        # Examples
        banner("TEST")
        log(4, "Debug test")
        log(3, "Info")
        log(2, "Warn")
        log(1, SCRIPT_NAME)
        log(0, LOCAL_DIR)
        run("ls", False)
        ret = run("ls")
        print(ret)
        ask("Do this?") and log(0, "You did this!")
        ask("Do that?", default='N') or log(1, "You didn't do it...")
        ask("Test this?", default=None) and log(0, "You did it!")
