#!/bin/bash # script PatchSelect.sh

############################################################
# this code must be repeated in any build script that uses build_functions.sh
############################################################

BUILD_DIR=~/Downloads/"BuildLoop"
OVERRIDE_FILE=LoopConfigOverride.xcconfig
DEV_TEAM_SETTING_NAME="LOOP_DEVELOPMENT_TEAM"

if [ ! -d "${BUILD_DIR}" ]; then
    mkdir "${BUILD_DIR}"
fi

STARTING_DIR="${PWD}"

# Set default values only if they haven't been defined as environment variables
: ${SCRIPT_BRANCH:="main"}
: ${LOCAL_BUILD_FUNCTIONS_PATH:=""}

# If CUSTOM_CONFIG_PATH is not set or empty, source build_functions.sh from GitHub
if [ -z "$LOCAL_BUILD_FUNCTIONS_PATH" ]; then
  source /dev/stdin <<< "$(curl -fsSL -o /dev/stdout https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/$SCRIPT_BRANCH/build_functions.sh)"
else
  # Source the local build_functions.sh when CUSTOM_CONFIG_PATH is set
  echo -e "Using local build_functions.sh\n"
  source "$LOCAL_BUILD_FUNCTIONS_PATH"
fi

initial_greeting

############################################################
# The rest of this is specific to PatchSelect.sh
############################################################

function menu() {
    local name="$1"
    local patch_file="$2"
    local directory="$3"

    # Check if the patch has already been applied
    if git apply --reverse --check "${mytmpdir}/${patch_file}.patch" --directory="${directory}" >/dev/null 2>&1; then
        echo "${name} *** Patch is applied ***"
    else
        # Try to apply the patch
        if git apply --check "${mytmpdir}/${patch_file}.patch" --directory="${directory}" >/dev/null 2>&1; then
            echo "${name}" # - Patch can be applied
        else
            echo "${name} !!! Patch can't be applied !!!"
        fi
    fi
}

function apply() {
    local name="$1"
    local patch_file="${mytmpdir}/$2.patch"
    local directory="$3"
    echo 
    # Check if the patch has already been applied
    if git apply --reverse --check "${patch_file}" --directory="${directory}" >/dev/null 2>&1; then
        echo "${name} *** Patch is applied ***"
    else
        # Try to apply the patch
        if git apply --check "${patch_file}" --directory="${directory}" >/dev/null 2>&1; then
            echo "${name} - Applying..."
            git apply "${patch_file}" --directory="${directory}"
            exit_code=$?
            if [ $exit_code -eq 0 ]; then
                echo "Successful!"
            else
                echo "Failed!"
            fi
        else
            echo "${name} !!! Patch can't be applied !!!"
        fi
    fi
}

function revertmenu() {
    local name="$1"
    local patch_file="$2"
    local directory="$3"

    # Check if the patch has already been applied
    if git apply --reverse --check "${mytmpdir}/${patch_file}.patch" --directory="${directory}" >/dev/null 2>&1; then
        echo "${name}" # - Patch can be reverted
    else
        # Try to apply the patch
        if git apply --check "${mytmpdir}/${patch_file}.patch" --directory="${directory}" >/dev/null 2>&1; then
            echo "${name} *** Patch is not applied ***"
        else
            echo "${name} !!! Reverting or applying the patch is not possible !!!"
        fi
    fi
}

function revert() {
    local name="$1"
    local patch_file="${mytmpdir}/$2.patch"
    local directory="$3"
    echo 
    if git apply --reverse --check "${patch_file}" --directory="${directory}" >/dev/null 2>&1; then
        echo "${name} - Reversing..."
        git apply --reverse "${patch_file}" --directory="${directory}"
        exit_code=$?
        if [ $exit_code -eq 0 ]; then
            echo "Successful!"
        else
            echo "Failed!"
        fi
    else
        if git apply --check "${mytmpdir}/${patch_file}.patch" --directory="${directory}" >/dev/null 2>&1; then
            echo "${name} *** Patch is not applied ***"
        else
            echo "${name} !!! Reverting or applying the patch is not possible !!!"
        fi
    fi
}

function add_patch() {
    name+=("$1")
    file+=("$2")
    folder+=("$3")
}

# Deletes the temp directory
function cleanup {      
  echo "Deleting temp working directory $mytmpdir"
  rm -r "$mytmpdir"
  tput cuu1 && tput el
}

section_separator
echo "Loop patch selection"

if [ "$(basename "$PWD")" != "LoopWorkspace" ]; then
    target_dir="$(find /Users/$USER/Downloads/BuildLoop -maxdepth 2 -type d -name LoopWorkspace -exec dirname {} \; -exec stat -f "%B %N" {} \; | sort -rn | awk '{print $2}' | head -n 1)"
    if [ -z "$target_dir" ]; then
        echo "Error: No folder containing LoopWorkspace found."
    else
        echo "Navigating to $target_dir"
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
    name=()
    file=()
    folder=()

    add_patch "Omnipod (Eros & Dash) Site Change" "cage" ""

    echo "Downloading patches, please wait..."
    cd $mytmpdir
    for i in ${!name[@]}
    do
        curl -fsSLOJ "https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/$SCRIPT_BRANCH/patch/${file[$i]}.patch"
    done
    tput cuu1 && tput el
    cd $workingdir

    while true; do
        echo
        echo "Select a patch you want to apply:"
#        echo "a) Apply all patches"
        for i in ${!name[@]}
        do
            menu "${i}) ${name[$i]}" "${file[$i]}" "${folder[$i]}";
        done        

        echo "r) Revert a patch"
        echo "q) Quit"

        read -p "Enter your choice: " choice
        if [[ $choice =~ ^[0-9]+$ && $choice -ge 0 && $choice -lt ${#name[@]} ]]; then
            apply "${name[$choice]}" "${file[$choice]}" "${folder[$choice]}";
        elif [[ $choice == "r" ]]; then
            section_separator
            echo "Select a patch to revert:"
            for i in ${!name[@]}
            do
                revertmenu "${i}) ${name[$i]}" "${file[$i]}" "${folder[$i]}";
            done        
            echo "*) Any other key will exit to last menu"
            read -p "Enter your choice: " choice
            if [[ $choice =~ ^[0-9]+$ && $choice -ge 0 && $choice -lt ${#name[@]} ]]; then
                revert "${name[$choice]}" "${file[$choice]}" "${folder[$choice]}";
            fi
        # elif [[ $choice == "a" ]]; then
        #     for i in ${!name[@]}
        #     do
        #         apply "${name[$i]}" "${file[$i]}" "${folder[$i]}";
        #     done        
        elif [[ $choice == "q" ]]; then
            exit 0
        else
            echo
            echo "Invalid choice. Try again."
        fi
        return_when_ready
        section_separator
    done
else
    exit 1
fi
