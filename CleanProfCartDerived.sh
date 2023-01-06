#!/bin/bash

clear
echo -e "\n\n🕒 Please be patient. On older computers and virtual machines, this may take 5-10 minutes or longer to run.\n"
echo -e "\n\n✅ Cleaning Profiles.\n"
rm -rf ~/Library/MobileDevice/Provisioning\ Profiles
echo -e "✅ Cleaning Derived Data files.\n"
rm -rf ~/Library/Developer/Xcode/DerivedData
echo -e "✅ Done Cleaning.\n\n⚠️  If Xcode is open, Quit it and open it again.\n"
echo -e "⬆️  You can press the up arrow on the keyboard followed by the Enter key to start the script from the beginning.\n\n";
exit 0
