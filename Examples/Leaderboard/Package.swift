// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Leaderboard",
    products: [
        .executable(name: "Leaderboard", targets: ["Leaderboard"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pvzig/SlackKit", .upToNextMinor(from: "4.6.0"))
    ],
    targets: [
        .target(name: "Leaderboard",
        dependencies: ["SlackKit"],
                path: "Leaderboard/Sources")
    ]
)
