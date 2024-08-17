#!/bin/bash # script Build_iAPS.sh

############################################################
# Required parameters for any build script that uses
#   inline build_functions
############################################################

BUILD_DIR=~/Downloads/"Build_iAPS"
# For iAPS, OVERRIDE_FILE is inside newly downloaded iAPS folder
USE_OVERRIDE_IN_REPO="1"
OVERRIDE_FILE="ConfigOverride.xcconfig"
DEV_TEAM_SETTING_NAME="DEVELOPER_TEAM"

# sub modules are not required
CLONE_SUB_MODULES="0"

FLAG_USE_SHA=0  # Initialize FLAG_USE_SHA to 0
FIXED_SHA=""    # Initialize FIXED_SHA with an empty string

#!inline build_functions.sh
#!inline utility_scripts.sh
#!inline run_script.sh

############################################################
# The rest of this is specific to the particular script
############################################################

# Set default values only if they haven't been defined as environment variables
: ${SCRIPT_BRANCH:="main"}


############################################################
# Welcome & Branch Selection
############################################################

URL_THIS_SCRIPT="https://github.com/Artificial-Pancreas/iAPS.git"

# Trio information
URL_FOR_TRIO_DISCORD="discord.gg/FnwFEFUwXE"
URL_FOR_TRIO_FACEBOOK="facebook.com/groups/diytrio"
URL_FOR_TRIO_WEBSITE="diy-trio.org"
URL_FOR_TRIO_DOCS="triodocs.org"

function select_iaps_main() {
    branch_select ${URL_THIS_SCRIPT} main
}

function select_iaps_dev() {
    branch_select ${URL_THIS_SCRIPT} dev
}

section_separator

echo -e "\n ${INFO_FONT}You are running the Build_iAPS script${NC}"
echo -e ""
echo -e "Access to this script is available as a courtesy;"
echo -e "  it might be removed without notice."
echo -e ""
echo -e "The Loop and Learn team that created this script"
echo -e "  suggest you build ${INFO_FONT}Trio${NC} instead."
echo -e ""
echo -e "Please read about this alternative here:"
echo -e ""
echo -e "  Trio Website  link: ${URL_FOR_TRIO_WEBSITE}"
echo -e "  Trio Facebook link: ${URL_FOR_TRIO_FACEBOOK}"
echo -e "  Trio Discord  link: ${URL_FOR_TRIO_DISCORD}"
echo -e ""
section_divider

options=(\
    "Switch to the TrioBuildSelectScript for Trio (New App, New App Group)" \
    "Continue with the iAPS script" \
    "Exit the script")
actions=(\
    "WHICH=Trio" \
    "WHICH=iAPS" \
    "exit_script")
menu_select "${options[@]}" "${actions[@]}"

if [ "$WHICH" = "Trio" ]; then
    run_script "TrioBuildSelectScript.sh"
    exit_script
fi

open_source_warning

if [ -z "$CUSTOM_BRANCH" ]; then
    while [ -z "$BRANCH" ]; do
        section_separator
        echo -e "\n ${INFO_FONT}You are running the script to build iAPS${NC}"
        echo -e " ${INFO_FONT}  or run maintenance utilities${NC}"
        echo -e ""
        echo -e "Before you continue, please ensure"
        echo -e "  you have Xcode and Xcode command line tools installed\n"
        echo -e "Please select which branch of iAPS to download and build."
        echo -e ""
        echo -e "Documentation for iAPS:"
        echo -e "  https://iaps.readthedocs.io/en/main/"
        echo -e "Documentation for maintenance utilities:"
        echo -e "  https://www.loopandlearn.org/build-select/#utilities-disk"
        echo -e ""

        options=("iAPS 2.3.3 tested main" "iAPS main" "iAPS dev" "Run Maintenance Utilities" "$(exit_or_return_menu)")
        actions=("select_iaps_tested_main" "select_iaps_main" "select_iaps_dev" "utility_scripts" "exit_script")
        menu_select "${options[@]}" "${actions[@]}"
    done
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
if [ ${FLAG_USE_SHA} == 1 ]; then
    echo -e "  Checking out commit ${FIXED_SHA}\n"
    git checkout ${FIXED_SHA} --recurse-submodules --quiet
    git describe --tags --exact-match
    git rev-parse HEAD
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
