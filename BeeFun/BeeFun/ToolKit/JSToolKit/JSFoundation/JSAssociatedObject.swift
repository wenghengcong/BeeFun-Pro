//
//  JSAssociatedObject.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/4/17.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

final class Lifted<T> {
    let value: T
    init(_ x: T) {
        value = x
    }
}

private func lift<T>(x: T) -> Lifted<T> {
    return Lifted(x)
}

func setAssociatedObject<T>(object: AnyObject, value: T, associativeKey: UnsafeRawPointer, policy: objc_AssociationPolicy) {
    if let v: AnyObject = value as? AnyObject {
        objc_setAssociatedObject(object, associativeKey, v, policy)
    } else {
        objc_setAssociatedObject(object, associativeKey, lift(x: value), policy)
    }
}

func getAssociatedObject<T>(object: AnyObject, associativeKey: UnsafeRawPointer) -> T? {
    if let v = objc_getAssociatedObject(object, associativeKey) as? T {
        return v
    } else if let v = objc_getAssociatedObject(object, associativeKey) as? Lifted<T> {
        return v.value
    } else {
        return nil
    }
}

class JSAssociatedObject: NSObject {

}
