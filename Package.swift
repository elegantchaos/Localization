// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Localization",
    products: [
        .library(
            name: "Localization",
            type: .static,
            targets: ["Localization"]),
        .library(
            name: "LocalizationShared",
            type: .dynamic,
            targets: ["Localization"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Localization",
            dependencies: []),
        .testTarget(
            name: "LocalizationTests",
            dependencies: ["Localization"]),
    ]
)
