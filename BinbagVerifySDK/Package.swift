// swift-tools-version: 5.9
// BinbagVerify SDK - Identity Verification for iOS
// Source code is compiled into binary - users cannot see implementation

import PackageDescription

let package = Package(
    name: "BinbagVerifySDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "BinbagVerifyPackage",
            targets: ["BinbagVerifyPackage", "AlamofireWrapper"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.9.0")
    ],
    targets: [
        // ============================================================
        // OPTION 1: Local Binary (for local development/direct folder sharing)
        // ============================================================
        .binaryTarget(
            name: "BinbagVerifyPackage",
            path: "BinbagVerifyPackage.xcframework"
        ),

        // ============================================================
        // OPTION 2: Remote URL (for SPM distribution via GitHub/Server)
        // Uncomment below and comment OPTION 1 when hosting remotely
        // ============================================================
        // .binaryTarget(
        //     name: "BinbagVerifyPackage",
        //     url: "https://github.com/iroid-solutions-ios/Binbag-ios/releases/download/1.0.1/BinbagVerifyPackage.xcframework.zip",
        //     checksum: "5e7e22d4151f07e1147d0d6082682e145915bcf9339e634442740006eacc3fee"
        // ),

        // Wrapper to include Alamofire dependency
        .target(
            name: "AlamofireWrapper",
            dependencies: [
                "Alamofire",
                "BinbagVerifyPackage"
            ],
            path: "Sources/AlamofireWrapper"
        ),
    ]
)
