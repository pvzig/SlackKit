// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SlackKit",
    products: [
        .library(name: "SlackKit", targets: ["SlackKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/SlackKit/SKCore", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/SlackKit/SKClient", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/caiofbpa/SKRTMAPI", .branch("use-cross-platform-starscream")),
        .package(url: "https://github.com/SlackKit/SKServer", .upToNextMajor(from: "4.0.0"))
    ],
    targets: [
        .target(name: "SlackKit", dependencies: ["SKClient", "SKRTMAPI", "SKServer"], path: "Sources")
    ]
)
