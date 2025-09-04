# `Loop and Learn`: lnl-scripts

## Introduction

These scripts simplify some tasks for building *Loop*, *Trio* and other DIY code from the GitHub repositories.

The code that these scripts help you download, build or modify is provided as open source (OS), and it is your responsibility to review the code and understand how each app works. This code is experimental and intended for testing, research, and educational purposes; it is not approved for therapy. Patches or customizations are even more experimental. You take full responsibility for building and running an OS app, and you do so at your own risk.

* [*Loop* Users](#loop-users)
* [*Trio* Users](#trio-users)
* [Individual Scripts](#individual-scripts)
* [Build a Custom Branch](#build-a-custom-branch)
* [Developer Tips](#developer-tips)
* [Other Apps?](#other-apps)

### *Loop* Users

Users of the *Loop* app should use the [Build Select Script](#loop-build-select-script). This script has a menu for users to choose the option they want.

* Script returns to top-menu after each option completes
* All Build scripts include automatic signing

The **Build Select Script** provides these options:

1. Build *Loop*
2. Build Related Apps
3. Maintenance Utilities
4. Customization Select

The `Build Loop` option offers your choice of the released (main) or development (dev) version of the *Loop* app.

The `Build Related Apps` option includes *LoopFollow*, *LoopCaregiver* and *xDrip4iOS*.

The `Maintenance Utilities` option includes `Delete Old Downloads` as well as other Xcode clean-up options.

The `Customization Select` option runs the Customization Select script, which is used to customize the *Loop* app.

In addition to selecting options from the top-menu of **BuildSelectScript**, each of the [individual scripts can be run directly](#individual-scripts).

### *Trio* Users

Users of the *Trio* app should use the [*Trio* Build Select Script](#trio-build-select-script). This script has a menu for users to choose the option they want.

* Script returns to top-menu after each option completes
* All Build scripts include automatic signing

The **Trio Build Select Script** provides these options:

1. Build *Trio*
2. Build Related Apps
3. Maintenance Utilities

The `Build Trio` option offers your choice of the released (main) or development (dev) version of *Trio*.

The `Build Related Apps` option includes *LoopFollow* and *xDrip4iOS*.

The `Maintenance Utilities` option includes `Delete Old Downloads` as well as other Xcode clean-up options.

In addition to selecting options from the top-menu of **TrioBuildSelectScript**, each of the [individual scripts can be run directly](#individual-scripts).

### `main` Branch

Note: the commands in the README are for the main branch of the scripts. If you are a developer or tester using a different branch, please read [Developer Tips](#developer-tips).

## *Loop* Build Select Script

This script is documented in

* [LnL: Build Select Script](https://www.loopandlearn.org/build-select)
* [*LoopDocs*: Build Select Script](https://loopkit.github.io/loopdocs/build/step14/#download-loop)

### Command to Execute Build Select Script

1. Open Terminal
2. Copy/Paste this code into Terminal (use copy icon, bottom right): 

```
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/loopandlearn/lnl-scripts/main/BuildSelectScript.sh)"
```

3. Enter and follow prompts

## *Trio* Build Select Script

This script is documented in

* [*TrioDocs*](https://triodocs.org)

The direct link (subject to change) is:

* [*TrioDocs*: Build *Trio* with Script](https://triodocs.org/install/build/mac/build/)

### Command to Execute Build Select Script

1. Open Terminal
2. Copy/Paste this code into Terminal (use copy icon, bottom right): 

```
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/loopandlearn/lnl-scripts/main/TrioBuildSelectScript.sh)"
```

3. Enter and follow prompts

## Individual Scripts

Individual scripts can be run directly with the commands listed below.

1. Open Terminal
2. Copy/Paste selected code into Terminal (use copy icon, bottom right):
3. Enter and follow prompts

#### Scripts included in BuildSelectScript or TrioBuildSelectScript

Use these commands to run a script directly instead of selecting it using the menu options in the Build Select Script.

#### BuildLoop

This builds the released or development version of *Loop*; you can choose the `main` or `dev` branch.

```
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/loopandlearn/lnl-scripts/main/BuildLoop.sh)"
```

#### BuildLoopFollow

```
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/loopandlearn/lnl-scripts/main/BuildLoopFollow.sh)"
```

#### BuildLoopCaregiver

```
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/loopandlearn/lnl-scripts/main/BuildLoopCaregiver.sh)"
```

#### BuildTrio

```
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/loopandlearn/lnl-scripts/main/BuildTrio.sh)"
```

#### BuildxDrip4iOS

```
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/loopandlearn/lnl-scripts/main/BuildxDrip4iOS.sh)"
```

#### CustomizationSelect

Patches or customizations are even more experimental than the released version of *Loop*. It is your responsibility to understand the changes made to the *Loop* code when you apply, remove or update one of these customizations. Review the documentation: [CustomizationSelect](https://www.loopandlearn.org/build-select/#customization-select).


```
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/loopandlearn/lnl-scripts/main/CustomizationSelect.sh)"
```

#### DeleteOldDownloads

```
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/loopandlearn/lnl-scripts/main/DeleteOldDownloads.sh)"
```

## Build a Custom Branch

In addition to building a particular app with one or more options for the branch to be used, all the `Build` scripts will build a custom branch when called with a particular syntax.

**Instructions for a custom branch:**

* Add ` - branch_name` to the end of the command below
* There must be a space after the ending quote followed by hyphen, another space and then the branch name
* This bypasses the menu and downloads the desired branch from for the app 

The example below is for `BuildLoop` but the same method works for all the `Build` scripts. You cannot just copy and paste this command. You must edit it first.

```
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/loopandlearn/lnl-scripts/main/BuildLoop.sh)" - put_desired_branch_name_here
```

## Developer Tips

When these scripts are being modified and tested, the developers will be working in a feature or development (dev) branch. In addition, they can use some special flags to simplify and speed up testing.

In order to test with a different branch, first configure that branch in Terminal with the export command. If using a branch other than dev, then modify the command with that branch name:

```
export SCRIPT_BRANCH=dev
```

Then for all commands found earlier in this README, replace the word main with $SCRIPT_BRANCH.

When testing locally, there are other test variables you can configure. Be sure to read these two files:
* `custom_config.sh`
* `clear_custom_config.sh`

### Inlining Scripts

This project uses a script inlining system to generate executable scripts from source files. The source files for each script are located in the src directory, and the generated scripts are output to the root directory. All inline scripts are in the inline_functions folder.

To modify a script, simply edit the corresponding source file in the src directory, and then run the build script (`./build.sh`) to regenerate all the scripts. The build script will inline any required files and generate the final executable scripts. By adding an argument after `./build.sh`, you can limit the rebuild to the indicated script.

To test a script during development, this command is helpful (example shown is for CustomatizationScript, but works for any script.)

1. Modify `src/CustomizationScript.sh`
1. Execute this command to rebuild and execute:
  * `./build.sh CustomizationScript.sh && ./CustomizationScript.sh`

Note that the build system uses special comments to indicate which files should be inlined. Any line in a script that starts with #!inline will be replaced with the contents of the specified file. The build system will inline files up to a maximum depth of 10, to prevent infinite recursion.

To learn more about the inlining process and how it works, please see the comments in the `build.sh` script.

### Environment Variable

The available environment variables used by the scripts are set using the `export` command and cleared with the `unset` command.

Once you use an export command, that environment variable stays set in that Terminal and will be used by the script. 

* You can use the unset command to stay in the same Terminal
* You can use CMD-N while in any Terminal window to open a new Terminal window, then switch to the new window

## Other Apps?

Several apps are no longer found in lnl-scripts.

* The *GlucoseDirect* CGM app owner is no longer providing updates
    * *Trio* has removed *GlucoseDirect* as a CGM option
    * `Loop and Learn` provides customization support to add other CGM to the *Loop* app and *GlucoseDirect* is no longer provided as an option
    
* *iAPS*
    * The script to build *iAPS* is still found in lnl-scripts but may be removed without notice
    * The *iAPS* app should only be used by folks who are involved in keeping up with the app and willing and able to build frequently without build-script support
    * The `Loop and Learn` Team suggest that *Trio* be used instead for most users
