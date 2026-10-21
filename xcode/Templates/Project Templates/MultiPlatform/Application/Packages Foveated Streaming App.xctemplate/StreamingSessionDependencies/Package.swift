// swift-tools-version:6.2

import PackageDescription

let package = Package(
    name: "StreamingSessionDependencies",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "StreamingSessionDependencies",
            targets: ["StreamingSessionDependency", "CloudXRKitDependency"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/streamingsession", from: "1.0.1"),
        .package(url: "https://github.com/NVIDIA/cloudxr-framework", exact: "6.1.0")
    ],
    targets: [
        .target(
            name: "StreamingSessionDependency",
            dependencies: [
                .product(name: "StreamingSession", package: "StreamingSession")
            ]
        ),
        .target(
            name: "CloudXRKitDependency",
            dependencies: [
                .product(name: "CloudXRKit", package: "cloudxr-framework")
            ]
        ),
    ]
)
