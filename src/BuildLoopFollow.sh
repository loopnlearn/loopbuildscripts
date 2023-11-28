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

URL_THIS_SCRIPT="https://github.com/loopandlearn/LoopFollow.git"

function choose_main_branch() {
    branch_select ${URL_THIS_SCRIPT} main
}

function choose_second() {
    branch_select "https://github.com/loopandlearn/LoopFollow_Second.git" main
}

function choose_third() {
    branch_select "https://github.com/loopandlearn/LoopFollow_Third.git" main
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
    echo -e "  - 'main branch': Use this to build the primary version of Loop Follow."
    echo -e "  - 'dev branch': Choose this for the latest development version."
    echo -e "  - 'Second LoopFollow app': Select this to build a secondary instance"
    echo -e "     of Loop Follow, useful if managing multiple Loopers."
    echo -e "  - 'Third LoopFollow app': Choose this to build a third instance."
    echo -e ""
    echo -e "Documentation is found at:"
    echo -e "  https://www.loopandlearn.org/loop-follow/"
    section_divider

    options=("main branch" "dev branch" "Second LoopFollow app" "Third LoopFollow app" "$(exit_or_return_menu)")
    actions=("choose_main_branch" "choose_dev_branch" "choose_second" "choose_third" "exit_script")
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

section_divider
before_final_return_message "no watch"
echo -e ""
return_when_ready
cd $REPO_NAME
xed . 
exit_script
