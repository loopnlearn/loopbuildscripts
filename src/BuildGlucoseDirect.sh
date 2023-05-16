#!/bin/bash # script BuildGlucoseDirect.sh

############################################################
# Required parameters for any build script that uses
#   inline build_functions
############################################################

BUILD_DIR=~/Downloads/"BuildGlucoseDirect"
OVERRIDE_FILE=GlucoseDirect.xcconfig
DEV_TEAM_SETTING_NAME="DEVELOPMENT_TEAM"

# value of 3 means add to an existing file in the repo
USE_OVERRIDE_IN_REPO="3"

# sub modules are not required
CLONE_SUB_MODULES="0"

#!inline build_functions.sh


############################################################
# The rest of this is specific to the particular script
############################################################

initial_greeting


############################################################
# Welcome & Branch Selection
############################################################

URL_THIS_SCRIPT="https://github.com/creepymonster/GlucoseDirect.git"

function choose_main_branch() {
    branch_select ${URL_THIS_SCRIPT} main
}

if [ -z "$CUSTOM_BRANCH" ]; then
    section_separator
    echo -e "\n${INFO_FONT}You are running the script to build GlucoseDirect${NC}"
    echo -e " You need Xcode and Xcode command line tools installed"
    echo -e ""
    echo -e " If you have not read the docs - please review before continuing"
    echo -e "    https://github.com/creepymonster/GlucoseDirect#readme"
    section_divider

    options=("Continue" "Cancel")
    actions=("choose_main_branch" "cancel_entry")
    menu_select "${options[@]}" "${actions[@]}"
else
    branch_select ${URL_THIS_SCRIPT} $CUSTOM_BRANCH
fi

############################################################
# Standard Build train
############################################################

standard_build_train

############################################################
# Open Xcode
############################################################

section_separator
before_final_return_message_without_watch
echo -e " *** Be patient while packages are downloaded"
echo -e ""
return_when_ready
cd $REPO_NAME
xed . 
exit_message
