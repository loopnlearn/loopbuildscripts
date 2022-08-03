# LoopBuildScripts

These scripts simplify some tasks for building Loop and FreeAPS.

## scripts

The scripts have been updated significantly.

* BuildLoop.sh : commonly referred to as Build Select
  * It assists in the build of released code for either Loop or FreeAPS
  * It also has a menu driven feature to enable running other scripts:
    * Utility scripts from loopnlearn
    * LoopFollow from customtypeone

* BuildLoopFixedDev : special purpose script
  * It clones the development branch for either Loop or FreeAPS
  * Then it performs a git checkout to a specific commit
  * The commit number for this script is updated after it has been lightly tested
  * Why is this done?
    - Avoids using the script to build a commit that has an issue and requires updating
    - This is a rare occurrence, but it does happen during development


### Build Select script

This is documented in

* https://www.loopandlearn.org/build-select
* https://loopkit.github.io/loopdocs/build/step14

1. Open terminal
2. Copy/Paste this code into terminal (use copy icon, bottom right): 

Master Branch
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/BuildLoop.sh)"
```

3. Hit Enter and follow prompts


### Build Development Branch

This downloads the development branch for either Loop or FreeAPS, then checks out a commit that has been tested.

Development branch is not typically advised, but at this point in time, many people are using it to get DASH.

1. Open terminal
2. Copy/Paste this code into terminal (use copy icon, bottom right):

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/BuildLoopFixedDev.sh)"
```

3. Hit Enter and follow prompts


