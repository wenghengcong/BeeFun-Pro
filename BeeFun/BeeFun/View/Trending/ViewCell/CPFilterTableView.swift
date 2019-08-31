//
//  CPFilterTableView.swift
//  BeeFun
//
//  Created by WengHengcong on 3/12/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

/// 筛选视图的协议方法
protocol CPFilterTableViewProtocol: class {

    /// 选中了筛选视图中的类型
    ///
    /// - Parameters:
    ///   - row: <#row description#>
    ///   - type: <#type description#>
    func didSelectTypeColoumn(_ row: Int, type: String)

    /// 选中了筛选视图中的值
    ///
    /// - Parameters:
    ///   - row: <#row description#>
    ///   - type: <#type description#>
    ///   - value: <#value description#>
    func didSelectValueColoumn(_ row: Int, type: String, value: String)

    func didTapSinceTime(since: String)
}

/// 筛选视图的列数
///
/// - two: 两列
/// - three: 三列
public enum CPFilterTableViewColumns: Int {

    case two = 2
    case three = 3

}

/// 筛选视图
class CPFilterTableView: UIView {

    let cellID = "FilterCell"

    weak var filterDelegate: CPFilterTableViewProtocol?

    /// 筛选视图的列数
    var coloumn: CPFilterTableViewColumns = .two

    /// 每行的宽度组合(多个tableview)
    var rowWidths: [CGFloat] = [0, 0]

    /// 每行的高度组合(多个tableview)
    var rowHeights: [CGFloat] = [0.0, 0.0]

    var filterTypes: [String] = []

    var filterData: [[String]] = [[]] {
        didSet {
            resetAllColoumnsData()
        }
    }
    
    let indexArr = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var mutipleSectionData: [[[String]]] = [[[]]]
    var mutipleSectionIndex: [[String]] = []
    
    let sinceArr: [String] = ["daily".localized, "weekly".localized, "monthly".localized]
    /// 选中的since index
    var selSinceIndex = 0
    let sinceBackV = UIView()
    let sinceLabel = UILabel()
    var sinceButtons: [UIButton] = []

    let separateLine = UIView()

    /// 当前选中的类型：左边tableview时候的index
    var selTypeIndex = 0
    
    /// 选择第二个表格的 section 和 row
    var selSecValueSectionIndex = 0
    var selSecValueRowIndex = 0

    /// 类型Table
    var firTableView: UITableView?
    /// 值Table
    var secTableView: UITableView?
    
    var tableviews: [UITableView] = []

    let bottomView = UIView()
    
    // MARK: - view cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - View
    func filterViewInit() {
        ftv_customView()
    }
    
    func ftv_customView() {
        for subs in self.subviews {
            subs.removeFromSuperview()
        }
        customSinceView()
        customTableView()
        customBottomView()
        layoutAllSubviews()
    }
    
    func customSinceView() {
        
        separateLine.backgroundColor = UIColor.bfLineBackgroundColor
        addSubview(separateLine)
        
        sinceLabel.font = UIFont.bfSystemFont(ofSize: 14.0)
        sinceLabel.text = "Since".localized
        sinceLabel.textAlignment = .center
        sinceLabel.textColor = UIColor.black
        sinceLabel.backgroundColor = UIColor.white
        sinceBackV.addSubview(sinceLabel)
        
        for (index, sinceTime) in sinceArr.enumerated() {
            let sinceTimeBtn = UIButton()
            sinceTimeBtn.setTitle(sinceTime, for: .normal)
            sinceTimeBtn.setTitleColor(UIColor.black, for: .normal)
            sinceTimeBtn.setTitleColor(UIColor.bfRedColor, for: .selected)
            sinceTimeBtn.titleLabel?.font = UIFont.bfSystemFont(ofSize: 14.0)
            sinceTimeBtn.backgroundColor = UIColor.white
            sinceTimeBtn.addTarget(self, action: #selector(tapSinceButton(sender:)), for: .touchUpInside)
            if index == 0 {
                sinceTimeBtn.isSelected = true
            }
            sinceBackV.addSubview(sinceTimeBtn)
            sinceButtons.append(sinceTimeBtn)
        }
        addSubview(sinceBackV)
    }
    
    func customTableView() {
        //如果column的数目与当前的宽度组合数目不对，直接返回
        if (coloumn.rawValue != rowWidths.count) || (coloumn.rawValue != rowHeights.count) {
            print("check coloumns and the datasouce count is equal")
            return
        }
        
        firTableView = UITableView()
        secTableView = UITableView()
        self.addSubview(firTableView!)
        self.addSubview(secTableView!)
        tableviews.append(firTableView!)
        tableviews.append(secTableView!)
        
        for (index, tableView) in tableviews.enumerated() {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorStyle = .none
            tableView.rowHeight = rowHeights[index]
            if #available(iOS 11, *) {
                tableView.estimatedRowHeight = 0
                tableView.estimatedSectionHeaderHeight = 0
                tableView.estimatedSectionFooterHeight = 0
            }
            tableView.register(UITableViewCell.self, forCellReuseIdentifier:cellID)
            tableView.sectionIndexColor = UIColor.bfLabelSubtitleTextColor
        }
    }
    
