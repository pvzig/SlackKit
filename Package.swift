// swift-tools-version:4.2

import PackageDescription

// MARK: Targets

let SlackKit: Target = .target(name: "SlackKit",
                               dependencies: ["SKCore", "SKClient", "SKRTMAPI", "SKServer"],
                               path: "SlackKit/Sources")

let SKClient: Target = .target(name: "SKClient",
                               dependencies: ["SKCore"],
                               path: "SKClient/Sources")

let SKCore: Target   = .target(name: "SKCore",
                               path: "SKCore/Sources")

let SKRTMAPI: Target = .target(name: "SKRTMAPI",
                               path: "SKRTMAPI/Sources")

#if os(macOS) || os(iOS) || os(tvOS)
SKRTMAPI.dependencies = [
    "SKCore",
    "SKWebAPI",
    "Starscream"
]
#else
SKRTMAPI.dependencies = [
    "SKCore",
    "SKWebAPI",
    "WebSockets",
    "HTTP",
    "URI"
]
#endif

let SKServer: Target = .target(name: "SKServer",
                               dependencies: ["SKCore", "SKWebAPI", "Swifter"],
                               path: "SKServer/Sources")

let SKWebAPI: Target = .target(name: "SKWebAPI",
                               dependencies: ["SKCore"],
                               path: "SKWebAPI/Sources")

// MARK: Package

let package = Package(
    name: "SlackKit",
    products: [
        .library(name: "SlackKit", targets: ["SlackKit"]),
        .library(name: "SKClient", targets: ["SKClient"]),
        .library(name: "SKCore", targets: ["SKCore"]),
        .library(name: "SKRMTAPI", targets: ["SKRTMAPI"]),
        .library(name: "SKServer", targets: ["SKServer"]),
        .library(name: "SKWebAPI", targets: ["SKWebAPI"])
    ],
    targets: [
        SlackKit, SKClient, SKCore, SKRTMAPI, SKServer, SKWebAPI
    ]
)

#if os(macOS) || os(iOS) || os(tvOS)
package.dependencies = [
    .package(url: "https://github.com/httpswift/swifter.git", .upToNextMinor(from: "1.4.5")),
    .package(url: "https://github.com/daltoniam/Starscream", .upToNextMinor(from: "3.0.6"))
]
#else
package.dependencies = [
    .package(url: "https://github.com/httpswift/swifter.git", .upToNextMinor(from: "1.4.5")),
    .package(url: "https://github.com/vapor/http", .upToNextMinor(from: "2.2.5"))
]
#endif
