////
////  IAPM.swift
////  Wenue
////
////  Created by iroid on 07/04/22.
////
//
//import Foundation
//import SwiftyStoreKit
//
//class IAPM {
//    
//    static let shared = { IAPM() } ()
//    
//    let MONTHLY_PLAN_ID = "com.Wenue.monthly"
//    let YEARLY_PLAN_ID  = "com.Wenue.yearly"
//    let SHARED_SECRET   = "9e843e0444c945e297d646a3b09a5179"
//
//    //MARK: - GET THE PRODUCT INFO
////    func retrieveProductInfo(productName: String,success: @escaping(SubscriptionProductInfoRequest?) -> Void,failure: @escaping(String) -> Void) {
////
////        SwiftyStoreKit.retrieveProductsInfo([productName]) { result in
////
////            if let product = result.retrievedProducts.first {
////
////                //let priceString = product.localizedPrice!
////                let priceString = "\(product.price)"
////                let currencySymbol = product.priceLocale.currencySymbol
////                print("\(product.priceLocale.currencySymbol ?? "") \(product.localizedPrice ?? "")")
////                print("Product: \(product.localizedDescription), price: \(priceString)")
////
////                let data = SubscriptionProductInfoRequest(productName: product.localizedDescription, productPrice: priceString, productCurrencySymbol: currencySymbol)
////                success(data)
////            }
////            else if let invalidProductId = result.invalidProductIDs.first {
////                failure("Invalid product identifier: \(invalidProductId)")
////            }
////            else {
////                failure("Error: \(String(describing: result.error?.localizedDescription))")
////            }
////        }
////    }
//    
//    //MARK: - PURCHASE PRODUCT
////    func purchaseProduct(productName: String,success: @escaping([String: Any]) -> Void,failure: @escaping(String) -> Void) {
////
////        SwiftyStoreKit.purchaseProduct(productName, atomically: true) { [weak self] result in
////
////            switch result {
////
////            case .success(let purchase):
////
////                let downloads = purchase.transaction.downloads
////
////                if !downloads.isEmpty {
////                    SwiftyStoreKit.start(downloads)
////                }
////
////                // fetch content from your server, then:
////                if purchase.needsFinishTransaction {
////                    SwiftyStoreKit.finishTransaction(purchase.transaction)
////                }
////
////                print("Purchase Success: \(purchase.productId)")
////                self?.verifyPurchaseReceipt(productId: purchase.productId) { (receiptData) in
////                    success(receiptData)
////                } failure: { (error) in
////                    failure(error)
////                }
////            case .error(let error):
////                switch error.code {
////                case .unknown:
////                    // print("Unknown error. Please contact support")
////                    failure("Unknown error. Please contact support")
////                case .clientInvalid:
////                    // print("Not allowed to make the payment")
////                    failure("Not allowed to make the payment")
////                case .paymentCancelled:
////                    Utility.hideIndicator()
////                    break
////                case .paymentInvalid:
////                    // print("The purchase identifier was invalid")
////                    failure("The purchase identifier was invalid")
////                case .paymentNotAllowed:
////                    // print("The device is not allowed to make the payment")
////                    failure("The device is not allowed to make the payment")
////                case .storeProductNotAvailable:
////                    // print("The product is not available in the current storefront")
////                    failure("The product is not available in the current storefront")
////                case .cloudServicePermissionDenied:
////                    // print("Access to cloud service information is not allowed")
////                    failure("Access to cloud service information is not allowed")
////                case .cloudServiceNetworkConnectionFailed:
////                    // print("Could not connect to the network")
////                    failure("Could not connect to the network")
////                case .cloudServiceRevoked:
////                    // print("User has revoked permission to use this cloud service")
////                    failure("User has revoked permission to use this cloud service")
////                default:
////                    // print((error as NSError).localizedDescription)
////                    failure((error as NSError).localizedDescription)
////                }
////            }
////        }
////    }
////
////
////    //MARK: - RESTORE PRODUCT
////    func restorePurchase(success: @escaping([String: Any]) -> Void,failure: @escaping(String) -> Void) {
////
////        Utility.showIndicator()
////
////        SwiftyStoreKit.restorePurchases(atomically: true) { [weak self] results in
////
////            if results.restoreFailedPurchases.count > 0 {
////                Utility.hideIndicator()
////                failure("Restore Failed: \(results.restoreFailedPurchases)")
////            }
////            else if results.restoredPurchases.count > 0 {
////
////                if let productId = results.restoredPurchases.first?.productId {
////
////                    self?.verifyPurchaseReceipt(productId: productId){ (receiptData) in
////                        success(receiptData)
////                    } failure: { (error) in
////                        failure(error)
////                    }
////                }
////                else {
////                    failure("Nothing to Restore")
////                }
////            }
////            else {
////                failure("Nothing to Restore")
////            }
////        }
////    }
////
////    //MARK: - VERIFY PURCHASE RECEIPT
////    func verifyPurchaseReceipt(productId: String,success: @escaping([String: Any]) -> Void,failure: @escaping(String) -> Void) {
////
////        var serviceType = AppleReceiptValidator.VerifyReceiptURLType.production
////
////        #if DEBUG
////            serviceType = AppleReceiptValidator.VerifyReceiptURLType.sandbox
////        #else
////            serviceType = AppleReceiptValidator.VerifyReceiptURLType.production
////        #endif
////
////        let appleValidator = AppleReceiptValidator(service: serviceType, sharedSecret: SHARED_SECRET)
////
////        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
////            switch result {
////            case .success(let receipt):
////                /*
////                let productId = productId
////                // Verify the purchase of a Subscription
////                let purchaseResult = SwiftyStoreKit.verifySubscription(
////                    ofType: .autoRenewable, // or .nonRenewing (see below)
////                    productId: productId,
////                    inReceipt: receipt)
////
////                switch purchaseResult {
////                case .purchased(let expiryDate, let items):
////                    print("\(productId) is valid until \(expiryDate)\n\(items)\n")
////                    print("Receipt")
////                    print(receipt)
////                */
////                if let data = receipt as? [String: Any] {
////                    success(data)
////                }
////                else {
////                    failure("Something went wrong")
////                }
////                /*
////                case .expired(let expiryDate, let items):
////                    print("\(productId) is expired since \(expiryDate)\n\(items)\n")
////                    failure("\(productId) is expired since \(expiryDate)\n\(items)\n")
////                case .notPurchased:
////                    print("The user has never purchased \(productId)")
////                    failure("The user has never purchased \(productId)")
////                }
////                */
////            case .error(let error):
////                print("Receipt verification failed: \(error)")
////                failure("Receipt verification failed: \(error)")
////            }
////        }
////    }
////
////
////}
////
////extension AppDelegate {
////
////    func getIAPProductsInfo() {
////
////        IAPM.shared.retrieveProductInfo(productName: IAPM.shared.MONTHLY_PLAN_ID) { (result) in
////            monthlyPlanPrice = result?.productPrice
////            monthlyPlanCurrencySymbol = result?.productCurrencySymbol
////        } failure: { error in }
////
////        IAPM.shared.retrieveProductInfo(productName: IAPM.shared.YEARLY_PLAN_ID) { (result) in
////            yearlyPlanPrice = result?.productPrice
////            yearlyPlanCurrencySymbol = result?.productCurrencySymbol
////        } failure: { error in }
////
////    }
////
////    func inAppPurchaseCompleteTransactions() {
////
////        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
////
////            for purchase in purchases {
////                switch purchase.transaction.transactionState {
////                case .purchased, .restored:
////                    let downloads = purchase.transaction.downloads
////                    if !downloads.isEmpty {
////                        SwiftyStoreKit.start(downloads)
////                    } else if purchase.needsFinishTransaction {
////                        // Deliver content from server, then:
////                        SwiftyStoreKit.finishTransaction(purchase.transaction)
////                        // UserDefaults.standard.set(true, forKey: "inAppPurchase")
////                    }
////                    print("\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
////                case .failed, .purchasing, .deferred:
////                    break // do nothing
////                @unknown default:
////                    break // do nothing
////                }
////            }
////        }
////
////        SwiftyStoreKit.updatedDownloadsHandler = { downloads in
////
////            // contentURL is not nil if downloadState == .finished
////            let contentURLs = downloads.compactMap { $0.contentURL }
////            if contentURLs.count == downloads.count {
////                print("Saving: \(contentURLs)")
////                SwiftyStoreKit.finishTransaction(downloads[0].transaction)
////            }
////        }
////    }
//}
