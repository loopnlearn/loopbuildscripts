#!/bin/bash # script CustomizationSelect.sh
# -----------------------------------------------------------------------------
# This file is GENERATED. DO NOT EDIT directly.
# If you want to modify this file, edit the corresponding file in the src/
# directory and then run the build script to regenerate this output file.
# -----------------------------------------------------------------------------

BUILD_DIR=~/Downloads/BuildLoop


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



############################################################
# The rest of this is specific to the particular script
############################################################

function display_applied_patches() {
    has_applied_patches=false
    for i in ${!name[@]}; do
        if git apply --reverse --check "${mytmpdir}/${file[$i]}.patch" --directory="${folder[$i]}" >/dev/null 2>&1; then
            if [ "$has_applied_patches" = false ]; then
                echo -e "${INFO_FONT}Currently applied customizations:${NC}"
                has_applied_patches=true
            fi
            echo "* ${name[$i]}"
        fi
    done
    if [ "$has_applied_patches" = true ]; then
        echo
    fi
}

function display_unapplicable_patches() {
    local has_unapplicable_patches=false
    for i in ${!name[@]}; do
        if ! git apply --check "${mytmpdir}/${file[$i]}.patch" --directory="${folder[$i]}" >/dev/null 2>&1 && \
           ! git apply --reverse --check "${mytmpdir}/${file[$i]}.patch" --directory="${folder[$i]}" >/dev/null 2>&1; then
            if [ "$has_unapplicable_patches" = false ]; then
                echo -e "${INFO_FONT}Unavailable customizations due to conflicts:${NC}"
                has_unapplicable_patches=true
            fi
            echo "* ${name[$i]}"
        fi
    done
    if [ "$has_unapplicable_patches" = true ]; then
        echo
    fi
}

function has_available_customizations() {
    for i in ${!name[@]}; do
        if git apply --check "${mytmpdir}/${file[$i]}.patch" --directory="${folder[$i]}" >/dev/null 2>&1; then
            return 0
        fi
    done
    return 1
}

function apply() {
    local name="$1"
    local patch_file="${mytmpdir}/$2.patch"
    local directory="$3"
    echo 
    # Check if the patch has already been applied
    if git apply --reverse --check "${patch_file}" --directory="${directory}" >/dev/null 2>&1; then
        echo -e "${ERROR_FONT}Requested Customization is already applied.${NC}"
        echo "    ${name}"
    else
        # Try to apply the patch
        if git apply --check "${patch_file}" --directory="${directory}" >/dev/null 2>&1; then
            echo "${name} - Applying..."
            git apply "${patch_file}" --directory="${directory}"
            exit_code=$?
            if [ $exit_code -eq 0 ]; then
                echo -e "  ${SUCCESS_FONT}Successful!${NC}"
            else
                echo -e "  ${ERROR_FONT}Failed!${NC}"
            fi
        else
            echo -e "${ERROR_FONT}Requested Customization cannot be applied.${NC}"
            echo "    ${name}"
        fi
    fi
}

function revert() {
    local name="$1"
    local patch_file="${mytmpdir}/$2.patch"
    local directory="$3"
    echo 
    if git apply --reverse --check "${patch_file}" --directory="${directory}" >/dev/null 2>&1; then
        echo "${name} - Removing..."
        git apply --reverse "${patch_file}" --directory="${directory}"
        exit_code=$?
        if [ $exit_code -eq 0 ]; then
            echo -e "  ${SUCCESS_FONT}Successful!${NC}"
        else
            echo -e "  ${ERROR_FONT}Failed!${NC}"
        fi
    else
        if git apply --check "${mytmpdir}/${patch_file}.patch" --directory="${directory}" >/dev/null 2>&1; then
            echo -e "${ERROR_FONT}Requested Customization was not applied.${NC}"
            echo "    ${name}"
        else
            echo -e "${ERROR_FONT}Requested Customization cannot be removed.${NC}"
            echo "    ${name}"
        fi
    fi
}

function add_patch() {
    name+=("$1")
    file+=("$2")
    folder+=("$3")
    url+=("$4")
}

