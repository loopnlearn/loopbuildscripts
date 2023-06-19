#!/bin/bash # script CustomizationSelect.sh
# -----------------------------------------------------------------------------
# This file is GENERATED. DO NOT EDIT directly.
# If you want to modify this file, edit the corresponding file in the src/
# directory and then run the build script to regenerate this output file.
# -----------------------------------------------------------------------------

BUILD_DIR=~/Downloads/BuildLoop


# *** Start of inlined file: inline_functions/patch_functions.sh ***

# *** Start of inlined file: inline_functions/common.sh ***
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
        "PATCH_BRANCH: Indicates the source branch for patches."
        "PATCH_REPO: Specifies the URL of the patch source repository."
        "LOCAL_PATCH_FOLDER: Defines a local directory for sourcing patches."
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
        echo
        echo "To clear the values, close this terminal and start a new one."
        echo "Sleeping for 2 sec then continuing"
        sleep 2
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
# *** End of inlined file: inline_functions/common.sh ***


# set to 1 for debug (verbose output) mode at beginning of script
# set to 2 for debug (verbose output) mode for every refresh
DEBUG_FLAG=0

: ${PATCH_BRANCH:="main"}
: ${PATCH_REPO:="https://github.com/loopandlearn/customization.git"}

REPO_NAME=$(basename "${PATCH_REPO}" .git)

# set fixed numbers for certain actions
SLEEP_TIME_AFTER_SUCCESS=1
REMOVE_CUSTOMIZATION_MENU_ITEM=40
UPDATE_CUSTOMIZATION_MENU_ITEM=45
EXIT_MENU_ITEM=50
EXIT_OPEN_XCODE_MENU_ITEM=60
MAX_MENU_ITEM=$EXIT_OPEN_XCODE_MENU_ITEM

one_time_flag=0

function message_about_display() {
    echo -e "${INFO_FONT}You may need to scroll up to read everything${NC}"
    echo -e "${INFO_FONT} or drag corner to make terminal taller${NC}"
    echo -e "${SUCCESS_FONT}There is $SLEEP_TIME_AFTER_SUCCESS second pause for a success message${NC}"
    echo "  Do not worry if it goes by too quickly to read"
    echo -e "${INFO_FONT}Errors will be reported and script will wait for user${NC}"
    echo
    one_time_flag=1
}

warning_flag=0

function warning_message() {
    echo -e "${INFO_FONT} *** WARNING ***${NC}"
    echo -e "${INFO_FONT}Customizations are even more experimental than the released version${NC}"
    echo -e "${INFO_FONT}of Loop. It is your responsibility to understand the changes${NC}"
    echo -e "${INFO_FONT}expected when you apply, remove or update one of these customizations${NC}"
    echo
    warning_flag=1
}

customization=()
folder=()
message_function=()
status=()
patch=()

function add_customization() {    
    customization+=("$1")
    folder+=("$2")
    message_function+=("$3")
}

