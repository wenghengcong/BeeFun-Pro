//
//  CPFilterTableView.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/12/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit


/// 筛选视图的协议方法
protocol CPFilterTableViewProtocol {

    /// 选中了筛选视图中的类型
    ///
    /// - Parameters:
    ///   - row: <#row description#>
    ///   - type: <#type description#>
    ///   - value: <#value description#>
    func didSelectTypeColoumn(_ row:Int ,type:String ,value:String)
    
    /// 选中了筛选视图中的值
    ///
    /// - Parameters:
    ///   - row: <#row description#>
    ///   - type: <#type description#>
    ///   - value: <#value description#>
    func didSelectValueColoumn(_ row:Int ,type:String ,value:String)

}

/// 筛选视图的列数
///
/// - two: 两列
/// - three: 三列
public enum CPFilterTableViewColumns:Int {
    
    case two = 2
    case three = 3
    
}

/// 筛选视图
class CPFilterTableView: UIView {

    let cellID = "FilterCell"

    var filterDelegate:CPFilterTableViewProtocol?
    
    
    /// 筛选视图的列数
    var coloumn:CPFilterTableViewColumns = .two {
        
        didSet{
//            fvc_FilterViewInit()
        }
    }
    
    
    /// 每行的宽度组合(多个tableview)
    var rowWidths:[CGFloat] = [0,0] {
        didSet {
            
        }
    }
    
    
    /// 每行的高度组合(多个tableview)
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
    
    /// 当前选中的类型
    var selTypeIndex = 0
    
    /// 上一次选中的类型
    var lastTypeIndex = 0
    
    
    var selFirValueIndex = 0
    var selSecValueIndex = 0

    /// 类型Table
    var firTableView:UITableView?
    
    /// 值Table
    var secTableView:UITableView?    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        ftv_customView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func ftv_customView(){
        
        //如果column的数目与当前的宽度组合数目不对，直接返回
        if( (coloumn.rawValue != rowWidths.count) || (coloumn.rawValue != rowHeights.count)  ){
            
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
    
    /// 重新加载所有数据
    func resetAllColoumnsData(){
        
        if (firTableView != nil) {
            firTableView!.reloadData()
        }
        
        if (secTableView != nil) {
            secTableView!.reloadData()
        }
        
    }
    
    
    /// 重置类型表格之外的所有数据
    ///
    /// - Parameter selindex: <#selindex description#>
    func resetOtherColoumnsData(_ selindex:Int){
        
        secTableView!.reloadData()
    }
    
    
    /// 重置所有属性
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
            cellText = filterTypes[indexPath.row]
        }else{
            cellText = filterData[selTypeIndex][indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        cell.textLabel?.textColor = UIColor.labelTitleTextColor

        if(tableView == firTableView){
            
            cell.backgroundColor = UIColor.viewBackgroundColor
            cell.textLabel!.font = UIFont.systemFont(ofSize: 14.0)
            cell.addSingleBorder(UIColor.lineBackgroundColor, linewidth: 0.5, at: .bottom)
            cell.addSingleBorder(UIColor.lineBackgroundColor, linewidth: 0.5, at: .right)
            
            if(indexPath.row == selTypeIndex){
                cell.backgroundColor = UIColor.white
                cell.removeBorder(.right)
                cell.textLabel?.textColor = UIColor.cpRedColor
            }
            
        }else{
            cell.textLabel!.font = UIFont.systemFont(ofSize: 12.0)
            cell.selectionStyle = .none
            
            let selValueIndex = (selTypeIndex == 0) ? selFirValueIndex : selSecValueIndex
            if(indexPath.row == selValueIndex){
                cell.textLabel?.textColor = UIColor.cpRedColor
            }
            
        }
        
        //所有数据从Plist读取的时候，已经经过本地化了
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
            selTypeIndex = indexPath.row
        }else{
            if (selTypeIndex == 0) {
                selFirValueIndex = indexPath.row
            }else{
                selSecValueIndex = indexPath.row
            }
        }

        let indexOfTableviews = (tableView == firTableView) ? 0:1
        
        /// 其中的数据在传进来时，已经本地化
        let type = filterTypes[selTypeIndex].enLocalized
        let selValueIndex = (selTypeIndex == 0) ? selFirValueIndex : selSecValueIndex
        //其中的数据从plist中读取已经本地化
        let value = (filterData[selTypeIndex][selValueIndex]).enLocalized
        
        resetAllColoumnsData()
        
        if(filterDelegate != nil){
            if (indexOfTableviews == 0 ) {
                filterDelegate?.didSelectTypeColoumn(indexPath.row, type: type, value: value)
            }else if(indexOfTableviews == 1){
                filterDelegate?.didSelectValueColoumn(indexPath.row, type: type, value: value)
            }
            
        }
    }
}
