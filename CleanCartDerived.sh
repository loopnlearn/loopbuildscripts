echo      Launch this script by pasting this command into a black terminal window.  
echo .
echo .     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/CleanCartDerived.sh)"
echo .
echo Cleaning carthage files
rm -rf ~/Library/Caches/org.carthage.CarthageKit
echo Cleaning Derived Data files
rm -rf ~/Library/Developer/Xcode/DerivedData
echo Done cleaning.    If xCode is open, Quit it and open it again.


