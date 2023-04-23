#!/bin/bash

# This script sets custom values for scripts, like BuildLoop.
#   It MUST be run using source in order to affect the build scripts.
#   For example: source custom_config.sh && ./BuildLoop.sh

# Clear values before setting them below
unset SCRIPT_BRANCH
unset LOCAL_BUILD_FUNCTIONS_PATH
unset FRESH_CLONE
unset CLONE_STATUS

# To Test build_functions.sh as they exist on github
# SCRIPT_BRANCH is the branch build_functions.sh will be sourced from
#   Uncomment line and replace main with branch you are testing
export SCRIPT_BRANCH="patch-select"

# To Test build_functions.sh as they exist on your local clone
# LOCAL_BUILD_FUNCTIONS_PATH lets you test build_functions.sh locally
#   Uncomment line; path should be your local clone of loopbuildscripts
export LOCAL_BUILD_FUNCTIONS_PATH="$HOME/projects/loopbuildscripts/build_functions.sh"
#export LOCAL_BUILD_FUNCTIONS_PATH="/Users/marion/Downloads/ManualClones/lnl/loopbuildscripts/build_functions.sh"

# FRESH_CLONE (of 0) lets you use an existing LoopWorkspace clone (saves time)
#   Uncomment the line
#   The terminal must be one level higher than an existing LoopWorkspace folder
#export FRESH_CLONE="0"

# CLONE_STATUS can be set to 0 for success (default) or 1 for error
#   Uncomment only to trigger an error in the clone check
#   Pair this with FRESH_CLONE="0"
#export CLONE_STATUS="1"

# SKIP_INITIAL_GREETING can be set to 1 to skip the initial greeting
#   Uncomment the line
#   Set the value to 1 to skip the initial greeting dialog
#export SKIP_INITIAL_GREETING="1"
