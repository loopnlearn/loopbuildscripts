#!/bin/bash # script Build_iAPS.sh

############################################################
# this code must be repeated in any build script that uses build_functions.sh
############################################################

BUILD_DIR=~/Downloads/"Build_iAPS"
# For iAPS, OVERRIDE_FILE is inside newly downloaded iAPS folder
# it will be generated with branch and date
OVERRIDE_FILE=file-cannot-exist-so-build_functions-will-work.txt
DEV_TEAM_SETTING_NAME="DEVELOPER_TEAM"

#!inline build_functions.sh


############################################################
# The rest of this is specific to  Build_iAPS.sh
############################################################

initial_greeting


############################################################
# Welcome & Branch Selection
############################################################


function select_iaps_main() {
    branch_select https://github.com/Artificial-Pancreas/iAPS.git main
}

function select_iaps_dev() {
    branch_select https://github.com/Artificial-Pancreas/iAPS.git dev
}

if [ -z "$CUSTOM_BRANCH" ]; then
    section_separator
    echo -e "\n ${RED}${BOLD}You are running the script to build iAPS${NC}"
    echo -e "Before you continue, please ensure"
    echo -e "  you have Xcode and Xcode command line tools installed\n"
    echo -e "Please select which branch of iAPS to download and build."
    echo -e "Most people should choose main branch"
    echo -e ""
    echo -e "Documentation is found at:"
    echo -e "  https://github.com/Artificial-Pancreas/iAPS#iaps"
    echo -e "       and"
    echo -e "  https://iaps.readthedocs.io/en/latest/"
    echo -e ""

    options=("iAPS main" "iAPS dev" "Cancel")
    actions=("select_iaps_main" "select_iaps_dev" "cancel_entry")
    menu_select "${options[@]}" "${actions[@]}"
else
    branch_select https://github.com/Artificial-Pancreas/iAPS.git $CUSTOM_BRANCH
fi

############################################################
# Standard Build train
############################################################

verify_xcode_path
clone_repo
automated_clone_download_error_check
# special for iAPS:
OVERRIDE_FULLPATH="${LOCAL_DIR}/iAPS/ConfigOverride.xcconfig"
check_config_override_existence_offer_to_configure
ensure_a_year


############################################################
# Open Xcode
############################################################

section_separator
echo -e "The following item will open (when you are ready)"
echo -e "* Xcode ready to prep your current download for build"
before_final_return_message
echo -e ""
# needed for main but not dev - remove when no longer required
echo -e "Check to make sure FreeAPS X is selected before building"
echo -e "  top middle of Xcode - next to phone"
return_when_ready
cd $REPO_NAME
xed . 
exit_message
