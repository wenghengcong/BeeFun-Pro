//
//  PurchaseManager.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/3/31.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit
import SwiftyStoreKit

enum PurchaseProduct: String {
    
    case reward = "com.junglesong.coderpursue.1025"
}

class PurchaseManager: NSObject {

    static let shared = PurchaseManager()
    
    func getInfo(_ purchase: PurchaseProduct) {
        
        SwiftyStoreKit.retrieveProductsInfo([purchase.rawValue]) { result in
            
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                
            }
            else {
                print("Error: \(String(describing: result.error))")
            }
            
        }
    }
    
    
    func purchase(_ purchase: PurchaseProduct) {
        
        SwiftyStoreKit.purchaseProduct(purchase.rawValue, atomically: true) { result in
            
            if case .success(let product) = result {
                // Deliver content from server, then:
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
            }
        }
    }
    
    
    func verifyPurchase(_ purchase: PurchaseProduct) {
        
        let appleValidator = AppleReceiptValidator(service: .production)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, password: "your-shared-secret") { result in
            
            switch result {
            case .success(let receipt):
                
                let productId = purchase.rawValue
                
                switch purchase {
                case .reward:
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
