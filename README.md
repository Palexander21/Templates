# Templates

The following templates are laid out to allow quick creation of shell or python scripts. They are nearly identical in their output and setup. Creating a new script from them is quick and easy.

### Shell Template Guide

The shell template has been designed to follow industry best practices. This includes:

* Double underscored and capitalized global variables set to `readonly` 
* single underscored lowercased local variables defined with `local`
* All variables expanded with "" and {} i.e. `"${__VAR}"`
* Commands run with `$()` instead of backticks.
* A trap function to cleanup on exit or errors
* No unset variables allowed.

The following functions have been implemented:
* `log` Allows you to log output of various verbosity levels:
    * 0 - Success ✔
    * 1 - Error ✖
    * 2 - Warn
    * 3 - Info
    * 4 - Debug
    * Example: `log 3 "This is an info message!` would output `[ INFO ] This is an info message!`
    * Verbosity level can be configured through the CLI with the flag -V [VERBBOSITY] or --verbose [VERBOSITY]
* `ask` Provides a prompt for a y/n question. Takes the question as an argument with the option of passing in the default answer as an argument
    * Example: `ask "Continue?" Y` outputs `Continue [Y/n]` with Y being the default if enter is pressed.
* `banner` Displays a banner for emphasising what step of the program you are on. Takes a title as a parameter.
    * Example: `banner "Testing Banner"` ouputs 
    ```
   #========================================================
    # 
    # Testing Banner
    #
    # ========================================================
* `menu` displays a program menu if needed.
* `help`, `usage`, and `version` are self-explanatory
* `main` Parses arguments, converting log args to their short counterpart.
* `cleanup` Always run last. Used for cleaning up tmp files used and making sure all changes that need to be restored are.

To use just delete the examples at the bottom of main, add your command-line args and create your functions as needed. Hope it speeds up bash script creation times!

### Python Template Guide

If Python is more your style than this template will work for writing similair scripts. It has all the same functionality as the shell template. The only difference being that to run shell commands you need to call the function `run([COMMAND], ret=True)`. This spawns a shell process and can either return the output if `ret=True` or just output as it receives it with `ret=False`
* Example: `run('ls', ret=False)` will print out the directory contents as fast as the subprocess and print it. `val = run('ls')` will return the value that `ls` command returns to val for later use.

Arguments are much easier to add as the argparse library is used for handling that.