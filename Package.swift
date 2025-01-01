// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "GIFPlayer",
    platforms: [
        .macOS(.v13)
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
                .process("Info.plist"),
                .process("GIFPlayer.entitlements")
            ]
        )
    ]
) 