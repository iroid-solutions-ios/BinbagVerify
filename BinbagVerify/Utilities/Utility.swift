//
//  Utility.swift
//  Wenue
//
//  Created by iroid on 02/02/22.
//

import UIKit
//import GoogleMobileAds
//import FTPopOverMenu_Swift
//import Alamofire
import AVFoundation
import SDWebImage
import Photos
import NotificationBannerSwift

class Utility: NSObject {
    
    static var instance = Utility()
    
    class func getAppName() -> String
    {
        let infoDictionary  : NSDictionary  = (Bundle.main.infoDictionary as NSDictionary?)!
        let appName         : NSString      = infoDictionary.object(forKey: "CFBundleName") as! NSString
        return appName as String
    }
    
    class func getAppVersion() -> String
    {
        let infoDictionary  : NSDictionary = (Bundle.main.infoDictionary as NSDictionary?)!
        let appName         : NSString     = infoDictionary.object(forKey: "CFBundleShortVersionString") as! NSString
        return appName as String
    }
    
    class func isDateEqualToToday(inputDate: Date) -> Bool {
        let calendar = Calendar.current
        let today = Date()
        
        return calendar.isDate(today, inSameDayAs: inputDate)
    }
    
    class func isCurrentDate(timestamp: TimeInterval) -> Bool {
        let date = Date(timeIntervalSince1970: timestamp / 1000) // Assuming the timestamp is in milliseconds
        
        let currentDate = Date()
        
        let calendar = Calendar.current
        let timestampDateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let currentDateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
        
        return timestampDateComponents == currentDateComponents
    }
    
