#!/bin/bash
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
        "SKIP_INITIAL_GREETING: If set, skips the initial greeting when running the script."
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

function initial_greeting() {
    # Skip initial greeting if opted out using env variable or this script is run from BuildLoop
    if [ "${SKIP_INITIAL_GREETING}" = "1" ] || [ "$0" = "_" ]; then return; fi

    local documentation_link="${1:-}"

    section_separator

    echo -e "${INFO_FONT}*** IMPORTANT ***${NC}\n"
    echo -e "This project is:"
    echo -e "${INFO_FONT}  Open Source software"
    echo -e "  Not \"approved\" for therapy${NC}"
    echo -e ""
    echo -e "  You take full responsibility when you build"
    echo -e "  or run an open source app, and"
    echo -e "  ${INFO_FONT}you do so at your own risk.${NC}"
    echo -e ""
    echo -e "To increase (decrease) font size"
    echo -e "  Hold down the CMD key and hit + (-)"
    echo -e "\n${INFO_FONT}By typing 1 and ENTER, you indicate you understand"
    echo -e "\n--------------------------------\n${NC}"

    options=("Agree" "Cancel")
    select opt in "${options[@]}"; do
        case $opt in
        "Agree")
            break
            ;;
        "Cancel")
            echo -e "\n${INFO_FONT}User did not agree to terms of use.${NC}\n\n"
            exit_message
            ;;
        *)
            echo -e "\n${INFO_FONT}User did not agree to terms of use.${NC}\n\n"
            exit_message
            ;;
        esac
    done

    echo -e "${NC}\n\n\n\n"
}

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


section_separator

echo -e "\n\n🕒 Please be patient. On older computers and virtual machines, this may take 5-10 minutes or longer to run.\n"

echo -e "\n\n✅ Removing Developer iOS DeviceSupport Library\n"
rm -rf "$HOME/Library/Developer/Xcode/iOS\ DeviceSupport"

echo -e "✅ Removing Developer watchOS DeviceSupport Library\n"
rm -rf "$HOME/Library/Developer/Xcode/watchOS\ DeviceSupport"

echo -e "✅ Removing Developer DerivedData\n"
rm -rf "$HOME/Library/Developer/Xcode/DerivedData"

echo -e "🛑  Please Reboot Now\n\n";
exit 0
# *** End of inlined file: src/XcodeClean.sh ***

