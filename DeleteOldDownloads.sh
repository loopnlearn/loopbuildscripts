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
        "SKIP_OPEN_SOURCE_WARNING: If set, skips the open source warning for build scripts."
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

function choose_option() {
    echo -e "Type a number from the list below and return to proceed."
    section_divider
}

function exit_script() {
    section_divider
    echo -e "${INFO_FONT}Exit from Script${NC}\n"
    echo -e "  You may close the terminal"
    echo -e "or"
    echo -e "  You can press the up arrow ⬆️  on the keyboard"
    echo -e "    and return to repeat script from beginning"
    section_divider
    exit 0
}

function invalid_entry() {
    echo -e "\n${ERROR_FONT}Invalid option${NC}\n"
}

function do_continue() {
    :
}

function menu_select() {
    choose_option

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

function exit_or_return_menu() {
    if [ "$0" != "_" ]; then
        echo "Exit Script"
    else
        echo "Return to Menu"
    fi
}
# *** End of inlined file: src/common.sh ***



# *** Start of inlined file: src/delete_old_downloads.sh ***
# Flag to skip all deletions
SKIP_ALL=false
folder_count=0
app_pattern_count=0

# Default if environment variable is not set
: ${DELETE_SELECTED_FOLDERS:="1"}

function list_build_folders_when_testing() {
    # only echo pattern when testing
    if [ ${DELETE_SELECTED_FOLDERS} == 0 ]; then
        echo
        echo -e "  ${INFO_FONT}Environment variable DELETE_SELECTED_FOLDERS is set to 0"
        echo -e "  This is the list of all patterns that will be searched${NC}"
        echo
        for pattern in "${patterns[@]}"; do
            echo "    $pattern"
        done
        section_divider
    fi
}

function delete_folders_except_latest() {
    local pattern="$1"
    local total_size=0
    local unsorted_folders=()
    for entry in ~/Downloads/$pattern; do
        [ -d "$entry" ] && unsorted_folders+=("$entry")
    done
    # Sort the folders array by date (newest first)
    IFS=$'\n' folders=($(sort -r <<<"${unsorted_folders[*]}"))
    IFS=$' \t\n' # Reset IFS to default value.

    if [ ${#folders[@]} -eq 0 ]; then
        return
    fi

    # increment because folders were found
    ((app_pattern_count=app_pattern_count+1))

    if [ ${#folders[@]} -eq 1 ]; then
        echo "Only one download found for app pattern: '$pattern'"
        return
    fi

    section_divider

    echo "More than one download found for app pattern:"
    echo "  '$pattern':"
    echo
    echo "Download Folder to Keep:"
    echo "  ${folders[0]/#$HOME/~}"
    echo

    echo "Download Folder(s) that can be deleted:"
    for folder in "${folders[@]:1}"; do
        echo "  ${folder/#$HOME/~}"
        total_size=$(($total_size + $(du -s "$folder" | awk '{print $1}')))
    done

    total_size_mb=$(echo "scale=2; $total_size / 1024" | bc)
    echo
    echo "Total size to be deleted: $total_size_mb MB"
    section_divider

    options=(
        "Delete these Folders" 
        "Skip delete at this location" 
        "$(exit_or_return_menu)")
    actions=(
        "delete_selected_folders \"$pattern\"" 
        "return" 
        "exit_script")
    menu_select "${options[@]}" "${actions[@]}"
}

function delete_selected_folders() {
    local pattern="$1"
    local unsorted_folders=()
    for entry in ~/Downloads/$pattern; do
        [ -d "$entry" ] && unsorted_folders+=("$entry")
    done
    # Sort the folders array by date (newest first)
    IFS=$'\n' folders=($(sort -r <<<"${unsorted_folders[*]}"))
    IFS=$' \t\n' # Reset IFS to default value.
    echo

    this_pattern_count=0

    for folder in "${folders[@]:1}"; do
        if [ ${DELETE_SELECTED_FOLDERS} == 1 ]; then
            rm -rf "$folder"
        fi
        echo "  Removed $folder"
        ((folder_count=folder_count+1))
        ((this_pattern_count=this_pattern_count+1))
    done

    echo -e "✅ ${SUCCESS_FONT}Deleted ${this_pattern_count} download folders for this app pattern${NC}"
    if [ ${DELETE_SELECTED_FOLDERS} == 0 ]; then
        echo
        echo -e "  ${INFO_FONT}Environment variable DELETE_SELECTED_FOLDERS is set to 0"
        echo -e "  So folders marked successfully deleted are still there${NC}"
    fi
    echo
    return_when_ready
}

function skip_all() {
    SKIP_ALL=true
}

function delete_old_downloads() {
    patterns=(
        "BuildLoop/Loop-*"
        "BuildLoop/Loop_lnl_patches-*"
        "BuildLoop/LoopCaregiver_dev-*"
        "BuildLoop/LoopWorkspace_*"
        "BuildLoop/Loop_dev-*"
        "BuildLoop/FreeAPS*"
        "BuildLoopFollow/LoopFollow_Main*"
        "BuildLoopFollow/LoopFollow_dev*"
        "BuildxDrip4iOS/xDrip4iOS*"
        "BuildGlucoseDirect/GlucoseDirect*"
        "Build_iAPS/iAPS_main*"
        "Build_iAPS/iAPS_dev*"
    )

    list_build_folders_when_testing

    if [ "$SKIP_ALL" = false ] ; then
        section_divider
        echo "For each type of Build provided as a build script, "
        echo "  you will be shown your most recent download"
        echo "  and given the option to remove older downloads."

        for pattern in "${patterns[@]}"; do
            if [ "$SKIP_ALL" = false ] ; then
                delete_folders_except_latest "$pattern"
            else
                break
            fi
        done
    fi

    echo
    echo -e "✅ ${SUCCESS_FONT}Download folders have been examined for all app patterns.${NC}"
    echo -e "   There were ${app_pattern_count} app patterns that contain one or more download"
    if [ ${folder_count} -eq 0 ]; then
        echo -e "   No Download folders deleted"
    else
        echo -e "   Deleted a total of ${folder_count} older download folders"
    fi
    if [ ${DELETE_SELECTED_FOLDERS} == 0 ]; then
        echo
        echo -e "  ${INFO_FONT}Environment variable DELETE_SELECTED_FOLDERS is set to 0"
        echo -e "  So folders marked successfully deleted are still there${NC}"
    fi

    exit_script
}
# *** End of inlined file: src/delete_old_downloads.sh ***


delete_old_downloads

# *** End of inlined file: src/DeleteOldDownloads.sh ***

