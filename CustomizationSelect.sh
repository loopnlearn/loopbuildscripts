#!/bin/bash # script CustomizationSelect.sh

############################################################
# this code must be repeated in any build script that uses build_functions.sh
############################################################

BUILD_DIR=~/Downloads/"BuildLoop"
OVERRIDE_FILE=LoopConfigOverride.xcconfig
DEV_TEAM_SETTING_NAME="LOOP_DEVELOPMENT_TEAM"
SCRIPT_DIR="${BUILD_DIR}/Scripts"

if [ ! -d "${BUILD_DIR}" ]; then
    mkdir "${BUILD_DIR}"
fi
if [ ! -d "${SCRIPT_DIR}" ]; then
    mkdir "${SCRIPT_DIR}"
fi

: ${STARTING_DIR:="${PWD}"}


# Set default values only if they haven't been defined as environment variables
: ${SCRIPT_BRANCH:="main"}
: ${LOCAL_BUILD_FUNCTIONS_PATH:=""}

# If CUSTOM_CONFIG_PATH is not set or empty, source build_functions.sh from GitHub
if [ -z "$LOCAL_BUILD_FUNCTIONS_PATH" ]; then
    # change directory to $SCRIPT_DIR before curl calls
    cd "${SCRIPT_DIR}"

    # store a copy of build_functions.sh in script directory
    curl -fsSLo ./build_functions.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/$SCRIPT_BRANCH/build_functions.sh

    # Verify build_functions.sh was downloaded.
    if [ ! -f ./build_functions.sh ]; then
        echo -e "\n *** Error *** build_functions.sh not downloaded "
        echo -e "Please attempt to download manually"
        echo -e "  Copy the following line and paste into terminal\n"
        echo -e "curl -SLo ~/Downloads/BuildLoop/Scripts/build_functions.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/build_functions.sh"
        echo -e ""
        exit
    fi
    source ./build_functions.sh
else
  # Source the local build_functions.sh when CUSTOM_CONFIG_PATH is set
  echo -e "Using local build_functions.sh\n"
  source "$LOCAL_BUILD_FUNCTIONS_PATH"
fi

initial_greeting

############################################################
# The rest of this is specific to CustomizationSelect.sh
############################################################

function menu() {
    local name="$1"
    local patch_file="$2"
    local directory="$3"

    # Check if the patch has already been applied
    if git apply --reverse --check "${mytmpdir}/${patch_file}.patch" --directory="${directory}" >/dev/null 2>&1; then
        echo "${name} *** Customization is applied ***"
    else
        # Try to apply the patch
        if git apply --check "${mytmpdir}/${patch_file}.patch" --directory="${directory}" >/dev/null 2>&1; then
            echo "${name}" # - Patch can be applied
        else
            echo "${name} !!! Customization can't be applied !!!"
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
        echo "${name} *** Customization is applied ***"
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
            echo "${name} !!! Customization can't be applied !!!"
        fi
    fi
}

function revertmenu() {
    local name="$1"
    local patch_file="$2"
    local directory="$3"

    # Check if the patch has already been applied
    if git apply --reverse --check "${mytmpdir}/${patch_file}.patch" --directory="${directory}" >/dev/null 2>&1; then
        echo "${name} *** Customization is applied ***" # - Patch can be reverted
    else
        # Try to apply the patch
        if git apply --check "${mytmpdir}/${patch_file}.patch" --directory="${directory}" >/dev/null 2>&1; then
            echo "${name}" # *** Patch is not applied ***
        else
            echo "${name} !!! Removing or applying the customization is not possible !!!"
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
            echo "Successful!"
        else
            echo "Failed!"
        fi
    else
        if git apply --check "${mytmpdir}/${patch_file}.patch" --directory="${directory}" >/dev/null 2>&1; then
            echo "${name} *** Customization is not applied ***"
        else
            echo "${name} !!! Removing or applying the customization is not possible !!!"
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
  echo -e "\n⬆️  You can press the up arrow on the keyboard followed by the Enter key to start the script from the beginning.\n\n";
}

section_separator
echo "Loop Prepared Customizations Selection"

cd "$STARTING_DIR"

if [ "$(basename "$PWD")" != "LoopWorkspace" ]; then
    target_dir="$(find /Users/$USER/Downloads/BuildLoop -maxdepth 2 -type d -name LoopWorkspace -exec dirname {} \; -exec stat -f "%B %N" {} \; | sort -rn | awk '{print $2}' | head -n 1)"
    if [ -z "$target_dir" ]; then
        echo "Error: No folder containing LoopWorkspace found."
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
    add_patch "Change Default to Upload G6 Readings" "upload_readings" "CGMBLEKit" "https://github.com/loopnlearn/CGMBLEKit/commit/b9638cc7cef74b1da74c950c0dbb3525f157e11f.patch"

    echo "Downloading customizations, please wait..."
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

    while true; do
        echo
        echo "The Prepared Customizations are documented on the Loop and Learn web site"
        echo "  https://www.loopandlearn.org/custom-code/#custom-list"
        echo
        echo "Directory where customizations will be applied:"
        echo "  $workingdir"
        echo
        echo "Select a customization to apply:"
        for i in ${!name[@]}
        do
            menu "$((${i}+1))) ${name[$i]}" "${file[$i]}" "${folder[$i]}";
        done        

        echo "$((${#name[@]}+1))) Remove a customization"
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
                echo "Select a customization to remove:"
                for i in ${!name[@]}
                do
                    revertmenu "$((${i}+1))) ${name[$i]}" "${file[$i]}" "${folder[$i]}";
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
                echo "Starting Xcode, please wait..."
                xed .
                exit 0
            fi
        else
            echo
            echo "Invalid choice."
            return_when_ready
        fi
        section_separator
    done
else
    exit 1
fi
