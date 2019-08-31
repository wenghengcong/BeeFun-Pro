//
//  BFProfileController+Data.swift
//  BeeFun
//
//  Created by WengHengcong on 01/06/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import MessageUI

extension BFProfileController {

    func pvc_loadSettingPlistData() {
        allSettings = BFGlobalHelper.readSettsingPlist("BFProfile")
        pvc_addActionToCellModel()
        //Check list:  reward开关关闭
        self.tableView.reloadData()
        //TODO: 分享的开关暂时关闭
        /*
         <dict>
         <key>type</key>
         <string>image</string>
         <key>id</key>
         <string>share</string>
         <key>key</key>
         <string>Share</string>
         <key>icon</key>
         <string>set_share</string>
         <key>disclosure</key>
         <true/>
         </dict>
         
         <dict>
         <key>type</key>
         <string>image</string>
         <key>id</key>
         <string>share</string>
         <key>key</key>
         <string>分享</string>
         <key>icon</key>
         <string>set_share</string>
         <key>disclosure</key>
         <true/>
         </dict>
         
         */
        if !ShareManager.shared.enable {
            
        }
    }
    
    func pvc_addActionToCellModel() {
        
        for first  in allSettings {
            for second in first {
                let viewType = second.identifier!
                if viewType == "forked" {
                    second.didSelectClosure = { [weak self] (table, index, model) in
                        if UserManager.shared.needLogin() {
                            if let uname = self?.user!.login {
                                let dic: [String: String] = ["uname": uname, "type": viewType]
                                let vc = BFRepoListController()
                                vc.hidesBottomBarWhenPushed = true
                                vc.dic = dic
                                vc.username = dic["uname"]
                                vc.viewType = dic["type"]
                                self?.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }

                } else if viewType == "feedback" {
                    
                    second.didSelectClosure = { [weak self] (table, index, model) in
//                        if let mailComposeViewController = self?.configuredMailComposeViewController() {
//                            if MFMailComposeViewController.canSendMail() {
//                                self?.present(mailComposeViewController, animated: true, completion: nil)
//                            } else {
//                                self?.showSendMailErrorAlert()
//                            }
//                        }
                        let feedbackVc = BFFeedbackController()
                        feedbackVc.hidesBottomBarWhenPushed = true
                        self?.navigationController?.pushViewController(feedbackVc, animated: true)
                    }

                } else if viewType == "share" {
                    second.didSelectClosure = { (table, index, model) in
                        ShareManager.shared.shareApp()
                    }
                } else if viewType == "reward" {
                    second.didSelectClosure = { (table, index, model) in
                        //            PurchaseManager.shared.getInfo(PurchaseProduct.reward)
                        //PurchaseManager.shared.purchase(PurchaseProduct.reward)
                    }

                } else if viewType == "tags" {
                    second.didSelectClosure = { [weak self] (table, index, model) in
                        if UserManager.shared.needLogin() {
                            let vc = BFTagsManageController()
                            vc.hidesBottomBarWhenPushed = true
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    
                } else if viewType == "lists" {
                    second.didSelectClosure = { [weak self] (table, index, model) in
                        if UserManager.shared.needLogin() {
                            let vc = BFListsManageController()
                            vc.hidesBottomBarWhenPushed = true
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                } else if viewType == "sync" {
                    second.didSelectClosure = { (table, index, model) in
                        let vc = BFReposSyncController()
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
    
        }
    }
    
}
