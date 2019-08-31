//
//  UIColor+Project.swift
//  BeeFun
//
//  Created by wenghengcong on 16/1/3.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {

    // MARK: - iOS 11 Gray scale
    
    class var iOS11White: UIColor {
        return UIColor.hex("ffffff", alpha: 1.0)
    }

    class var iOS11GrayLevel1: UIColor {
        return UIColor.hex("efeff4", alpha: 1.0)
    }
    
    // MARK: GrayLevel2 = LightGray
    class var iOS11GrayLevel2: UIColor {
        return UIColor.hex("e5e5ea", alpha: 1.0)
    }
    
    class var iOS11LightGray: UIColor {
        return UIColor.hex("e5e5ea", alpha: 1.0)
    }
    
    class var iOS11GrayLevel3: UIColor {
        return UIColor.hex("d1d1d6", alpha: 1.0)
    }
    
    // MARK: GrayLevel4 = MidGray
    class var iOS11GrayLevel4: UIColor {
        return UIColor.hex("c7c7c7", alpha: 1.0)
    }
    
    class var iOS11MidGray: UIColor {
        return UIColor.hex("c7c7c7", alpha: 1.0)
    }

    class var iOS11GrayLevel5: UIColor {
        return UIColor.hex("8e8e93", alpha: 1.0)
    }
    
    class var iOS11Gray: UIColor {
        return UIColor.hex("8e8e93", alpha: 1.0)
    }
    
    class var iOS11Black: UIColor {
        //black
        return UIColor.hex("000000", alpha: 1.0)
    }

    // MARK: - iOS 11 Spectrum
    class var iOS11Red: UIColor {
        return UIColor.hex("ff3b30", alpha: 1.0)
    }
    
    class var iOS11Orange: UIColor {
        return UIColor.hex("ff9500", alpha: 1.0)
    }
    
    class var iOS11Yellow: UIColor {
        return UIColor.hex("ffcc00", alpha: 1.0)
    }
    
    class var iOS11Green: UIColor {
        return UIColor.hex("4cd964", alpha: 1.0)
    }
    
    class var iOS11TealBlue: UIColor {
        return UIColor.hex("5ac8fa", alpha: 1.0)
    }
    
    class var iOS11Blue: UIColor {
        return UIColor.hex("007aff", alpha: 1.0)
    }
    
    class var iOS11Purple: UIColor {
        return UIColor.hex("5856d6", alpha: 1.0)
    }
    
    class var iOS11Pink: UIColor {
        return UIColor.hex("ff2d55", alpha: 1.0)
    }
    
    // MARK: - BeeFun Color
    class var bfTabBarTitleTextColor: UIColor {
        //red
        return UIColor.hex("d81e06", alpha: 1.0)
    }
    
    // MARK: label
    class var bfLabelSubtitleTextColor: UIColor {
        //black
        return UIColor.hex("7b7b7b", alpha: 1.0)
    }
    
    // MARK: view
    class var bfViewBackgroundColor: UIColor {
        return UIColor.hex("f5f5f5", alpha: 1.0)
    }

    //line
    class var bfLineBackgroundColor: UIColor {
        return UIColor.hex("ceced2", alpha: 1.0)
    }

    class var bfRedColor: UIColor {
        //red
        return UIColor.hex("e31100", alpha: 1.0)
    }

    class var bfBlueColor: UIColor {
        //red
        return UIColor.hex("5677fc", alpha: 1.0)
    }
}
