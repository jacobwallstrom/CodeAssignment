// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AppLibrary",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "AppLibrary",
            targets: ["Adapters", "UseCases", "Models", "Infrastructure"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-navigation.git", from: "2.2.0"),
        .package(url: "https://github.com/pointfreeco/swift-case-paths.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Infrastructure",
            dependencies: [
                "Models",
                "UseCases",
                "Adapters",
                .product(name: "SwiftUINavigation", package: "swift-navigation"),
            ]
        ),
        .target(
            name: "Adapters",
            dependencies: [
                "Models",
                "UseCases",
                .product(name: "CasePaths", package: "swift-case-paths"),
            ]
        ),
        .target(
            name: "UseCases",
            dependencies: ["Models"]
        ),
        .target(
            name: "Models",
            dependencies: []
        ),
        .testTarget(
            name: "AppLibraryTests",
            dependencies: ["Adapters", "Models", "UseCases"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
