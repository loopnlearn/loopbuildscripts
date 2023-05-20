#!/bin/bash

#!inline common.sh

section_separator
echo -e "\n✅ Cleaning Profiles"
echo -e " - this ensures the next app you build with Xcode will last a year.\n"
rm -rf ~/Library/MobileDevice/Provisioning\ Profiles
echo -e "✅ Profiles are cleaned."
exit_script
