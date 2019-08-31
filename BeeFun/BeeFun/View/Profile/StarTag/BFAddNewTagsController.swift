//
//  BFAddNewTagsController.swift
//  BeeFun
//
//  Created by WengHengcong on 02/06/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper

class BFAddNewTagsController: BFBaseViewController {
    
    var textField = UITextField()
    var tagsValueChanged: Bool = false
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        atc_viewInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func leftItemAction(_ sender: UIButton?) {
        if textField.text != nil && !textField.text!.isEmpty {
            let willAddTagName = textField.text!.trimmed
            if willAddTagName.lowercased() == "all" {
                return
            }
            
            let alertController = UIAlertController(title: "Save Tags?".localized, message: nil, preferredStyle: .alert)
            
            alertController.addAction(title: "Cancel".localized, style: .cancel, handler: { (_) in
                _ = self.navigationController?.popViewController(animated: true)
            })
            
            alertController.addAction(title: "Save".localized, style: .default, handler: { (_) in
                self.saveTag()
            })
            self.present(alertController, animated: true, completion: {
                
            })
        } else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    /// 保存
    override func rightItemAction(_ sender: UIButton?) {
        saveTag()
    }
    
    func backLastView() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - data
    func makeNewTagObj() -> ObjTag {
        let tag = ObjTag()
        if let tagName = textField.text {
            tag.name = tagName
            tag.owner = UserManager.shared.login
        }
        return tag
    }
    
    func saveTag() {
        textField.endEditing(true)
        //1. 先检查text是否为空
        if textField.text != nil && !textField.text!.isEmpty {
            
            let willAddTagName = textField.text!.trimmed
            if willAddTagName.lowercased() == "all" {
                JSMBHUDBridge.showInfo("'All' is default,change one.".localized)
                return
            }
            
            let newTag = makeNewTagObj()
            BeeFunProvider.sharedProvider.request(BeeFunAPI.addTag(tagModel: newTag)) { (result) in
                switch result {
                case let .success(response):
                    do {
                        if let tagResponse: GetAllTagResponse = Mapper<GetAllTagResponse>().map(JSONObject: try response.mapJSON()) {
                            if let code = tagResponse.codeEnum {
                                if code == BFStatusCode.bfOk {
                                    //添加成功
                                    JSMBHUDBridge.showSuccess("Success".localized)
                                    NotificationCenter.default.post(name: NSNotification.Name.BeeFun.AddTag, object: nil, userInfo: ["tag": newTag.name!])
                                    self.backLastView()
                                } else if code == BFStatusCode.addTagWhenExist {
                                    JSMBHUDBridge.showError("Already exists!".localized, view: self.view)
                                }
                                return
                            }
                        }
                    } catch {
                    }
                    JSMBHUDBridge.showError("Failure".localized)
                case .failure:
                    //删除失败
                    JSMBHUDBridge.showError("Failure".localized)
                }
            }
        } else {
            JSMBHUDBridge.showError("No tag to save".localized, view: self.view)
        }
    }
    
    // MARK: - view
    func atc_viewInit() {
        title = "Add new tag".localized
        rightItem?.setTitle("Save".localized, for: .normal)
        rightItem?.isHidden = false
        
        let inputH: CGFloat = 50
        let backView = UIView()
        backView.backgroundColor = UIColor.white
        backView.frame = CGRect(x: 0, y: topOffset, w: ScreenSize.width, h: inputH)
        view.addSubview(backView)
        
        textField.placeholder = "input new tag name".localized
        textField.font = UIFont.bfSystemFont(ofSize: 17.0)
        textField.textColor = UIColor.bfRedColor
        textField.delegate = self
        textField.clearButtonMode = .always
        textField.returnKeyType = .done
        textField.frame = CGRect(x: 15, y: 0, w: ScreenSize.width-15, h: inputH)
        backView.addSubview(textField)
    }
    
}

extension BFAddNewTagsController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text != nil && !textField.text!.isEmpty {
            tagsValueChanged = true
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveTag()
        return true
    }
}
