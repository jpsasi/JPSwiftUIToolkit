// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JPSwiftUIToolkit",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "JPSwiftUIToolkit",
            targets: ["JPSwiftUIToolkit"]),
    ],
    dependencies: [
      .package(url: "https://github.com/jpsasi/JPSwiftToolkit", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
          name: "JPSwiftUIToolkit", 
          dependencies: [
            .product(name: "JPSwiftToolkit", package: "JPSwiftToolkit"),
          ]),
        .testTarget(
            name: "JPSwiftUIToolkitTests",
            dependencies: ["JPSwiftUIToolkit"]
        ),
    ]
)
