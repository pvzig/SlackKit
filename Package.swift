// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SlackKit",
    platforms: [
        .macOS(.v10_10), .iOS(.v10), .tvOS(.v10)
    ],
    products: [
        .library(name: "SlackKit", targets: ["SlackKit"]),
        .library(name: "SKClient", targets: ["SKClient"]),
        .library(name: "SKCore", targets: ["SKCore"]),
        .library(name: "SKRTMAPI", targets: ["SKRTMAPI"]),
        .library(name: "SKServer", targets: ["SKServer"]),
        .library(name: "SKWebAPI", targets: ["SKWebAPI"])
    ],
    dependencies: [
        .package(name: "Swifter", url: "https://github.com/httpswift/swifter.git", .upToNextMinor(from: "1.5.0")),
        .package(name: "WebSocket", url: "https://github.com/vapor/websocket", .upToNextMinor(from: "1.1.2")),
        .package(name: "Starscream", url: "https://github.com/daltoniam/Starscream", .upToNextMinor(from: "4.0.4"))
    ],
    targets: [
        .target(name: "SlackKit",
                dependencies: ["SKCore", "SKClient", "SKRTMAPI", "SKServer"],
                path: "SlackKit/Sources"),
        .target(name: "SKClient",
                dependencies: ["SKCore"],
                path: "SKClient/Sources"),
        .target(name: "SKCore",
                path: "SKCore/Sources"),
        .target(name: "SKRTMAPI",
                dependencies: [
                    "SKCore",
                    "SKWebAPI",
                    .product(name: "Starscream", package: "Starscream", condition: .when(platforms: [.macOS, .iOS, .tvOS])),
                    .product(name: "WebSocket", package: "WebSocket", condition: .when(platforms: [.macOS, .linux])),
                ],
                path: "SKRTMAPI/Sources"),
        .target(name: "SKServer",
                dependencies: ["SKCore", "SKWebAPI", "Swifter"],
                path: "SKServer/Sources"),
        .target(name: "SKWebAPI",
                dependencies: ["SKCore"],
                path: "SKWebAPI/Sources"),
        .testTarget(name: "SlackKitTests",
                dependencies: ["SlackKit", "SKCore", "SKClient", "SKRTMAPI", "SKServer"],
                path: "SlackKitTests",
                exclude: [
                    "Supporting Files"
                ],
                resources: [
                    .copy("Resources")
                ])
    ],
    swiftLanguageVersions: [.v5]
)
