// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "mousecop",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "mousecop",
            path: "Sources/mousecop"
        )
    ]
)
