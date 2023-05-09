#!/bin/bash # script BuildLoop.sh

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

initial_greeting "https://loopdocs.org"


############################################################
# Welcome & What to do selection
############################################################

section_separator
echo -e "${BOLD}Welcome to the Loop and Learn\n  Build-Select Script\n${NC}"
echo -e "This script will help you to:"
echo -e "  1 Download and build Loop"
echo -e "  2 Download and build LoopFollow"
echo -e "  3 Select a Utility Script to assist when updating your computer"
echo -e "     or Customizing Loop"
echo -e "\nRun the script again to choose a different task"

options=("Build Loop" "Build LoopFollow" "Utility Scripts" "Cancel")
actions=("WHICH=Loop" "WHICH=LoopFollow" "WHICH=UtilityScripts" "cancel_entry")
menu_select "${options[@]}" "${actions[@]}"

if [ "$WHICH" = "Loop" ]; then
    if [ -z "$CUSTOM_URL" ] || [ -z "$CUSTOM_BRANCH" ]; then
        function choose_loop() {
            branch_select https://github.com/LoopKit/LoopWorkspace.git main Loop
        }

        function choose_loop_with_patches() {
            branch_select https://github.com/loopnlearn/LoopWorkspace.git main_lnl_patches Loop_lnl_patches
        }
        
        section_separator
        echo -e "Before you continue, please ensure"
        echo -e "  you have Xcode and Xcode command line tools installed\n"
        echo -e "Please select which version of Loop to download and build."
        echo -e "\n  Loop:"
        echo -e "      This is always the current released version"
        echo -e "      More info at https://github.com/LoopKit/Loop/releases"
        echo -e "\n  Loop with Patches:"
        echo -e "      adds 2 CGM options, CustomTypeOne LoopPatches, new Logo"
        echo -e "      More info at https://www.loopandlearn.org/main-lnl-patches"

        options=("Loop" "Loop with Patches" "Cancel")
        actions=("choose_loop" "choose_loop_with_patches" "cancel_entry")
        menu_select "${options[@]}" "${actions[@]}"
    else
        branch_select $CUSTOM_URL $CUSTOM_BRANCH
    fi

    ############################################################
    # Standard Build train
    ############################################################

    check_versions
    verify_xcode_path
    clone_repo
    automated_clone_download_error_check
    check_config_override_existence_offer_to_configure
    ensure_a_year

    section_separator
    echo -e "The following item will open (when you are ready)"
    echo -e "* Xcode ready to prep your current download for build"
    before_final_return_message
    echo -e "\n${RED}${BOLD}As of Loop 3.2${NC}, LoopWorkspace is already configured."
    echo -e "LoopWorkspace shows up in 2 places at top of Xcode."
    echo -e "LoopDocs graphics will be updated soon.\n"
    return_when_ready
    cd $REPO_NAME
    xed .
    exit_message

elif [ "$WHICH" = "LoopFollow" ]
then
    cd $SCRIPT_DIR
    echo -e "\n\n--------------------------------\n\n"
    echo -e "Downloading Loop Follow Script\n"
    echo -e "\n--------------------------------\n\n"
    curl -fsSLo ./BuildLoopFollow.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/$SCRIPT_BRANCH/BuildLoopFollow.sh
    echo -e "\n\n\n\n"
    source ./BuildLoopFollow.sh
else
    function choose_clean_derived() {
        echo -e "\n--------------------------------\n"
        echo -e "Downloading Script: CleanDerived.sh"
        echo -e "\n--------------------------------\n"
        curl -fsSLo ./CleanDerived.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/$SCRIPT_BRANCH/CleanDerived.sh
        source ./CleanDerived.sh
    }

    function choose_xcode_cleanup() {
        echo -e "\n--------------------------------\n"
        echo -e "Downloading Script: XcodeClean.sh"
        echo -e "\n--------------------------------\n"
        curl -fsSLo ./XcodeClean.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/$SCRIPT_BRANCH/XcodeClean.sh
        source ./XcodeClean.sh
    }

    function choose_clean_profiles() {
        echo -e "\n--------------------------------\n"
        echo -e "Downloading Script: CleanProfiles.sh"
        echo -e "\n--------------------------------\n"
        curl -fsSLo ./CleanProfiles.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/$SCRIPT_BRANCH/CleanProfiles.sh
        source ./CleanProfiles.sh
    }

    function choose_customizations() {
        echo -e "\n--------------------------------\n"
        echo -e "Downloading Script: CustomizationSelect.sh"
        echo -e "\n--------------------------------\n"
        curl -fsSLOJ https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/$SCRIPT_BRANCH/CustomizationSelect.sh
        source ./CustomizationSelect.sh
    }

    cd $SCRIPT_DIR
    echo -e "\n\n\n\n"
    echo -e "\n--------------------------------\n"
    echo -e "${BOLD}These utility scripts automate several cleanup actions${NC}"
    echo -e "\n--------------------------------\n"
    echo -e "1 ➡️  Clean Derived Data:\n"
    echo -e "    This script is used to clean up data from old builds."
    echo -e "    In other words, it frees up space on your disk."
    echo -e "    Xcode should be closed when running this script.\n"
    echo -e "2 ➡️  Xcode Cleanup (The Big One):\n"
    echo -e "    This script clears even more disk space filled up by using Xcode."
    echo -e "    It is typically used after uninstalling Xcode"
    echo -e "      and before installing a new version of Xcode."
    echo -e "    It can free up a substantial amount of disk space."
    echo -e "\n    You might be directed to use this script to resolve a problem."
    echo -e "\n${RED}${BOLD}    Beware that you might be required to fully uninstall"
    echo -e "      and reinstall Xcode if you run this script with Xcode installed.\n${NC}"
    echo -e "    Always a good idea to reboot your computer after Xcode Cleanup.\n"
    echo -e "3 ➡️  Clean Profiles:\n"
    echo -e "    Incorporated in the BuildLoop section"
    echo -e "    No longer needed as a stand-alone step.\n"
    echo -e "4 ➡️  Apply Customizations to Loop:\n"
    echo -e "    The customizations are documented here:"
    echo -e "    https://www.loopandlearn.org/custom-code/#custom-list"
    echo -e "5 ➡️  Delete old downloads :\n"
    echo -e "    TODO: Describe this feature..."
    echo -e "\n--------------------------------\n"
    echo -e "${RED}${BOLD}You may need to scroll up in the terminal to see details about options${NC}"

    options=("Clean Derived Data" "Xcode Cleanup (The Big One)" "Clean Profiles" "Apply Customizations to Loop" "Delete old downloads" "Cancel")
    actions=("choose_clean_derived" "choose_xcode_cleanup" "choose_clean_profiles" "choose_customizations" "delete_old_downloads" "cancel_entry")
    menu_select "${options[@]}" "${actions[@]}"
fi

