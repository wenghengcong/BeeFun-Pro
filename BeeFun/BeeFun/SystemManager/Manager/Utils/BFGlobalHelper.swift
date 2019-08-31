//
//  BFGlobalHelper.swift
//  BeeFun
//
//  Created by wenghengcong on 16/1/31.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import Foundation

class BFGlobalHelper {

    static let shared = BFGlobalHelper()

    /** calculator text size */

    class func calculatorTextSize(_ text: String, size: CGSize, font: UIFont) -> CGRect {

        let boundingBox: CGRect = text.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return boundingBox

    }

    class func heightWithConstrainedWidth(_ text: String, width: CGFloat, font: UIFont) -> CGFloat {

        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)

        let boundingBox = text.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)

        return boundingBox.height
    }

    class func widthWithConstrainedHeight(_ text: String, height: CGFloat, font: UIFont) -> CGFloat {

        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)

        let boundingBox = text.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)

        return boundingBox.width
    }

    /// 从Plist配置文件中读取配置
    ///
    /// - Parameter file: plist文件名
    class func readSettsingPlist(_ file: String) -> [[JSCellModel]] {
        
        var settingsArr: [[JSCellModel]] = []
        if let path = Bundle.appBundle.path(forResource: file, ofType: "plist") {
            let dictArr = NSArray(contentsOfFile: path)
            if dictArr != nil {
                for item in dictArr! {
                    var section: [JSCellModel] = []
                    let sectionArr = item as! [AnyObject]
                    for rowdict in sectionArr {
                        let settings = JSCellModel()
                        settings.setValuesForKeys(rowdict as! Dictionary)
                        section.append(settings)
                    }
                    settingsArr.append(section)
                }
            }
        }
        return settingsArr
    }

    /** app version */

}
