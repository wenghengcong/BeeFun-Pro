//
//  CPFilterTableView.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/12/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

protocol CPFilterTableViewProtocol {

    func didSelectTypeColoumn(_ row:Int ,type:String ,value:String)
    func didSelectValueColoumn(_ row:Int ,type:String ,value:String)

}

public enum CPFilterTableViewColumns:Int {
    
    case two = 2
    case three = 3
    
}

class CPFilterTableView: UIView {

    let cellID = "FilterCell"

    var filterDelegate:CPFilterTableViewProtocol?
    
    var coloumn:CPFilterTableViewColumns = .two {
        
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
    
    var filterTypes:[String] = []

    var filterData:[[String]] = [[]]{
        
        didSet {
            resetAllColoumnsData()
        }
        
    }
    
    var selTypeIndex = 0
    var lastTypeIndex = 0
    
    var selFirValueIndex = 0
    var selSecValueIndex = 0

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
        
        for index in 0...coloumn.rawValue-1 {

            let tableView = tableviews[index]
            let width = rowWidths[index]
            if(index == 0){
                tableView.frame = CGRect(x: 0, y: 0, width: width, height: self.height)
                tableView.backgroundColor = UIColor.viewBackgroundColor
            }else{
                let lastTableview = tableviews[index-1]
                tableView.frame = CGRect(x: lastTableview.right, y: 0, width: width, height: 260)
                tableView.backgroundColor = UIColor.white
            }
            
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorStyle = .none
            tableView.rowHeight = rowHeights[index]
            tableView.register(UITableViewCell.self, forCellReuseIdentifier:cellID)
            
        }
        
        let bottomView = UIView(frame:CGRect(x: 0, y: firTableView!.bottom, width: width, height: 10))
        bottomView.backgroundColor = UIColor.cpRedColor
        self.addSubview(bottomView)
    }
    
    func filterViewInit(){
        ftv_customView()
        
    }
    
    func resetAllColoumnsData(){
        
        if (firTableView != nil) {
            firTableView!.reloadData()
        }
        
        if (secTableView != nil) {
            secTableView!.reloadData()
        }
        
    }
    
    func resetOtherColoumnsData(_ selindex:Int){
        
        secTableView!.reloadData()
    }
    
    func resetProperty() {
        selTypeIndex = 0
        lastTypeIndex = 0
        selFirValueIndex = 0
        selSecValueIndex = 0
    }
    
}

extension CPFilterTableView:UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (filterTypes.count <= 0) {
            return 0
        }
        
        if (filterData.count <= 0) {
            return 0
        }
        
        if(tableView == firTableView){
            return filterTypes.count
        }else{
            return filterData[selTypeIndex].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        var cellText = ""

        if(tableView == firTableView){
            cellText = filterTypes[(indexPath as NSIndexPath).row]
        }else{
            cellText = filterData[selTypeIndex][(indexPath as NSIndexPath).row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        cell.textLabel?.textColor = UIColor.labelTitleTextColor

        if(tableView == firTableView){
            
            cell.backgroundColor = UIColor.viewBackgroundColor
            cell.textLabel!.font = UIFont.systemFont(ofSize: 14.0)
            cell.addSingleBorder(UIColor.lineBackgroundColor, linewidth: 0.5, at: .bottom)
            cell.addSingleBorder(UIColor.lineBackgroundColor, linewidth: 0.5, at: .right)
            
            if((indexPath as NSIndexPath).row == selTypeIndex){
                cell.backgroundColor = UIColor.white
                cell.removeBorder(.right)
                cell.textLabel?.textColor = UIColor.cpRedColor
            }
            
        }else{
            cell.textLabel!.font = UIFont.systemFont(ofSize: 12.0)
            cell.selectionStyle = .none
            
            let selValueIndex = (selTypeIndex == 0) ? selFirValueIndex : selSecValueIndex
            if((indexPath as NSIndexPath).row == selValueIndex){
                cell.textLabel?.textColor = UIColor.cpRedColor
            }
            
        }
        cell.textLabel!.text = cellText
        return cell
            
        
    }
    

}

extension CPFilterTableView:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (tableView == firTableView){
            return rowHeights[0]
        }
        
        return rowHeights[1]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (tableView == firTableView){
            selTypeIndex = (indexPath as NSIndexPath).row
        }else{
            if (selTypeIndex == 0) {
                selFirValueIndex = (indexPath as NSIndexPath).row
            }else{
                selSecValueIndex = (indexPath as NSIndexPath).row
            }
        }

        let indexOfTableviews = (tableView == firTableView) ? 0:1
        
        let type = filterTypes[selTypeIndex]
        let selValueIndex = (selTypeIndex == 0) ? selFirValueIndex : selSecValueIndex
        let value = filterData[selTypeIndex][selValueIndex]
        
        resetAllColoumnsData()
        
        if(filterDelegate != nil){
            if (indexOfTableviews == 0 ) {
                filterDelegate?.didSelectTypeColoumn((indexPath as NSIndexPath).row, type: type, value: value)
            }else if(indexOfTableviews == 1){
                filterDelegate?.didSelectValueColoumn((indexPath as NSIndexPath).row, type: type, value: value)
            }
            
        }
        
    }
}
