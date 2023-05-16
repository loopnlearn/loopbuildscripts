# Flag to skip all deletions
SKIP_ALL=false
folder_count=0
app_pattern_count=0

# Default if environment variable is not set
${DELETE_SELECTED_FOLDERS:="1"}

function list_build_folders() {
    echo -e "The script will look for downloads of a particular app"
    echo -e "  and offer to remove all but the most recent download."
    echo -e "It does this for each type of Build offered as a build script."
    # only echo pattern when testing
    if [ ${DELETE_SELECTED_FOLDERS} == 0 ]; then
        echo
        for pattern in "${patterns[@]}"; do
            echo "    $pattern"
        done
    fi
    section_divider

    options=("Continue" "Skip" "Exit script")
    actions=("return" "skip_all" "cancel_entry")
    menu_select "${options[@]}" "${actions[@]}"
}

function delete_folders_except_latest() {
    local pattern="$1"
    local total_size=0
    local folders=($(ls -dt ~/Downloads/$pattern/ 2>/dev/null))

    if [ ${#folders[@]} -eq 0 ]; then
        return
    fi

    # increment because folders were found
    ((app_pattern_count=app_pattern_count+1))

    if [ ${#folders[@]} -eq 1 ]; then
        echo "Only one download for app pattern: '$pattern'"
        return
    fi

    section_divider

    echo "Pattern for this app: '$pattern':"
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
    echo "Total size to be deleted: $total_size_mb MB"
    section_divider

    options=("Delete these Folders" "Skip delete at this location" "Skip delete at all locations" "Exit script")
    actions=("delete_selected_folders \"$pattern\"" "return" "skip_all" "cancel_entry")
    menu_select "${options[@]}" "${actions[@]}"
}

function delete_selected_folders() {
    local pattern="$1"
    local folders=($(ls -dt ~/Downloads/$pattern))
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

    echo -e "✅ {SUCCESS_FONT}Deleted ${this_pattern_count} download folders for this app pattern${NC}"
    return_when_ready
}

function skip_all() {
    SKIP_ALL=true
}

function delete_old_downloads() {
    patterns=(
        "BuildLoop/Loop-*"
        "BuildLoop/LoopCaregiver-*"
        "BuildLoop/Loop_lnl_patches-*"
        "BuildLoop/LoopWorkspace_*"
        "BuildLoop/FreeAPS*"
        "BuildLoopFollow/LoopFollow_Main*"
        "BuildLoopFollow/LoopFollow_dev*"
        "BuildxDrip4iOS/xDrip4iOS*"
        "BuildGlucoseDirect/GlucoseDirect*"
        "Build_iAPS/iAPS_main*"
        "Build_iAPS/iAPS_dev*"
    )

    section_separator
    list_build_folders

    if [ "$SKIP_ALL" = false ] ; then
        section_divider
        echo "For each type of Build provided as a build script, "
        echo "  you will be shown your most recent download"
        echo "  and given the option to remove older downloads."
        echo 

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
    echo -e "   Found folders containing downloads for ${app_pattern_count} app patterns"
    if [ ${folder_count} -eq 0 ]; then
        echo -e "   No Download folders deleted"
    else
        echo -e "   Deleted a total of ${folder_count} older download folders"
    fi

    exit_message
}
