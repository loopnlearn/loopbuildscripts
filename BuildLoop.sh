clear
echo -e "\nPlease select which version of Loop you would like to download and build. Type the number 1, 2, or 3 and hit enter."
options=("FreeAPS" "Loop Master Branch" "Loop Auto Bolus Branch")
select opt in "${options[@]}"
do
    case $opt in
        "FreeAPS")
            FOLDERNAME=FreeAPS
            BRANCH=freeaps
            REPO=https://github.com/ivalkou/LoopWorkspace
            break
            ;;
        "Loop Master Branch")
            FOLDERNAME=Loop-Master
            BRANCH=master
            REPO=https://github.com/LoopKit/LoopWorkspace
            break
            ;;
        "Loop Auto Bolus Branch")
            FOLDERNAME=Loop-AutoBolus
            BRANCH=automatic-bolus
            REPO=https://github.com/LoopKit/LoopWorkspace
            break
            ;;
        *) 
    esac
done

Echo     Set environment variables
LOOP_BUILD=$(date +'%y%m%d-%H%M')
LOOP_DIR=~/Downloads/BuildLoop/$FOLDERNAME-$LOOP_BUILD
Echo make directories using format year month date hour minute so it can be easily sorted
mkdir ~/Downloads/BuildLoop/
mkdir $LOOP_DIR
cd $LOOP_DIR
pwd
Echo download software from github
git clone --branch=$BRANCH --recurse-submodules $REPO
cd LoopWorkspace
Echo Open xcode
xed .
exit
