echo      Launch this script by pasting this command into a black terminal window.  
echo .
echo .     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/XcodeClean.sh)"
echo .
Echo Removing Developer iOS DeviceSupport Library
rm -rf ~/Library/Developer/Xcode/iOS\ DeviceSupport
Echo Removing Developer watchOS DeviceSupport Library
rm -rf ~/Library/Developer/Xcode/watchOS\ DeviceSupport
Echo Removing Cache CarthageKit
rm -rf ~/Library/Caches/org.carthage.CarthageKit
Echo Removing Developer DerivedData
rm -rf ~/Library/Developer/Xcode/DerivedData
echo YOU SHOULD CLOSE THIS WINDOW AND REBOOT
exit

