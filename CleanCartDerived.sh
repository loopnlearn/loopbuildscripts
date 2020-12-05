# !/bin/bash

clear

echo -e "\n\n✅ Cleaning Carthage Files.\n"
rm -rf ~/Library/Caches/org.carthage.CarthageKit
echo -e "✅ Cleaning Derived Data files.\n"
rm -rf ~/Library/Developer/Xcode/DerivedData
echo -e "✅ Done Cleaning.\n\n⚠️  If Xcode is open, Quit it and open it again.\n"
echo -e "⬆️  You can press the up arrow on the keyboard followed by the Enter key to start the script from the beginning.\n\n";
exit 0
