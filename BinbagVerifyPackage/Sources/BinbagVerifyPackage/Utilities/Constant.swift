//
//  Constant.swift
//  Wenue
//
//  Created by iroid on 02/02/22.
//

import UIKit

//Swagger documentation: https://demo.iroidsolutions.com/wenue/public/api/documentation/
//Base URL: https://demo.iroidsolutions.com/wenue/public/api/v1

//MARK: - API URL
//let server_url = "https://demo.iroidsolutions.com/wenue/public/api/v1" // old
//let server_url = "https://web.wenue.at/api/v1/login" // new


//MARK: - Storyboard identifiers
struct STORYBOARD {
    //MARK: - Authentication
    static let main                            = UIStoryboard(name : "Main", bundle : Bundle.main)
    static let onBoarding                      = UIStoryboard(name : "OnBoarding", bundle : Bundle.main)
    static let auth                            = UIStoryboard(name : "Authentication", bundle : Bundle.main)
    static let popUp                           = UIStoryboard(name : "PopUp", bundle : Bundle.main)
    static let verifyAccount                   = UIStoryboard(name : "VerifyDocument", bundle : Bundle.main)


}




//MARK: - Global Variables
let isAppInTestMode                      = true // true or false
let APPLICATION_NAME                     = "BinbagVerify"
let DEVICE_UNIQUE_IDETIFICATION : String = UIDevice.current.identifierForVendor!.uuidString
// Note: AppDelegate reference removed - package should not depend on main app types
// Access AppDelegate from the host app if needed
let userDefaults                         = UserDefaults.standard


let isiPad: Bool = UIDevice.current.userInterfaceIdiom == .pad


let VIDEO_LENTH          = 60
let VenueDescriptionTextLimit = 1000
let Per_Page = 20
let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height
let TIMER_COUNT = 60
var signUpRequest : SignUpRequest?

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

var leftSafeArea: CGFloat {
    
    if let window = UIApplication.shared.windows.first {
        return window.safeAreaInsets.left
    }
    return 0
}

var rightSafeArea: CGFloat {
    
    if let window = UIApplication.shared.windows.first {
        return window.safeAreaInsets.right
    }
    return 0
}

func getFileName() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMddHHmmss"
    return dateFormatter.string(from: Date())
}

var TERMS_OF_SERVICE = "https://www.privacypolicies.com/live/c15052ef-4b3b-4c29-b80a-2d09d4f628f1"

let YYYY_MM_DDHHMMSS  =   "yyyy-MM-dd HH:mm:ss"
let MMM_DD_YYY  =  "MMM dd, yyyy"

//MARK: - Language related
let SELECTED_LANG = "LANGUAGE"
var LANGUAGE = ""

let ENGLISH_LANG_CODE = "en"
let SPANISH_LANG_CODE = "es"

//MARK: - Date Formates
let MMMM_YYYY    = "MMMM YYYY"
let MMddYYYY     = "MM/dd/YYYY"
let ddMMYY_HHMMA = "dd/MM/YY h :mm a"
let DD_MM_YY_H_M = "dd/MM/yy h :mma"
let dd_MM_YYYY   = "dd/MM/yyyy"
let HH_MM_A      = "hh:mm a"

let YYYYMMDD_HHMMSS = "YYYY-MM-dd hh:mm:ss"
//let YYYYMMDD_HHMM_A = "yyyy/MM/dd hh:mm a"
let YYYYMMDD_HHMM_A = "MM-dd-yyyy hh:mm a"
let MM_DD_YYYY = "MM-dd-yyyy"
let YYYY_MM_DD = "yyyy/MM/dd"
let DD_MM_YYYY_HHMM_A = "dd/MM/yyyy hh:mm a"
let DD_MM_YYYY = "dd-MM-yyyy"
let H_MM_SS = "H:mm:ss"
let D_MMM_HHMM_A = "d MMM yyyy hh:mm a"
let D_MMM = "d MMM"
let YYYYMMDD = "yyyy-MM-dd"
let TIMESTAMPFORMATE = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
let EE = "EE"
let D = "d"
let H_MM_A = "h:mm a"
let HH_MM = "HH:mm"
let EEE_DD_MMM = "EEE-dd MMM"
let START_TIME = 0
let END_TIME = 23

//MARK: - Session Key
let USER_ID         = "userid"
let USER_DATA       = "user_data"
let IS_LOGIN        = "is_login"
let USER_EMAIL      = "email"
let USERNAME        = "username"
let UPLOADED_IMAGES = "uploaded_image"
let UPLOADED_VIDEOS = "uploaded_video"

//MARK: - In App Purchase
var monthlyPlanPrice : String?
var monthlyPlanCurrencySymbol : String?
var yearlyPlanPrice  : String?
var yearlyPlanCurrencySymbol : String?

let PURCHASE_DATA = "PURCHASE_DATA"
var homeVC: UIViewController?

struct DeviceInfo {
    struct Orientation {
        // indicate current device is in the LandScape orientation
        static var isLandscape: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                    ? UIDevice.current.orientation.isLandscape
                    : UIApplication.shared.statusBarOrientation.isLandscape
            }
        }
        // indicate current device is in the Portrait orientation
        static var isPortrait: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                    ? UIDevice.current.orientation.isPortrait
                    : UIApplication.shared.statusBarOrientation.isPortrait
            }
        }
    }
    
}

