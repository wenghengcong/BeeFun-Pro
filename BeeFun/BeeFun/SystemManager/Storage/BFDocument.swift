//
//  BFDocument.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/12/5.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit


class BFDocument: UIDocument {

    var data: NSData?
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
         // Load your document from contents
        if let validData: NSData = contents as? NSData {
            self.data = validData.copy() as? NSData
        }
    }
    
    override func contents(forType typeName: String) throws -> Any {
        // Encode your document with an instance of NSData or NSFileWrapper
        if self.data == nil {
            self.data = NSData()
        }
        return self.data ?? NSData()
    }
}
