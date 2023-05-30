#!/bin/bash # script ProfileSelect.sh

BUILD_DIR=~/Downloads/BuildLoop

#!inline patch_functions.sh

############################################################
# The rest of this is specific to the particular script
############################################################

# this is always used - it is the introductory message
special_menu_item_0=0

function message_for_special_menu_item_0() {
    echo "Proposed: Loop PR 2002 Profile Switching"
    echo "  see https://https://github.com/LoopKit/Loop/pull/2002"
    echo
}

# Set these to out-of-range values
# They are not used for single-item script
special_menu_item_1=100
special_menu_item_2=100
# and just in case:
special_menu_item_3=100


add_customization "Profiles (PR#2002)" "profile"

function customization_info {
    :
}

patch_menu