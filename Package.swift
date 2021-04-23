// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "JLCoordinator",
    platforms: [.iOS(.v12)],
    products: [
        .library(name: "JLCoordinator", targets: ["JLCoordinator"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "JLCoordinator",
            dependencies: [],
            path: "JLCoordinator/Sources"
        )
    ]
)
