// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkMonitor",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v11),
    ],
    products: [
        .library(
            name: "NetworkMonitor",
            targets: ["NetworkMonitor"]
        ),
    ],
    targets: [
        .target(
            name: "NetworkMonitor",
            dependencies: []
        ),
        .testTarget(
            name: "NetworkMonitorTests",
            dependencies: ["NetworkMonitor"]
        ),
    ]
)
