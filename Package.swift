// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KPCTabsControl",
    platforms: [
        .macOS(.v10_14)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "KPCTabsControl",
            targets: ["KPCTabsControl"]
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "KPCTabsControl",
            path: "KPCTabsControl",
            resources: [
                .copy("Resources")
            ],
            swiftSettings: [.define("SwiftPackage")]
        )
    ]
)
