#!/bin/bash # script BuildLoop.sh
# -----------------------------------------------------------------------------
# This file is GENERATED. DO NOT EDIT directly.
# If you want to modify this file, edit the corresponding file in the src/
# directory and then run the build script to regenerate this output file.
# -----------------------------------------------------------------------------


# *** Start of inlined file: src/common.sh ***
STARTING_DIR="${PWD}"

############################################################
# define some font styles and colors
############################################################

# remove special font
NC='\033[0m'
# add special font
#INFO_FONT='\033[1;36m'
INFO_FONT='\033[1m'
SUCCESS_FONT='\033[1;32m'
ERROR_FONT='\033[1;31m'

function section_divider() {
    echo -e ""
    echo -e "--------------------------------"
    echo -e ""
}

function section_separator() {
    clear
    section_divider
}

function return_when_ready() {
    echo -e "${INFO_FONT}Return when ready to continue${NC}"
    read -p "" dummy
}

# Skip if this script is called from another script, then this has already been displayed
if [ "$0" != "_" ]; then
    # Inform the user about env variables set
    # Variables definition
    variables=(
        "SCRIPT_BRANCH: Indicates the loopbuildscripts branch in use."
        "LOCAL_SCRIPT: Set to 1 to run scripts from the local directory."
        "FRESH_CLONE: Lets you use an existing clone (saves time)."
        "CLONE_STATUS: Can be set to 0 for success (default) or 1 for error."
        "SKIP_OPEN_SOURCE_WARNING: If set, skips the initial greeting when running the script."
        "CUSTOM_URL: Overrides the repo url."
        "CUSTOM_BRANCH: Overrides the branch used for git clone."
        "CUSTOM_MACOS_VER: Overrides the detected macOS version."
        "CUSTOM_XCODE_VER: Overrides the detected Xcode version."
        "DELETE_SELECTED_FOLDERS: Echoes folder names but does not delete them"
    )

    # Flag to check if any variable is set
    any_variable_set=false

    # Iterate over each variable
    for var in "${variables[@]}"; do
        # Split the variable name and description
        IFS=":" read -r name description <<<"$var"

        # Check if the variable is set
        if [ -n "${!name}" ]; then
            # If this is the first variable set, print the initial message
            if ! $any_variable_set; then
                section_separator
                echo -e "For your information, you are running this script in customized mode"
                echo -e "You might be using a branch other than main, and using SCRIPT_BRANCH"
                echo -e "Developers might have additional environment variables set:"
                any_variable_set=true
            fi

            # Print the variable name, value, and description
            echo "  - $name: ${!name}"
            echo "    $description"
        fi
    done
    if $any_variable_set; then
        echo -e "\nTo clear the values, close this terminal and start a new one."
        return_when_ready
    fi
fi

function choose_or_cancel() {
    echo -e "Type a number from the list below and return to proceed."
    echo -e "${INFO_FONT}  To cancel, any entry not in list also works${NC}"
    section_divider
}

function cancel_entry() {
    echo -e "\n${INFO_FONT}User canceled${NC}\n"
    exit_message
}

function invalid_entry() {
    echo -e "\n${ERROR_FONT}User canceled by entering an invalid option${NC}\n"
    exit_message
}

function exit_message() {
    section_divider
    echo -e "${SUCCESS_FONT}Shell Script Completed${NC}"
    echo -e " * You may close the terminal window now if you want"
    echo -e " or"
    echo -e " * You can press the up arrow ⬆️  on the keyboard"
    echo -e "    and return to repeat script from beginning.\n\n"
    exit 0
}

function do_continue() {
    :
}

function menu_select() {
    choose_or_cancel

    local options=("${@:1:$#/2}")
    local actions=("${@:$(($# + 1))/2+1}")

    while true; do
        select opt in "${options[@]}"; do
            for i in $(seq 0 $((${#options[@]} - 1))); do
                if [ "$opt" = "${options[$i]}" ]; then
                    eval "${actions[$i]}"
                    return
                fi
            done
            invalid_entry
            break
        done
    done
}
# *** End of inlined file: src/common.sh ***


# *** Start of inlined file: src/run_script.sh ***
# The function fetches and executes a script either from LnL GitHub repository
# or from the current local directory (if LOCAL_SCRIPT is set to "1").
# The script is executed with "_" as parameter $0, telling the script that it is
# run from within the ecosystem of LnL.
# run_script accepts two parameters:
#   1. script_name: The name of the script to be executed.
#   2. extra_arg (optional): An additional argument to be passed to the script.
# If the script fails to execute, the function prints an error message and terminates
# the entire shell script with a non-zero status code.
run_script() {
    local script_name=$1
    local extra_arg=$2
    echo -e "\n--------------------------------\n"
    echo -e "Executing Script: $script_name"
    echo -e "\n--------------------------------\n"

    if [[ ${LOCAL_SCRIPT:-0} -eq 0 ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/$SCRIPT_BRANCH/$script_name)" _ "$extra_arg"
    else
        /bin/bash -c "$(cat $script_name)" _ "$extra_arg"
    fi

    if [ $? -ne 0 ]; then
        echo "Error: Failed to execute $script_name"
        exit 1
    fi
}
# *** End of inlined file: src/run_script.sh ***


function placeholder() {
    section_divider
    echo -e "  The feature is not available, coming soon"
    echo -e "  This is a placeholder"
    exit_message
}

############################################################
# The rest of this is specific to the particular script
############################################################


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

    run_script "BuildLoopReleased.sh" $CUSTOM_BRANCH

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
        "Placeholder"
        "Cancel"
    )
    actions=(
        "run_script 'CustomizationSelect.sh'"
        "placeholder"
        "cancel_entry"
    )
    menu_select "${options[@]}" "${actions[@]}"
fi

# *** End of inlined file: src/BuildLoop.sh ***

