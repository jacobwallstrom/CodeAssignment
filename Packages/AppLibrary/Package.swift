// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AppLibrary",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "AppLibrary",
            targets: ["UI", "Models", "Gateways"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-navigation.git", from: "2.2.0"),
    ],
    targets: [
        .target(
            name: "UI",
            dependencies: [
                "Gateways",
                "Models",
                .product(name: "SwiftUINavigation", package: "swift-navigation"),
            ]
        ),
        .target(
            name: "Gateways",
            dependencies: ["Models"]
        ),
        .target(
            name: "Models",
            dependencies: []
        ),
        .testTarget(
            name: "AppLibraryTests",
            dependencies: ["UI", "Models", "Gateways"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
