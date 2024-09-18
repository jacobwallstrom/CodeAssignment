// swift-tools-version: 6.0
import PackageDescription

let package = Package(
	name: "AppLibrary",
	platforms: [.iOS(.v18)],
	products: [
		.library(
			name: "AppLibrary",
			targets: ["UI", "Models", "Gateways"]),
	],
	dependencies: [],
	targets: [
		.target(
			name: "UI",
			dependencies: ["Gateways", "Models"]
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
		)
	],
	swiftLanguageModes: [.v6]
)
