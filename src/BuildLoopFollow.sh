#!/bin/bash # script BuildLoopFollow.sh

############################################################
# Required parameters for any build script that uses
#   inline build_functions
############################################################

BUILD_DIR=~/Downloads/BuildLoopFollow
OVERRIDE_FILE=LoopFollowConfigOverride.xcconfig
DEV_TEAM_SETTING_NAME="LF_DEVELOPMENT_TEAM"
CLONE_SUB_MODULES="0"

#!inline build_functions.sh


############################################################
# The rest of this is specific to the particular script
############################################################

open_source_warning


############################################################
# Welcome & Branch Selection
############################################################

URL_THIS_SCRIPT="https://github.com/jonfawcett/LoopFollow.git"

function choose_main_branch() {
    branch_select ${URL_THIS_SCRIPT} Main
}

function choose_dev_branch() {
    branch_select ${URL_THIS_SCRIPT} dev
}

if [ -z "$CUSTOM_BRANCH" ]; then
    section_separator
    echo -e "${INFO_FONT}You are running the script to build Loop Follow${NC}"
    echo -e "  You need Xcode and Xcode command line tools installed"
    echo -e ""
    echo -e "Please select which branch of Loop Follow to download and build."
    echo -e "  Most people should choose Main branch"
    echo -e ""
    echo -e "Documentation is found at:"
    echo -e "  https://www.loopandlearn.org/loop-follow/"
    section_divider
    
    options=("Main Branch" "Dev Branch" "Cancel")
    actions=("choose_main_branch" "choose_dev_branch" "cancel_entry")
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
echo -e ""
return_when_ready
cd $REPO_NAME
xed . 
exit_message
