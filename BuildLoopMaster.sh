echo      Launch this script by pasting this command into a black terminal window.  
echo .
echo .     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/BuildLoopMaster.sh)"
echo .
Echo     Set environment variables
LOOP_BUILD=$(date +'%y%m%d-%H%M')
LOOP_DIR=~/Downloads/BuildLoop/Loop-Master-$LOOP_BUILD
Echo make directories using format year month date hour minute so it can be easily sorted
mkdir ~/Downloads/BuildLoop/
mkdir $LOOP_DIR
cd $LOOP_DIR
pwd
Echo download software from github
git clone --branch=master --recurse-submodules https://github.com/LoopKit/LoopWorkspace
cd LoopWorkspace
Echo Open xcode
xed .
echo YOU SHOULD CLOSE THIS WINDOW NOW AND FINISH IN xCode.
exit


