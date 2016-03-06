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
    
}
