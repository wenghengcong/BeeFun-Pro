//
//  ListScrollView.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/5/10.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

class ListScrollView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    let cellID = "ListCellIdentifier"

    /// list列表数据源
    var lists: [ String ] = [] {
        didSet {
            reload()
        }
    }
    
    /// 可能没有选中，默认选中第一个并不合适
    var selIndex: Int?
    
    var listTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(listTableView)
        backgroundColor = UIColor.bfViewBackgroundColor
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.separatorStyle = .none
//        listTableView.backgroundColor = UIColor.bfViewBackgroundColor
        if #available(iOS 11, *) {
            listTableView.estimatedRowHeight = 0
            listTableView.estimatedSectionHeaderHeight = 0
            listTableView.estimatedSectionFooterHeight = 0
        }
        listTableView.register(UITableViewCell.self, forCellReuseIdentifier:cellID)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reload() {
        listTableView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        listTableView.frame = CGRect(x: 0, y: 0, w: frame.width, h: frame.height)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.backgroundColor = UIColor.white
        cell.textLabel?.textColor = UIColor.black
//        cell.textLabel?.numberOfLines = 0
        cell.textLabel!.font = UIFont.bfSystemFont(ofSize: 17.0)
        cell.textLabel?.adjustFontSizeToFitWidth(minScale: 0.5)
        cell.addBorderSingle(UIColor.bfLineBackgroundColor, width: 0.5, at: .bottom)
        cell.addBorderSingle(UIColor.bfLineBackgroundColor, width: 0.5, at: .right)
        if selIndex != nil && indexPath.row == selIndex {
            cell.backgroundColor = UIColor.hex("e2e2e2", alpha: 1.0)
            cell.removeBorder(.right)
            cell.textLabel?.textColor = UIColor.bfRedColor
        }
        cell.textLabel?.text = lists[indexPath.row]
        return cell
    }
    
    //delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return designBy4_7Inch(40)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selIndex = indexPath.row
        reload()
    }
    
}
