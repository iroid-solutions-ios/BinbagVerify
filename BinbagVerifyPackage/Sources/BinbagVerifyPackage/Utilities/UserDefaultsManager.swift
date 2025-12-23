//
//  UserDefaultsManager.swift
//  Wenue
//
//  Created by iroid on 02/02/22.
//

import Foundation

enum UserDefaultsKeys : String {
    case DEVICETOKEN
    case DEVICETOKENDATA
    case FirebasePushToken
    case isUserLoggedIn
    case isGuestUser
    case userDataDix
    case userData
    case isUpdateUserProfile
    case isUpdateSearchHistory
    case isUpdateRanking
    case respondedPostsIds
    case isPlanPurchased
    case iAPTransactionIdentifier
    case iAPTransactionDate
}

extension UserDefaults {

    //MARK: - Save DEVICETOKEN
    func setDeviceToken(value: String) {
        set(value, forKey: UserDefaultsKeys.DEVICETOKEN.rawValue)
    }
    
    func getDeviceToken() -> String {
        return string(forKey: UserDefaultsKeys.DEVICETOKEN.rawValue)! //?? ""
    }
    
    //MARK: - Save DEVICETOKENDATA
    func setDeviceTokenData(value: Any) {
        set(value, forKey: UserDefaultsKeys.DEVICETOKENDATA.rawValue)
        synchronize()
    }
    
    func getDeviceTokenData() -> String {
        return string(forKey: UserDefaultsKeys.DEVICETOKENDATA.rawValue)! //?? ""
    }
    
    //MARK: - Save FirebasePushToken
    func setFCMToken(value: String) {
        set(value, forKey: UserDefaultsKeys.FirebasePushToken.rawValue)
        synchronize()
    }
    
    func getFCMToken() -> String {
        return string(forKey: UserDefaultsKeys.FirebasePushToken.rawValue)! //?? ""
    }
    
    //MARK: - Check Login
    func setUserLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isUserLoggedIn.rawValue)
        synchronize()
    }

    func isUserLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isUserLoggedIn.rawValue)
    }
    
    //MARK: - Guest User
    func setGuestUserLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isGuestUser.rawValue)
        synchronize()
    }

    func isGuestUser() -> Bool {
        return bool(forKey: UserDefaultsKeys.isGuestUser.rawValue)
    }
    
    //MARK: - Update user profile
    func setUpdateUserProfile(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isUpdateUserProfile.rawValue)
        synchronize()
    }

    func isUpdateUserProfile() -> Bool {
        return bool(forKey: UserDefaultsKeys.isUpdateUserProfile.rawValue)
    }

    //MARK: - Check/Set PlanPurchaseStatus
    func setPlanPurchaseStatus(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isPlanPurchased.rawValue)
        synchronize()
    }

    func isPlanPurchased()-> Bool {
        return bool(forKey: UserDefaultsKeys.isPlanPurchased.rawValue)
    }
    
    //MARK: - iAPTransactionIdentifier
    func setiAPTransactionIdentifier(value: String) {
        set(value, forKey: UserDefaultsKeys.iAPTransactionIdentifier.rawValue)
        synchronize()
    }
    
    func getiAPTransactionIdentifier() -> String {
        return string(forKey: UserDefaultsKeys.iAPTransactionIdentifier.rawValue)!
    }
    
    //MARK: - iAPTransactionDate
    func setiAPTransactionDate(value: Date) {
        set(value, forKey: UserDefaultsKeys.iAPTransactionDate.rawValue)
        synchronize()
    }
    
    func getiAPTransactionDate() -> Date {
        return UserDefaults.standard.object(forKey: UserDefaultsKeys.iAPTransactionDate.rawValue) as! Date
    }
    
    //MARK: - Update Search History
    func setUpdateSearchHistory(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isUpdateSearchHistory.rawValue)
        synchronize()
    }

    func isUpdateSearchHistory() -> Bool {
        return bool(forKey: UserDefaultsKeys.isUpdateSearchHistory.rawValue)
    }
    
   
    
    /*
    //MARK: - User Data Dix
    func setUserData(value: NSDictionary) {
        set(value, forKey: UserDefaultsKeys.userDataDix.rawValue)
        synchronize()
    }
    
    func getUserData() -> Any? {
        return value(forKey: UserDefaultsKeys.userDataDix.rawValue)
    }
    */
    
    /*
    //MARK: - User Data Model
    func setUserData(userData : [LoginData]) {
        UserDefaults.standard.setStructArray(userData, forKey: UserDefaultsKeys.userData.rawValue)
        synchronize()
    }
    
    func getUserData() -> [LoginData] {
        if UserDefaults.standard.value(forKey: UserDefaultsKeys.userData.rawValue) != nil {
            let arrOfDetail = UserDefaults.standard.structArrayData(LoginData.self, forKey: UserDefaultsKeys.userData.rawValue)
            return arrOfDetail
        } else {
            return [LoginData]()
        }
    }
    */
 
    
    func clearUserDefaultsValues() {
        
        userDefaults.removeObject(forKey: UserDefaultsKeys.isUserLoggedIn.rawValue)
        userDefaults.removeObject(forKey: UserDefaultsKeys.userDataDix.rawValue)
        userDefaults.removeObject(forKey: UserDefaultsKeys.userData.rawValue)
        userDefaults.removeObject(forKey: UserDefaultsKeys.isGuestUser.rawValue)
        userDefaults.removeObject(forKey: UserDefaultsKeys.isUpdateUserProfile.rawValue)
        userDefaults.removeObject(forKey: UserDefaultsKeys.isUpdateSearchHistory.rawValue)
        userDefaults.removeObject(forKey: UserDefaultsKeys.isUpdateRanking.rawValue)
        userDefaults.removeObject(forKey: UserDefaultsKeys.respondedPostsIds.rawValue)
        
        synchronize()
    }
    
}


//MARK: - Examples
/*
 Save in UserDefaults where you want
 UserDefaults.standard.setLoggedIn(value: true)          // String
 UserDefaults.standard.setUserID(value: result.User.id!) // String
 
 Retrieve data anywhere in app
 print("ID : \(UserDefaults.standard.getUserID())")
 UserDefaults.standard.getUserID()
 
 Remove Values
 UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userID)
 */

/*
 Additional option by using get set
var intArray: [Int] {
    get {
        return UserDefaults.standard.array(forKey: "intArray") as? [Int] ?? []
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "intArray")
    }
}
*/
