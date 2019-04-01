// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HelloWorld",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/IBM-Swift/Kitura.git", from: "2.6.2"),
        .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", from: "1.8.0"),
        .package(url: "https://github.com/askari01/helloPackage.git", from: "0.0.2"),
        .package(url: "https://github.com/IBM-Swift/Swift-Kuery.git", from: "3.0.0"),
        .package(url: "https://github.com/IBM-Swift/Swift-Kuery-SQLite.git", from: "2.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "HelloWorld",
            dependencies: ["Kitura","HeliumLogger", "helloPackage", "SwiftKuery", "SwiftKuerySQLite"]),
        .testTarget(
            name: "HelloWorldTests",
            dependencies: ["HelloWorld"]),
    ]
)
