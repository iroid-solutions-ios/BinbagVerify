//
//  Constant.swift
//  BinbagVerifyPackage
//

import UIKit

//MARK: - Global Variables
let APPLICATION_NAME = "BinbagVerify"
let DEVICE_UNIQUE_IDETIFICATION: String = UIDevice.current.identifierForVendor?.uuidString ?? ""

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

var bottomSafeArea: CGFloat {
    if let window = UIApplication.shared.windows.first {
        return window.safeAreaInsets.bottom
    }
    return 0
}

var topSafeArea: CGFloat {
    if let window = UIApplication.shared.windows.first {
        return window.safeAreaInsets.top
    }
    return 0
}

func getFileName() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMddHHmmss"
    return dateFormatter.string(from: Date())
}

//MARK: - Video Settings
let VIDEO_LENTH = 60 // Maximum video recording duration in seconds

//MARK: - Date Formats
let YYYY_MM_DD = "yyyy-MM-dd"
let DD_MM_YYYY = "dd-MM-yyyy"
let MM_DD_YYYY = "MM-dd-yyyy"
let HH_MM = "HH:mm"

//MARK: - UserDefaults Keys
let USER_DATA = "user_data"
let UPLOADED_IMAGES = "uploaded_images"
let UPLOADED_VIDEOS = "uploaded_videos"
let PURCHASE_DATA = "purchase_data"
