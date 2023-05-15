# loopbuildscripts

These scripts simplify some tasks for building Loop and other DIY code from the GitHub repositories.

The script that most user should use is the BuildLoop.sh script, otherwise known as the **Build-Select-Script**. This script has a menu for users to choose the option they want.

As of 15-May-2023, dev branch, the **Build-Select-Script** options (in BuildLoop.sh) were updated and expanded. The scripts are now significantly easier to create and maintain. All Build scripts include automatic signing.

This script will help you to:

1. Download and Build Loop
2. Download and Build Related Apps
3. Run Maintenance Utilities
4. Run Customization Utilities

The Build Loop option is similar to the previous version.

The Build Related Apps option includes Loop Follow, LoopCaregiver and xDrip4iOS. (Yes, GlucoseDirect is planned).

The Maintenance Utilities option will soon include the Delete Old Downloads as well as other Xcode clean-up options.

The Run Customization Utilities leads to the Customization Select script and has a placeholder for other customization scripts that are planned, but not yet ready.

In addition to selecting options with the **Build-Select-Script** (BuildLoop.sh), each of the scripts can be run directly.

There are several build scripts for specific code not included in **Build-Select-Script**. These are:

* [BuildLoopDev.sh](#buildloopdev)
* [BuildFreeAPS.sh](#buildfreeaps)
* [Build_iAPS.sh](#build_iaps)


### Build-Select-Script

This is documented (note - for main only, not for dev) in

* [LnL: Build-Select](https://www.loopandlearn.org/build-select)
* [LoopDocs: Build-Select](https://loopkit.github.io/loopdocs/build/step14/#download-loop)

1. Open terminal
2. Copy/Paste this code into terminal (use copy icon, bottom right): 

```
export SCRIPT_BRANCH="dev" && \
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/loopnlearn/loopbuildscripts/$SCRIPT_BRANCH/BuildLoop.sh)"
```

3. Hit Enter and follow prompts


### Other Scripts

The other scripts can be run with the following commands

1. Open terminal
2. Copy/Paste selected code into terminal (use copy icon, bottom right):
3. Hit Enter and follow prompts

#### Branches other than main

Each command below has an export command to select the correct branch from loopbuildscripts. This will be modified prior to merge to main. Note that the export sets an enviroment variable that remains set (and used) until it it cleared.

#### Scripts included in Build-Select-Script

Use these commands to run a script directly instead of using the **Build-Select-Script** menu.

#### BuildLoopFollow

```
export SCRIPT_BRANCH=dev && \
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/loopnlearn/loopbuildscripts/$SCRIPT_BRANCH/BuildLoopFollow.sh)"
```

#### BuildLoopCaregiver

```
export SCRIPT_BRANCH="dev" && \
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/loopnlearn/loopbuildscripts/$SCRIPT_BRANCH/BuildLoopCaregiver.sh)"
```

#### BuildxDrip4iOS

```
export SCRIPT_BRANCH="dev" && \
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/loopnlearn/loopbuildscripts/$SCRIPT_BRANCH/BuildxDrip4iOS.sh)"
```

#### CustomizationSelect

```
export SCRIPT_BRANCH="dev" && \
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/loopnlearn/loopbuildscripts/$SCRIPT_BRANCH/CustomizationSelect.sh)"
```

#### Scripts not included in Build-Select-Script

These scripts can only be run directly.

#### BuildLoopDev

This script enables building the dev branch, a lightly tested version of the dev branch or you can add ` - branch_name` to the end of the command to download and build any desired branch of LoopKit/LoopWorkspace.

```
export SCRIPT_BRANCH="dev" && \
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/loopnlearn/loopbuildscripts/$SCRIPT_BRANCH/BuildLoopFixedDev.sh)"
```

#### BuildFreeAPS

```
export SCRIPT_BRANCH="dev" && \
/bin/bash -c "$(curl -fsSL 
  https://raw.githubusercontent.com/loopnlearn/loopbuildscripts/$SCRIPT_BRANCH/BuildFreeAPS.sh)"
```

#### Build_iAPS

```
export SCRIPT_BRANCH="dev" && \
/bin/bash -c "$(curl -fsSL 
  https://raw.githubusercontent.com/loopnlearn/loopbuildscripts/$SCRIPT_BRANCH/Build_iAPS.sh)"
```

## Developer Tips

When these scripts are being modified and tested, the developers use some special flags to make it easy to test quickly.

Be sure to modify the README file to use main instead of $SCRIPT_BRANCH prior to merging from dev (or other branch) to main.

When testing locally, there are other test variables you can configure. Be sure to read these two files:
* custom_config.sh
* clear_custom_config.sh

### Inlining Scripts

This project uses a script inlining system to generate executable scripts from source files. The source files for each script are located in the src directory, and the generated scripts are output to the root directory.

To modify a script, simply edit the corresponding source file in the src directory, and then run the build script (./build.sh) to regenerate the output file. The build script will inline any required files and generate the final executable script.

For example, if you want to modify the BuildLoop.sh script, you would edit the src/BuildLoop.sh file, and then run type `./build.sh` in the root directory. The build.sh script will then generate the BuildLoop.sh file in the root directory, which can be executed.

Note that the build system uses special comments to indicate which files should be inlined. Any line in a script that starts with #!inline will be replaced with the contents of the specified file. The build system will inline files up to a maximum depth of 10, to prevent infinite recursion.

To learn more about the inlining process and how it works, please see the comments in the build.sh script.

### Environment Variable

The available environment variables used by the scripts are set using the `export` command and cleared with the `unset` command.

Once you use an export command, that environment variable stays set in that terminal and will be used by the script. 

* You can use the unset command to stay in the same terminal
* You can use CMD-N while in any terminal window to open a new terminal window, then switch to the new window
