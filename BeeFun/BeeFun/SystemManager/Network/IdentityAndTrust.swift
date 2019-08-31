//
//  IdentityAndTrust.swift
//  BeeFun
//
//  Created by 翁恒丛 on 2018/6/19.
//  Copyright © 2018年 JungleSong. All rights reserved.
//

import UIKit
/// 定义一个结构体，存储认证相关信息
struct IdentityAndTrust {
    
    var identityRef: SecIdentity
    var trust: SecTrust
    var certArray: AnyObject
    
    static func extractIdentity(certificate path: String, type: String, password: String) -> IdentityAndTrust {
        var identityAndTrust: IdentityAndTrust!
        var securityError: OSStatus = errSecSuccess
        
        let path: String = Bundle.main.path(forResource: path, ofType: type)!
        let PKCS12Data = NSData(contentsOfFile: path)!
        let key: NSString = kSecImportExportPassphrase as NSString
        let options: NSDictionary = [key: password] //客户端证书密码
        //create variable for holding security information
        //var privateKeyRef: SecKeyRef? = nil
        var items: CFArray?
        securityError = SecPKCS12Import(PKCS12Data, options, &items)
        if securityError == errSecSuccess {
            let certItems: CFArray = items as CFArray!
            let certItemsArray: Array = certItems as Array
            let dict: AnyObject? = certItemsArray.first
            if let certEntry: Dictionary = dict as? Dictionary<String, AnyObject> {
                // grab the identity
                let identityPointer: AnyObject? = certEntry["identity"]
                let secIdentityRef: SecIdentity = identityPointer as! SecIdentity!
                print("\(String(describing: identityPointer))  :::: \(secIdentityRef)")
                // grab the trust
                let trustPointer: AnyObject? = certEntry["trust"]
                if let trustRef: SecTrust = trustPointer as! SecTrust {
                    print("\(String(describing: trustPointer))  :::: \(trustRef)")
                    // grab the cert
                    let chainPointer: AnyObject? = certEntry["chain"]
                    identityAndTrust = IdentityAndTrust(identityRef: secIdentityRef,
                                                        trust: trustRef, certArray: chainPointer!)
                }
            }
        }
        return identityAndTrust
    }
}
