//
//  JSGCD.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/4/17.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

class JSGCD: NSObject {

    func delay(_ delay: Double, closure:@escaping () -> Void) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }

}
