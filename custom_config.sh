#!/bin/bash

# This script sets custom values for scripts, like BuildLoop.
#   It MUST be run using source in order to affect the build scripts.
#   For example: source custom_config.sh && ./BuildLoop.sh

# Clear values before setting them below
unset SCRIPT_BRANCH
unset LOCAL_SCRIPT
unset FRESH_CLONE
unset CLONE_STATUS
unset SKIP_OPEN_SOURCE_WARNING
unset CUSTOM_URL
unset CUSTOM_BRANCH
unset CUSTOM_MACOS_VER
unset CUSTOM_XCODE_VER
unset PATCH_BRANCH
unset PATCH_REPO
unset LOCAL_PATCH_FOLDER

# To Test Scripts as they exist on github
# SCRIPT_BRANCH is the branch scripts will be sourced from
#   Uncomment line and replace main with branch you are testing
#export SCRIPT_BRANCH="main"

# LOCAL_SCRIPT can be set to 1 to run scripts from the local directory
#   If not set or set to 0, scripts will be sourced from GitHub
#   Uncomment the line
#   Set the value to 1 to run scripts locally
#export LOCAL_SCRIPT="1"

# FRESH_CLONE (of 0) lets you use an existing LoopWorkspace clone (saves time)
#   Uncomment the line
#   Terminal must be one level higher than an existing LoopWorkspace folder
#export FRESH_CLONE="0"

# CLONE_STATUS can be set to 0 for success (default) or 1 for error
#   Uncomment only to trigger an error in the clone check
#   Pair this with FRESH_CLONE="0"
#export CLONE_STATUS="1"

# SKIP_OPEN_SOURCE_WARNING can be set to 1 to skip the open source warning
#   Uncomment the line
#   Set the value to 1 to skip the open source warning
#export SKIP_OPEN_SOURCE_WARNING="1"

# CUSTOM_BRANCH overrides the branch used for git clone
#   Uncomment the line
#   Set value to branch name, for example libre
#export CUSTOM_BRANCH=libre

# CUSTOM_URL overrides the repo url
#   Uncomment the line
#   Set the repo to be cloned
#export CUSTOM_URL=https://github.com/bjorkert/LoopWorkspace.git

# CUSTOM_XCODE_VER overrides the detected Xcode version
#   Uncomment the line
#   Set the version to be simulated
#export CUSTOM_XCODE_VER=14.1

# CUSTOM_MACOS_VER overrides the detected macOS version
#   Uncomment the line
#   Set the version to be simulated
#export CUSTOM_MACOS_VER=12.9

# DELETE_SELECTED_FOLDERS override to just report what folders would be deleted
#   Uncomment the line
#   Default is 1 (really delete)
#export DELETE_SELECTED_FOLDERS=0

# PATCH_BRANCH is the branch from which patches will be sourced
#   Uncomment the line and replace "main" with the branch you are using
#export PATCH_BRANCH="main"

# PATCH_REPO is the repository URL from which patches will be sourced
#   Uncomment the line and replace with your own repository URL if not using the default
#export PATCH_REPO="https://github.com/loopandlearn/customization.git"

# LOCAL_PATCH_FOLDER is the local directory from which patches will be sourced
#   If not set or empty, patches will be downloaded from the PATCH_REPO
#   Uncomment the line and replace with your own local directory if not using the default
#   The path should be absolute or relative to the current script's directory
#export LOCAL_PATCH_FOLDER="/path/to/your/local/patch/folder"