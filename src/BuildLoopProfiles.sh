#!/bin/bash # script BuildLoopProfiles.sh

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


URL_THIS_SCRIPT="https://github.com/bjorkert/LoopWorkspace.git"
branch_select ${URL_THIS_SCRIPT} profiles Loop_profiles

section_separator
echo -e "${INFO_FONT}You are running the script for the development version for Loop"
echo -e "  with profiles functionality.${NC}"
echo
echo "  You should be following zulipchat and have read LoopDocs:"
echo
echo "https://loopkit.github.io/loopdocs/faqs/branch-faqs/#whats-going-on-in-the-dev-branch"
echo
echo -e "${INFO_FONT}Be aware that a development version may require frequent rebuilds${NC}"
section_divider

options=("Continue" "$(exit_or_return_menu)")
actions=(":" "exit_script")
menu_select "${options[@]}" "${actions[@]}"

############################################################
# Standard Build train
############################################################

standard_build_train

############################################################
# Open Xcode
############################################################

section_divider
before_final_return_message
echo -e ""
return_when_ready
cd $REPO_NAME
xed . 
exit_script
