// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "UserProfileFeature",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "UserProfileFeature",
            targets: ["UserProfileFeature"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/iosdevbyul/WakTrainerCoreModels", branch: "main")
    ],
    targets: [
        .target(
            name: "UserProfileFeature",
            dependencies: [
                .product(name: "WakTrainerCoreModels", package: "WakTrainerCoreModels")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "UserProfileFeatureTests",
            dependencies: ["UserProfileFeature"]
        ),
    ]
)
