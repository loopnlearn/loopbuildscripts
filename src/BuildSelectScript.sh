#!/bin/bash # script BuildSelectScript.sh

#!inline common.sh
#!inline build_warning.sh
#!inline run_script.sh

# Set default values only if they haven't been defined as environment variables
: ${SCRIPT_BRANCH:="main"}

function placeholder() {
    section_divider
    echo -e "  The feature is not available, coming soon"
    echo -e "  This is a placeholder"
    return
}

############################################################
# The rest of this is specific to the particular script
############################################################

FIRST_TIME="1"
SKIP_OPEN_SOURCE_WARNING="0"

function first_time_menu() {
    section_separator
    echo -e "${INFO_FONT}Welcome to the Loop and Learn\n  Build-Select Script\n${NC}"
    echo "Choose from one of these options:"
    echo "  1 Download and Build Loop"
    echo "  2 Download and Build Related Apps"
    echo "  3 Run Maintenance Utilities"
    echo "  4 Run Customization Select"
    echo "  5 Exit Script"
    echo ""
    echo "After completing a given option, you can choose another or exit the script"
    FIRST_TIME="0"
}

############################################################
# Welcome & What to do selection
############################################################

while true; do
    if [ "${FIRST_TIME}" = "1" ]; then
        first_time_menu
    fi
    section_divider

    options=(\
        "Build Loop" \
        "Build Related Apps" \
        "Maintenance Utilities" \
        "Customization Select" \
        "Exit Script")
    actions=(\
        "WHICH=Loop" \
        "WHICH=OtherApps" \
        "WHICH=UtilityScripts" \
        "WHICH=CustomizationScripts" \
        "exit_script")
    menu_select "${options[@]}" "${actions[@]}"

    if [ "$WHICH" = "Loop" ]; then

        # Issue Warning if not done previously
        open_source_warning

        run_script "BuildLoopReleased.sh" $CUSTOM_BRANCH


    elif [ "$WHICH" = "OtherApps" ]; then

        # Issue Warning if not done previously
        open_source_warning

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
            "Return to Menu")
        actions=(\
            "WHICH=LoopFollow" \
            "WHICH=LoopCaregiver" \
            "WHICH=xDrip4iOS" \
            "WHICH=GlucoseDirect" \
            return)
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
            "Return to Menu"
        )
        actions=(
            "run_script 'DeleteOldDownloads.sh'"
            "run_script 'CleanDerived.sh'"
            "run_script 'XcodeClean.sh'"
            return
        )
        menu_select "${options[@]}" "${actions[@]}"

    else
        run_script "CustomizationSelect.sh" $CUSTOM_BRANCH
    fi
done
