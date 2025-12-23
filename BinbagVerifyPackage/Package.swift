// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BinbagVerifyPackage",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "BinbagVerifyPackage",
            targets: ["BinbagVerifyPackage"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.9.0"),
        .package(url: "https://github.com/kizitonwose/CountryPickerView.git", from: "3.3.0"),
        .package(url: "https://github.com/hackiftekhar/IQKeyboardManager.git", from: "7.0.0"),
        .package(url: "https://github.com/Daltron/NotificationBanner.git", from: "3.2.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.18.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.0"),
    ],
    targets: [
        .target(
            name: "BinbagVerifyPackage",
            dependencies: [
                "Alamofire",
                "CountryPickerView",
                .product(name: "IQKeyboardManagerSwift", package: "IQKeyboardManager"),
                .product(name: "NotificationBannerSwift", package: "NotificationBanner"),
                "SDWebImage",
                "SnapKit",
            ],
            path: "Sources/BinbagVerifyPackage",
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
