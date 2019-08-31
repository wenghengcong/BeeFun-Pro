//
//  SESearchViewController.swift
//  BeeFun
//
//  Created by WengHengcong on 01/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit

/// 搜索模块：SE前缀
class SESearchViewController: BFBaseViewController {

    lazy var searchBar = JSSearchBar(frame: CGRect(x: 10, y: 0, width: ScreenSize.width-100, height: 28))
    
    lazy var historyTable = UITableView()
    let cellID = "History"
    
    var historyData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        svc_setupNavBar()
        svc_setupHistoryTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        svc_loadHistoryData()
    }

    // MARK: - Data
    func svc_loadHistoryData() {
        if let values: [String] = BFUserDefaultManager.shared.searchHistory {
            historyData = values
            if historyData.isEmpty {
                historyTable.isHidden = true
            } else {
                historyTable.reloadData()
            }
        }
    }

    // MARK: - Action
    override func leftItemAction(_ sender: UIButton?) {
        svc_dismissSearchKeyboard()
        svc_jumpToTrendingPage()
    }
    
    @objc func svc_clearAllRecords() {
        
        let alertController = UIAlertController(title: "Clear all history records?".localized, message:nil, preferredStyle: .alert)
        
        alertController.addAction(title: "Cancel".localized, style: .cancel, handler: { (_) in
        })
        
        alertController.addAction(title: "Sure".localized, style: .default, handler: { (_) in
            let empty: [String] = []
            BFUserDefaultManager.shared.searchHistory = empty
            self.svc_loadHistoryData()
        })
        self.present(alertController, animated: true, completion: {
            
        })
    }
    
    override func rightItemAction(_ sender: UIButton?) {
        svc_dismissSearchKeyboard()
        svc_jumpToTrendingPage()
    }
    
    func svc_jumpToTrendingPage() {
        //返回到首页
        if  let stackNv = navigationController?.viewControllers {
            for vc in stackNv {
                if vc.isKind(of: BFTrendingController.self) {
                    _ = navigationController?.popToViewController(vc, animated: true)
                }
            }
        }
    }
    
    func svc_jumpSearchResultPage(searchKey: String?) {
        let resultVC = SESearchResultController()
        resultVC.hidesBottomBarWhenPushed = true
        resultVC.searchKey = searchBar.text ?? "BeeFun"
        navigationController?.pushViewController(resultVC, animated: true)
    }
}
// MARK: - Tableview Delegate
extension SESearchViewController {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        svc_dismissSearchKeyboard()
        let selRecord = historyData[indexPath.row]
        if !selRecord.isEmpty {
            searchBar.text = selRecord
            svc_jumpSearchResultPage(searchKey: selRecord)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let bgV = UIView()
            bgV.frame = CGRect(x: 0, y: 0, w: ScreenSize.width, h: 36)
            bgV.addBorderSingle(at: .bottom)
            
            let historyL = UILabel()
            historyL.frame = CGRect(x: 15, y: 5, w: ScreenSize.width, h: 28)
            historyL.text = "Historical records".localized
            bgV.addSubview(historyL)
            
            return bgV
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let bgV = UIView()
            bgV.frame = CGRect(x: 0, y: 20, w: ScreenSize.width, h: 35)
            
            let clearAllBtn = UIButton()
            let x: CGFloat = 45
            clearAllBtn.frame = CGRect(x: x, y: 20, w: ScreenSize.width-2*x, h: 35)
            clearAllBtn.backgroundColor = UIColor.bfRedColor
            clearAllBtn.layer.cornerRadius = 4.0
            clearAllBtn.layer.masksToBounds = true
            clearAllBtn.setTitleColor(UIColor.white, for: .normal)
            clearAllBtn.addTarget(self, action: #selector(svc_clearAllRecords), for: .touchUpInside)
            clearAllBtn.titleLabel?.font = UIFont.bfSystemFont(ofSize: 17.0)
            clearAllBtn.setTitle("Clear All Records".localized, for: .normal)
            bgV.addSubview(clearAllBtn)
            
            return bgV
        }
        return nil
    }
    
}

// MARK: - Tableview Datasource
extension SESearchViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? BFSwipeCell
        if cell == nil {
            cell = BFSwipeCell(style: .default, reuseIdentifier: cellID)
        }
        cell?.textLabel?.text = historyData[indexPath.row]
        cell?.textLabel?.textColor = UIColor.bfLabelSubtitleTextColor
//        cell?.delegate = self
        cell?.setBothEndsLines(indexPath.row, all: historyData.count)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && historyData.count > 0 {
            return 36
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 && historyData.count > 0 {
            return 35
        }
        return 0
    }
}

extension SESearchViewController: UISearchBarDelegate {
    
    func svc_dismissSearchKeyboard() {
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
        view.endEditing(true)
        view.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        svc_dismissSearchKeyboard()
        svc_saveSearchKey()
        svc_jumpSearchResultPage(searchKey: searchBar.text)
    }
    
    func svc_saveSearchKey() {
        if searchBar.text != nil && searchBar.text!.length > 0 {
            if !historyData.contains(searchBar.text!) {
                //未包含
                historyData.append(searchBar.text!)
                BFUserDefaultManager.shared.searchHistory = historyData
            }
        }
    }
    
}

// MARK: - Scroll Delegate
extension SESearchViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}
