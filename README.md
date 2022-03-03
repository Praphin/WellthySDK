# Wellthy iOS Framework

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Chatkit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

# Replace `<Your Target Name>` with your app's target name.
target '<Your Target Name>' do
  pod 'Plum-SDK'
end
```

Then, run the following command:

```bash
$ pod install
```

> You might need to use the `--repo-update` flag to ensure the specs repository is aware of the latest version of Plum-SDK.
