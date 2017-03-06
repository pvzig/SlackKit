import PackageDescription

let package = Package(
    name: "SlackKit",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/gabriel-dynamo/swifter.git",
                 majorVersion: 4, minor: 0),
        .Package(url: "https://github.com/gabriel-dynamo/Starscream", majorVersion: 3, minor: 0)
    ]
)
