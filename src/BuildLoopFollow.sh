#!/bin/bash # script BuildLoopFollow.sh

############################################################
# this code must be repeated in any build script that uses build_functions.sh
############################################################

BUILD_DIR=~/Downloads/BuildLoopFollow
OVERRIDE_FILE=LoopFollowConfigOverride.xcconfig
DEV_TEAM_SETTING_NAME="LF_DEVELOPMENT_TEAM"

#!inline build_functions.sh


############################################################
# The rest of this is specific to  BuildLoopFollow.sh
############################################################

initial_greeting


############################################################
# Branch Selection
############################################################

function choose_main_branch() {
    REPO_NAME="LoopFollow"
    REPO="https://github.com/jonfawcett/LoopFollow"
    BRANCH="Main"
}

function choose_dev_branch() {
    REPO_NAME="LoopFollow"
    REPO="https://github.com/jonfawcett/LoopFollow"
    BRANCH="dev"
}

if [ -z "$CUSTOM_BRANCH" ]; then
    section_separator
    echo -e "\n ${RED}${BOLD}You are running the script to build Loop Follow${NC}"
    echo -e "Before you continue, please ensure"
    echo -e "  you have Xcode and Xcode command line tools installed\n"
    echo -e "Please select which branch of Loop Follow to download and build."
    echo -e "Most people should choose main branch"
    echo -e ""
    echo -e "Documentation is found at:"
    echo -e "  https://www.loopandlearn.org/...."
    options=("Main Branch" "Dev Branch" "Cancel")
    actions=("choose_main_branch" "choose_dev_branch" "cancel_entry")
    menu_select "${options[@]}" "${actions[@]}"
else
    REPO_NAME="LoopFollow"
    REPO="https://github.com/jonfawcett/LoopFollow"
    BRANCH="$CUSTOM_BRANCH"
fi


############################################################
# Standard Build train
############################################################

delete_old_downloads
verify_xcode_path
clone_repo
automated_clone_download_error_check
check_config_override_existence_offer_to_configure
ensure_a_year


############################################################
# Open Xcode
############################################################

cd LoopFollow
section_separator
echo -e "The following item will open (when you are ready)"
echo -e "* Xcode ready to prep your current download for build"
before_final_return_message
echo -e ""
return_when_ready
xed .
exit_message