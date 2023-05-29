#!/bin/bash # script CustomizationSelect.sh
# -----------------------------------------------------------------------------
# This file is GENERATED. DO NOT EDIT directly.
# If you want to modify this file, edit the corresponding file in the src/
# directory and then run the build script to regenerate this output file.
# -----------------------------------------------------------------------------

BUILD_DIR=~/Downloads/BuildLoop


# *** Start of inlined file: src/patch_functions.sh ***

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
        # Called directly
        echo "Exit Script"
    else
        # Called from BuildSelectScript
        echo "Return to Menu"
    fi
}

function exit_script() {
    if [ "$0" != "_" ]; then
        # Called directly
        exit_message
    else
        # Called from BuildSelectScript
        exit 0
    fi
}

function exit_message() {
    section_divider
    echo -e "${INFO_FONT}Exit from Script${NC}\n"
    echo -e "  You may close the terminal"
    echo -e "or"
    echo -e "  You can press the up arrow ⬆️  on the keyboard"
    echo -e "    and return to repeat script from beginning"
    section_divider
    exit 0
}
# *** End of inlined file: src/common.sh ***


: ${PATCH_BRANCH:="main"}
: ${PATCH_REPO:="https://github.com/bjorkert/patchrepo.git"}

REPO_NAME=$(basename "${PATCH_REPO}" .git)

# set fixed numbers for certain actions
remove_customization_menu_item=40
update_customization_menu_item=45
exit_menu_item=50
exit_open_xcode_menu_item=60
max_menu_item=$exit_open_xcode_menu_item

customization=()
folder=()
status=()
patch=()

function add_customization() {    
    customization+=("$1")
    folder+=("$2")
}

