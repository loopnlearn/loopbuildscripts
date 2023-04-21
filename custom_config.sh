#!/bin/bash

# This script sets custom values for scripts, like BuildLoop.
#   It MUST be run using source in order to affect the build scripts.
#   For example: source custom_config.sh && ./BuildLoop.sh

# Clear values before setting them below
unset SCRIPT_BRANCH
unset LOCAL_BUILD_FUNCTIONS_PATH
unset FRESH_CLONE

# SCRIPT_BRANCH is the branch build_functions.sh will be sourced from
#   Uncomment line and replace main with branch you are testing
# export SCRIPT_BRANCH="main"

# LOCAL_BUILD_FUNCTIONS_PATH lets you test build_functions.sh locally
#   Uncomment line; path should be your local clone of loopbuildscripts
#export LOCAL_BUILD_FUNCTIONS_PATH="$HOME/projects/loopbuildscripts/build_functions.sh"
#export LOCAL_BUILD_FUNCTIONS_PATH="$HOME/Downloads/ManualClones/lnl/loopbuildscripts/build_functions.sh"


# FRESH_CLONE (of 0) lets you use an existing LoopWorkspace clone (saves time)
#   Uncomment the line
#   The terminal must be one level higher than an existing LoopWorkspace folder
# export FRESH_CLONE="0"
