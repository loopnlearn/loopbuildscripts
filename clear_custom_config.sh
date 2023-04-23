#!/bin/bash

# Unset environment variables related to testing
# This script MUST be run using source in order to affect the build scripts.
# For example: source clear_custom_config.sh&&./BuildLoop.sh

unset SCRIPT_BRANCH
unset LOCAL_BUILD_FUNCTIONS_PATH
unset FRESH_CLONE
unset CLONE_STATUS
unset SKIP_INITIAL_GREETING
