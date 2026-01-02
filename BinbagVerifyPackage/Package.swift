// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BinbagVerifyPackage",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Static library for regular development (use build script for XCFramework)
        .library(
            name: "BinbagVerifyPackage",
            targets: ["BinbagVerifyPackage"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.9.0")
    ],
    targets: [
        .target(
            name: "BinbagVerifyPackage",
            dependencies: [
                "Alamofire"
            ],
            path: "Sources/BinbagVerifyPackage",
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
