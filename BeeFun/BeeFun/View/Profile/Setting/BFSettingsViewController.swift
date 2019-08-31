//
//  BFSettingsViewController.swift
//  BeeFun
//
//  Created by WengHengcong on 3/16/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

class BFSettingsViewController: BFBaseViewController {

    var logOutBtn: UIButton! = UIButton()

    var settingsArr: [[JSCellModel]] = []

    override func viewDidLoad() {
        self.title = "Settings".localized
        super.viewDidLoad()

        psvc_setupTableView()
        psvc_customView()
        psvc_readPlist()

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
        _ = self.navigationController?.popViewController(animated: true)
    }

    func psvc_customView() {

        logOutBtn.setTitle("Log Out".localized, for: .normal)
        logOutBtn.setTitle("Log Out".localized, for: .highlighted)
        logOutBtn.setTitleColor(UIColor.white, for: .normal)
        logOutBtn.setTitleColor(UIColor.white, for: .highlighted)
        logOutBtn.titleLabel?.font = UIFont.bfSystemFont(ofSize: 15.0)
        logOutBtn.backgroundColor = UIColor.bfRedColor
        logOutBtn.radius = 3.0
        logOutBtn.addTarget(self, action: #selector(BFSettingsViewController.psvc_logoutAction), for: UIControlEvents.touchUpInside)
        self.view.addSubview(logOutBtn)

        let logX: CGFloat = 10
        let logW = ScreenSize.width-2*logX
        let logY = tableView.bottom + 37.0
        let logH: CGFloat = 40
        logOutBtn.frame = CGRect(x: logX, y: logY, w: logW, h: logH)
    }

    func psvc_setupTableView() {

        refreshHidden = .none
        self.view.addSubview(self.tableView)
        self.tableView.frame = CGRect(x: 0, y: topOffset, w: ScreenSize.width, h: 253)
        self.tableView.isScrollEnabled = false
        self.automaticallyAdjustsScrollViewInsets = false
    }

    func psvc_readPlist() {
        settingsArr = BFGlobalHelper.readSettsingPlist("BFSetting")
    }

    @objc func psvc_logoutAction() {

        if !UserManager.shared.isLogin {
            JSMBHUDBridge.showText(kLoginFirstTip, view: self.view)
            return
        }

        let alertVC = UIAlertController(title: "Log Out".localized + "?", message: "", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { (_) in
            // ...
        }
        alertVC.addAction(cancelAction)

        let OKAction = UIAlertAction(title: "Sure".localized, style: .default) { (_) in
            UserManager.shared.userSignOut()
            NotificationCenter.default.post(name: NSNotification.Name.BeeFun.DidLogout, object:nil)
            _ = self.navigationController?.popViewController(animated: true)

        }
        alertVC.addAction(OKAction)
        self.present(alertVC, animated: true) {
            // ...
        }

    }

}

extension BFSettingsViewController {

    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsArr.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionArr = settingsArr[section]
        return sectionArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let section = (indexPath as NSIndexPath).section
        let row = indexPath.row
        let sectionOfSetting = settingsArr[section]
        let settings: JSCellModel = settingsArr[section][row]
        
        let cellId = "SettingsBaseCellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? JSBaseCell
        if cell == nil {
            cell = JSCellFactory.cell(type:settings.type!) as? JSBaseCell
        }

        if settings.identifier == "version" {
            settings.value = JSApp.appVersion
        }
        cell!.model = settings
        cell?.bothEndsLine(row, all: sectionOfSetting.count)
        return cell!
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: 15))
        view.backgroundColor = UIColor.bfViewBackgroundColor
        return view

    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

}

extension BFSettingsViewController {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let section = (indexPath as NSIndexPath).section
        let row = indexPath.row
        let settings: JSCellModel = settingsArr[section][row]

        let viewType = settings.identifier!

        if viewType == "language" {
            let viewValue = settings.value
            if viewValue == "切换到英语" {

                let alertController = UIAlertController(title: "切换到英语?", message: "Tha app shows in English", preferredStyle: .alert)

                let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
                    // ...
                }
                alertController.addAction(cancelAction)

                let OKAction = UIAlertAction(title: "确定", style: .default) { (_) in
                    JSLanguage.setEnglish()
                    JSLanguage.synchronize()
                    self.reloadAllResource()
                    self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(OKAction)

                self.present(alertController, animated: true) {
                    // ...
                }

            } else if viewValue == "Change to Chinese" {

                let alertController = UIAlertController(title: "Change to Chinese?", message: "App将会显示成中文", preferredStyle: .alert)

                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
                    // ...
                }
                alertController.addAction(cancelAction)

                let OKAction = UIAlertAction(title: "Sure", style: .default) { (_) in
                    JSLanguage.setChinese()
                    JSLanguage.synchronize()
                    self.reloadAllResource()
                    self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(OKAction)

                self.present(alertController, animated: true) {
                    // ...
                }

            }
        } else if viewType == "rate" {

            JSApp.rateUs()

        } else if viewType == "about" {
            let aboutVC = BFAboutViewController()
            self.navigationController?.pushViewController(aboutVC, animated: true)
        }

    }
}

extension BFSettingsViewController {

    func reloadAllResource() {
        self.tableView.reloadData()
        BFTabbarManager.jsTabbarController?.reload()
    }

}
