// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Robot or Not Bot",
    products: [
        .executable(name: "Robot or Not Bot", targets: ["Robot or Not Bot"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pvzig/SlackKit", .upToNextMinor(from: "4.6.0"))
    ],
    targets: [
        .target(name: "Robot or Not Bot",
        dependencies: ["SlackKit"],
                path: "Robot or Not Bot/Sources")
    ]
)
