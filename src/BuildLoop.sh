#!/bin/bash # script BuildLoop.sh

############################################################
# Required parameters for any build script that uses
#   inline build_functions
############################################################

BUILD_DIR=~/Downloads/BuildLoop
OVERRIDE_FILE=LoopConfigOverride.xcconfig
DEV_TEAM_SETTING_NAME="LOOP_DEVELOPMENT_TEAM"

#!inline build_functions.sh

#!inline run_script.sh

function placeholder() {
    section_divider
    echo -e "  The feature is not available, coming soon"
    echo -e "  This is a placeholder"
    exit_message
}

############################################################
# The rest of this is specific to the particular script
############################################################

initial_greeting


############################################################
# Welcome & What to do selection
############################################################

section_separator
echo -e "${INFO_FONT}Welcome to the Loop and Learn\n  Build-Select Script\n${NC}"
echo -e "This script will help you to:"
echo -e "  1 Download and Build Loop"
echo -e "  2 Download and Build Related Apps"
echo -e "  3 Run Maintenance Utilities"
echo -e "  4 Run Customization Utilities"
echo -e ""
echo -e "Run the script again to choose a different option"
echo -e "You need Xcode and Xcode command line tools installed"
section_divider

options=(\
    "Build Loop" \
    "Build Related Apps" \
    "Maintenance Utilities" \
    "Customization Utilities" \
    "Cancel")
actions=(\
    "WHICH=Loop" \
    "WHICH=OtherApps" \
    "WHICH=UtilityScripts" \
    "WHICH=CustomizationScripts" \
    "cancel_entry")
menu_select "${options[@]}" "${actions[@]}"

if [ "$WHICH" = "Loop" ]; then

    URL_THIS_SCRIPT="https://github.com/jonfawcett/LoopFollow.git"

    if [ -z "$CUSTOM_BRANCH" ]; then
        function choose_loop() {
            branch_select https://github.com/LoopKit/LoopWorkspace.git main Loop
        }

        function choose_loop_with_patches() {
            branch_select https://github.com/loopnlearn/LoopWorkspace.git main_lnl_patches Loop_lnl_patches
        }
        
        section_separator
        echo -e "${INFO_FONT}You should be familiar with the documenation found at:${NC}"
        echo -e "   https://loopdocs.org"
        echo -e ""
        echo -e "Select which version of Loop to download and build."
        echo -e "   Loop:"
        echo -e "      This is always the current released version"
        echo -e "      More info at https://github.com/LoopKit/Loop/releases"
        echo -e "   Loop with Patches:"
        echo -e "      Adds 2 CGM options, CustomTypeOne LoopPatches, new Logo"
        echo -e "      More info at https://www.loopandlearn.org/main-lnl-patches"
        section_divider

        options=("Loop" "Loop with Patches" "Cancel")
        actions=("choose_loop" "choose_loop_with_patches" "cancel_entry")
        menu_select "${options[@]}" "${actions[@]}"
    else
        section_separator
        echo -e "You are about to download $CUSTOM_BRANCH branch from"
        echo -e "  ${CUSTOM_URL:-"https://github.com/LoopKit/LoopWorkspace.git"}\n"
        return_when_ready
        branch_select ${CUSTOM_URL:-"https://github.com/LoopKit/LoopWorkspace.git"} $CUSTOM_BRANCH
    fi

    ############################################################
    # Standard Build train
    ############################################################

    standard_build_train

    section_separator
    before_final_return_message
    return_when_ready
    cd $REPO_NAME
    xed .
    exit_message

elif [ "$WHICH" = "OtherApps" ]; then

    section_separator
    echo -e "Select the app you want to build"
    echo -e "  Each selection will indicate documentation links"
    echo -e "  Please read the documentation before using the app"
    echo -e ""
    options=(\
        "Build Loop Follow" \
        "Build LoopCaregiver" \
        "Build xDrip4iOS" \
        "Build Glucose Direct" \
        "Cancel")
    actions=(\
        "WHICH=LoopFollow" \
        "WHICH=LoopCaregiver" \
        "WHICH=xDrip4iOS" \
        "WHICH=GlucoseDirect" \
        "cancel_entry")
    menu_select "${options[@]}" "${actions[@]}"
    if [ "$WHICH" = "LoopFollow" ]; then
        run_script "BuildLoopFollow.sh" $CUSTOM_BRANCH
    elif [ "$WHICH" = "LoopCaregiver" ]; then
        run_script "BuildLoopCaregiver.sh" $CUSTOM_BRANCH
    elif [ "$WHICH" = "xDrip4iOS" ]; then
        run_script "BuildxDrip4iOS.sh" $CUSTOM_BRANCH
    elif [ "$WHICH" = "GlucoseDirect" ]; then
        run_script "BuildGlucoseDirect.sh" $CUSTOM_BRANCH
    fi

elif [ "$WHICH" = "UtilityScripts" ]; then

    section_separator
    echo -e "${INFO_FONT}These utility scripts automate several cleanup actions${NC}"
    echo -e ""
    echo -e " 1. Delete Old Downloads:"
    echo -e "     This will keep the most recent download for each build type"
    echo -e "     It asks before deleting any folders"
    echo -e " 2. Clean Derived Data:"
    echo -e "     Free space on your disk from old Xcode builds."
    echo -e "     You should quit Xcode before running this script."
    echo -e " 3. Xcode Cleanup (The Big One):"
    echo -e "     Clears more disk space filled up by using Xcode."
    echo -e "     * Use after uninstalling Xcode prior to new installation"
    echo -e "     * It can free up a substantial amount of disk space"
    section_divider

    options=(
        "Delete Old Downloads"
        "Clean Derived Data"
        "Xcode Cleanup"
        "Cancel"
    )
    actions=(
        "run_script 'DeleteOldDownloads.sh'"
        "run_script 'CleanDerived.sh'"
        "run_script 'XcodeClean.sh'"
        "cancel_entry"
    )
    menu_select "${options[@]}" "${actions[@]}"

else
    section_separator
    echo -e "${INFO_FONT}Selectable Customizations for:${NC}"
    echo -e "    Released code: Loop or Loop with Patches"
    echo -e "    Might work for development branches of Loop"
    echo -e ""
    echo -e "Reports status for each customization:"
    echo -e "    can be or has been applied or is not applicable"
    echo -e ""
    echo -e "Automatically finds most recent Loop download unless"
    echo -e "    terminal is already at the LoopWorkspace folder level"
    section_divider

    options=(
        "Loop Customizations"
        "CustomTypeOne Customizations"
        "Cancel"
    )
    actions=(
        "run_script 'CustomizationSelect.sh'"
        "placeholder"
        "cancel_entry"
    )
    menu_select "${options[@]}" "${actions[@]}"
fi