function refresh_status() {
    # Status documentation
    # 0 Patch not applied (a current version of the patch is possible to apply)
    # 1 Patch applied (a current version of the patch can be reversed)
    # 2 Old version applied (an archived version of the patch can be reversed, possible upgrade)
    # 3 Patch not applicable due to conflicts (no version of the patch can be applied or reversed)
    
    # Iterate through each customization
    for ((index=0; index<${#customization[@]}; index++)); do
        if [ -z "$LOCAL_PATCH_FOLDER" ]; then
            local patch_folder="$mytmpdir/${REPO_NAME}/${folder[$index]}"
        else
            local patch_folder="$LOCAL_PATCH_FOLDER/${folder[$index]}"
        fi
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
    if [ $DEBUG_FLAG -eq 2 ]; then
        debug_printout
    fi
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
                echo -e "${INFO_FONT}  Currently applied customizations:${NC}"
                has_applied_patches=true
            fi
            if [[ ${status[$index]} -eq 2 ]]; then
                echo -e "     * ${customization[$index]} ${SUCCESS_FONT}(Update available)${NC}"
                has_updatable_patches=true
            else
                echo "     * ${customization[$index]}"
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
                echo -e "${INFO_FONT}  Unavailable customizations (due to conflicts):${NC}"
                has_unapplicable_patches=true
            fi
            echo "    * ${customization[$index]}"
        fi
    done
    if [ "$has_unapplicable_patches" = true ]; then
        message_incompatible
        echo
    fi
}

function apply_patch {
    local index=$1
    local patch_file="${patch[$index]}"
    local customization_name="${customization[$index]}"
    if [ -f "$patch_file" ]; then
        if git apply --whitespace=nowarn "$patch_file"; then
            echo -e "${SUCCESS_FONT}  Customization $customization_name applied successfully${NC}"
            sleep $SLEEP_TIME_AFTER_SUCCESS
        else
            echo -e "${ERROR_FONT}  Failed to apply customization $customization_name${NC}"
            return_when_ready
        fi
    else
        echo -e "${ERROR_FONT}  Patch file for customization $customization_name not available${NC}"
        return_when_ready
    fi
    refresh_status
}

function revert_patch {
    local index=$1
    local patch_file="${patch[$index]}"
    local customization_name="${customization[$index]}"
    if [ -f "$patch_file" ]; then
        if git apply --whitespace=nowarn --reverse "$patch_file"; then
            echo -e "${SUCCESS_FONT}  Customization $customization_name reverted successfully${NC}"
            sleep $SLEEP_TIME_AFTER_SUCCESS
        else
            echo -e "${ERROR_FONT}  Failed to revert customization $customization_name${NC}"
            return_when_ready
        fi
    else
        echo -e "${ERROR_FONT}  Patch file for customization $customization_name does not exist${NC}"
        return_when_return
    fi
    refresh_status
}

function patch_menu {
    section_separator
    echo -e "${INFO_FONT}Loop Customization Select Script${NC}"

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

        if [ -z "$LOCAL_PATCH_FOLDER" ]; then
            echo -e "${INFO_FONT}Downloading customizations, please wait  ...  patiently  ...${NC}"
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
        fi

        refresh_status
        if [ $DEBUG_FLAG -eq 1 ]; then
            debug_printout
        fi

        echo

        ### repeating menu start here:
        while true; do
            echo -e "${INFO_FONT}Directory where customizations will be applied:${NC}"
            echo -e "${INFO_FONT}  ${workingdir/$HOME/~}${NC}"
            echo

            display_applied_patches
            display_unapplicable_patches

            message_generic

            for ((index=0; index<${#customization[@]}; index++)); do
                if [ ${status[$index]} -eq 0 ]; then
                    if [ -n "${message_function[$index]}" ]; then
                        eval "${message_function[$index]}"
                    fi
                    printf "%4d) %s\n" $((index+1)) "${customization[$index]}"
                fi
            done

            echo

            if [ "$has_applied_patches" = true ]; then
                echo "  $REMOVE_CUSTOMIZATION_MENU_ITEM) Remove a customization"
            fi
            if [ "$has_updatable_patches" = true ]; then
                echo -e "${SUCCESS_FONT}  $UPDATE_CUSTOMIZATION_MENU_ITEM) Update a customization${NC}"
            fi

            echo "  $EXIT_MENU_ITEM) $(exit_or_return_menu)"
            echo "  $EXIT_OPEN_XCODE_MENU_ITEM) $(exit_or_return_menu) and open Xcode"
            echo

            if [ $one_time_flag -eq 0 ]; then
                message_about_display
            fi
            if [ $warning_flag -eq 0 ]; then
                warning_message
            fi
            read -p "Enter your choice: " choice
            if [[ $choice =~ ^[0-9]+$ && $choice -ge 1 && $choice -le $MAX_MENU_ITEM ]]; then
                if [[ $choice -le ${#customization[@]} ]]; then
                    index=$(($choice-1))
                    if [ ${status[$index]} -eq 0 ]; then
                        apply_patch "$index";
                    else
                        echo -e "${ERROR_FONT}Your selection of $choice is not valid${NC}"
                        return_when_ready
                    fi
                elif [[ $choice -eq $REMOVE_CUSTOMIZATION_MENU_ITEM ]]; then
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
                        if [ ${status[$index]} -eq 1 ]; then
                            revert_patch "$index";
                        else
                            echo -e "${ERROR_FONT}Your selection of $choice is not valid${NC}"
                            return_when_ready
                        fi
                    fi
                elif [[ $choice -eq $UPDATE_CUSTOMIZATION_MENU_ITEM ]]; then
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
                        if [ ${status[$index]} -eq 2 ]; then
                            echo "First reverse older version"
                            revert_patch "$index";
                            echo "Now apply newer version"
                            apply_patch "$index";
                            return_when_ready
                        else
                            echo -e "${ERROR_FONT}Your selection of $choice is not valid${NC}"
                            return_when_ready
                        fi
                    fi
                elif [[ $choice -eq $EXIT_MENU_ITEM ]]; then
                    exit 0
                elif [[ $choice -eq $EXIT_OPEN_XCODE_MENU_ITEM ]]; then
                    echo -e "${INFO_FONT}Starting Xcode, please wait...${NC}"
                    xed .
                    exit 0
                else
                    echo -e "${ERROR_FONT}Your choice of $choice is invalid${NC}"
                    return_when_ready
                fi
            else
                echo
                echo -e "${ERROR_FONT}Your choice of $choice is invalid${NC}"
                return_when_ready
            fi            
            section_separator
        done
    else
        exit 1
    fi
}
# *** End of inlined file: inline_functions/patch_functions.sh ***


############################################################
# The rest of this is specific to the particular script
############################################################

message_incompatible_count=0

# this is always used - it is the introductory message - it can be blank
function message_generic() {
    echo "  These Customizations are documented on the Loop and Learn web site"
    echo "        https://www.loopandlearn.org/custom-code/#custom-list"
    echo
}

# this is always used - it is the incompatible patches message - it can be blank
function message_incompatible() {
    :
}

# optional message to go with add_customization line
function message_for_cto() {
    echo
    echo "  CustomTypeOne LoopPatches"
    echo "        https://www.loopandlearn.org/custom-type-one-loop-patches/"
    echo "        Update automatic when Glucose Based Application Factor also selected"
}

# optional message to go with add_customization line
function message_for_pr1988() {
    echo
    echo "  Glucose Based Application Factor"
    echo "     This feature in development gradually increases AB factor with glucose"
    echo -e "     (replaces ${INFO_FONT}\"switcher patch\"${NC}, CustomTypeOne Loop Patches)"
    echo "        https://github.com/LoopKit/Loop/pull/1988"
}

# optional message to go with add_customization line
function message_for_pr2002() {
    echo
    echo "  Profile Switching"
    echo "     This feature in development enables save and restore of named profiles"
    echo "        https://github.com/LoopKit/Loop/pull/2002"
}

function message_for_pr2008() {
    echo
    echo "  Integral Retrospective Correction"
    echo "     This feature in development modifies retrospective correction."
    echo "     Helps when glucose is different than Loop predicts for longer times."
    echo "        https://github.com/LoopKit/Loop/pull/2008"
}

# list patches in this order with args:
#   User facing information for option
#   Folder name in the patch repo
#   (Optional) message function shown prior to option

add_customization "CAGE: Upload Pod Start to Nightscout" "omnipod_cage"
add_customization "SAGE: Upload Dexcom Sensor Start to Nightscout" "dexcom_sage"
add_customization "Change Default to Upload Dexcom Readings" "dexcom_upload_readings"
add_customization "Increase Future Carbs Limit to 4 hours" "future_carbs_4h"
add_customization "Modify Carb Warning & Limit: Low Carb to 49 & 99" "low_carb_limit"

add_customization "Modify Carb Warning & Limit: High Carb to 201 & 300" "high_carb_limit"
add_customization "Disable Authentication Requirement" "no_auth"
add_customization "Override Insulin Needs Picker (50% to 200%, steps of 5%)" "override_sens"
add_customization "Libre Users: Limit Loop to 5 minute update" "limit_loop_cycle_time"
add_customization "Modify Logo to include LnL icon" "lnl_icon"

add_customization "CustomTypeOne LoopPatches" "customtypeone_looppatches" "message_for_cto"

add_customization "Profile Save & Load" "2002" "message_for_pr2002"
add_customization "Glucose Based Application Factor" "1988" "message_for_pr1988"
add_customization "Integral Retrospective Correction" "2008" "message_for_pr2008"


patch_menu
# *** End of inlined file: src/CustomizationSelect.sh ***

