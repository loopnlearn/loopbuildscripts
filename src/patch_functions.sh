#!inline common.sh

: ${PATCH_BRANCH:="main"}
: ${PATCH_REPO:="https://github.com/bjorkert/patchrepo.git"}

REPO_NAME=$(basename "${PATCH_REPO}" .git)

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
            echo "The Prepared Customizations are documented on the Loop and Learn web site"
            echo "  https://www.loopandlearn.org/custom-code/#custom-list"
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
                echo "$((${#customization[@]}+1))) Remove a customization"
            fi
            if [ "$has_updatable_patches" = true ]; then
                echo "$((${#customization[@]}+2))) Update a customization"
            fi
            echo "$((${#customization[@]}+3))) $(exit_or_return_menu)"
            echo "$((${#customization[@]}+4))) $(exit_or_return_menu) and open Xcode"

            read -p "Enter your choice: " choice
            if [[ $choice =~ ^[0-9]+$ && $choice -ge 1 && $choice -le $((${#customization[@]}+4)) ]]; then
                if [[ $choice -le ${#customization[@]} ]]; then
                    index=$(($choice-1))
                    apply_patch "$index";
                    return_when_ready
                elif [[ $choice -eq $((${#customization[@]}+1)) ]]; then
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
                elif [[ $choice -eq $((${#customization[@]}+3)) ]]; then
                    exit 0
                elif [[ $choice -eq $((${#customization[@]}+4)) ]]; then
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