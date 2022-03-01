// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Indy",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Indy",
            targets: ["Indy"]
        )
    ],
    targets: [
        .target(
            name: "Indy",
            dependencies: ["IndyObjc"]
        ),
        .testTarget(
            name: "IndyTests",
            dependencies: ["Indy"],
            resources: [.copy("Resource")]
        ),
        .binaryTarget(
            name: "IndyObjc",
            path: "Frameworks/IndyObjc.xcframework"
        )
    ]
)
