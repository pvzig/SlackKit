# SKClient
Create a custom SlackKit client.

## Installation

<details>
  <summary><strong>Swift Package Manager</strong></summary>
Add SlackKit as a dependency to your <code>Package.swift</code> and specify SKClient as a target dependency:

```swift
import PackageDescription
  
let package = Package(
    name: "SampleApp",
    products: [
        .executable(
            name: "SampleApp",
            targets: ["SampleApp"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pvzig/SlackKit.git", .upToNextMinor(from: "4.6.0")),
    ],
    targets: [
        .target(
            name: "SampleApp",
            dependencies: ["SKClient"])
    ]
)

```
</details>
<details>
  <summary><strong>Carthage</strong></summary>
Add SlackKit to your <code>Cartfile</code>:

```
github "pvzig/SlackKit"
```

and run

```
carthage bootstrap
```

Drag the built <code>SKClient.framework</code> and it's dependency <code>SKCore.framework</code> into your Xcode project.
</details>
<details>
  <summary><strong>CocoaPods</strong></summary>
Add SKClient to your <code>Podfile</code>:

```
use_frameworks!
pod 'SlackKit/SKClient'
```
</details>

## Usage
To use the library in your project import it:

#### Carthage & SPM

```swift
import SKClient
```

#### CocoaPods

```swift
import SlackKit
```

### The Basics
Subclass `Client` to create a custom SlackKit client.

```
class MyClient: Client {

    override func notificationForEvent(_ event: Event, type: EventType) {
    …
    }

	override func initialSetup(JSON: [String: Any]) {
	…
	}
}
```

Pass your custom client to [`SlackKit`](https://www.github.com/pvzig/SlackKit) when adding an RTM bot:

```
let bot = SlackKit()
bot.addRTMBotWithAPIToken(“xoxb-SLACK_AUTH_TOKEN”, client: MyClient())
```