    class func convertTimestampToDate(timestamp: TimeInterval, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let date = Date(timeIntervalSince1970: timestamp/1000)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: date)
    }
    
    /*
     func setUpWeChatStylePopoverMenu()
     {
     let config = FTConfiguration.shared
     config.backgoundTintColor = UIColor.white
     config.borderColor        = UIColor.lightGray
     config.menuWidth          = 180
     config.menuSeparatorColor = UIColor.clear
     config.menuRowHeight      = 44
     config.cornerRadius       = 8
     config.localShadow        = false
     config.globalShadow       = true
     config.shadowAlpha        = 0.6
     }
     */
    
    
    
    class func assignbackground(_ sender: UIView)
    {
        let background = UIImage(named: "splash_bg")
        
        
        //let blurEffect = UIBlurEffect(style: .dark)
        //let blurView = UIVisualEffectView(effect: blurEffect)
        
        var imageView: UIImageView!
        imageView               = UIImageView(frame: sender.bounds)
        imageView.contentMode   =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image         = background
        imageView.center        = sender.center
        
        //sender.addSubview(blurView)
        //sender.bringSubview(toFront: blurView)
        sender.addSubview(imageView)
        sender.sendSubviewToBack(imageView)
        
    }
    
    
    
    
    // MARK : - Google Video Ads Function
    /*class func createAndLoadRewardedAd() -> GADRewardedAd {
     let rewardedAd = GADRewardedAd(adUnitID: Constant.rewardedAdUnitID)
     rewardedAd.load(GADRequest()) { error in
     if let error = error {
     print("Loading failed: \(error)")
     } else {
     print("Loading Succeeded")
     }
     }
     return rewardedAd
     }*/
    
    class func currentWeekDates() -> [Date] {
        let currentDate = Date()
        let calendar = Calendar.current
        let weekDay = calendar.component(.weekday, from: currentDate)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: currentDate)!
        return (weekdays.lowerBound ..< weekdays.upperBound)
            .compactMap { calendar.date(byAdding: .day, value: $0 - weekDay + 1, to: currentDate) }
    }

    
    class func changeDateFormate(date:String,dateForamte:String,getFormate:String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateForamte //"yyyy/MM/dd"
        let date = (dateFormatter.date(from: date) ?? nil) ?? Date()
        dateFormatter.dateFormat = getFormate //"MM/dd"
        let resultString = dateFormatter.string(from: date)
        print(resultString)
        return resultString
    }
    
    class func getCurrentTime() -> String
    {
        let date        = Date()
        let calender    = Calendar.current
        let components  = calender.dateComponents([.hour,.minute,.second], from: date)
        var hour        = String()
        var minutes     = String()
        
        if components.hour! < 10
        {
            hour = String("0\(components.hour!)")
        }
        else
        {
            hour = String("\(components.hour!)")
        }
        
        if components.minute! < 10
        {
            minutes = String("0\(components.minute!)")
        }
        else
        {
            minutes = String("\(components.minute!)")
        }
        
        let currentTime = "\(hour):\(minutes)"
        return currentTime
    }
    
    class func getcurrentDate() -> String
    {
        let date        = Date()
        let calender    = Calendar.current
        let components  = calender.dateComponents([.day,.month,.year], from: date)
        var day         = String()
        var month       = String()
        
        if components.day! < 10
        {
            day = String("0\(components.day!)")
        }
        else
        {
            day = String("\(components.day!)")
        }
        
        if components.month! < 10
        {
            month = String("0\(components.month!)")
        }
        else
        {
            month = String("\(components.month!)")
        }
        
        let todayDate = "\(components.year!)/\(month)/\(day)"
        return todayDate
    }
    
    class func getTodaysDay(dateFormate:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY,MM,DD"
        let dayName: String = dateFormatter.string(from: Date())
        
        return dayName
    }
    
    class func getDateTimeFromTimeInterVel(from dateIntervel: Int) -> Date{
        let date = Date(timeIntervalSince1970: TimeInterval(dateIntervel))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return date
    }
    
    class func convertIntoDate(dateInRowForamt:Int, dateFormat:String) -> String {
        guard dateInRowForamt != 0 else { return "No Date" }
        
        let myDate = getDateTimeFromTimeInterVel(from: dateInRowForamt)
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.timeZone = TimeZone(identifier: "UTC")
        
        return formatter.string(from:myDate)
    }
    
    class func getCurrentDateTimeInIST() -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone   = NSTimeZone(abbreviation: "IST")! as TimeZone
        
        let date = NSDate()
        let cstTimeZoneStr = formatter.string(from: date as Date)
        
        return cstTimeZoneStr
    }
    
    
    class func getDateInLOCALFormat(_ strDate: String) -> String
    {
        var gmt = NSTimeZone(abbreviation: "IST")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = gmt! as TimeZone
        
        let date: Date? = dateFormatter.date(from: strDate)
        gmt = NSTimeZone.system as NSTimeZone
        dateFormatter.timeZone   = gmt! as TimeZone
        dateFormatter.dateFormat = "d MMM, yyyy"
        var timeStamp: String = dateFormatter.string(from: date!)
        
        if (timeStamp.count) <= 0 {
            timeStamp = ""
        }
        
        return timeStamp
    }
    
    class func setDateAndTime(selectDateTime: String) -> String? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "\(MM_DD_YYYY) \(HH_MM)"
        
        guard let date = dateFormatter.date(from: selectDateTime) else {
            return nil
        }
        
        let timestamp: TimeInterval = date.timeIntervalSince1970 * 1000
        
        return String(Int(timestamp))
    }
    
   
    
    class func getTimeInLOCALFormat(_ strDate: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var gmt = NSTimeZone(abbreviation: "IST")
        dateFormatter.timeZone = gmt! as TimeZone
        
        let date: Date? = dateFormatter.date(from: strDate)
        gmt = NSTimeZone.system as NSTimeZone
        dateFormatter.timeZone   = gmt! as TimeZone
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.amSymbol   = "am"
        dateFormatter.pmSymbol   = "pm"
        var timeStamp: String    = dateFormatter.string(from: date!)
        
        if (timeStamp.count) <= 0 {
            timeStamp = ""
        }
        
        return timeStamp
    }
    
    class func getTimeIn24HrFormat(_ strDate: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        
        var gmt = NSTimeZone(abbreviation: "IST")
        dateFormatter.timeZone = gmt! as TimeZone
        
        let date: Date? = dateFormatter.date(from: strDate)
        gmt = NSTimeZone.system as NSTimeZone
        dateFormatter.timeZone   = gmt! as TimeZone
        dateFormatter.dateFormat = "HH:mm:ss"
        var timeStamp: String    = dateFormatter.string(from: date!)
        
        if (timeStamp.count) <= 0 {
            timeStamp = ""
        }
        
        return timeStamp
    }
    
    class func LocalToUTC(date:Date, fromFormat:String, toFormat:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = TimeZone.current
        let dt = date
        //let dt = dateFormatter.date(from: date) ?? Date()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = toFormat
        
        return dateFormatter.string(from: dt)
    }
    
    func getFormatedDOB(_ strDate: String, originalFormat: String, responseFormat: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = originalFormat
        
        let date: Date? = dateFormatter.date(from: strDate)
        dateFormatter.dateFormat = responseFormat
        
        var timeStamp: String = dateFormatter.string(from: date!)
        if (timeStamp.count) <= 0 {
            timeStamp = ""
        }
        return timeStamp
    }
    
    class func removeUserData(){
        UserDefaults.standard.removeObject(forKey: USER_DATA)
    }
    
    class func saveUserData(data: [String: Any]){
        UserDefaults.standard.setValue(data, forKey: USER_DATA)
    }

    class func getUserData() -> LogInResponse?{
        if let data = UserDefaults.standard.value(forKey: USER_DATA) as? [String: Any]{
            let dic = LogInResponse(JSON: data)
            return dic
        }
        return nil
    }

    class func getAccessToken() -> String?{
        if let token = getUserData()?.auth?.accessToken {
            return token
        }
        return nil
    }
    
    class func getDateTimeStamp(date:Date) -> Date{
        let date = Utility.localToUTC(fromFormat: date.dateFormatWithSuffix(), toFormat: "yyyy-MM-dd HH:mm:ss z", dateValue: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let string = date                 // "March 24, 2017 at 7:00 AM"
        let finalDate = dateFormatter.date(from: string)
        return finalDate!
    }
    
    class func localToUTC(fromFormat: String, toFormat: String,dateValue:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.dateFormat = toFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        print(dateFormatter.string(from: date))
//        dateFormatter.calendar = NSCalendar.current
//        dateFormatter.timeZone = NSTimeZone.local
//        let dt = dateFormatter.date(from: date)
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        dateFormatter.dateFormat = toFormat
        return dateFormatter.string(from: dateValue)
    }
    
    //Compare previously uploaded image posts with uploaded image
    class func uploadedImageByUser(fileName:[String]){
        UserDefaults.standard.set(fileName, forKey: UPLOADED_IMAGES)
    }
    
    class func getUploadedImageName() -> [String]?{
        let data = UserDefaults.standard.array(forKey: UPLOADED_IMAGES) as? [String] ?? []
        return data
    }
    
    class func removeUploadedImageData(){
        UserDefaults.standard.removeObject(forKey: UPLOADED_IMAGES)
    }
    
    //Compare previously uploaded video posts with uploaded video
    class func uploadedVideoByUser(fileName:[String]){
        UserDefaults.standard.set(fileName, forKey: UPLOADED_VIDEOS)
    }
    
    class func getUploadedVideoName() -> [String]?{
        let data = UserDefaults.standard.array(forKey: UPLOADED_VIDEOS) as? [String] ?? []
        return data
    }
    
    class func removeUploadedVideoData(){
        UserDefaults.standard.removeObject(forKey: UPLOADED_VIDEOS)
    }
    
    class func cornerView(view : UIView){
        view.clipsToBounds = true
        view.layer.cornerRadius = 40
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
//    class func setLoginRoot() {
//        let vc = STORYBOARD.main.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//        let navVC = UINavigationController(rootViewController: vc)
//        navVC.interactivePopGestureRecognizer?.isEnabled = false
//        navVC.navigationBar.isHidden = true
//        appDelegate.window?.rootViewController = navVC
//        appDelegate.window?.makeKeyAndVisible()
//        UIView.transition(with: appDelegate.window!, duration: 0.1, options: [.curveEaseInOut], animations: nil, completion: nil)
//    }
    
    class func setTabRoot(){
//        let vc = STORYBOARD.tabbar.instantiateViewController(withIdentifier: "TabbarScreen") as! TabbarScreen
//        let navVC = UINavigationController(rootViewController: vc)
//        navVC.navigationBar.isHidden = true
//        appDelegate.window?.rootViewController = navVC
//        appDelegate.window?.makeKeyAndVisible()
//        UIView.transition(with: appDelegate.window!, duration: 0.1, options: [.curveEaseInOut], animations: nil, completion: nil)
    }
   
//    class func addInnerShadow(view: OTPFieldView) {
//        let innerShadowLayer = CALayer()
//        innerShadowLayer.backgroundColor = UIColor.black.cgColor
//        
//        let size = view.bounds.size
//        innerShadowLayer.bounds = CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width * 2, height: size.height)
//        
//        innerShadowLayer.position = CGPoint(x: size.width / 2, y: -size.height / 2)
//        
//        innerShadowLayer.shadowColor = UIColor.black.cgColor
//        innerShadowLayer.shadowOffset = CGSize(width: 0, height: 3)
//        innerShadowLayer.shadowOpacity = 0.16
//        innerShadowLayer.shadowRadius = 6
//        
//        view.layer.addSublayer(innerShadowLayer)
//    }
    
    class func setRootFirstViewController() {
        
//        let vc = STORYBOARD.main.instantiateViewController(withIdentifier: "FirstScreen") as! FirstScreen
//        let navVC = UINavigationController(rootViewController: vc)
//        navVC.interactivePopGestureRecognizer?.isEnabled = false
//        navVC.navigationBar.isHidden = true
//        appDelegate.window?.rootViewController = nil
//        appDelegate.window?.rootViewController = navVC
//        appDelegate.window?.makeKeyAndVisible()
//        UIView.transition(with: appDelegate.window!, duration: 0.1, options: [.curveEaseInOut], animations: nil, completion: nil)
    }

    class func setRootLoginRegisterViewController() {
//        let vc = STORYBOARD.loginregister.instantiateViewController(withIdentifier: "LoginRegisterScreen") as! LoginRegisterScreen
//        let navVC = UINavigationController(rootViewController: vc)
//        //navVC.interactivePopGestureRecognizer?.isEnabled = true
//        navVC.interactivePopGestureRecognizer?.isEnabled = false
//        navVC.navigationBar.isHidden = true
//        appDelegate.window?.rootViewController = navVC
//        appDelegate.window?.makeKeyAndVisible()
//        UIView.transition(with: appDelegate.window!, duration: 0.1, options: [.curveEaseInOut], animations: nil, completion: nil)
    }
    
    class func setRootHomeController() {
        
//        let HomeVC =  STORYBOARD.home.instantiateViewController(withIdentifier: "HomeScreen") as! HomeScreen
//        let MenuVC =  STORYBOARD.menu.instantiateViewController(withIdentifier: "MenuScreen") as! MenuScreen
        
//        let rootVC = HomeVC
//        let leftVC = MenuVC
        
//        let sideMenuController = LGSideMenuController(rootViewController: rootVC,leftViewController: leftVC,rightViewController: nil)
//        sideMenuController.leftViewWidth = (screenWidth * 0.773) // 290/375
//        sideMenuController.isLeftViewSwipeGestureEnabled = true
//        sideMenuController.isRightViewSwipeGestureEnabled = false
        
//        let navVC = UINavigationController(rootViewController: sideMenuController)
//        navVC.isNavigationBarHidden = true
        //navVC.interactivePopGestureRecognizer?.isEnabled = true
//        navVC.interactivePopGestureRecognizer?.isEnabled = false
//        navVC.interactivePopGestureRecognizer?.delegate = nil
        
//        appDelegate.window?.rootViewController = nil
//        appDelegate.window?.rootViewController = navVC
//        appDelegate.window?.makeKeyAndVisible()
        
//        UIView.transition(with: appDelegate.window!, duration: 0.1, options: [.curveEaseInOut], animations: nil, completion: nil)
        /*
        let rootNavigationController = UINavigationController(rootViewController: HomeVc)
        let sideMenuController1 = LGSideMenuController(rootViewController: rootNavigationController, leftViewController: leftViewController, rightViewController: rightViewController)
         */
    }
    
    class func blurImage(_ imageUrl: String!, imageView: UIImageView!) {
        if imageUrl != nil && !(imageUrl == "") {
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imageView.sd_setImage(with: URL(string: imageUrl!), placeholderImage: UIImage(named: "place_holder_image.png")) { image, error, sdkType, imageUrl in
                blurEffect(profileImageView: imageView, image: image ?? UIImage())
            }
        } else {
            imageView?.image = UIImage(named: "place_holder_image.png")
        }
    }

    class func blurEffect(profileImageView: UIImageView!, image: UIImage?) {
        guard let inputImage = CIImage(image: image ?? UIImage()) else { return }

        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(40, forKey: kCIInputRadiusKey)

        guard let outputImage = filter?.outputImage else { return }

        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(outputImage, from: inputImage.extent) else { return }

        let processedImage = UIImage(cgImage: cgImage)

        // Create a separate UIImageView for the blurred image
        let blurredImageView = UIImageView(frame: profileImageView.bounds)
        blurredImageView.contentMode = .scaleAspectFill
        blurredImageView.image = processedImage

        // Add the blurred image view as a subview to the original image view
        profileImageView.addSubview(blurredImageView)
    }
    
    class func purchaseData(data: [String: Any]) {
        UserDefaults.standard.setValue(data, forKey: PURCHASE_DATA)
    }
    
//    class func getPurchaseData() -> PurchaseProductRequest? {
//        if let data = UserDefaults.standard.value(forKey: PURCHASE_DATA) as? [String: Any] {
//            let dic = PurchaseProductRequest(JSON: data)
//            return dic
//        }
//        return nil
//    }
    
    class func removePurchaseData(){
        UserDefaults.standard.removeObject(forKey: PURCHASE_DATA)
    }
    
    class func setImage(_ imageUrl: String!, imageView: UIImageView!) {
        if imageUrl != nil && !(imageUrl == "") {
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            // imageView.sd_setShowActivityIndicatorView(true)
            // imageView.sd_setIndicatorStyle(.gray)
            imageView!.sd_setImage(with: URL(string: imageUrl.replacingOccurrences(of: " ", with: "%20") ), placeholderImage: UIImage(named: "image_placeholder"))
        }
        else
        {
            imageView?.image = UIImage(named: "image_placeholder")
        }
    }
    
//    class func setSvgImage(_ imageUrl: String!, imageView: UIImageView!) {
//
//        if imageUrl != nil && !(imageUrl == "") {
//            imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
//            if imageUrl.contains(".svg") {
//                imageView.sd_setImage(with: URL(string: imageUrl ?? "" ) ,
//                                      placeholderImage: UIImage(named: ""),
//                                      context: [.imageCoder: CustomSVGDecoder(fallbackDecoder: SDImageSVGCoder.shared)])
//            } else {
//                imageView!.sd_setImage(with: URL(string: imageUrl! ), placeholderImage: UIImage(named: ""))
//            }
//        }
//        else {
//            imageView?.image = UIImage(named: "image_placeholder")
//        }
//    }
    
//    class func setProfileSvgImage(_ imageUrl: String!, imageView: UIImageView!) {
//
//        if imageUrl != nil && !(imageUrl == "") {
//            imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
//            if imageUrl.contains(".svg") {
//                imageView.sd_setImage(with: URL(string: imageUrl ?? "" ) ,
//                                      placeholderImage: UIImage(named: "ic_demo_userImage"),
//                                      context: [.imageCoder: CustomSVGDecoder(fallbackDecoder: SDImageSVGCoder.shared)])
//            } else {
//                imageView!.sd_setImage(with: URL(string: imageUrl! ), placeholderImage: UIImage(named: "ic_demo_userImage"))
//            }
//        }
//        else {
//            imageView?.image = UIImage(named: "ic_demo_userImage")
//        }
//    }
    
    class func silentModeSoundOn() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch {
        }
    }
    
    // --
    
    class func Toast(message: String, controller: UIViewController) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 25;
        toastContainer.clipsToBounds  =  true
        
        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font.withSize(12.0)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        
        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)
        
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
        toastContainer.addConstraints([a1, a2, a3, a4])
        
        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 65)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -65)
        let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottom, multiplier: 1, constant: -75)
        controller.view.addConstraints([c1, c2, c3])
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
    
    class func showAlert(vc: UIViewController, message: String) {
        let alertController = UIAlertController(title: APPLICATION_NAME, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title:  "Ok", style: .default, handler: nil)
        alertController.addAction(OKAction)
        vc.present(alertController, animated: true, completion: nil)
    }
