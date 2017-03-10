//
//  UIColor+Project.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/3.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    
    // MARK: - init
    
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    public convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var formatted = hex.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        if let hex = Int(formatted, radix: 16) {
            let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16)/255.0)
            let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8)/255.0)
            let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0)/255.0)
            self.init(red: red, green: green, blue: blue, alpha: alpha)        } else {
            return nil
        }
    }
    
    public convenience init(gray: CGFloat, alpha: CGFloat = 1) {
        self.init(red: gray/255, green: gray/255, blue: gray/255, alpha: alpha)
    }
    
    // MARK: - Class funcs
    
    public class func hex(_ hexStr : String, alpha : CGFloat = 1.0) -> UIColor {
        return UIColor.init(hex: hexStr , alpha: alpha)!
    }
    
    public class func gray(gray: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor.init(gray: gray)
    }
    
    // MARK: - component
    
    public var redComponent: Int {
        var r: CGFloat = 0
        getRed(&r, green: nil, blue: nil, alpha: nil)
        return Int(r * 255)
    }
    
    public var greenComponent: Int {
        var g: CGFloat = 0
        getRed(nil, green: &g, blue: nil, alpha: nil)
        return Int(g * 255)
    }
    
    public var blueComponent: Int {
        var b: CGFloat = 0
        getRed(nil, green: nil, blue: &b, alpha: nil)
        return Int(b * 255)
    }
    
    public var alpha: CGFloat {
        var a: CGFloat = 0
        getRed(nil, green: nil, blue: nil, alpha: &a)
        return a
    }
    
    public static func random(randomAlpha: Bool = false) -> UIColor {
        let randomRed = CGFloat.random()
        let randomGreen = CGFloat.random()
        let randomBlue = CGFloat.random()
        let alpha = randomAlpha ? CGFloat.random() : 1.0
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: alpha)
    }
    
    
    //MARK: navigation bar
    class func navigationBarTitleTextColor() -> UIColor {
        //white
        return UIColor.hex("ffffff", alpha: 1.0)
    }
    
    class func navigationBarBackgroundColor() -> UIColor {
        //red
        return UIColor.hex("e31100", alpha: 1.0)
    }
    
    //MARK: tab bar
    class func tabBarTitleTextColor() -> UIColor {
        //red
        return UIColor.hex("e31100", alpha: 1.0)
    }
    
    class func tabBarBackgroundColor() -> UIColor {
        //light gray
        return UIColor.white
    }
    
    //MARK: label
    class func labelSubtitleTextColor() -> UIColor {
        //black
        return UIColor.hex("9b9b9b", alpha: 1.0)
    }
    
    class func labelTitleTextColor() -> UIColor {
        //gray
        return UIColor.hex("000000", alpha: 1.0)
    }
    
    //MARK: text field
    class func textFieldTextColor() -> UIColor {
        //black
        return UIColor.hex("000000", alpha: 1.0)
    }
    
    class func textFieldPlaceholderTextColor() -> UIColor {
        //light gray
        return UIColor.hex("c7c6cd", alpha: 1.0)
    }
    
    //MARK: text view
    class func textViewTextColor() -> UIColor {
        return UIColor.hex("000000", alpha: 1.0)
    }
    
    class func textViewPlaceholderTextColor() -> UIColor {
        return UIColor.hex("c7c6cd", alpha: 1.0)
    }
    
    //MARK: button
    class func buttonWihteTitleTextColor() -> UIColor {
        return UIColor.hex("ffffff", alpha: 1.0)
    }
    
    class func buttonBlackTitleTextColor() -> UIColor {
        return UIColor.hex("000000", alpha: 1.0)
    }
    
    class func buttonRedTitleTextColor() -> UIColor {
        return UIColor.hex("e31100", alpha: 1.0)
    }
    
    class func buttonRedBackgroundColor() -> UIColor {
        return UIColor.hex("e31100", alpha: 1.0)
    }
    
    //below 3 color group
    class func buttonWhiteBackgroundColor() -> UIColor {
        return UIColor.hex("ffffff", alpha: 1.0)
    }
    
    class func buttonHighlightBackgroundColor() -> UIColor {
        return UIColor.hex("e31100", alpha: 1.0)
    }
    
    class func buttonSelectedBackgroundColor() -> UIColor {
        return UIColor.hex("e31100", alpha: 1.0)
    }
    
    //MARK: view
    class func viewBackgroundColor() -> UIColor {
        return UIColor.hex("f8f8f8", alpha: 1.0)
    }
    
    //badege
    class func badgeBackgroundColor() -> UIColor {
        return UIColor.hex("e31100", alpha: 1.0);
    }
    
    //line
    class func lineBackgroundColor() -> UIColor {
        return UIColor.hex("d9d9d9", alpha: 1.0);
    }
    
    
    //MARK: color name
    class func cpBlackColor() -> UIColor {
        //black
        return UIColor.hex("000000", alpha: 1.0)
    }
    
    class func cpRedColor() -> UIColor {
        //red
        return UIColor.hex("e31100", alpha: 1.0)
    }
    
    class func cpBlueColor() -> UIColor {
        //red
        return UIColor.hex("5677fc", alpha: 1.0)
    }

    
}

private extension CGFloat {
    /// SwiftRandom extension
    static func random(_ lower: CGFloat = 0, _ upper: CGFloat = 1) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upper - lower) + lower
    }
}
