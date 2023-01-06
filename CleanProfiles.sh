#!/bin/bash

clear
echo -e "\n✅ Cleaning Profiles"
echo -e " - this ensures the next app you build with Xcode will last a year.\n"
rm -rf ~/Library/MobileDevice/Provisioning\ Profiles
echo -e "✅ Profiles are cleaned."
echo -e "⬆️  You can press the up arrow on the keyboard followed by the Enter key to start the script from the beginning.\n\n";
exit 0
