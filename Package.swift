// swift-tools-version:5.0

import PackageDescription

let package = Package(
	name: "CoreCombine",
	platforms: [
		.iOS("13.0"),
		.macOS("10.15"),
	],
	products: [
		.library(
			name: "CoreCombine",
			targets: ["CoreCombine"]),
	],
	targets: [
		.target(
			name: "CoreCombine",
			dependencies: []),
		.testTarget(
			name: "CoreCombineTests",
			dependencies: ["CoreCombine"]),
	]
)