//
    class func showActionAlert(vc: UIViewController,message: String)
    {

        let alertController = UIAlertController(title: APPLICATION_NAME, message: message, preferredStyle: .alert)

        // Create the actions
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
            UIAlertAction in
           // NSLog("OK Pressed")
            vc.navigationController?.popViewController(animated: true)
        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
//            UIAlertAction in
//            NSLog("Cancel Pressed")
//        }

        // Add the actions
        alertController.addAction(okAction)
//        alertController.addAction(cancelAction)

        // Present the controller
        vc.present(alertController, animated: true, completion: nil)
    }
//
    class func showNoInternetConnectionAlertDialog(vc: UIViewController) {

        let alertController = UIAlertController(title: APPLICATION_NAME, message: "It seems you are not connected to the internet. Kindly connect and try again", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(OKAction)
        vc.present(alertController, animated: true, completion: nil)
    }

//    class func showAlert(vc: UIViewController? = nil, message: String) {
//        let banner = GrowingNotificationBanner(title: APPLICATION_NAME, subtitle: message, style: .warning)
//        banner.autoDismiss = true
//        banner.duration = 2.0
//        banner.show()
//    }
    
    class func getMissingValidation(str: String,firstString:String) -> [String] {
        var errors: [String] = [firstString]
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: str)){
            errors.append("one uppercase")
        }
        
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: str)){
            errors.append("one digit")
        }

