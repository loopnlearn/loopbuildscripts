#!/bin/bash # script BuildLoopDev.sh

############################################################
# Required parameters for any build script that uses
#   inline build_functions
############################################################

BUILD_DIR=~/Downloads/BuildLoop
OVERRIDE_FILE=LoopConfigOverride.xcconfig
DEV_TEAM_SETTING_NAME="LOOP_DEVELOPMENT_TEAM"

#!inline build_functions.sh


############################################################
# The rest of this is specific to the particular script
############################################################

open_source_warning


############################################################
# Welcome & Branch Selection
############################################################

# Stable Dev SHA
FIXED_SHA="a32a19d"
FIXED_COMMIT_DATE="2024-Aug-21"
FLAG_USE_SHA=0

URL_THIS_SCRIPT="https://github.com/LoopKit/LoopWorkspace.git"

function choose_dev_branch() {
    branch_select ${URL_THIS_SCRIPT} dev Loop_dev
}

function choose_fixed_dev_branch() {
    FLAG_USE_SHA=1
    branch_select ${URL_THIS_SCRIPT} dev Loop_dev_${FIXED_SHA}
}

if [ -z "$CUSTOM_BRANCH" ]; then
    section_separator
    echo -e "${INFO_FONT}You are running the script for the development version for Loop${NC}"
    echo -e "${INFO_FONT}You should be familiar with the documenation found at:${NC}"
    echo -e "   https://loopdocs.org"
    echo
    echo "  You should be following zulipchat and have read LoopDocs:"
    echo
    echo "https://loopkit.github.io/loopdocs/faqs/branch-faqs/#whats-going-on-in-the-dev-branch"
    echo
    echo -e "${INFO_FONT}Be aware that a development version may require frequent rebuilds${NC}"
    echo "  1. If you choose dev, you get the most recent commit"
    echo "  2. If you choose lightly tested, you will get:"
    echo -e "    commit ${INFO_FONT}${FIXED_SHA}${NC}, from ${INFO_FONT}${FIXED_COMMIT_DATE}${NC}"
    section_divider

    options=("Choose dev" "Choose dev lightly tested" "$(exit_or_return_menu)")
    actions=("choose_dev_branch" "choose_fixed_dev_branch" "exit_script")
    menu_select "${options[@]}" "${actions[@]}"
else
    branch_select ${URL_THIS_SCRIPT} $CUSTOM_BRANCH
fi

############################################################
# Standard Build train
############################################################

verify_xcode_path
check_versions
clone_repo
automated_clone_download_error_check

# special build train for lightly tested commit
cd $REPO_NAME

this_dir="$(pwd)"
echo -e "In ${this_dir}"
if [ ${FRESH_CLONE} == 0 ] && [ ${FLAG_USE_SHA} == 1 ]; then
    echo -e "\nExtra steps to prepare downloaded code from older clone"
    echo -e "Quit out of Xcode and stash any changes in LoopWorkspace"
    echo -e ""
    return_when_ready
    echo -e "  Updating to latest commit"
    git checkout dev
    git pull
fi
if [ ${FLAG_USE_SHA} == 1 ]; then
    echo -e "  Checking out commit ${FIXED_SHA}\n"
    git checkout ${FIXED_SHA} --recurse-submodules --quiet
    git --no-pager branch
    echo -e "Continue if no errors reported"
    return_when_ready
fi

check_config_override_existence_offer_to_configure
ensure_a_year


############################################################
# Open Xcode
############################################################

section_divider
before_final_return_message
echo -e ""
return_when_ready
xed . 
after_final_return_message
exit_script
