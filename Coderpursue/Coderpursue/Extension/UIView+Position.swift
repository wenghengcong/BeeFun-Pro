//
//  UIView+Position.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/16.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit

/** Position Extends UIView

*/
extension UIView {
    
    var width:CGFloat {
        
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
        
    }
    
    var height:CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
        
    }
    
    var size:CGSize  {
        get {
            return self.frame.size
        }
        set {
            self.frame.size = newValue
        }
    }
    
    var origin:CGPoint {
        get {
            return self.frame.origin
        }
        set {
            self.frame.origin = newValue
        }
    }
    
    var x:CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin = CGPointMake(newValue, self.frame.origin.y)

        }
    }
    
    var y:CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin = CGPointMake(self.frame.origin.x, newValue)

        }
    }
    
    var centerX:CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPointMake(newValue, self.center.y)

        }
    }
    
    var centerY:CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center = CGPointMake(self.center.x, newValue)

        }
    }
    
    var left:CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue

        }
    }
    
    var right:CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            self.frame.origin.x = newValue - self.frame.size.width

        }
    }
    
    var top:CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    
    var bottom:CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            self.frame.origin.y = newValue - self.frame.size.height

        }
    }
    
}