//        if(!NSPredicate(format:"SELF MATCHES %@", ".*[!&^%$#@()/]+.*").evaluate(with: str)){
//            errors.append("one symbol")
//        }
        
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: str)){
            errors.append("one lowercase")
        }
        
        if(str.count < 8){
            errors.append("min 8 characters")
        }
//        if errors.count > 1 {
//            errors.append(lastString)
//        }
        return errors
    }
    
    //Use 6 - 12 characters include letters and numbers
    class func isPasswordValid(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,12}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
    
    class func successAlert(message: String){
        let banner = GrowingNotificationBanner(title: APPLICATION_NAME, subtitle: message, style: .success)
        banner.autoDismiss = true
        banner.duration = 2.0
        banner.show()
    }
    
    //MARK: Internet Alert
//    class func showNoInternetConnectionAlertDialog(vc: UIViewController) {
//        let banner = GrowingNotificationBanner(title: APPLICATION_NAME, subtitle: "It seems you are not connected to the internet. Kindly connect and try again.", style: .danger)
//        banner.autoDismiss = true
//        banner.duration = 2.0
//        banner.show()
//
//    }
    
    class func convertDateStringToTimeInterval(_ dateString: String) -> TimeInterval? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        if let date = dateFormatter.date(from: dateString) {
            return date.timeIntervalSince1970
        }

        return nil
    }
    
    class func showAlertSomethingWentWrong(vc: UIViewController) {
        let alertController = UIAlertController(title: APPLICATION_NAME, message: "Oops! Something went wrong. Kindly try again later", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(OKAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    class func encode(_ s: String) -> String {
        let data = s.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    
    class func decode(_ s: String) -> String? {
        let data = s.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }
    class func clearNotifications(){
        UIApplication.shared.applicationIconBadgeNumber = 0 // For Clear Badge Counts
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    /*
     //MARK:- No data in tableview show this label
     class func showNoDataLabel(width:CGFloat,height:CGFloat) -> UILabel
     {
     let msglbl           = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
     msglbl.text          = "No data available";
     msglbl.textAlignment = NSTextAlignment.center;
     msglbl.font          = UIFont(name: "Poppins-Regular", size: 16)
     msglbl.textColor     = UIColor.black
     msglbl.sizeToFit()
     return msglbl
     }
     
     class func showNoDataLabel(width:CGFloat,height:CGFloat, strAltMsg: String) -> UIView
     {
     
     let noDataView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
     
     let msglbl               = UILabel(frame: CGRect(x: 12, y: 25, width: noDataView.frame.size.width-24, height: height-50))
     msglbl.text          = strAltMsg
     msglbl.textAlignment = .center
     msglbl.font          = UIFont(name: "Poppins-Regular", size: 16.0)
     msglbl.numberOfLines = 0
     msglbl.textColor     = UIColor.lightGray //UIColor(white: 0.9, alpha: 1.0)
     
     noDataView.addSubview(msglbl)
     return noDataView
     }
     */
    // --
    
    class func getLabelHeight(label:UILabel) -> (Int,Int){
        var lineCount = 0
        let textSize = CGSize(width: label.frame.size.width, height: CGFloat(MAXFLOAT))
        let rHeight = lroundf(Float(label.sizeThatFits(textSize).height))
        let charSize = lroundf(Float(label.font.lineHeight))
        lineCount = rHeight / charSize
        return (lineCount,rHeight)
    }
    
    class func checkForEmptyString(valueString: String) -> Bool {
        if valueString.isEmpty {
            return true
        }else{
            return false
        }
    }
    
    /*
    class func showIndicator() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
                SwiftLoader.show(title: "Loading...", animated: true)
            // SwiftLoader.sh
        }
    }
    
    class func hideIndicator() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            SwiftLoader.hide()
        }
    }
    */
    
    class func showIndicator() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            //SwiftLoader.show(title: "Loading...", animated: true)
            
            var config : SwiftLoader.Config = SwiftLoader.Config()
            config.size = 200
            config.backgroundColor = .white
            config.spinnerColor = #colorLiteral(red: 0.3294117647, green: 0.7176470588, blue: 0.7725490196, alpha: 1) //.appColorBlue
            config.titleTextColor = #colorLiteral(red: 0.3294117647, green: 0.7176470588, blue: 0.7725490196, alpha: 1) //.appColorBlue
            config.spinnerLineWidth = 2.0
            config.foregroundColor = .black //.appColorTextFieldBG
            config.foregroundAlpha = 0.4
            config.centerImageBackgroundColor = .clear//.appBlueColor
            
            SwiftLoader.setConfig(config: config)
            // SwiftLoader.show(animated: true)
            //SwiftLoader.show(title: Utility.getLocalizedString(value: "PLEASE_WAIT"), imageName: "appicon_60", animated: false)
            SwiftLoader.show(title: nil, imageName: "ic_logo", animated: false)
        }
    }
    
    class func hideIndicator() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            SwiftLoader.hide()
        }
    }
    
    class func setGreetingMessage() -> String?{
        let currentHour = Calendar.current.component(.hour, from: Date())
        
        switch currentHour {
        case 6..<12:
            return Utility.getLocalizedString(value: "GOOD_MORNING")
        case 12..<17:
            return Utility.getLocalizedString(value: "GOOD_AFTERNOON")
        case 17..<21:
            return Utility.getLocalizedString(value: "GOOD_EVENING")
        default:
            return Utility.getLocalizedString(value: "GOOD_NIGHT")
        }
        
    }
    
    class func setUpGradiantView(view:UIView, colors: [UIColor])-> CAGradientLayer?{
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = [0.0, 0.5, 1.0]
        view.clipsToBounds = true
        return gradient
    }
    
    class func gradientLayer(gradientView:UIView){

//        let layer0 = CAGradientLayer()
//        layer0.colors = [
//            UIColor(red: 1, green: 0.247, blue: 0.212, alpha: 1).cgColor,
//            UIColor(red: 0.557, green: 0, blue: 0, alpha: 1).cgColor
//                        ]
//
//        layer0.locations = [0, 1]
//        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
//        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
//        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1.29, b: 1.16, c: -1.16, d: 0.27, tx: 0.42, ty: -0.22))
//        layer0.bounds = gradientView.bounds.insetBy(dx: -0.5*gradientView.bounds.size.width, dy: -0.5*gradientView.bounds.size.height)
//        layer0.position = gradientView.center
//        //layer0.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
//        //gradientView.layer.addSublayer(layer0)
//        gradientView.layer.insertSublayer(layer0, at: 0)
        
        let layer0 = CAGradientLayer()
        layer0.colors = [
            UIColor(red: 0.557, green: 0, blue: 0, alpha: 1).cgColor,
          UIColor(red: 1, green: 0.257, blue: 0.212, alpha: 1).cgColor
          
        ]
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0, y: 1)
        layer0.endPoint = CGPoint(x: 1, y: 0)
        layer0.frame = gradientView.bounds
       // layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: -0.99, b: 0.91, c: -1.77, d: -2.61, tx: 1.87, ty: 1.35))
        //layer0.bounds = gradintView1.bounds.insetBy(dx: -0.5*gradintView1.bounds.size.width, dy: -0.5*gradintView1.bounds.size.height)
        //layer0.position = gradintView1.center
        gradientView.layer.addSublayer(layer0)
    }
    
    
    class func gradientLayerForButton(gradientView:UIButton){
        let layer0 = CAGradientLayer()
        layer0.colors = [
            UIColor(red: 0.557, green: 0, blue: 0, alpha: 1).cgColor,
          UIColor(red: 1, green: 0.257, blue: 0.212, alpha: 1).cgColor
          
        ]
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0, y: 1)
        layer0.endPoint = CGPoint(x: 1, y: 0)
        layer0.frame = gradientView.bounds
       // layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: -0.99, b: 0.91, c: -1.77, d: -2.61, tx: 1.87, ty: 1.35))
        //layer0.bounds = gradintView1.bounds.insetBy(dx: -0.5*gradintView1.bounds.size.width, dy: -0.5*gradintView1.bounds.size.height)
        //layer0.position = gradintView1.center
       gradientView.layer.insertSublayer(layer0, at: 0)
    }
    
    class func getCurrentLanguage() -> String{
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: "AppleLanguages") as! NSArray
        let current = langArray.firstObject as! String
        return current
    }
    
  
    class func setLanguage(langStr:String){
        let defaults = UserDefaults.standard
        defaults.set([langStr], forKey: "AppleLanguages")
        defaults.synchronize()
        Bundle.setLanguage(langStr)
    }
    class func setLocalizedValuesforView(parentview: UIView ,isSubViews : Bool)
    {
        if parentview is UILabel {
            let label = parentview as! UILabel
            let titleLabel = label.text
            if titleLabel != nil {
                label.text = self.getLocalizedString(value: titleLabel!)
            }
        }
        else if parentview is UIButton {
            let button = parentview as! UIButton
            let titleLabel = button.title(for:.normal)
            if titleLabel != nil {
                button.setTitle(self.getLocalizedString(value: titleLabel!), for: .normal)
            }
        }
        else if parentview is UITextField {
            let textfield = parentview as! UITextField
            let titleLabel = textfield.text!
            //               if(titleLabel == "")
            //               {
            let placeholdetText = textfield.placeholder
            if(placeholdetText != nil)
            {
                textfield.placeholder = self.getLocalizedString(value:placeholdetText!)
            }
            
            //                   return
            //               }
            textfield.text = self.getLocalizedString(value:titleLabel)
        }
        else if parentview is UITextView {
            let textview = parentview as! UITextView
            let titleLabel = textview.text!
            textview.text = self.getLocalizedString(value:titleLabel)
        }
        if(isSubViews)
        {
            for view in parentview.subviews {
                self.setLocalizedValuesforView(parentview:view, isSubViews: true)
            }
        }
    }
    
    //MARK: - Get user deafult file size
    class func getSizeOfUserDefaults() -> Int? {
        guard let libraryDir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first else {
            return nil
        }

        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            return nil
        }

        let filepath = "\(libraryDir)/Preferences/\(bundleIdentifier).plist"
        let filesize = try? FileManager.default.attributesOfItem(atPath: filepath)
        let retVal = filesize?[FileAttributeKey.size]
        return retVal as? Int
    }
    
    class func getLocalizedString(value: String) -> String
    {
        var str = ""
        let language = self.getCurrentLanguage()
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        if(path != nil)
        {
            let languageBundle = Bundle(path:path!)
            str = NSLocalizedString(value, tableName: nil, bundle: languageBundle!, value: value, comment: "")
        }
        return str
    }
    
    //MARK: Forunderline in Button title
    class func attributedStringWithUnderline(_ button: UIButton, string: String){
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: string, attributes: underlineAttribute)
        button.titleLabel?.attributedText = underlineAttributedString
        button.titleLabel?.numberOfLines = 2
    }
    //MARK: reachability
    class func isInternetAvailable() -> Bool
    {
        var  isAvailable : Bool
        isAvailable = true
        let reachability = try? Reachability() //try? Reachability(hostname: "google.com") //Reachability()
        if(reachability?.connection == Reachability.Connection.unavailable)
        {
            isAvailable = false
        }
        else
        {
            isAvailable = true
        }

        return isAvailable

    }
 
    
    // --
    
    class func trimString(_ text: String) -> String
    {
        let trimmedString: String = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmedString
    }
    
    class func validateEmail(_ emailStr: String) -> Bool
    {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest  = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: emailStr)
    }
    
    class func validatePhoneNumber(_ phoneNoStr: String) -> Bool
    {
        //let phoneNoRegex = "^(\\+?)(\\d{10})$"
        
        let phoneNoRegex = "^[0-9+]{0,1}+[0-9]{5,14}$"
        
        let phoneNoTest  = NSPredicate(format: "SELF MATCHES %@", phoneNoRegex)
        return phoneNoTest.evaluate(with: phoneNoStr)
    }
    
    class func validateDuration(_ durationStr: String) -> Bool
    {
        let durationRegex = "[0-9]{2}:[0-9]{2}:[0-9]{2}"
        let durationTest  = NSPredicate(format: "SELF MATCHES %@", durationRegex)
        return durationTest.evaluate(with: durationStr)
    }
    class func getCompressImageData(_ originalImage: UIImage?) -> Data? {
        // UIImage *largeImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        let largeImage: UIImage? = originalImage

        var compressionRatio: Double = 1
        var resizeAttempts: Int = 3
//        var imgData = UIImageJPEGRepresentation(largeImage!, CGFloat(compressionRatio))
        var imgData = largeImage!.jpegData(compressionQuality: CGFloat(compressionRatio))
        print(String(format: "Starting Size: %lu", UInt(imgData?.count ?? 0)))

        if (imgData?.count)! > 1000000 {
            resizeAttempts = 4
        } else if (imgData?.count)! > 400000 && (imgData?.count)! <= 1000000 {
            resizeAttempts = 2
        } else if (imgData?.count)! > 100000 && (imgData?.count)! <= 400000 {
            resizeAttempts = 2
        } else if (imgData?.count)! > 40000 && (imgData?.count)! <= 100000 {
            resizeAttempts = 1
        } else if (imgData?.count)! > 10000 && (imgData?.count)! <= 40000 {
            resizeAttempts = 1
        }

        print("resizeAttempts \(resizeAttempts)")

        while resizeAttempts > 0 {
            resizeAttempts -= 1
            print("Image was bigger than 400000 Bytes. Resizing.")
            print(String(format: "%i Attempts Remaining", resizeAttempts))
            compressionRatio = compressionRatio * 0.6
            print("compressionRatio \(compressionRatio)")
            print(String(format: "Current Size: %lu", UInt(imgData?.count ?? 0)))
//            imgData = UIImageJPEGRepresentation(largeImage!, CGFloat(compressionRatio))
            imgData = largeImage!.jpegData(compressionQuality: CGFloat(compressionRatio))
            print(String(format: "New Size: %lu", UInt(imgData?.count ?? 0)))
        }

        //Set image by comprssed version
        let savedImage = UIImage(data: imgData!)

        //Check how big the image is now its been compressed and put into the UIImageView
        // *** I made Change here, you were again storing it with Highest Resolution ***

//        var endData = UIImageJPEGRepresentation(savedImage!, CGFloat(compressionRatio))
        var endData = savedImage!.jpegData(compressionQuality: CGFloat(compressionRatio))
        //NSData *endData = UIImagePNGRepresentation(savedImage);

        print(String(format: "Ending Size: %lu", UInt(endData?.count ?? 0)))

        return endData
    }
    class func getAddressString(addressInfo: NSDictionary) -> String
    {
        var addressString     = ""
        let strAdd1           = addressInfo["address1"] as! String
        let strAdd2           = addressInfo["address2"] as! String
        let strAdd3           = addressInfo["address3"] as! String
        let strCity           = addressInfo["city"] as! String
        let strState          = addressInfo["state"] as! String
        let strPincode        = addressInfo["pincode"] as! String
        
        addressString         = "\(strAdd1), \(strAdd2), \(strAdd3), \(strCity), \(strState)-\(strPincode)"
        
        return addressString
    }
    
    class func getUIcolorfromHex(hex:String,alpha:Int? = 1) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha ?? 1)
        )
    }
    
    class func applyCustomColor(toViews views: UIView...,toLabels labels: UILabel..., andButtons buttons: UIButton...,buttonBackgroundColor backgroundButtons: UIButton...) {
        let customColor = Utility.getUIcolorfromHex(hex: "#9E8958")
        views.forEach { $0.backgroundColor = customColor }
        labels.forEach { $0.textColor = customColor }
        buttons.forEach { $0.setTitleColor(customColor, for: .normal) }
        backgroundButtons.forEach({$0.backgroundColor = customColor})
    }
    
    class func setCustomColorForButton(text: String, textColor: UIColor, font: UIFont?, for button: UIButton) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font ?? UIFont.systemFont(ofSize: 14),
            .foregroundColor: textColor
        ]
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        button.setAttributedTitle(attributedText, for: .normal)
    }
    
    
    // --
    
    
    class func setCustomFontSize(noramlSize: Int) -> CGFloat
    {
        
        //Current runable device/simulator width find
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        
        // basewidth you have set like your base storybord is IPhoneSE this storybord width 320px.
        let baseWidth: CGFloat = 320
        
        let fontSize = CGFloat(noramlSize) * (width / baseWidth)
        
        return fontSize.rounded()
    }
    
    class func findHeight(fromText text: String, maxWidth: CGFloat, font: UIFont) -> CGRect
    {
        let attributes = [NSAttributedString.Key.font: font]
        let rectAmnt: CGRect = text.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: (attributes as Any as! [NSAttributedString.Key : Any]), context: nil)
        return rectAmnt
    }
    
    
    //Convert the Swift dictionary to JSON String
    class func JSONString(object: Any)  -> String?
    {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            // here "decoded" is of type `Any`, decoded from JSON data
            return jsonString
            // you can now cast it with the right type
            
        } catch {
            print(error.localizedDescription)
        }
        
        return ""
        
    }
    
    /*
    // If use raw data then create request and pass parameters in httpBody
    class func createRequest(url : String, dictParams: Parameters) -> URLRequest {
        let urlString      = url
        let url            = URL(string: urlString)!
        var request        = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody   = try JSONSerialization.data(withJSONObject: dictParams)
        } catch let error {
            print("Error : \(error.localizedDescription)")
        }
        
        return request
    }
    */
    
    
    class func formatNumber(num: Double) ->String
    {
        var thousandNum = num/1000
        var millionNum  = num/1000000
        
        
        if num >= 1000 && num < 1000000
        {
            if(floor(thousandNum) == thousandNum)
            {
                return("\(Int(thousandNum))k")
            }
            
            return("\(thousandNum.roundToPlaces(places: 1))k")
        }
        
        if num > 1000000
        {
            if(floor(millionNum) == millionNum)
            {
                return("\(Int(thousandNum))k")
            }
            
            return ("\(millionNum.roundToPlaces(places: 1))M")
        }
        else
        {
            if(floor(num) == num)
            {
                return ("\(Int(num))")
            }
            
            return ("\(num)")
        }
        
    }
    
    
    class func resizedImage(at url: URL, for size: CGSize) -> UIImage?
    {
        guard let image = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

    //--
    class func labelWidth(height: CGFloat, font: UIFont,text: String) -> CGFloat {
    let label =  UILabel(frame: CGRect(x: 0, y: 0, width: .greatestFiniteMagnitude, height: height))
    label.numberOfLines = 0
    label.text = text
    label.font = font
    label.sizeToFit()
    return label.frame.width
}
    
    //MARK: - Return in MB
    class func getVideoSize(url: URL?) -> Double {
        guard let filePath = url?.path else {
            return 0.0
        }
        do {
            let attribute = try FileManager.default.attributesOfItem(atPath: filePath)
            if let size = attribute[FileAttributeKey.size] as? NSNumber {
                return size.doubleValue / 1000000.0
            }
        } catch {
            print("Error: \(error)")
        }
        return 0.0
    }
    
    class func lightCompressVideo(videoURL: URL,destinationURL: URL? = nil,compressProgress: @escaping(_ value:Double) -> Void,completion: @escaping(_ url: URL) -> Void) {
        
        var destURL: URL?
        
        if let url = destinationURL {
            destURL = url
        }
        else {
            let destinationPath = NSTemporaryDirectory() + UUID().uuidString+".mp4"
            destURL = URL(fileURLWithPath: destinationPath as String)
        }
        
        print("Before size light compress:--",Utility.getVideoSize(url: videoURL))
        
        LightCompressor().compressVideo(source: videoURL, destination: destURL!, quality: .high, isMinBitRateEnabled: true, keepOriginalResolution: true, progressQueue: .main) { (progress) in
            
            //print(progress.fractionCompleted)
            compressProgress(progress.fractionCompleted)
        } completion: { (result) in
            
            switch result {
                
            case .onSuccess(let path):
                print(path)
                completion(path)
                print("After size light compress:--",Utility.getVideoSize(url: path))
                break
            case .onStart:
                print("Start")
                break
            case .onFailure(let error):
                print("fail")
                print(error.localizedDescription)
                completion(videoURL)
                break
            case .onCancelled:
                completion(videoURL)
                break
            }
        }
    }
    
    class func getCompressedImageData(_ originalImage: UIImage?) -> Data? {
        // UIImage *largeImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        let largeImage = originalImage
        
        var compressionRatio: Double = 1
        var resizeAttempts = 3
        var imgData = largeImage?.jpegData(compressionQuality: CGFloat(compressionRatio))
        print(String(format: "Starting Size: %lu", UInt(imgData?.count ?? 0)))
        
        if imgData!.count > 1000000 {
            resizeAttempts = 4
        } else if imgData!.count > 400000 && imgData!.count <= 1000000 {
            resizeAttempts = 2
        } else if imgData!.count > 100000 && imgData!.count <= 400000 {
            resizeAttempts = 2
        } else if imgData!.count > 40000 && imgData!.count <= 100000 {
            resizeAttempts = 1
        } else if imgData!.count > 10000 && imgData!.count <= 40000 {
            resizeAttempts = 1
        }
        print("resizeAttempts \(resizeAttempts)")
        //Trying to push it below around about 0.4 meg
        //while ([imgData length] > 400000 && resizeAttempts > 0) {
        while resizeAttempts > 0 {
            
            resizeAttempts -= 1
            
            print("Image was bigger than 400000 Bytes. Resizing.")
            print(String(format: "%i Attempts Remaining", resizeAttempts))
            
            //Increase the compression amount
            compressionRatio = compressionRatio * 0.6
            print("compressionRatio \(compressionRatio)")
            
            //Test size before compression
            //            print(String(format: "Current Size: %lu", UInt(imgData.c)))
            imgData = largeImage!.jpegData(compressionQuality: CGFloat(compressionRatio))
            
            //Test size after compression
            //            print(String(format: "New Size: %lu", UInt(imgData.length())))
            
        }
        
        //Set image by comprssed version
        let savedImage = UIImage(data: imgData!)
        //Check how big the image is now its been compressed and put into the UIImageView
        // *** I made Change here, you were again storing it with Highest Resolution ***
        let endData = savedImage!.jpegData(compressionQuality: CGFloat(compressionRatio))
        //NSData *endData = UIImagePNGRepresentation(savedImage);
        
        print(String(format: "Ending Size: %lu", UInt(endData?.count ?? 0)))
        
        return endData
    }
    
    class func getThumbnailFromImage(selectedImage : UIImage?) -> UIImage? {
        
        guard let yourImage = selectedImage else { return nil}

        if let imageData = yourImage.png() { // pngData()
            
            var thumbnailImage : UIImage?
            
            let options = [
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceThumbnailMaxPixelSize: 300] as CFDictionary // Specify your desired size at kCGImageSourceThumbnailMaxPixelSize. I've specified 100 as per your question

            imageData.withUnsafeBytes { ptr in
               guard let bytes = ptr.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                  return
               }
               if let cfData = CFDataCreate(kCFAllocatorDefault, bytes, imageData.count){
                  let source = CGImageSourceCreateWithData(cfData, nil)!
                  let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options)!
                   thumbnailImage = UIImage(cgImage: imageReference) // You get your thumbail here
               }
            }
            
            return (thumbnailImage != nil) ? thumbnailImage : nil
        }
        else {
            return nil
        }
    }
    
    
    /*
     if let data = image.png() {
         let imageFromPNGData = UIImage(data: data)
     }
    */
    
    class func applyCurvedPath(givenView: UIView, curvedPercent:CGFloat)
    {
        guard curvedPercent <= 1 && curvedPercent >= 0 else {
            return
        }
        
        let shapeLayer = CAShapeLayer(layer: givenView.layer)
        shapeLayer.path = self.pathCurvedForView(givenView: givenView,curvedPercent: curvedPercent).cgPath
        shapeLayer.frame = givenView.bounds
        shapeLayer.masksToBounds = true
        givenView.layer.mask = shapeLayer
    }
    
    private class func pathCurvedForView(givenView: UIView, curvedPercent:CGFloat) -> UIBezierPath
    {
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x:0, y:0))
        arrowPath.addLine(to: CGPoint(x:givenView.bounds.size.width, y:0))
        arrowPath.addLine(to: CGPoint(x:givenView.bounds.size.width, y:givenView.bounds.size.height - (givenView.bounds.size.height*curvedPercent)))
        arrowPath.addQuadCurve(to: CGPoint(x:0, y:givenView.bounds.size.height - (givenView.bounds.size.height*curvedPercent)), controlPoint: CGPoint(x:givenView.bounds.size.width/2, y:givenView.bounds.size.height))
        arrowPath.addLine(to: CGPoint(x:0, y:0))
        arrowPath.close()
        
        return arrowPath
    }
    
    
    //--
    
    
    class func setTextFieldBorder(txtF: UITextField)
    {
        txtF.layer.borderColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        txtF.layer.borderWidth  = 2.0
        txtF.layer.cornerRadius = 6.0
    }
    
    class func setTextViewBorder(tV: UITextView)
    {
        tV.layer.borderColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tV.layer.borderWidth  = 2.0
        tV.layer.cornerRadius = 6.0
    }
    //--
    
    //--
    
    /*
    class func setSVprogress()
    {
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setDefaultAnimationType(.native)
        //SVProgressHUD.setFadeInAnimationDuration(0.1)
        
        SVProgressHUD.setMinimumDismissTimeInterval(0.8)
        SVProgressHUD.setMaximumDismissTimeInterval(1.2)
    }
    */
    
    class func callNumber(phoneNumber:String) {

      if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {

        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneCallURL)) {
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        }
      }
        
        //callNumber("7178881234")
    }
    
    class func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    func getDayNameFrom1to7Number(forNo Day: Int) -> String {
        let weekDay = Day
        switch weekDay {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return "Nada"
        }
    }
    
    func getDayNoFromDayName(forNo Day: String) -> Int {
        let weekDay = Day
        switch weekDay {
        case "Sunday":
            return 1
        case "Monday":
            return 2
        case "Tuesday":
            return 3
        case "Wednesday":
            return 4
        case "Thursday":
            return 5
        case "Friday":
            return 6
        case "Saturday":
            return 7
        default:
            return 0
        }
    }
    
    func getAllDaysOfTheCurrentWeek() -> [Date] {
        var dates: [Date] = []
        guard let dateInterval = Calendar.current.dateInterval(of: .weekOfYear,
                                                               for: Date()) else {
            return dates
        }
        
        Calendar.current.enumerateDates(startingAfter: dateInterval.start,
                                        matching: DateComponents(hour:0),
                                        matchingPolicy: .nextTime) { date, _, stop in
                guard let date = date else {
                    return
                }
                if date <= dateInterval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
        }
        
        return dates
    }
    
    class func getDayOfWeekString(today:String) -> String? {
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy" //"yyyy-MM-dd"
        
        if let todayDate = formatter.date(from: today) {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            let myComponents = myCalendar.components(.weekday, from: todayDate)
            let weekDay = myComponents.weekday
            switch weekDay {
            case 1:
                return "Sunday"
            case 2:
                return "Monday"
            case 3:
                return "Tuesday"
            case 4:
                return "Wednesday"
            case 5:
                return "Thursday"
            case 6:
                return "Friday"
            case 7:
                return "Saturday"
            default:
                print("Error fetching days")
                return "Day"
            }
        } else {
            return nil
        }
    }
    
    class func generateImageFromPHAsset(asset: PHAsset,completion: @escaping(UIImage) -> Void){
          let options = PHImageRequestOptions()
                 options.isSynchronous = false
          options.deliveryMode = .highQualityFormat
          options.isNetworkAccessAllowed = true
          PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: options) { (image, info) in
              // Do something with image
              if let image = image {
                  completion(image)
              }
          }
      }
    
    class func getVideoURLForPHAsset(ofPhotoWith mPhasset: PHAsset, completionHandler : @escaping ((_ responseURL : URL?) -> Void)) {
           let options: PHVideoRequestOptions = PHVideoRequestOptions()
           options.version = .original
           options.deliveryMode = .highQualityFormat
           options.isNetworkAccessAllowed = true
           PHImageManager.default().requestAVAsset(forVideo: mPhasset, options: options, resultHandler: { (asset, audioMix, info) in
               if let urlAsset = asset as? AVURLAsset {
                   let localVideoUrl = urlAsset.url
                   completionHandler(localVideoUrl)
               } else {
                   completionHandler(nil)
               }
           })
       }
    
    class func compressPHAssetVideo(videoURL: URL, completion: @escaping(_ url: URL) -> Void){
            let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".MP4")
            print(compressedURL)
            
            self.compressVideo(inputURL: videoURL, outputURL: compressedURL) { exportSession in
                guard let session = exportSession else {
                    return
                }
                switch session.status {
                case .unknown:
                    print("unknown")
                    break
                case .waiting:
                    print("waiting")
                    break
                case .exporting:
                    print("exporting")
                    break
                case .completed:
                    do {
                        let compressedData = try  Data.init(contentsOf: compressedURL)
    //                    self.compressVideo = compressedURL
    //                    print(compressedData)
                        print("File size AFTER compression: \(Double(compressedData.count / 1048576)) mb")
                        completion(compressedURL)
                    }
                    catch{
                        print(error)
                    }
                case .failed:
                    print("failed")
                    completion(videoURL)
                    break
                case .cancelled:
                    print("cancelled")
                    completion(videoURL)
                    break
                @unknown default:
                    break
                }
            }
        }
    
    
    class func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
            handler(nil)

            return
        }
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
    
    
    class func createThumbnailFromVideoURL(videoURL: String) -> UIImage?{
           let asset = AVAsset(url: URL(string: videoURL)!)
           let assetImgGenerate = AVAssetImageGenerator(asset: asset)
           assetImgGenerate.appliesPreferredTrackTransform = true
           let time = CMTimeMakeWithSeconds(Float64(0), preferredTimescale: asset.duration.timescale)
           do {
               let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
               let thumbnail = UIImage(cgImage: img)
               return thumbnail
           } catch let err{
               print(err.localizedDescription)
           }
           return nil
       }
    
    class func getThumbnailImage(forUrl url: URL) -> UIImage? {
          let asset: AVAsset = AVAsset(url: url)
          let imageGenerator = AVAssetImageGenerator(asset: asset)
          imageGenerator.appliesPreferredTrackTransform = true
          do {
              let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1) , actualTime: nil)
              
              return UIImage(cgImage: thumbnailImage)
          } catch let error {
              print(error)
          }
          
          return nil
      }
    
    class func getDeviceCurrentOrienationMask(orienation: UIDeviceOrientation) -> UIInterfaceOrientationMask{
        switch orienation {
        case .portrait:
            return .portrait
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
    
    //MARK: -
    
    class func writeToFile(urlString: String) -> URL?
    {
        guard let videoUrl = URL(string: urlString) else { return nil }
        
        do {
            
            let videoData = try Data(contentsOf: videoUrl)
            let fm = FileManager.default
            
            guard let docUrl = fm.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("Unable to reach the documents folder")
                return nil
            }
            
            let localUrl = docUrl.appendingPathComponent(videoUrl.lastPathComponent)
            try videoData.write(to: localUrl)
            return localUrl
            
        } catch  {
            print("could not save data")
            return nil
        }
    }
    
    
    class func removeFileIfExist(url: URL?)
    {
        guard let url = url else { return }
        
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let filePath = docDir.appendingPathComponent(url.lastPathComponent)
        
        do {
            try FileManager.default.removeItem(at: filePath)
            print("File deleted")
        }
        catch {
            print("Error")
        }
    }
    
    class func UTCToLocalForChat(timeStamp:NSNumber, toFormat: String) -> String {
        let myTimeInterval = TimeInterval(Double(truncating: timeStamp))
      //  let date = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        
        let seconds = myTimeInterval / 1000
        let date = Date(timeIntervalSince1970: seconds)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.dateFormat = toFormat
        return dateFormatter.string(from: date as Date)
    }
    
    class func UTCToLocal(date:String, dateFormate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormate//YYYYMMDD_HHMM_A
        dateFormatter.timeZone = TimeZone(identifier: "Etc/GMT")
        
        let utcDateString = date
        if let utcDate = dateFormatter.date(from: utcDateString ) {
            dateFormatter.timeZone = TimeZone.current
            let convertedDateString = dateFormatter.string(from: utcDate)
            print(convertedDateString) // Output: 2023-07-13 16:00:00
            
            return convertedDateString
        }
        return ""
    }
    
    class func LocalToUTC(date:String,dateFormate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormate//HH_MM_A
        dateFormatter.timeZone = TimeZone.current
        
        let utcDateString = date
        if let utcDate = dateFormatter.date(from: utcDateString ) {
            dateFormatter.timeZone = TimeZone(identifier: "Etc/GMT")
            let convertedDateString = dateFormatter.string(from: utcDate)
            print(convertedDateString) // Output: 2023-07-13 16:00:00
            
            return convertedDateString
        }
        return ""
        
    }
    
}