    func customBottomView() {
        bottomView.backgroundColor = UIColor.bfRedColor
        self.addSubview(bottomView)
    }
    
    func layoutAllSubviews() {
        
        let firColoumWidth = rowWidths[0]
        let sinceViewHeight: CGFloat = 40
        sinceBackV.frame = CGRect(x: 0, y: 0, w: ScreenSize.width, h: sinceViewHeight)
        sinceLabel.frame = CGRect(x: 0, y: 0, w: firColoumWidth, h: sinceBackV.height)
        
        let separateH: CGFloat = 1
        separateLine.frame = CGRect(x: 0, y: sinceBackV.bottom, w: sinceBackV.width, h: separateH)
        
        let btnW = (sinceBackV.width-firColoumWidth)/CGFloat(sinceArr.count)
        for (index, sinceTimeBtn) in sinceButtons.enumerated() {
            let x = btnW*CGFloat(index)+sinceLabel.right
            sinceTimeBtn.frame = CGRect(x: x, y: 0, w: btnW, h: sinceBackV.height)
        }
        
        let bottomHeight: CGFloat = 10
        let tableHeight = self.height-40-bottomHeight
        let tableY = separateLine.bottom
        for (index, tableView) in tableviews.enumerated() {
            let width = rowWidths[index]
            if index == 0 {
                tableView.frame = CGRect(x: 0, y: tableY, width: width, height: tableHeight)
                tableView.backgroundColor = UIColor.bfViewBackgroundColor
            } else {
                let lastTableview = tableviews[index-1]
                tableView.frame = CGRect(x: lastTableview.right, y: tableY, width: width, height: tableHeight)
                tableView.backgroundColor = UIColor.white
            }
        }
        
        bottomView.frame = CGRect(x: 0, y: firTableView!.bottom, width: width, height: bottomHeight)
    }

    // MARK: - Reload 
    
    /// 重新加载所有数据
    func resetAllColoumnsData() {
        mutipleSectionData.removeAll()
        mutipleSectionIndex.removeAll()
        //开始处理N组数据，将其索引化
        for typeData in filterData {
            //每个类型下的数据，比如language下的数据
            var typeArr: [[String]] = []
            var sectionIndexArr: [String] = []
            for sectionIndex in indexArr {
                let sectionArr: [String] = typeData.filter({ $0.lowercased().hasPrefix(sectionIndex.lowercased()) })
                if !sectionArr.isEmpty {
                    typeArr.append(sectionArr)
                    sectionIndexArr.append(sectionIndex)
                }
            }
            if !sectionIndexArr.isEmpty {
                mutipleSectionIndex.append(sectionIndexArr)
            }
            if !typeArr.isEmpty {
                mutipleSectionData.append(typeArr)
            }
        }
        
        if firTableView != nil {
            firTableView!.reloadData()
        }
        if secTableView != nil {
            secTableView!.reloadData()
        }
    }

    /// 重置类型表格之外的所有数据
    ///
    /// - Parameter selindex: <#selindex description#>
    func resetOtherColoumnsData(_ selindex: Int) {
        secTableView!.reloadData()
    }

    /// 重置所有属性
    func resetProperty() {
        selTypeIndex = 0
        selSecValueRowIndex = 0
        selSecValueSectionIndex = 0
    }
    
