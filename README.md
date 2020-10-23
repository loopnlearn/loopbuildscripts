# LoopBuildScripts

These scripts simplify some tasks for building Loop and FreeAPS.

### Workspace Build Prep
The latest FreeAPS or Loop workspace files will download to Downloads/BuildLoop/FreeAPS or Downloads/BuildLoop/Loop. Each folder will be timestamped with date-HHMM  and branch (for Loop) so you can easily know what each folder is in the future. As soon as the download is complete, xcode will open the the downloaded workspace file to sign and build.   You should only build the Loop Master Branch unless you are fully aware of the settings changes needed for the Auto branches and the
commitment to debugging and frequent rebuids required for the Dev branch.

#### To Build FreeAPS
1. Open terminal. Tip: press command-space to open spotlight search. Start typing term... and you will see the terminal application icon in the box. Hit enter to open.
2. Copy/Paste this code into terminal: 
*`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/BuildFreeAPS.sh)"`*
3. Hit Enter

#### To Build Loop
1. Open terminal
2. Copy/Paste this code into terminal: 

Master Branch
*`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/BuildLoopMaster.sh)"`*

Dev Branch
*`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/BuildLoopDev.sh)"`*

Automatic Bolus Branch
*`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/BuildLoopAutomaticBolus.sh)"`*

3. Hit Enter


#### To clean Carthage files and Derived Data files
1. Open terminal
2. Copy/Paste this code into terminal: 

CleanCartDerived
*`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/CleanCartDerived.sh)"`*


#### Don't use this, it is a test script for selecting the branch when you run the script.   #### DON'T USE IT

1. Open terminal
2. Copy/Paste this code into terminal: 

CleanCartDerived
*`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/LoopMain.sh)"`*


