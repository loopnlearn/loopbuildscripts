function delete_folders_except_latest() {
    local pattern="$1"
    local total_size=0
    local folders=($(ls -dt ~/Downloads/$pattern 2>/dev/null))

    if [ ${#folders[@]} -eq 0 ]; then
        return
    fi

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

    scripts_folder="$(dirname "${folders[0]}")/Scripts"
    if [ -d "$scripts_folder" ]; then
        echo "  ${scripts_folder/#$HOME/~}"
        total_size=$(($total_size + $(du -s "$scripts_folder" | awk '{print $1}')))
    else
        scripts_folder=""
    fi

    total_size_mb=$(echo "scale=2; $total_size / 1024" | bc)
    echo "Total size to be deleted: $total_size_mb MB"

    options=("Delete" "Cancel" "Quit")
    actions=("delete_selected_folders \"$pattern\" \"$scripts_folder\"" "return" "cancel_entry")
    menu_select "${options[@]}" "${actions[@]}"
}

function delete_selected_folders() {
    local pattern="$1"
    local scripts_folder="$2"
    local folders=($(ls -dt ~/Downloads/$pattern))

    for folder in "${folders[@]:1}"; do
        # rm -rf "$folder"
        echo "xxx $folder"
    done

    if [ -n "$scripts_folder" ]; then
        # rm -rf "$scripts_folder"
        echo "xxx $scripts_folder"
    fi

    echo "Folders deleted."
}

function delete_old_downloads() {
    patterns=(
        "BuildLoopFollow/LoopFollow-*"
        "Build_iAPS/iAPS-*"
        "NonExistingApp/Loop-*"
        "BuildLoop/Loop-*"
        "BuildLoop/LoopCaregiver-*"
        "BuildLoop/Loop_lnl_patches-*"
    )

    section_separator
    echo "We will now go through all build folders and for each, "
    echo "show the latest folder while giving you the option to "
    echo "remove older folders, including the temporary "Scripts" folder."
    echo 

    for pattern in "${patterns[@]}"; do
        delete_folders_except_latest "$pattern"
    done

    exit_message
}
