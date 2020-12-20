# SlackKit: Slack Apps in Swift

## Installation
<details>
  <summary><strong>Swift Package Manager</strong></summary>
Add SlackKit to your <code>Package.swift</code>

```swift  
let package = Package(
	dependencies: [
		.package(url: "https://github.com/pvzig/SlackKit.git", .upToNextMinor(from: "4.6.0"))
	]
)
```

**When built using Swift Package Manager, SlackKit includes the [vapor websocket framework](https://github.com/vapor/websocket) by default which requires libressl.**

You can install it with [homebrew](https://brew.sh): `brew install libressl`

For additional details, see the [SKRTMAPI readme](https://github.com/pvzig/SlackKit/tree/master/SKRTMAPI#swift-package-manager).
</details>
<details>
  <summary><strong>Carthage</strong></summary>
Add SlackKit to your <code>Cartfile</code>:

```
github "pvzig/SlackKit"
```
</details>
<details>
  <summary><strong>CocoaPods</strong></summary>
Add SlackKit to your <code>Podfile</code>:

```
pod 'SlackKit'
```
</details>

### Usage
To use the library in your project import it:

#### Carthage & SPM

```swift
import SKWebAPI
```

#### CocoaPods

```swift
import SlackKit
```

#### The Basics
Create a bot user with an API token:

```swift
import SlackKit

let bot = SlackKit()
bot.addRTMBotWithAPIToken("xoxb-SLACK-BOT-TOKEN")
// Register for event notifications
bot.notificationForEvent(.message) { (event, _) in
	// Your bot logic here
	print(event.message)
}
```

or create a ready-to-launch Slack app with your [application’s `Client ID` and `Client Secret`](https://api.slack.com/apps):

```swift
import SlackKit

let bot = SlackKit()
let oauthConfig = OAuthConfig(clientID: "CLIENT_ID", clientSecret: "CLIENT_SECRET")
bot.addServer(oauth: oauthConfig)
```

or just make calls to the Slack Web API:

```swift
import SlackKit

let bot = SlackKit()
bot.addWebAPIAccessWithToken("xoxb-SLACK-BOT-TOKEN")
bot.webAPI?.authenticationTest(success: { (success) in
	print(success)
}, failure: nil)

```

#### Slash Commands
After [configuring your slash command in Slack](https://my.slack.com/services/new/slash-commands) (you can also provide slash commands as part of a [Slack App](https://api.slack.com/slack-apps)), create a route, response middleware for that route, and add it to a responder:

```swift
let slackkit = SlackKit()
let middleware = ResponseMiddleware(token: "SLASH_COMMAND_TOKEN", response: SKResponse(text: "👋"))
let route = RequestRoute(path: "/hello", middleware: middleware)
let responder = SlackKitResponder(routes: [route])
slackkit.addServer(responder: responder)
```
When a user enters that slash command, it will hit your configured route and return the response you specified.

#### Message Buttons
Add [message buttons](https://api.slack.com/docs/message-buttons) to your responses for additional interactivity.

To send messages with actions, add them to an attachment and send them using the Web API:

```swift
let helloAction = Action(name: "hello", text: "🌎")
let attachment = Attachment(fallback: "Hello World", title: "Welcome to SlackKit", callbackID: "hello_world", actions: [helloAction])
slackkit.webAPI?.sendMessage(channel: "CXXXXXX", text: "", attachments: [attachment], success: nil, failure: nil)
```

To respond to message actions, add a `RequestRoute` with `MessageActionMiddleware` using your app’s verification token to your `SlackKitResponder`:

```swift
let response = ResponseMiddleware(token: "SLACK_APP_VERIFICATION_TOKEN", response: SKResponse(text: "Hello, world!"))
let actionRoute = MessageActionRoute(action: helloAction, middleware: response)
let actionMiddleware = MessageActionMiddleware(token: "SLACK_APP_VERIFICATION_TOKEN", routes:[actionRoute])
let actions = RequestRoute(path: "/actions", middleware: actionMiddleware)
let responder = SlackKitResponder(routes: [actions])
slackkit.addServer(responder: responder)
```

#### OAuth
Slack has [many different oauth scopes](https://api.slack.com/docs/oauth-scopes) that can be combined in different ways. If your application does not request the proper OAuth scopes, your API calls will fail. 

If you authenticate using OAuth and the Add to Slack or Sign in with Slack buttons this is handled for you.

For local development of things like OAuth, slash commands, and message buttons, you may want to use a tool like [ngrok](https://ngrok.com).
