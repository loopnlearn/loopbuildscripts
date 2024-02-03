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
#!inline loopfollow_functions.sh

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
    echo -e "${INFO_FONT}STOP - Please read this updated information${NC}"
    echo -e ""
    echo -e "You can build main or dev branch of Loop Follow with this script"
    echo -e "For main branch, you can choose multiple instances"
    echo -e "  - useful if you follow more than one looper"
    echo -e ""
    echo -e "${INFO_FONT}You can choose a custom app/display name${NC}"
    echo -e ""
    echo -e "These choices build the main branch"
    echo -e "  - 'main branch': Use this to build the primary version of Loop Follow"
    echo -e "  - 'Second LoopFollow': Use this for a second looper"
    echo -e "  - 'Third LoopFollow': Use this for a third looper"
    echo -e ""
    echo -e "  - 'dev branch': Choose only when a feature is being tested in dev"
    echo -e ""
    echo -e "Documentation: https://www.loopandlearn.org/loop-follow/"
    echo -e ""
    return_when_ready
    section_divider

    options=("main branch" "Second LoopFollow app" "Third LoopFollow app" "dev branch" "$(exit_or_return_menu)")
    actions=("choose_main_branch" "choose_second" "choose_third" "choose_dev_branch" "exit_script")
    menu_select "${options[@]}" "${actions[@]}"
else
    branch_select ${URL_THIS_SCRIPT} $CUSTOM_BRANCH
fi


############################################################
# Standard Build train
############################################################

standard_build_train
loop_follow_display_name_config_override


############################################################
# Open Xcode
############################################################

section_divider
before_final_return_message
echo -e ""
return_when_ready
cd $REPO_NAME
xed . 
after_final_return_message
exit_script