# Deletes the temp directory
function cleanup {      
    echo "Deleting temp working directory $mytmpdir"
    rm -r "$mytmpdir"
    tput cuu1 && tput el
    exit_message
}

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

    #Declare all patches
    #Using simple arrays since bash 3 which is shipped with mac does not support associative arrays
    name=() #Displayed name
    file=() #File to retrieve (optional)
    folder=() #Optional folder if the patch is not workspace level
    url=() #Optional url to patch, it will be stored as "file"-name

    add_patch "Increase Future Carbs Limit to 4 hours" "future_carbs_4h" "Loop" "https://github.com/loopnlearn/Loop/commit/a974b6749ef4506ca679a0061c260dabcfbf9ee2.patch"
    add_patch "Libre Users: Limit Loop to <5 minutes" "limit_loop_cycle_time" "Loop" "https://github.com/loopnlearn/Loop/commit/414588c5e7dc36f692c8bbcf2d97adde1861072a.patch"
    add_patch "Modify Carb Warning & Limit: Low Carb to 49 & 99" "low_carb_limit" "Loop" "https://github.com/loopnlearn/Loop/commit/d9939c65a6b2fc088ee5acdf0d9dc247ad30986c.patch"
    add_patch "Modify Carb Warning & Limit: High Carb to 201 & 300" "high_carb_limit" "Loop" "https://github.com/loopnlearn/Loop/commit/a79482ac638736c2b3b8c5057b48e3097323a522.patch"
    add_patch "Disable Authentication Requirement" "no_auth" "LoopKit" "https://github.com/loopnlearn/LoopKit/commit/77ee44534dd16154d910cfb11dea240cf8a23262.patch"
    add_patch "Override Insulin Needs Picker (50% to 200%, steps of 5%)" "override_sens" "LoopKit" "https://github.com/loopnlearn/LoopKit/commit/f35654104f70b7dc70f750d129fbb338b9a4cee0.patch"
    add_patch "CAGE: Upload Pod Start to Nightscout" "cage" "" ""
    add_patch "SAGE: Upload G6 Sensor Start to Nightscout" "sage" "CGMBLEKit" "https://github.com/loopnlearn/CGMBLEKit/commit/777c7e36de64bdc060973a6628a02add0917520e.patch"
    add_patch "Change Default to Upload Dexcom Readings" "g6g7_upload_readings" "" ""

    echo -e "${INFO_FONT}Downloading customizations, please wait...${NC}"
    cd $mytmpdir
    for i in ${!name[@]}
    do
        if [ -z "${url[$i]}" ]; then
            curl -fsSLOJ "https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/$SCRIPT_BRANCH/patch/${file[$i]}.patch"
        else
            curl -fsSL --output "${file[$i]}.patch" "${url[$i]}"
        fi
    done
    tput cuu1 && tput el
    cd $workingdir

    echo
    while true; do
        echo "The Prepared Customizations are documented on the Loop and Learn web site"
        echo "  https://www.loopandlearn.org/custom-code/#custom-list"
        echo
        echo -e "${INFO_FONT}Directory where customizations will be applied:${NC}"
        echo -e "${INFO_FONT}  ${workingdir/$HOME/~}${NC}"
        echo

        display_applied_patches
        display_unapplicable_patches

        if has_available_customizations; then
            echo -e "${INFO_FONT}Select a customization to apply or another option in the list:${NC}"
        else
            echo -e "${INFO_FONT}There are no available customizations. Select an option in the list:${NC}"
        fi
        for i in ${!name[@]}; do
            if git apply --check "${mytmpdir}/${file[$i]}.patch" --directory="${folder[$i]}" >/dev/null 2>&1; then
                echo "$((${i}+1))) ${name[$i]}"
            fi
        done

        if [ "$has_applied_patches" = true ]; then
            echo "$((${#name[@]}+1))) Remove a customization"
        fi
        echo "$((${#name[@]}+2))) Quit"
        echo "$((${#name[@]}+3))) Quit and open Xcode"

        read -p "Enter your choice: " choice
        if [[ $choice =~ ^[0-9]+$ && $choice -ge 1 && $choice -le $((${#name[@]}+3)) ]]; then
            if [[ $choice -le ${#name[@]} ]]; then
                index=$(($choice-1))
                apply "${name[$index]}" "${file[$index]}" "${folder[$index]}";
                return_when_ready
            elif [[ $choice -eq $((${#name[@]}+1)) ]]; then
                section_separator
                echo -e "${INFO_FONT}Select a customization to remove:${NC}"

                for i in ${!name[@]}; do
                    if git apply --reverse --check "${mytmpdir}/${file[$i]}.patch" --directory="${folder[$i]}" >/dev/null 2>&1; then
                        echo "$((${i}+1))) ${name[$i]}"
                    fi
                done

                echo "*) Any other key will exit to last menu"
                read -p "Enter your choice: " choice
                if [[ $choice =~ ^[0-9]+$ && $choice -ge 1 && $choice -le ${#name[@]} ]]; then
                    index=$(($choice-1))
                    revert "${name[$index]}" "${file[$index]}" "${folder[$index]}";
                    return_when_ready
                fi
            elif [[ $choice -eq $((${#name[@]}+2)) ]]; then
                exit 0
            elif [[ $choice -eq $((${#name[@]}+3)) ]]; then
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
# *** End of inlined file: src/CustomizationSelect.sh ***

