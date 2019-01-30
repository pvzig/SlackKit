# SKWebAPI: SlackKit Web API Module
![Swift Version](https://img.shields.io/badge/Swift-4.0.3-orange.svg)
![Plaforms](https://img.shields.io/badge/Platforms-macOS,iOS,tvOS,Linux-lightgrey.svg)
![License MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg)
[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg)](https://github.com/Carthage/Carthage)
[![CocoaPods compatible](https://img.shields.io/badge/CocoaPods-compatible-brightgreen.svg)](https://cocoapods.org)

A Swift module to help make requests to the [Slack Web API](https://api.slack.com/web).

## Installation

### CocoaPods

Add SKWebAPI to your pod file:

```
use_frameworks!
pod 'SKWebAPI'
```
and run

```
# Use CocoaPods version >= 1.4.0
pod install
```

### Carthage

Add SKWebAPI to your Cartfile:

```
github "SlackKit/SKWebAPI"
```
and run

```
carthage bootstrap
```

Drag the built `SKWebAPI.framework` into your Xcode project.

### Swift Package Manager

Add SKWebAPI to your Package.swift

```swift
import PackageDescription
  
let package = Package(
	dependencies: [
		.package(url: "https://github.com/SlackKit/SKWebAPI.git", .upToNextMinor(from: "4.1.0"))
	]
)
```

Run `swift build` on your application’s main directory.

To use the library in your project import it:

```swift
import SKWebAPI
```

## Usage
Initialize an instance of `SKWebAPI` with a Slack auth token and make your requests:

```swift
let webAPI = WebAPI(token: xoxp-SLACK_AUTH_TOKEN)
webAPI.authenticationTest(success: { (user, team) in
	print("\(user) - \(team)")
}, failure: nil)
```

### Web API Methods
SlackKit currently supports the a subset of the Slack Web API that is available to bot users:

| Web APIs      |
| ------------- |
| `api.test`|
| `api.revoke`|
| `auth.test`|
| `channels.history`|
| `channels.info`|
| `channels.list`|
| `channels.mark`|
| `channels.create`|
| `channels.invite`|
| `channels.setPurpose`|
| `channels.setTopic`|
| `chat.delete`|
| `chat.meMessage`|
| `chat.postMessage`|
| `chat.update`|
| `emoji.list`|
| `files.comments.add`|
| `files.comments.edit`|
| `files.comments.delete`|
| `files.delete`|
| `files.info`|
| `files.upload`|
| `groups.close`|
| `groups.history`|
| `groups.info`|
| `groups.list`|
| `groups.mark`|
| `groups.open`|
| `groups.setPurpose`|
| `groups.setTopic`|
| `im.close`|
| `im.history`|
| `im.list`|
| `im.mark`|
| `im.open`|
| `mpim.close`|
| `mpim.history`|
| `mpim.list`|
| `mpim.mark`|
| `mpim.open`|
| `oauth.access`|
| `pins.add`|
| `pins.list`|
| `pins.remove`|
| `reactions.add`|
| `reactions.get`|
| `reactions.list`|
| `reactions.remove`|
| `rtm.start`|
| `stars.add`|
| `stars.remove`|
| `team.info`|
| `users.getPresence`|
| `users.info`|
| `users.list`|
| `users.setActive`|
| `users.setPresence`|
