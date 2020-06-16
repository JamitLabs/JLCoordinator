// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "CoordinatorBase",
    platforms: [.iOS(.v9)],
    products: [
        .library(name: "CoordinatorBase", targets: ["CoordinatorBase"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CoordinatorBase",
            dependencies: [],
            path: "CoordinatorBase/Sources"
        )
    ]
)
