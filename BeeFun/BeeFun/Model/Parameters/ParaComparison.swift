//
//  ComparisonOperator.swift
//  BeeFun
//
//  Created by WengHengcong on 3/8/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

public enum ComparisonOperator:String {
    
    case None = ""
    case Less = "<"
    case LessEqual = "<="
    case Greater = ">"
    case GreaterEqual = ">="
    case Equal = "="
    case Between = ".."
    
}

/**
 sample:
 1000
 >=30000
 <50
 50..120
 */

class ParaComparison<T:AnyObject>: NSObject {
    
    var left:T?
    var right:T?
    var op:ComparisonOperator?

    override init() {
        super.init()
        
    }
    
    init(left:T ,right:T, op:ComparisonOperator) {
        super.init()
        self.left = left
        self.right = right
        self.op = op
    }
    
    init(left:T,op:ComparisonOperator) {
        self.left = left
        self.op = op
    }
    
    func combineComparision()->String{
        
        let leftStr:String = "\(self.left!)"
        var comparision:String?
        
        if(self.op == nil){
            return ""
        }
        
        if(right == nil){
            //无右边参数，即只有一个参数
            if(self.op! == .None){
                comparision = leftStr
            }else{
                comparision = op!.rawValue+leftStr
            }
            
        }else{
            //两个参数
            let rightStr:String = "\(self.right!)"
            comparision = leftStr+op!.rawValue+rightStr
            
        }
        
        return comparision!
    }
    
    
}
