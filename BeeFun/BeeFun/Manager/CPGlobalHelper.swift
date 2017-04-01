//
//  CPGlobalHelper.swift
//  BeeFun
//
//  Created by wenghengcong on 16/1/31.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import Foundation
import MBProgressHUD

class CPGlobalHelper {
    
    static let shared = CPGlobalHelper()


    
    /** calculator text size */
    
    class func calculatorTextSize(_ text:String ,size:CGSize ,font:UIFont) -> CGRect {
        
        let boundingBox:CGRect = text.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox
        
    }
    
    class func heightWithConstrainedWidth(_ text:String ,width: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = text.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    class func widthWithConstrainedHeight(_ text:String ,height: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = text.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.width
    }
    

    
    
    //read plis file and convert data to array
    class func readPlist(_ file:String)->[[ObjSettings]] {
        
        var settingsArr:[[ObjSettings]] = []

        if let path = Bundle.appBundle.path(forResource: file, ofType: "plist") {
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
