//
//  CPSearchFilterView.swift
//  Coderpursue
//
//  Created by WengHengcong on 4/9/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

protocol CPSearchFilterViewProtcocol {
    
    func didBeginSearch(_ para:[String:Int])
    func showContentView(_ show:Bool)

}

class CPSearchFilterView: UIView {

    var searchParaDelegate:CPSearchFilterViewProtcocol?
    
    let cellID = "SearchFilterCell"
    
    var tableView:UITableView = UITableView()
    var contentView = UIView()
    
    /// 筛选项一行的高度
    var paraBtnH:CGFloat = 40.0
    
    /// 筛选具体选项数据展示的高度
    var contengH:CGFloat = 0.0
    
    var selParaIndex = 0    //current select para index

    /// 筛选后得到的字典{[选项：选项序]}，比如：{[语言：1]}
    var selValueDic:[String:Int] = [:]
    
    //顶部一排的筛选选项按钮
    var paraBtns:[UIButton] = []
    
    /// 筛选项，比如“Language”和"Sort"
    var filterPara:[String] = [] {
        didSet {
            for item in filterPara {
                selValueDic[item] = 0
            }
        }
    }
    
    /// 筛选项对应的选项数据，需要跟筛选项对应
    var filterData:[[String]] = [[]] {
        didSet {
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        ftv_customView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func sfv_customView() {
        
        self.backgroundColor = UIColor.viewBackgroundColor

        let column = filterPara.count
        let btnW:CGFloat = width/CGFloat(column)
        
        for index in 0...filterPara.count-1 {
            
            let btnX = CGFloat(index)*btnW

            let paraBtn = UIButton.init(frame: CGRect(x: btnX, y: 0, width: btnW, height: paraBtnH))
            paraBtn.addOnePixelAroundBorder(UIColor.lightGray)
            paraBtn.titleLabel?.textAlignment = .center
            paraBtn.setImage(UIImage(named: "arrow_down"), for: UIControlState())
            paraBtn.setImage(UIImage(named: "arrow_down"), for: .highlighted)

            paraBtn.setImage(UIImage(named: "arrow_up"), for: .selected)
            paraBtn.setTitleColor(UIColor.cpBlackColor, for: UIControlState())
            paraBtn.setTitleColor(UIColor.cpRedColor, for: .selected)
            paraBtn.setTitle(filterPara[index], for: UIControlState())
            paraBtn.titleLabel?.font = UIFont.middleSizeSystemFont()
            paraBtn.tag = index
            paraBtn.addTarget(self, action:#selector(clickParaBtnAction(_:)), for: .touchUpInside)
            paraBtn.backgroundColor = UIColor.white
            
            paraBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -paraBtn.imageView!.width, 0, paraBtn.imageView!.frame.size.width);
            paraBtn.imageEdgeInsets = UIEdgeInsetsMake(0, paraBtn.titleLabel!.width+15, 0, -paraBtn.titleLabel!.width);
            
            paraBtns.append(paraBtn)
            
            self.addSubview(paraBtn)
            
        }
        
        contengH = self.height-paraBtnH
        contentView.frame = CGRect(x: 0, y: paraBtnH, width: width, height: contengH)
        contentView.backgroundColor = UIColor.white
        
        let actionBtnH:CGFloat = 40
        
        tableView.frame = CGRect(x: 0, y: 0, width: width,height: contentView.height-actionBtnH)
        tableView.backgroundColor = UIColor.viewBackgroundColor
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = 44
        tableView.register(UITableViewCell.self, forCellReuseIdentifier:cellID)
        contentView.addSubview(tableView)

        
        let footView = UIView.init(frame: CGRect(x: 0, y: tableView.bottom, width: width, height: actionBtnH))
        
        let resetBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: width/2, height: actionBtnH))
        resetBtn.setTitle("Reset".localized, for: UIControlState())
        resetBtn.setTitleColor(UIColor.cpBlackColor, for: UIControlState())
        resetBtn.backgroundColor = UIColor.white
        resetBtn.addTarget(self, action: #selector(CPSearchFilterView.resetParaAction), for: .touchUpInside)
        footView.addSubview(resetBtn)
        
        let sureBtn = UIButton.init(frame: CGRect(x: width/2,y: 0, width: width/2, height: actionBtnH))
        sureBtn.setTitle("Sure".localized, for: UIControlState())
        sureBtn.setTitleColor(UIColor.white, for: UIControlState())
        sureBtn.backgroundColor = UIColor.cpRedColor
        sureBtn.addTarget(self, action: #selector(CPSearchFilterView.sureAction), for: .touchUpInside)
        
        footView.addSubview(sureBtn)
        contentView.addSubview(footView)
        
        self.addSubview(contentView)
        
        self.frame = CGRect(x: 0,y: 64,width: width,height: paraBtnH)
        contentView.isHidden = true
    }
    
    func hiddenContentView(_ hidden:Bool) {
        
        if hidden {
            
            self.frame = CGRect(x: 0,y: 64,width: self.width,height: self.paraBtnH)
            self.contentView.isHidden = hidden
            
        }else{
            
            self.frame = CGRect(x: 0,y: 64,width: self.width,height: self.paraBtnH+self.contengH)
            self.contentView.frame = CGRect(x: 0, y: self.paraBtnH, width: self.width, height: self.contengH)
            self.contentView.isHidden = hidden
            
        }
        
    }
    
    
    /// 点击筛选项按钮
    ///
    /// - Parameter sender: <#sender description#>
    func clickParaBtnAction(_ sender:UIButton?){
        
        if let btn = sender {
            btn.isSelected = !btn.isSelected
            selParaIndex = btn.tag
            
            let str = btn.isSelected ? "selected" : "unselected"
            print("\(str)")
            if btn.isSelected {
                hiddenContentView(false)
                tableView.reloadData()
            }else{
                hiddenContentView(true)
            }
            
            for paraBtn in paraBtns {
                if paraBtn.tag != selParaIndex {
                    paraBtn.isSelected = false
                }
            }
            
            if searchParaDelegate != nil {
                searchParaDelegate?.showContentView(btn.isSelected)
            }
            
        }
        
    }
    
    /// 充值按钮
    func resetParaAction() {
        
        for (selPara, _) in selValueDic {
            selValueDic[selPara] = 0
        }
        tableView.reloadData()
        sureAction()
    }
    
    /// 确定按钮
    func sureAction() {
        
        if searchParaDelegate != nil {
            hiddenContentView(true)
            for paraBtn in paraBtns {
                paraBtn.isSelected = false
            }
            searchParaDelegate?.didBeginSearch(selValueDic)
            searchParaDelegate?.showContentView(false)
        }
        
    }
    
    
}

extension CPSearchFilterView:UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (filterData.count <= 0) {
            return 0
        }
        return filterData[selParaIndex].count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.textColor = UIColor.labelTitleTextColor
        cell.backgroundColor = UIColor.viewBackgroundColor
        cell.textLabel!.font = UIFont.systemFont(ofSize: 14.0)
        cell.textLabel?.textAlignment = .center
        cell.selectionStyle = .none
        
        //排序选项已经本地化
        let currentPara = filterPara[selParaIndex]
        let selValueIndex = selValueDic[currentPara]
        if((indexPath as NSIndexPath).row == selValueIndex){
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor.cpRedColor
        }
        
        //make the seperator line is full width
//        if cell.respondsToSelector(Selector("setSeparatorInset:")) {
//            cell.separatorInset = UIEdgeInsetsZero
//        }
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        cell.textLabel!.text = filterData[selParaIndex][(indexPath as NSIndexPath).row]
        
        return cell
    }
    

}

extension CPSearchFilterView:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    
    /// 点击具体某一个筛选项对应的选项
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - indexPath: <#indexPath description#>
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /// 获取选中的value，需要将其英文化
        let currentPara = filterPara[selParaIndex].localized
        selValueDic[currentPara] = (indexPath as NSIndexPath).row
        print(selValueDic)
        tableView.reloadData()
        
    }
}
