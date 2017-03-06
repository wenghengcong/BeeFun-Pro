//
//  CPGlobalHelper.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/31.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import Foundation

class CPGlobalHelper {
    
    static let shared = CPGlobalHelper()

    func showMessage(_ message:String ,view:UIView) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud?.labelText = message
        hud?.mode = .text
        hud?.hide(true, afterDelay: 1.5)
    }
    
    func showError(_ error:String ,view:UIView) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud?.labelText = error
        hud?.mode = .text
        hud?.hide(true, afterDelay: 1.5)
    }
    
    /** calculator text size */
    
    func calculatorTextSize(_ text:String ,size:CGSize ,font:UIFont) -> CGRect {
        
        let boundingBox:CGRect = text.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox
        
    }
    
    func heightWithConstrainedWidth(_ text:String ,width: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = text.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    func widthWithConstrainedHeight(_ text:String ,height: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = text.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.width
    }
    

    
    
    //read plis file and convert data to array
    func readPlist(_ file:String)->[[ObjSettings]] {
        
        var settingsArr:[[ObjSettings]] = []

        if let path = Bundle.main.path(forResource: file, ofType: "plist") {
            let dictArr = NSArray(contentsOfFile: path)!
            // use swift dictionary as normal
//            print(dictArr)
            for item in dictArr {
                
                var section:[ObjSettings] = []
                let sectionArr = item as! [AnyObject]
                
                for rowdict in sectionArr {
                    let settings = ObjSettings()
                    settings.setValuesForKeys(rowdict as! Dictionary)
                    section.append(settings)
                    
                }
                
                settingsArr.append(section)
            }
            
        }

        return settingsArr
    }
    
    /** app version */
    

}
