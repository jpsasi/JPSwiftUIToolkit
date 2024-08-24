// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JPSwiftUIToolkit",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "JPSwiftUIToolkit",
            targets: ["JPSwiftUIToolkit"]),
    ],
    dependencies: [
      .package(url: "https://github.com/jpsasi/JPSwiftToolkit", branch: "main")
    ],
    targets: [
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
