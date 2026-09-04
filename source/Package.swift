// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Platformer3D",

    platforms: [
        .macOS(.v14)
    ],

    products: [
        .library(
            name: "Platformer3D",
            type: .dynamic,
            targets: ["Platformer3D"]
        )
    ],

    dependencies: [
        .package(
            url: "https://github.com/apple/swift-numerics",
            from: "1.0.0"
        ),

        .package(
            path: "/Users/noor/SwiftGodotSDK/0.75.0"
        )
    ],

    targets: [
        .target(
            name: "Platformer3D",

            dependencies: [
                .product(
                    name: "Numerics",
                    package: "swift-numerics"
                ),

                .product(
                    name: "SwiftGodotSDK",
                    package: "0.75.0"
                )
            ],

            swiftSettings: [
                .unsafeFlags([
                    "-suppress-warnings"
                ])
            ]
        ),

        .testTarget(
            name: "Platformer3DTests",
            dependencies: [
                "Platformer3D"
            ]
        )
    ]
)