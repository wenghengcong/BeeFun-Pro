//
//  PurchaseManager.swift
//  Coderpursue
//
//  Created by WengHengcong on 2017/3/31.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit
import SwiftyStoreKit

enum RegisteredPurchase: String {
    
    case purchase1 = "com.junglesong.coderpursue.1"
}

class PurchaseManager: NSObject {

    let appBundleId = AppBundleIdentifier
    let purchase1Suffix = RegisteredPurchase.purchase1
    
    func getInfo(_ purchase: RegisteredPurchase) {
        
        SwiftyStoreKit.retrieveProductsInfo([appBundleId + "." + purchase.rawValue]) { result in
            
        }
    }
    
    
    func purchase(_ purchase: RegisteredPurchase) {
        
        SwiftyStoreKit.purchaseProduct(appBundleId + "." + purchase.rawValue, atomically: true) { result in
            
            if case .success(let product) = result {
                // Deliver content from server, then:
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
            }
        }
    }
    
    
    func verifyPurchase(_ purchase: RegisteredPurchase) {
        
        let appleValidator = AppleReceiptValidator(service: .production)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, password: "your-shared-secret") { result in
            
            switch result {
            case .success(let receipt):
                
                let productId = self.appBundleId + "." + purchase.rawValue
                
                switch purchase {
                case .purchase1:
                    break
                default:
                    let purchaseResult = SwiftyStoreKit.verifyPurchase(
                        productId: productId,
                        inReceipt: receipt
                    )

                }
                
            case .error(let error):

                if case .noReceiptData = error {

                }
            }
        }
    }    
}