extension Array where Element: Hashable {
    func uniqued() -> Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
extension UIView {

  // OUTPUT 1
//  func dropShadow(scale: Bool = true) {
//    layer.masksToBounds = false
//    layer.shadowColor = UIColor.black.cgColor
//    layer.shadowOpacity = 0.5
//    layer.shadowOffset = CGSize(width: -1, height: 1)
//    layer.shadowRadius = 1
//
//    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
//    layer.shouldRasterize = true
//    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
//  }

  // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, cornerRadius: CGFloat = 0.0, scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offSet
    layer.shadowRadius = radius
    layer.cornerRadius = cornerRadius

    layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}

extension Bundle {
    
    class func setLanguage(_ language: String) {
        
        defer {
            object_setClass(Bundle.main, AnyLanguageBundle.self)
        }
        
        objc_setAssociatedObject(Bundle.main, &bundleKey,    Bundle.main.path(forResource: language, ofType: "lproj"), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

var bundleKey: UInt8 = 0

class AnyLanguageBundle: Bundle {
    
    override func localizedString(forKey key: String,
                                  value: String?,
                                  table tableName: String?) -> String {
        
        guard let path = objc_getAssociatedObject(self, &bundleKey) as? String,
            let bundle = Bundle(path: path) else {
                
                return super.localizedString(forKey: key, value: value, table: tableName)
        }
        
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Date {
    
    func dateFormatWithSuffix() -> String {
        return "d'\(self.daySuffix())' MMM, yyyy"
    }
    
    func daySuffix() -> String {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.day, from: self)
        let dayOfMonth = components.day
        switch dayOfMonth {
        case 1, 21, 31:
            return "st"
        case 2, 22:
            return "nd"
        case 3, 23:
            return "rd"
        default:
            return "th"
        }
    }
    
}
extension String {
    public var convertHtmlToNSAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data,options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }

    public func convertHtmlToAttributedStringWithCSS(font: UIFont? , csscolor: String , lineheight: Int, csstextalign: String) -> NSAttributedString? {
        guard let font = font else {
            return convertHtmlToNSAttributedString
        }
        let modifiedString = "<style>body{font-family: '\(font.fontName)'; font-size:\(font.pointSize)px; color: \(csscolor); line-height: \(lineheight)px; text-align: \(csstextalign); }</style>\(self)";
        guard let data = modifiedString.data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch {
            print(error)
            return nil
        }
    }
}

extension URL {
    func valueOf(_ queryParameterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParameterName })?.value
    }
}

//MARK: prevent screen captuer
extension UIView {
    func makeSecure() {
        DispatchQueue.main.async {
            let field = UITextField()
            field.isSecureTextEntry = true
            self.addSubview(field)
            field.backgroundColor = .red
            field.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            field.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            self.layer.superlayer?.addSublayer(field.layer)
            field.layer.sublayers?.first?.addSublayer(self.layer)
        }
    }
}

extension Calendar {
  func intervalOfWeek(for date: Date) -> DateInterval? {
    dateInterval(of: .weekOfYear, for: date)
  }

  func startOfWeek(for date: Date) -> Date? {
    intervalOfWeek(for: date)?.start
  }

  func daysWithSameWeekOfYear(as date: Date) -> [Date] {
    guard let startOfWeek = startOfWeek(for: date) else {
      return []
    }

    return (0 ... 6).reduce(into: []) { result, daysToAdd in
      result.append(Calendar.current.date(byAdding: .day, value: daysToAdd, to: startOfWeek))
    }
    .compactMap { $0 }
  }
}
extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Utility.getCurrentLanguage())
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
