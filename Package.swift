// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "GIFPlayer",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "GIFPlayer", targets: ["GIFPlayer"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "GIFPlayer",
            dependencies: [],
            path: "GIFPlayer",
            resources: [
                .process("GIFPlayer.entitlements")
            ]
        )
    ]
) 