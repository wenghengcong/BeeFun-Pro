//
//  BFFeedbackController.swift
//  BeeFun
//
//  Created by 翁恒丛 on 2018/7/4.
//  Copyright © 2018年 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper

class BFFeedbackController: BFBaseViewController {
    
    var titleTextField: UITextField = UITextField()
    var contentTextView: UITextView = UITextView()
    var submitBtn: UIButton = UIButton()
    
    override func viewDidLoad() {
        needShowReloadView = false
        needShowEmptyView = false
        needShowLoginView = false
        title = "Feedback".localized
        super.viewDidLoad()
        fc_navBar()
        fc_customeView()
    }
    
    override func leftItemAction(_ sender: UIButton?) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func rightItemAction(_ sender: UIButton?) {
        let feedIssueVc = BFFeedbackIssueController()
        feedIssueVc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(feedIssueVc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func fc_navBar() {
        if let login = UserManager.shared.login, login == BFFeedbackManager.shared.adminLogin {
            rightItem?.isHidden = false
            rightItem?.setTitle("View", for: .normal)
        }
    }
    
    func fc_customeView() {
        
        let topBegin: CGFloat = topOffset + 10
        let inputH: CGFloat = 50
        let leftMargin: CGFloat = 10
        let contentWidth: CGFloat = ScreenSize.width - 2*leftMargin
        
        titleTextField.placeholder = "bug? function？...".localized
        titleTextField.radius = 5.0
        titleTextField.borderStyle = .roundedRect
        titleTextField.backgroundColor = UIColor.white
        titleTextField.font = UIFont.bfSystemFont(ofSize: 17.0)
        titleTextField.textColor = UIColor.iOS11Black
        titleTextField.clearButtonMode = .always
        titleTextField.returnKeyType = .done
        titleTextField.frame = CGRect(x: leftMargin, y: topBegin, w: contentWidth, h: inputH)
        view.addSubview(titleTextField)
        
        var minusHeight: CGFloat = 80
        if ScreenSize.height <= 568 {
            minusHeight = 180
        }
        let contentH: CGFloat = ScreenSize.height-topOffset-60-60-minusHeight
        contentTextView.font = UIFont.bfSystemFont(ofSize: 17.0)
        contentTextView.backgroundColor = UIColor.white
        contentTextView.radius = 5.0
        contentTextView.textColor = UIColor.iOS11Black
        contentTextView.frame = CGRect(x: leftMargin, y: titleTextField.bottom + 10, w: contentWidth, h: contentH)
        view.addSubview(contentTextView)
        
        submitBtn.setTitle("Submit".localized, for: .normal)
        submitBtn.setTitle("Submit".localized, for: .highlighted)
        submitBtn.setTitleColor(UIColor.white, for: .normal)
        submitBtn.setTitleColor(UIColor.white, for: .highlighted)
        submitBtn.titleLabel?.font = UIFont.bfSystemFont(ofSize: 20.0)
        submitBtn.backgroundColor = UIColor.bfRedColor
        submitBtn.radius = 5.0
        submitBtn.frame = CGRect(x: leftMargin, y: contentTextView.bottom + 35, w: contentWidth, h: 50)
        submitBtn.addTarget(self, action: #selector(fc_uploadAction), for: UIControlEvents.touchUpInside)
        view.addSubview(submitBtn)
    }
    
    @objc func fc_uploadAction() {
        if titleTextField.text == nil || titleTextField.text!.isEmpty {
            JSMBHUDBridge.showText("Title can't be empty".localized)
            return
        }
        uploadFeedback()
    }
}

extension BFFeedbackController: UITextFieldDelegate {
    
}

extension BFFeedbackController: UITextViewDelegate {
    
}

// MARK: - upload feedback to repo
extension BFFeedbackController {
    
    func uploadFeedback() {

        var body: [String: String] = [:]
        if let title = titleTextField.text {
            body["title"] = title
        }
        
        if let content = contentTextView.text {
            body["body"] = content
        }
        
        IssueProvider.sharedProvider.request(IssueAPI.createIssue(owner: "wenghengcong", repo: "BeeFunFeedback", body: body)) { (result) in
            switch result {
            case let .success(response):
                let statusCode = response.statusCode
                if statusCode == BFStatusCode.created.rawValue {
                    _ = self.navigationController?.popViewController(animated: true)
                } else {
                    JSMBHUDBridge.showInfo(kNetworkErrorTip)
                }
            case .failure:
                break
            }
        }
    }
}
