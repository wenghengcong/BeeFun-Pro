//
//  CPFilterTableView.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/12/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

protocol CPFilterTableViewProtocol {
    
    func didSelectColoumn(index:Int ,row:Int ,type:String ,value:String)
    
}

public enum CPFilterTableViewColumns:Int {
    
    case Two = 2
    case Three = 3
    
}

class CPFilterTableView: UIView {

    let cellID = "FilterCell"

    var filteDelegate:CPFilterTableViewProtocol?
    
    var coloumn:CPFilterTableViewColumns = .Two {
        
        didSet{
//            fvc_FilterViewInit()
        }
    }
    
    var rowWidths:[CGFloat] = [0,0] {
        didSet {
            
        }
    }
    
    var rowHeights:[CGFloat] = [0.0,0.0] {
        didSet {

        }
    }
    
    var firstArr:[String] = ["Language","Country"]

    var tabData:[[String]] = [[]]{
        
        didSet {

        }
        
    }
    
    var selTypeIndex = 0
    var selValueIndex = 0

    var firTableView:UITableView?
    var secTableView:UITableView?    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        ftv_customView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func ftv_customView(){
        
        if( (coloumn.rawValue != rowWidths.count) || (coloumn.rawValue != rowWidths.count)  ){
            
            print("check coloumns and the datasouce count is equal")
            return
        }
        
        for subs in self.subviews {
            subs.removeFromSuperview()
        }
        
        firTableView = UITableView()
        secTableView = UITableView()
        self.addSubview(firTableView!)
        self.addSubview(secTableView!)

        let tableviews = [firTableView!,secTableView!]
        
        for(var index = 0 ;index < coloumn.rawValue;index++){
            
            let tableView = tableviews[index]
            let width = rowWidths[index]
            if(index == 0){
                tableView.frame = CGRectMake(0, 0, width, self.height)
                tableView.backgroundColor = UIColor.viewBackgroundColor()
            }else{
                let lastTableview = tableviews[index-1]
                tableView.frame = CGRectMake(lastTableview.right, 0, width, 260)
                tableView.backgroundColor = UIColor.whiteColor()
            }
            
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorStyle = .None
            tableView.rowHeight = rowHeights[index]
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:cellID)
            
        }
        
        let bottomView = UIView(frame:CGRectMake(0, firTableView!.bottom, width, 10))
        bottomView.backgroundColor = UIColor.cpRedColor()
        self.addSubview(bottomView)
    }
    
    func filterViewInit(){
        
        ftv_customView()
        resetAllColoumnsData()
    }
    
    func resetAllColoumnsData(){
        
        firTableView!.reloadData()
        secTableView!.reloadData()
    }
    
    func resetOtherColoumnsData(selindex:Int){
        
        secTableView!.reloadData()
    }
    
    func resetProperty() {
        selTypeIndex = 0
        selValueIndex = 0
        resetAllColoumnsData()
    }
    
}

extension CPFilterTableView:UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(tableView == firTableView){
            return firstArr.count
        }else{
            return tabData[selTypeIndex].count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellText = ""

        if(tableView == firTableView){
            cellText = firstArr[indexPath.row]
        }else{
            cellText = tabData[selTypeIndex][indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
        
        cell.textLabel?.textColor = UIColor.labelTitleTextColor()

        if(tableView == firTableView){
            
            cell.backgroundColor = UIColor.viewBackgroundColor()
            cell.textLabel!.font = UIFont.systemFontOfSize(14.0)
            cell.addSingleBorder(UIColor.lineBackgroundColor(), linewidth: 0.5, at: .Bottom)
            cell.addSingleBorder(UIColor.lineBackgroundColor(), linewidth: 0.5, at: .Right)
            
            if(indexPath.row == selTypeIndex){
                cell.backgroundColor = UIColor.whiteColor()
                cell.removeBorder(.Right)
                cell.textLabel?.textColor = UIColor.cpRedColor()
            }
            
        }else{
            cell.textLabel!.font = UIFont.systemFontOfSize(12.0)
            cell.selectionStyle = .None
            
            if(indexPath.row == selValueIndex){
                cell.textLabel?.textColor = UIColor.cpRedColor()
            }
        }
        cell.textLabel!.text = cellText
        return cell
            
        
    }
    

}

extension CPFilterTableView:UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (tableView == firTableView){
            return rowHeights[0]
        }
        
        return rowHeights[1]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)

        if (tableView == firTableView){
            selTypeIndex = indexPath.row
        }else{
            selValueIndex = indexPath.row
        }

        cell?.backgroundColor = UIColor.whiteColor()
        cell?.removeBorder(.Right)
        cell?.textLabel?.textColor = UIColor.cpRedColor()
        resetAllColoumnsData()
        
        let indexOfTableviews = (tableView == firTableView) ? 0:1
        
        let type = firstArr[selTypeIndex]
        let value = tabData[selTypeIndex][selValueIndex]
        
        if(filteDelegate != nil){
            self.filteDelegate?.didSelectColoumn(indexOfTableviews, row: indexPath.row ,type: type,value: value)
        }
        
    }
}