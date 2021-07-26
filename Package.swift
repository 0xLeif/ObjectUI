// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ObjectUI",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .watchOS(.v7),
        .tvOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ObjectUI",
            targets: ["ObjectUI"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/0xLet/WTV", from: "0.1.1"),
        .package(url: "https://github.com/0xLet/SURL", from: "0.1.0"),
        .package(url: "https://github.com/0xLet/SwiftFu", from: "1.0.1"),
        .package(url: "https://github.com/0xLeif/Chronicle", from: "0.2.3"),
        .package(url: "https://github.com/0xLeif/Task", from: "1.0.0"),
        .package(url: "https://github.com/0xLeif/Yarn", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ObjectUI",
            dependencies: [
                "WTV",
                "SURL",
                "SwiftFu",
                "Chronicle",
                "Task",
                "Yarn"
            ]),
        .testTarget(
            name: "ObjectUITests",
            dependencies: ["ObjectUI"]),
    ]
)
