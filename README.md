# NOTE: This Yuneec SDK for iOS is deprecated.

We are moving to [Dronecode SDK](http://dronecore.io/), for iOS please checkout [Dronecode-SDK-Swift](https://github.com/dronecore/DroneCore-Swift).


## Yuneec SDK for iOS

[![Build Status](https://travis-ci.org/YUNEEC/Yuneec-SDK-iOS.svg?branch=master)](https://travis-ci.org/YUNEEC/Yuneec-SDK-iOS)

This repository contains the iOS wrappers for the Yuneec SDK written in Objective-C/Objective-C++.

## Usage

### Use Carthage to get the framework

To use the Yuneec SDK in your iOS application, you can pull in this framework using [Carthage](https://github.com/Carthage/Carthage).

To install carthage, it's easiest to use [Homebrew](https://brew.sh/):

```
brew install carthage
```

Then to add the framework, create the file `Cartfile` in your app's repository with below's content:

```
# Require the iOS framework of the Yuneec SDK
github "YUNEEC/Yuneec-SDK-iOS" >= 0.10.1
```

Then, to pull in the library and build it, run Carthage in your app's repository:

```
carthage update
```

This command also needs to be re-run if you want to udpate the framework.

### Add the framework into your project

Open the project in XCode and do the following:

1. Open Project Settings -> General
2. Find Embedded Binaries and press *+*
3. Click Other, go one folder up, and select `Carthage/Build/iOS/Yuneec_SDK_iOS.framework`.
4. Do "Product Clean" and "Product Build"

### Use Carthage to check out a developer branch

While developing, you might need a developer version of the iOS wrappers. They can be accessed by using a branch in the `Cartfile`:

```
github "YUNEEC/Yuneec-SDK-iOS" "branch-name"
```

### Build using xcodebuild

To build, do:

```
xcodebuild
```

This will call [./download-dronecore.sh](download-dronecore.sh) to pull the `DroneCore-iOS-vX.Y.Z-Release.zip` file from s3 using curl, unzip it. Then it will compile the Objective-C wrappers.

To clean up and force the script to download the zip file again, you can use:
```
xcodebuild clean
rm *.zip
```
Or to remove any unstaged files in the directory: `git clean -dfx`. Attention, check using `--dry-run` first what you're about to remove.

## Docs

Autogenerated API docs can be found locally in the [docs](docs) directory or on the [Yuneec Developer Portal](https://developer.yuneec.com/sites/default/files/ios-sdk/index.html).

### Generate docs

To generate the docs, [jazzy](https://github.com/realm/jazzy) is used.

To install it, do:

```
sudo gem install jazzy
```

To update the docs:

```
jazzy --objc --umbrella-header Yuneec_SDK_iOS/Yuneec_SDK_iOS.h --theme docs/yuneec
```

## License

The source code in this repository which is just a  wrapper around the Yuneec-SDK (C++ library) is published under the [BSD 3-Clause license](LICENSE).

