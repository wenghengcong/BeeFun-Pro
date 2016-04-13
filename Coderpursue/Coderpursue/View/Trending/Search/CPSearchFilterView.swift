//
//  CPSearchFilterView.swift
//  Coderpursue
//
//  Created by WengHengcong on 4/9/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

protocol CPSearchFilterViewProtcocol {
    
    func didBeginSearch(para:[String:Int])
    func showContentView(show:Bool)

}

class CPSearchFilterView: UIView {

    var searchParaDelegate:CPSearchFilterViewProtcocol?
    
    let cellID = "SearchFilterCell"
    
    var tableView:UITableView = UITableView()
    var contentView = UIView()
    
    var paraBtnH:CGFloat = 40.0
    var contengH:CGFloat = 0.0
    
    var selParaIndex = 0    //current select para index
    var selValueDic:[String:Int] = [:]
    
    var paraBtns:[UIButton] = []
    
    var filterPara:[String] = [] {
        didSet {
            for item in filterPara {
                selValueDic[item] = 0
            }
        }
    }
    
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
        
        self.backgroundColor = UIColor.viewBackgroundColor()

        let column = filterPara.count
        let btnW:CGFloat = width/CGFloat(column)
        
        for index in 0...filterPara.count-1 {
            
            let btnX = CGFloat(index)*btnW

            let paraBtn = UIButton.init(frame: CGRectMake(btnX, 0, btnW, paraBtnH))
            paraBtn.addOnePixelAroundBorder(UIColor.lightGrayColor())
            paraBtn.titleLabel?.textAlignment = .Center
            paraBtn.setImage(UIImage(named: "arrow_down"), forState: .Normal)
            paraBtn.setImage(UIImage(named: "arrow_down"), forState: .Highlighted)

            paraBtn.setImage(UIImage(named: "arrow_up"), forState: .Selected)
            paraBtn.setTitleColor(UIColor.cpBlackColor(), forState: .Normal)
            paraBtn.setTitleColor(UIColor.cpRedColor(), forState: .Selected)
            paraBtn.setTitle(filterPara[index], forState: .Normal)
            paraBtn.titleLabel?.font = UIFont.middleSizeSystemFont()
            paraBtn.tag = index
            paraBtn.addTarget(self, action:#selector(clickParaBtnAction(_:)), forControlEvents: .TouchUpInside)
            paraBtn.backgroundColor = UIColor.whiteColor()
            
            paraBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -paraBtn.imageView!.width, 0, paraBtn.imageView!.frame.size.width);
            paraBtn.imageEdgeInsets = UIEdgeInsetsMake(0, paraBtn.titleLabel!.width+15, 0, -paraBtn.titleLabel!.width);
            
            paraBtns.append(paraBtn)
            
            self.addSubview(paraBtn)
            
        }
        
        contengH = self.height-paraBtnH
        contentView.frame = CGRectMake(0, paraBtnH, width, contengH)
        contentView.backgroundColor = UIColor.whiteColor()
        
        let actionBtnH:CGFloat = 40
        
        tableView.frame = CGRectMake(0, 0, width,contentView.height-actionBtnH)
        tableView.backgroundColor = UIColor.viewBackgroundColor()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .SingleLine
        tableView.rowHeight = 44
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:cellID)
        contentView.addSubview(tableView)

        
        let footView = UIView.init(frame: CGRectMake(0, tableView.bottom, width, actionBtnH))
        
        let resetBtn = UIButton.init(frame: CGRectMake(0, 0, width/2, actionBtnH))
        resetBtn.setTitle("Reset", forState: .Normal)
        resetBtn.setTitleColor(UIColor.cpBlackColor(), forState: .Normal)
        resetBtn.backgroundColor = UIColor.whiteColor()
        resetBtn.addTarget(self, action: #selector(CPSearchFilterView.resetParaAction), forControlEvents: .TouchUpInside)
        footView.addSubview(resetBtn)
        
        let sureBtn = UIButton.init(frame: CGRectMake(width/2,0, width/2, actionBtnH))
        sureBtn.setTitle("Sure", forState: .Normal)
        sureBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        sureBtn.backgroundColor = UIColor.cpRedColor()
        sureBtn.addTarget(self, action: #selector(CPSearchFilterView.sureAction), forControlEvents: .TouchUpInside)
        
        footView.addSubview(sureBtn)
        contentView.addSubview(footView)
        
        self.addSubview(contentView)
        
        self.frame = CGRectMake(0,64,width,paraBtnH)
        contentView.hidden = true
    }
    
    func hiddenContentView(hidden:Bool) {
        
        if hidden {
            
            self.frame = CGRectMake(0,64,self.width,self.paraBtnH)
            self.contentView.hidden = hidden
            
        }else{
            
            self.frame = CGRectMake(0,64,self.width,self.paraBtnH+self.contengH)
            self.contentView.frame = CGRectMake(0, self.paraBtnH, self.width, self.contengH)
            self.contentView.hidden = hidden
            
        }
        
    }
    
    
    func clickParaBtnAction(sender:UIButton?){
        
        if let btn = sender {
            btn.selected = !btn.selected
            selParaIndex = btn.tag
            
            let str = btn.selected ? "selected" : "unselected"
            print("\(str)")
            if btn.selected {
                hiddenContentView(false)
                tableView.reloadData()
            }else{
                hiddenContentView(true)
            }
            
            for paraBtn in paraBtns {
                if paraBtn.tag != selParaIndex {
                    paraBtn.selected = false
                }
            }
            
            if searchParaDelegate != nil {
                searchParaDelegate?.showContentView(btn.selected)
            }
            
        }
        
    }
    
    func resetParaAction() {
        
        for (selPara, _) in selValueDic {
            selValueDic[selPara] = 0
        }
        tableView.reloadData()
        sureAction()
    }
    
    func sureAction() {
        
        if searchParaDelegate != nil {
            hiddenContentView(true)
            for paraBtn in paraBtns {
                paraBtn.selected = false
            }
            searchParaDelegate?.didBeginSearch(selValueDic)
            searchParaDelegate?.showContentView(false)
        }
        
    }
    
    
}

extension CPSearchFilterView:UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (filterData.count <= 0) {
            return 0
        }
        return filterData[selParaIndex].count

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
        cell.textLabel?.textColor = UIColor.labelTitleTextColor()
        cell.backgroundColor = UIColor.viewBackgroundColor()
        cell.textLabel!.font = UIFont.systemFontOfSize(14.0)
        cell.textLabel?.textAlignment = .Center
        cell.selectionStyle = .None
        
        let currentPara = filterPara[selParaIndex]
        let selValueIndex = selValueDic[currentPara]
        if(indexPath.row == selValueIndex){
            cell.backgroundColor = UIColor.whiteColor()
            cell.textLabel?.textColor = UIColor.cpRedColor()
        }
        
        //make the seperator line is full width
//        if cell.respondsToSelector(Selector("setSeparatorInset:")) {
//            cell.separatorInset = UIEdgeInsetsZero
//        }
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
        cell.textLabel!.text = filterData[selParaIndex][indexPath.row]
        
        return cell
    }
    

}

extension CPSearchFilterView:UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let currentPara = filterPara[selParaIndex]
        selValueDic[currentPara] = indexPath.row
        print(selValueDic)
        tableView.reloadData()
        
    }
}
