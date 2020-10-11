# SKServer
A server-side Swift framework for creating Slack apps.

## Installation
<details>
  <summary><strong>Swift Package Manager</strong></summary>
Add SlackKit as a dependency to your <code>Package.swift</code> and specify SKServer as a target dependency:

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
            dependencies: ["SKServer"])
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

Drag the built <code>SKServer.framework</code> and it's dependencies <code>SKCore.framework</code>, <code>SKWebAPI.framework</code>, and <code>Swifter.framework</code> into your Xcode project.
</details>
<details>
  <summary><strong>CocoaPods</strong></summary>
Add SKServer to your <code>Podfile</code>:

```
use_frameworks!
pod 'SlackKit/SKServer'
```
</details>

## Usage
To use the library in your project import it:

#### Carthage & SPM

```swift
import SKServer
```

#### CocoaPods

```swift
import SlackKit
```

### The Basics
For local development and testing of features like OAuth, slash commands, and message buttons that require connecting over https, you may want to use a tool like [ngrok](https://ngrok.com/).

Initialize an instance of `SKServer` with a `SlackKitResponder`:

```swift
let middleware = ResponseMiddleware(token: "xoxp-SLACK_AUTH_TOKEN", response: SKResponse(text: "👋"))
let route = RequestRoute(path: "/hello", middleware: middleware)
let responder = SlackKitResponder(routes: [route])
// Without OAuth
let server = SKServer(responder: responder)
// With OAuth
let oauthConfig = OAuthConfig(clientID: "CLIENT_ID", clientSecret: "CLIENT_SECRET")
let server = SKServer(responder: responder, oauth: oauthConfig)
server.start()
```

OAuth is configured by default to use the `/oauth` route.

### Middleware
Use the provided `ResponseMiddleware` to respond to requests:

```swift
let middleware = ResponseMiddleware(token: "xoxp-SLACK_AUTH_TOKEN", response: SKResponse(text: "👋"))
```

Or create your own custom middleware by conforming to the `Middleware` protocol:

```swift
public protocol Middleware {
    func respond(to request: (RequestType, ResponseType)) -> (RequestType, ResponseType)
}
```

### RequestRoute
Use the `RequestRoute` type to assign a middleware to a specific route:

```swift
let route = RequestRoute(path: "/hello", middleware: middleware)
```

### SlackKitResponder
Add your routes to a `SlackKitResponder`:

```swift
let responder = SlackKitResponder(routes: [route])
```

### SKServer
Finally, initialize and start your `SKServer`:

```swift
let server = SKServer(responder: responder)
server.start()
```

## Custom Integrations

### Outgoing Webhook
To use an outgoing webhook, configure middleware and a route with the Slack verification token [after configuring your outgoing webhook in Slack](https://api.slack.com/outgoing-webhooks) and pointing it at your server:

```swift
let outgoingMiddleware = ResponseMiddleware(token: "xoxp-SLACK_AUTH_TOKEN", response: SlackResponse(text: "Hello, 🌎", responseType: .inChannel))
let outgoingRoute = RequestRoute(path: "/world", middleware: outgoingMiddleware)
let responder = SlackKitResponder(routes: [outgoingRoute])
let server = SKServer(responder: responder)
server.start()
```

## Slack App Features

### Slash Commands
After [configuring your slash command in Slack](https://my.slack.com/services/new/slash-commands) (you can also provide slash commands as part of a [Slack App](https://api.slack.com/slack-apps)), create a route, response middleware for that route, and add it to a responder:

```swift
let middleware = ResponseMiddleware(token: "SLASH_COMMAND_TOKEN", response: SKResponse(text: "👋"))
let route = RequestRoute(path: "/hello", middleware: middleware)
let responder = SlackKitResponder(routes: [route])
let server = SKServer(responder: responder)
server.start()
```

When a user enters that slash command, it will hit your configured route and return the response you specified.

### Message Buttons
To use message buttons, create actions using the `Action` type and attach them to your `SlackResponse` as attachments:

```swift
let confirm = Action.Confirm(text: "Are you sure?", title: "Confirm", okText: "All Systems Go", dismissText: "Abort!")
let action = Action(name: "launch", text: "Blast Off!", style: .Danger, confirm: confirm)
let attachment = Attachment(fallback: "launch", title: "Misson Control", callbackID: "launch_id", actions: [action])
let response = SlackResponse(text: "T-Minus 10…", responseType: .InChannel, attachments: [attachment])
```

To respond to message button presses, create a `MessageActionRoute` for each action, with a corresponding middleware:

```swift
let responseMiddleware = ResponseMiddleware(token: "slack-verification-token", response: SlackResponse(text: "Initiate Launch Sequence"))
let messageActionRoute = MessageActionRoute(action: action, middleware: responseMiddleware)
```

Add your `MessageActionRoute` to a `MessageActionResponder`:

```swift
let responder = MessageActionResponder(routes: [messageActionRoute])
```

Finally, create a `MessageActionMiddleware` and specify the route to reach it:

```swift
let actionMiddleware = MessageActionMiddleware(token: "slack-verification-token", responder: responder)
let actionRoute = RequestRoute(path: "/actions", middleware: actionMiddleware)
let responder = SlackKitResponder(routes: [actionRoute])
let server = SKServer(responder: responder)
server.start()
```

Provide your own server implementation by conforming to `SlackKitServer`:

```swift
public protocol SlackKitServer {
	func start()
}
```

```swift
let server = YourServer()
let slackApp = SKServer(server: YourServer(), responder: aResponder)
```
