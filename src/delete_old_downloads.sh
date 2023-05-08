function delete_folders_except_latest() {
    local pattern="$1"
    local folders=($(ls -dt ~/Downloads/$pattern))
    local total_size=0

    section_separator
    if [ ${#folders[@]} -le 1 ]; then
        echo "No folders to delete for pattern '$pattern'"
        return
    fi

    echo "Preserved folder for pattern '$pattern':"
    echo "${folders[0]}"
    echo

    echo "Folders to delete for pattern '$pattern':"
    for folder in "${folders[@]:1}"; do
        echo "$folder"
        total_size=$(($total_size + $(du -s "$folder" | awk '{print $1}')))
    done

    total_size_mb=$(echo "scale=2; $total_size / 1024" | bc)
    echo "Total size to be deleted: $total_size_mb MB"

    options=("Delete" "Keep" "Quit")
    actions=("delete_selected_folders \"$pattern\"" "return" "cancel_entry")
    menu_select "${options[@]}" "${actions[@]}"
}

function delete_selected_folders() {
    local pattern="$1"
    local folders=($(ls -dt ~/Downloads/$pattern))

    for folder in "${folders[@]:1}"; do
        #rm -rf "$folder"
        echo "now this folder would have been removed with: rm -rf $folder"
    done

    echo "Folders deleted."
}

function delete_old_downloads() {
    patterns=(
        "BuildLoopFollow/LoopFollow-*"
        "Build_iAPS/iAPS-*"
        "BuildLoop/Loop-*"
        "BuildLoop/LoopCaregiver-*"
        "BuildLoop/Loop_lnl_patches-*"
    )

    for pattern in "${patterns[@]}"; do
        delete_folders_except_latest "$pattern"
    done
    
    exit_message
}