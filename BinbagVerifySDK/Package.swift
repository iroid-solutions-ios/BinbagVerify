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
        //     url: "https://github.com/YOUR_ORG/BinbagVerifySDK/releases/download/v1.0.0/BinbagVerifyPackage.xcframework.zip",
        //     checksum: "YOUR_CHECKSUM_HERE"  // Run: swift package compute-checksum BinbagVerifyPackage.xcframework.zip
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
