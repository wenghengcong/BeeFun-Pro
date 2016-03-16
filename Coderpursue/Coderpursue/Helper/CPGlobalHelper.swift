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
    
    static let sharedInstance = CPGlobalHelper()

    func showMessage(message:String ,view:UIView) {
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = message
        hud.mode = .Text
        hud.hide(true, afterDelay: 1.5)
    }
    
    func showError(error:String ,view:UIView) {
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = error
        hud.mode = .Text
        hud.hide(true, afterDelay: 1.5)
    }
    
    /**
     计算动态文本
     */
    func calculatorTextSize(text:String ,size:CGSize ,font:UIFont) -> CGRect {
        
        let boundingBox:CGRect = text.boundingRectWithSize(size, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox
        
    }
    
    func heightWithConstrainedWidth(text:String ,width: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        let boundingBox = text.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    func widthWithConstrainedHeight(text:String ,height: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: CGFloat.max, height: height)
        
        let boundingBox = text.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.width
    }
    
    //rate us
    func rateUs() {
        let appstroreUrl = ("http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(AppleAppID)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8")
        UIApplication.sharedApplication().openURL(  NSURL(string: appstroreUrl)! );
    }
    
    func readPlist(file:String)->[[ObjSettings]] {
        
        var settingsArr:[[ObjSettings]] = []

        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "plist") {
            let dictArr = NSArray(contentsOfFile: path)!
            // use swift dictionary as normal
//            print(dictArr)
            for item in dictArr {
                
                var section:[ObjSettings] = []
                let sectionArr = item as! [AnyObject]
                
                for rowdict in sectionArr {
                    let settings = ObjSettings()
                    settings.setValuesForKeysWithDictionary(rowdict as! Dictionary)
                    section.append(settings)
                    
                }
                
                settingsArr.append(section)
            }
            
        }

        return settingsArr
    }
    
    
}
