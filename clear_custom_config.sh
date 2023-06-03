#!/bin/bash

# Unset environment variables related to testing
# This script MUST be run using source in order to affect the build scripts.
# For example: source clear_custom_config.sh&&./BuildLoop.sh

unset SCRIPT_BRANCH
unset LOCAL_SCRIPT
unset FRESH_CLONE
unset CLONE_STATUS
unset SKIP_OPEN_SOURCE_WARNING
unset CUSTOM_URL
unset CUSTOM_BRANCH
unset CUSTOM_MACOS_VER
unset CUSTOM_XCODE_VER
unset DELETE_SELECTED_FOLDERS
unset PATCH_BRANCH
unset PATCH_REPO
unset LOCAL_PATCH_FOLDER
