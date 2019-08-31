//
//  CPAboutViewController.swift
//  BeeFun
//
//  Created by WengHengcong on 3/16/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

class BFAboutViewController: BFBaseViewController {

    var logoImage: UIImageView! = UIImageView(image: UIImage(named: "app_logo_90"))
    var introTextV: UITextView! = UITextView()

    var allSettings: [[JSCellModel]] = []

    override func viewDidLoad() {
        self.title = "About".localized
        super.viewDidLoad()
        pavc_readPlist()
        pavc_setupTableView()
        pavc_customView()
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

    func pavc_setupTableView() {

        refreshHidden = .none
        self.tableView.isScrollEnabled = false
        self.automaticallyAdjustsScrollViewInsets = false

    }

    func pavc_customView() {

        self.view.addSubview(logoImage)
        self.view.addSubview(introTextV)

        let logoW: CGFloat = 90.0
        let logoX = (ScreenSize.width-logoW)/2.0
        let logoY: CGFloat = uiTopBarHeight+14.0
        logoImage.frame = CGRect(x: logoX, y: logoY, w: logoW, h: logoW)

        introTextV.font = UIFont.bfSystemFont(ofSize: 14.0)
        introTextV.textColor = UIColor.black
        introTextV.text = "  BeeFun is a client for github.It is written in Swift language. Welcome more suggestions and reports of bugs come from everyone! Thanks.".localized
        introTextV.isEditable = false

        let textY = logoImage.bottom + 12.0
        introTextV.frame = CGRect(x: 0, y: textY, w: ScreenSize.width, h: 80.0)

        self.view.addSubview(tableView)
        let tableY = introTextV.bottom + 15
        let tableH = ScreenSize.height-tableY
        self.tableView.frame = CGRect(x: 0, y: tableY, w: ScreenSize.width, h: tableH)
    }

    func pavc_readPlist() {
        allSettings = BFGlobalHelper.readSettsingPlist("BFAbout")
    }
}

extension BFAboutViewController {

    func numberOfSections(in tableView: UITableView) -> Int {
        return allSettings.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let sectionArr = allSettings[section]
        return sectionArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = (indexPath as NSIndexPath).section
        let row = indexPath.row
        let rowOfSettings: JSCellModel = allSettings[section][row]
        let sectionOfSettings = allSettings[section]

        var cell = tableView.dequeueReusableCell(withIdentifier: "AboutJSLabelCellIdentifier") as? JSLabelCell
        if cell == nil {
            cell = JSCellFactory.cell(type: rowOfSettings.type!) as? JSLabelCell
        }

        cell!.model = rowOfSettings
        cell?.bothEndsLine(row, all: sectionOfSettings.count)

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

extension BFAboutViewController {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = (indexPath as NSIndexPath).section
        let row = indexPath.row
        let settings: JSCellModel = allSettings[section][row]

        let viewType = settings.identifier!
        var url = ""

        if viewType == "openlib" {
//            self.performSegueWithIdentifier(SegueTrendingShowRepositoryDetail, sender: nil)
        } else if viewType == "website" {
//            self.performSegueWithIdentifier(SegueTrendingShowRepositoryDetail, sender: nil)
        } else if viewType == "beefun" {
            url = AppOfficeSite
        } else if viewType == "me" {
            url = "https://github.com/wenghengcong"
        }
        
        JumpManager.shared.jumpWebView(url: url)
    }

}