    // MARK: - Action
    
   @objc func tapSinceButton(sender: UIButton) {
        for button in sinceButtons {
            button.isSelected = sender == button
        }
        if let since = sender.currentTitle?.enLocalized {
            filterDelegate?.didTapSinceTime(since: since)
        }
    }
}

extension CPFilterTableView:UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if mutipleSectionData.isEmpty {
            return 1
        }
        
        if tableView == firTableView {
            return 1
        } else {
            if !mutipleSectionData.isBeyond(index: selTypeIndex) {
                let typeData = mutipleSectionData[selTypeIndex]
                return typeData.count
            }
        }

        return 1
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {

        if mutipleSectionData.isEmpty {
            return nil
        }
        
        if tableView == firTableView {
            return nil
        } else {
            if !mutipleSectionIndex.isBeyond(index: selTypeIndex) {
                let indexData = mutipleSectionIndex[selTypeIndex]
                return indexData
            }
        }
        return nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if filterTypes.isEmpty {
            return 0
        }
        if mutipleSectionData.isEmpty {
            return 0
        }
        if tableView == firTableView {
            return filterTypes.count
        } else {
            
            if !mutipleSectionData.isBeyond(index: selTypeIndex) {
                let typeData = mutipleSectionData[selTypeIndex]
                let sectionData = typeData[section]
                return sectionData.count
            }
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cellText = ""

        let section = indexPath.section
        let row = indexPath.row
        
        if tableView == firTableView {
            cellText = filterTypes[row]
        } else {
            let typeData = mutipleSectionData[selTypeIndex]
            let sectionData = typeData[section]
            if !sectionData.isBeyond(index: row) {
                cellText = sectionData[row]
            }
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)

        cell.textLabel?.textColor = UIColor.iOS11Black

        if tableView == firTableView {

            cell.backgroundColor = UIColor.bfViewBackgroundColor
            cell.textLabel!.font = UIFont.bfSystemFont(ofSize: 14.0)
            cell.textLabel!.adjustFontSizeToFitWidth(minScale: 0.5)
            cell.addBorderSingle(UIColor.bfLineBackgroundColor, width: 0.5, at: .bottom)
            cell.addBorderSingle(UIColor.bfLineBackgroundColor, width: 0.5, at: .right)

            if indexPath.row == selTypeIndex {
                cell.backgroundColor = UIColor.white
                cell.removeBorder(.right)
                cell.textLabel?.textColor = UIColor.black
            }

        } else {
            cell.textLabel!.font = UIFont.bfSystemFont(ofSize: 12.0)
            cell.textLabel!.adjustFontSizeToFitWidth(minScale: 0.5)
            cell.selectionStyle = .none

            let selValueIndex = selSecValueRowIndex
            if row == selValueIndex && section == selSecValueSectionIndex {
                cell.textLabel?.textColor = UIColor.bfRedColor
            }

        }

        //所有数据从Plist读取的时候，已经经过本地化了
        cell.textLabel!.text = cellText
        return cell

    }

}

extension CPFilterTableView:UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if tableView == firTableView {
            return rowHeights[0]
        }

        return rowHeights[1]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let section = indexPath.section
        let row = indexPath.row
        
        if tableView == firTableView {
            selTypeIndex = row
        } else {
            selSecValueSectionIndex = section
            selSecValueRowIndex = row
        }

        let indexOfTableviews = (tableView == firTableView) ? 0:1

        /// 其中的数据在传进来时，已经本地化
        let type = filterTypes[selTypeIndex].enLocalized
        //其中的数据从plist中读取已经本地化
        let typeData = mutipleSectionData[selTypeIndex]
        let sectionData = typeData[section]
        if !sectionData.isBeyond(index: row) {
            let value = (sectionData[selSecValueRowIndex]).enLocalized
            resetAllColoumnsData()
            if filterDelegate != nil {
                if indexOfTableviews == 0 {
                    filterDelegate?.didSelectTypeColoumn(indexPath.row, type: type)
                } else if indexOfTableviews == 1 {
                    filterDelegate?.didSelectValueColoumn(indexPath.row, type: type, value: value)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
}
