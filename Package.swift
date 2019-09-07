// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Replacer",
    products: [
        .library(
            name: "Replacer",
            targets: ["Replacer"]),
        .library(
            name: "TestReplacer",
            targets: ["TestReplacer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "4.9.0"),
    ],
    targets: [
        .target(
            name: "Replacer",
            dependencies: []),
        .testTarget(
            name: "ReplacerTests",
            dependencies: ["Replacer", "Alamofire"],
            path: "Tests/ReplacerTests"),
        .target(
            name: "TestReplacer",
            dependencies: ["Replacer"]),
        // .testTarget(
        //     name: "TestReplacerTests",
        //     dependencies: ["TestReplacer"],
        //     path: "Tests/TestReplacerTests"),
    ]
)
