#!/bin/bash

# This script sets custom values for BuildLoop it MUST be run using source in order to affect the build scripts.
# For example: source custom_config.sh&&./BuildLoop.sh

# Clear values before setting them below
unset SCRIPT_BRANCH
unset LOCAL_BUILD_FUNCTIONS_PATH
unset FRESH_CLONE

# SCRIPT_BRANCH is the branch build_functions.sh will be sourced from
export SCRIPT_BRANCH="xcode-select"

# Local sourcing of build_functions.sh
#export LOCAL_BUILD_FUNCTIONS_PATH="$HOME/projects/loopbuildscripts/build_functions.sh"
#export LOCAL_BUILD_FUNCTIONS_PATH="$HOME/Downloads/ManualClones/lnl/loopbuildscripts/build_functions.sh"

# Use existing loop download instead of cloning a new
#export FRESH_CLONE="0"