function refresh_status() {
    # Status documentation
    # 0 Patch not applied (a current version of the patch is possible to apply)
    # 1 Patch applied (a current version of the patch can be reversed)
    # 2 Old version applied (an archived version of the patch can be reversed, possible upgrade)
    # 3 Patch not applicable due to conflicts (no version of the patch can be applied or reversed)
    
    # Iterate through each customization
    for ((index=0; index<${#customization[@]}; index++)); do
        local patch_folder="$mytmpdir/${REPO_NAME}/${folder[$index]}"
        local archive_folder="$patch_folder/archive"
        
        # Initialize status as not applicable
        status[$index]=3
        patch[$index]=""

        # Check all patches in the current patch folder
        for patch_file in "$patch_folder"/*.patch; do
            if [ -f "$patch_file" ]; then
                # Try to apply the patch
                if git apply --check "$patch_file" >/dev/null 2>&1; then
                    status[$index]=0
                    patch[$index]="$patch_file"
                    break
                fi

                # Try to reverse the patch
                if git apply --reverse --check "$patch_file" >/dev/null 2>&1; then
                    status[$index]=1
                    patch[$index]="$patch_file"
                    break
                fi
            fi
        done

        # If no current patch can be applied or reversed, check archived patches
        if [ ${status[$index]} -eq 3 ]; then
            for patch_file in "$archive_folder"/*.patch; do
                if [ -f "$patch_file" ]; then
                    # Try to reverse the patch
                    if git apply --reverse --check "$patch_file" >/dev/null 2>&1; then
                        status[$index]=2
                        patch[$index]="$patch_file"
                        break
                    fi
                fi
            done
        fi
    done
}

function debug_printout() {
    echo "Customizations:"
    for ((index=0; index<${#customization[@]}; index++)); do
        echo "$index: ${customization[$index]}"
    done

    echo "Folders:"
    for ((index=0; index<${#folder[@]}; index++)); do
        echo "$index: ${folder[$index]}"
    done

    echo "Statuses:"
    for ((index=0; index<${#status[@]}; index++)); do
        echo "$index: ${status[$index]}"
    done

    echo "Patches:"
    for ((index=0; index<${#patch[@]}; index++)); do
        echo "$index: ${patch[$index]}"
    done
}

# Deletes the temp directory
function cleanup {      
    echo "Deleting temp working directory $mytmpdir"
    rm -rf "$mytmpdir"
    tput cuu1 && tput el
    exit_script
}

function display_applied_patches() {
    has_applied_patches=false
    has_updatable_patches=false
    for ((index=0; index<${#customization[@]}; index++)); do
        if [[ ${status[$index]} -eq 1 || ${status[$index]} -eq 2 ]]; then
            if [ "$has_applied_patches" = false ]; then
                echo -e "${INFO_FONT}Currently applied customizations:${NC}"
                has_applied_patches=true
            fi
            if [[ ${status[$index]} -eq 2 ]]; then
                echo "* ${customization[$index]} (Update available)"
                has_updatable_patches=true
            else
                echo "* ${customization[$index]}"
            fi
        fi
    done
    if [ "$has_applied_patches" = true ]; then
        echo
    fi
}

function display_unapplicable_patches() {
    has_unapplicable_patches=false
    for ((index=0; index<${#customization[@]}; index++)); do
        if [ ${status[$index]} -eq 3 ]; then
            if [ "$has_unapplicable_patches" = false ]; then
                echo -e "${INFO_FONT}Unavailable customizations due to conflicts:${NC}"
                has_unapplicable_patches=true
            fi
            echo "* ${customization[$index]}"
        fi
    done
    if [ "$has_unapplicable_patches" = true ]; then
        echo
    fi
}

function apply_patch {
    local index=$1
    local patch_file="${patch[$index]}"
    local customization_name="${customization[$index]}"
    if [ -f "$patch_file" ]; then
        if git apply --whitespace=nowarn "$patch_file"; then
            echo "Customization $customization_name applied successfully."
        else
            echo "Failed to apply customization $customization_name."
        fi
    else
        echo "Patch file for customization $customization_name does not exist."
    fi
    refresh_status
}

function revert_patch {
    local index=$1
    local patch_file="${patch[$index]}"
    local customization_name="${customization[$index]}"
    if [ -f "$patch_file" ]; then
        if git apply --whitespace=nowarn --reverse "$patch_file"; then
            echo "Customization $customization_name reverted successfully."
        else
            echo "Failed to revert customization $customization_name."
        fi
    else
        echo "Patch file for customization $customization_name does not exist."
    fi
    refresh_status
}

function patch_menu {
    section_separator
    echo -e "${INFO_FONT}Loop Prepared Customizations Selection${NC}"

    cd "$STARTING_DIR"

    if [ "$(basename "$PWD")" != "LoopWorkspace" ]; then
        target_dir=$(find ${BUILD_DIR/#\~/$HOME} -maxdepth 1 -type d -name "Loop*" -exec [ -d "{}"/LoopWorkspace ] \; -print 2>/dev/null | xargs -I {} stat -f "%m %N" {} | sort -rn | head -n 1 | awk '{print $2"/LoopWorkspace"}')
        if [ -z "$target_dir" ]; then
            echo -e "${ERROR_FONT}Error: No folder containing LoopWorkspace found in${NC}"
            echo "    $BUILD_DIR"
        else
            cd "$target_dir"
        fi
    fi

    # Verify current folder
    if [ $(basename $PWD) = "LoopWorkspace" ]; then
        echo "Creating temporary folder"
        workingdir=$PWD
        mytmpdir=$(mktemp -d)

        # Check if tmp dir was created
        if [[ ! "$mytmpdir" || ! -d "$mytmpdir" ]]; then
            echo "Could not create temporary folder"
            exit 1
        fi
        tput cuu1 && tput el

        # Register the cleanup function to be called on the EXIT signal
        trap cleanup EXIT

        echo -e "${INFO_FONT}Downloading customizations, please wait...${NC}"
        cd $mytmpdir
        git clone --quiet --branch=$PATCH_BRANCH $PATCH_REPO
        clone_exit_status=$?
        if [ $clone_exit_status -eq 0 ]; then
            tput cuu1 && tput el
            cd $workingdir
        else
            echo -e "❌ ${ERROR_FONT}An error occurred during download. Please investigate the issue.${NC}"
            exit 1
        fi

        refresh_status
        #Remove this debug printout before release
        debug_printout

        echo
        while true; do
            customization_info
            echo
            echo -e "${INFO_FONT}Directory where customizations will be applied:${NC}"
            echo -e "${INFO_FONT}  ${workingdir/$HOME/~}${NC}"
            echo

            display_applied_patches
            display_unapplicable_patches

            echo -e "${INFO_FONT}Select a customization to apply or another option in the list:${NC}"

            for ((index=0; index<${#customization[@]}; index++)); do
                if [ ${status[$index]} -eq 0 ]; then
                    echo "$((${index}+1))) ${customization[$index]}"
                fi
            done

            if [ "$has_applied_patches" = true ]; then
                echo "$remove_customization_menu_item) Remove a customization"
            fi
            if [ "$has_updatable_patches" = true ]; then
                echo "$update_customization_menu_item) Update a customization"
            fi

            echo "$exit_menu_item) $(exit_or_return_menu)"
            echo "$exit_open_xcode_menu_item) $(exit_or_return_menu) and open Xcode"

            read -p "Enter your choice: " choice
            if [[ $choice =~ ^[0-9]+$ && $choice -ge 1 && $choice -le $max_menu_item ]]; then
                if [[ $choice -le ${#customization[@]} ]]; then
                    index=$(($choice-1))
                    apply_patch "$index";
                    return_when_ready
                elif [[ $choice -eq $remove_customization_menu_item ]]; then
                    section_separator
                    echo -e "${INFO_FONT}Select a customization to remove:${NC}"

                    for ((index=0; index<${#customization[@]}; index++)); do
                        if [ ${status[$index]} -eq 1 ]; then
                            echo "$((${index}+1))) ${customization[$index]}"
                        fi
                    done

                    echo "*) Any other key will exit to last menu"
                    read -p "Enter your choice: " choice
                    if [[ $choice =~ ^[0-9]+$ && $choice -ge 1 && $choice -le ${#customization[@]} ]]; then
                        index=$(($choice-1))
                        revert_patch "$index";
                        return_when_ready
                    fi
                elif [[ $choice -eq $((${#customization[@]}+2)) ]]; then
                    section_separator
                    echo -e "${INFO_FONT}Select a customization to update:${NC}"

                    for ((index=0; index<${#customization[@]}; index++)); do
                        if [ ${status[$index]} -eq 2 ]; then
                            echo "$((${index}+1))) ${customization[$index]}"
                        fi
                    done

                    echo "*) Any other key will exit to last menu"
                    read -p "Enter your choice: " choice
                    if [[ $choice =~ ^[0-9]+$ && $choice -ge 1 && $choice -le ${#customization[@]} ]]; then
                        index=$(($choice-1))
                        revert_patch "$index";
                        apply_patch "$index";
                        return_when_ready
                    fi
                elif [[ $choice -eq $exit_menu_item ]]; then
                    exit 0
                elif [[ $choice -eq $exit_open_xcode_menu_item ]]; then
                    echo -e "${INFO_FONT}Starting Xcode, please wait...${NC}"
                    xed .
                    exit 0
                fi
            else
                echo
                echo -e "${ERROR_FONT}Invalid choice.${NC}"
                return_when_ready
            fi            
            section_separator
        done
    else
        exit 1
    fi
}
# *** End of inlined file: src/patch_functions.sh ***


############################################################
# The rest of this is specific to the particular script
############################################################

add_customization "Profiles" "profile"
add_customization "Enhanced AutoBolus" "ab_ramp"
add_customization "CustomTypeOne LoopPatches (original)" "customtypeone_looppatches"
add_customization "CustomTypeOne LoopPatches (no switcher)" "customtypeone_looppatches_no_switcher"

add_customization "Increase Future Carbs Limit to 4 hours" "future_carbs_4h"
add_customization "Libre Users: Limit Loop to <5 minutes" "limit_loop_cycle_time"
add_customization "Modify Carb Warning & Limit: Low Carb to 49 & 99" "low_carb_limit"
add_customization "Modify Carb Warning & Limit: High Carb to 201 & 300" "high_carb_limit"
add_customization "Disable Authentication Requirement" "no_auth"
add_customization "Override Insulin Needs Picker (50% to 200%, steps of 5%)" "override_sens"
add_customization "CAGE: Upload Pod Start to Nightscout" "omnipod_cage"
add_customization "SAGE: Upload Dexcom Sensor Start to Nightscout" "dexcom_sage"
add_customization "Change Default to Upload Dexcom Readings" "dexcom_upload_readings"
add_customization "Modify Logo with LnL icon" "lnl_icon"

function customization_info {
    echo "The Prepared Customizations are documented on the Loop and Learn web site"
    echo "  https://www.loopandlearn.org/custom-code/#custom-list"
}

patch_menu
# *** End of inlined file: src/CustomizationSelect.sh ***

