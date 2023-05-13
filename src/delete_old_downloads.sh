# Flag to skip all deletions
SKIP_ALL=false

function list_build_folders() {
    echo "The script will look for old downloads in these locations:"
    for pattern in "${patterns[@]}"; do
        echo "$pattern"
    done

    options=("Continue" "Skip" "Exit script")
    actions=("return" "skip_all" "cancel_entry")
    menu_select "${options[@]}" "${actions[@]}"
}

function delete_folders_except_latest() {
    local pattern="$1"
    local total_size=0
    local folders=($(ls -dt ~/Downloads/$pattern 2>/dev/null))

    section_divider

    if [ ${#folders[@]} -le 1 ]; then
        echo "No folders to delete for '$pattern'"
        return
    fi

    echo "Folder to Keep:"
    echo "  ${folders[0]/#$HOME/~}"
    echo

    echo "Folder(s) that can be deleted:"
    for folder in "${folders[@]:1}"; do
        echo "  ${folder/#$HOME/~}"
        total_size=$(($total_size + $(du -s "$folder" | awk '{print $1}')))
    done

    total_size_mb=$(echo "scale=2; $total_size / 1024" | bc)
    echo "Total size to be deleted: $total_size_mb MB"

    options=("Delete these Folders" "Skip delete at this location" "Skip delete at all locations" "Exit script")
    actions=("delete_selected_folders \"$pattern\"" "return" "skip_all" "cancel_entry")
    menu_select "${options[@]}" "${actions[@]}"
}

function delete_selected_folders() {
    local pattern="$1"
    local folders=($(ls -dt ~/Downloads/$pattern))

    for folder in "${folders[@]:1}"; do
        # rm -rf "$folder"
        echo "xxx $folder"
    done

    echo "Folder(s) deleted."
}

function skip_all() {
    SKIP_ALL=true
}

function delete_old_downloads() {
    patterns=(
        "BuildLoopFollow/LoopFollow_Main-*"
        "BuildLoopFollow/LoopFollow_dev-*"
        "Build_iAPS/iAPS_main-*"
        "Build_iAPS/iAPS_dev-*"
        "BuildLoop/Loop-*"
        "BuildLoop/FreeAPS-*"
        "BuildLoop/LoopCaregiver-*"
        "BuildLoop/Loop_lnl_patches-*"
        "BuildLoop/LoopWorkspace_*"
    )

    section_separator
    list_build_folders

    if [ "$SKIP_ALL" = false ] ; then
        echo "We will now go through all build folders and for each, "
        echo "show the latest folder while giving you the option to "
        echo "remove older folders."
        echo 

        for pattern in "${patterns[@]}"; do
            if [ "$SKIP_ALL" = false ] ; then
                delete_folders_except_latest "$pattern"
            else
                break
            fi
        done
    fi

    exit_message
}