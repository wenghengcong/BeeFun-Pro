//
//  BFTagsManagerController.swift
//  BeeFun
//
//  Created by WengHengcong on 01/06/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import SwipeCellKit
import ObjectMapper

class BFTagsManageController: BFBaseViewController {

    var tagsData: [ObjTag] = []
    var currentPage: UInt = 1
    var perPage: UInt = 15
    var sortPara: String?
    var directionPara: String?
    var tagFilter: TagFilter = TagFilter()

    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tmc_viewInit()
        tmc_requestTagsData()
        tmc_registerNoti()
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
    
    func tmc_registerNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(tmc_handleAddTagsNoti), name: NSNotification.Name.BeeFun.AddTag, object: nil)
    }
    
    @objc func tmc_handleAddTagsNoti() {
        tmc_requestTagsData()
    }
    
    // MARK: - data
    func tmc_requestTagsData() {
        currentPage = 1
        sortPara = "name"
        directionPara = "desc"
        requestTagsFromBeeFun()
    }
    
    func requestTagsFromBeeFun() {
        
        let hud = JSMBHUDBridge.showHud(view: view)
        if !UserManager.shared.needLoginAlert() {
            _ = checkCurrentLoginState()
            hud.hide(animated: true)
            return
        }
        
        if let owner = UserManager.shared.login {
            tagFilter.owner = owner
        }
        tagFilter.page = currentPage
        tagFilter.pageSize = perPage
        tagFilter.sord = directionPara
        tagFilter.sidx = sortPara
        
        var dict: [String: Any] = [:]
        do {
            dict = try JSONSerialization.jsonObject(with: try JSONEncoder().encode(tagFilter), options: []) as! [String: Any]
        } catch {
            print("tag filter is error")
        }
        
        BeeFunProvider.sharedProvider.request(BeeFunAPI.getAllTags(filter: dict) ) { (result) in
            hud.hide(animated: true)
            switch result {
            case let .success(response):
                do {
                    if let allTag: GetAllTagResponse = Mapper<GetAllTagResponse>().map(JSONObject: try response.mapJSON()) {
                        if let code = allTag.codeEnum, code == BFStatusCode.bfOk {
                            if let data = allTag.data {
                                self.handleResponseData(data: data)
                            }
                        }
                    }
                } catch {
                }
            case .failure: break
            }
        }
    }
    
    override func reconnect() {
        super.reconnect()
        requestTagsFromBeeFun()
    }
    
    override func request() {
        super.request()
        requestTagsFromBeeFun()
    }
    
    override func didAction(place: BFPlaceHolderView) {
        if place == placeEmptyView {
            request()
        } else if place == placeLoginView {
            login()
        } else if place == placeReloadView {
            self.request()
        }
    }
    
    func handleResponseData(data: [ObjTag]) {
        if self.currentPage == 1 {
            self.tagsData.removeAll()
            self.tagsData = data
            let addNewTag = ObjTag()
            addNewTag.name = "Add new tag".localized
            tagsData.insert(addNewTag, at: 0)
            
        } else {
            self.tagsData += data
        }
        
        for allTag in tagsData where allTag.name == "All" {
            tagsData.removeAll(allTag)
        }
        tableView.reloadData()
    }
    
    // MARK: - view
    func tmc_viewInit() {
        title = "Tags".localized
        view.addSubview(tableView)
        view.backgroundColor = .white
        tableView.frame = CGRect(x: 0, y: topOffset, w: ScreenSize.width, h: ScreenSize.height-topOffset)
        self.automaticallyAdjustsScrollViewInsets = false
    }

    // 顶部刷新
    override func headerRefresh() {
        super.headerRefresh()
        currentPage = 1
        requestTagsFromBeeFun()
    }
    
    // 底部刷新
    override func footerRefresh() {
        super.footerRefresh()
        currentPage += 1
        requestTagsFromBeeFun()
    }
}

extension BFTagsManageController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagsData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellId = " "
        let row = indexPath.row
        let tag: ObjTag = tagsData[row]

        if row == 0 {
            cellId = "AddTagsCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? AddTagsCell
            if cell == nil {
                cell = (AddTagsCell.cellFromNibNamed("AddTagsCell") as? AddTagsCell)
            }
            cell?.showtext = tag.name
            cell?.setBothEndsLines(row, all: tagsData.count)
            return cell!
        }
        
        cellId = "ShowTagsCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? ShowTagsCell
        if cell == nil {
            cell = ShowTagsCell(style: .default, reuseIdentifier: cellId)
        }
        cell?.textLabel?.text = tag.name
        cell?.delegate = self
        cell?.setBothEndsLines(row, all: tagsData.count)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let vc = BFAddNewTagsController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - Tags 的操作
extension BFTagsManageController {
    
    func updateTagByUser(index: Int, orginal from: ObjTag, change to: ObjTag) {
        if to.name == nil || from.name == nil {
            return
        }
        if !tagsData.isBeyond(index: index) {
            tagsData[index] = to
        }
        let hud = JSMBHUDBridge.showHud(view: view)
        BeeFunProvider.sharedProvider.request(BeeFunAPI.updateTag(name: from.name!, to: to.name!)) { (result) in
            hud.hide(animated: true)
            switch result {
            case let .success(response):
                do {
                    if let tagResponse: GetAllTagResponse = Mapper<GetAllTagResponse>().map(JSONObject: try response.mapJSON()) {
                        if let code = tagResponse.codeEnum, code == BFStatusCode.bfOk {
                            //更新成功
                            JSMBHUDBridge.showSuccess("Success".localized)
                            self.tableView.reloadData()
                            NotificationCenter.default.post(name: NSNotification.Name.BeeFun.UpdateTag, object: nil, userInfo: ["from": from.name!, "to": to.name!])
                        }
                    }
                } catch {
                }
            case .failure:
                //更新失败
                JSMBHUDBridge.showError("Failure".localized)
            }
        }
    }
    
    func deleteTagByUser(tag: ObjTag, index: Int) {
        if tag.name == nil {
            return
        }
        
        let hud = JSMBHUDBridge.showHud(view: view)
        BeeFunProvider.sharedProvider.request(BeeFunAPI.deleteTag(name: tag.name!)) { (result) in
            hud.hide(animated: true)
            switch result {
            case let .success(response):
                do {
                    if let tagResponse: GetAllTagResponse = Mapper<GetAllTagResponse>().map(JSONObject: try response.mapJSON()) {
                        if let code = tagResponse.codeEnum, code == BFStatusCode.bfOk {
                            //删除成功
                            JSMBHUDBridge.showSuccess("Success".localized)
                            let removeIndex = index
                            if removeIndex < self.tagsData.count && removeIndex > 0 {
                                self.tagsData.remove(at: removeIndex)
                            }
                            self.tableView.reloadData()
                            NotificationCenter.default.post(name: NSNotification.Name.BeeFun.DelTag, object: nil, userInfo: ["tag": tag.name!])
                            return
                        }
                    }
                } catch {
                }
                JSMBHUDBridge.showError("Failure".localized)
            case .failure:
                //删除失败
                JSMBHUDBridge.showError("Failure".localized)
            }
        }
    }
}

extension BFTagsManageController : SwipeTableViewCellDelegate {
   
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .right {
            let tag = tagsData[indexPath.row]
            
            let edit = SwipeAction(style: .default, title: nil) { _, _ in
                
                let alertController = UIAlertController(title: "Edit".localized, message: nil, preferredStyle: .alert)
                
                alertController.addTextField(configurationHandler: { (textField) in
                    textField.placeholder = "make a change".localized
                })
                
                alertController.addAction(title: "Cancel".localized, style: .cancel, handler: { (_) in
                })
                
                alertController.addAction(title: "OK".localized, style: .default, handler: { (_) in
                    if let firstTextField = alertController.textFields?[0] {
                        if firstTextField.text != nil {
                            if let newTag: ObjTag = tag.copy() as? ObjTag {
                                newTag.name = firstTextField.text?.trimmed
                                self.updateTagByUser(index: indexPath.row, orginal: tag, change: newTag)
                            }
         
                        }
                    }
                })
                self.present(alertController, animated: true, completion: { 
                    
                })
            }

            edit.hidesWhenSelected = true
            configure(action: edit, with: .edit)
            
            let trash = SwipeAction(style: .destructive, title: nil) { _, _ in
                let message = "Trash it will remove this tag from star repositories!".localized
                let alertController = UIAlertController(title: "Trash".localized, message: message, preferredStyle: .alert)
                alertController.addAction(title: "Cancel".localized, style: .cancel, handler: { (_) in
                    
                })
                
                alertController.addAction(title: "OK".localized, style: .default, handler: { (_) in
                    
                    self.deleteTagByUser(tag: tag, index: indexPath.row)
                })
                
                self.present(alertController, animated: true, completion: {
                    
                })

            }
            trash.hidesWhenSelected = true
            configure(action: trash, with: .trash)
            return [trash, edit]
        }
        return nil
    }
    
    /*
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var options = SwipeTableOptions()
        options.expansionStyle = orientation == .left ? .selection : .destructive
        var defaultOptions = SwipeTableOptions()
        defaultOptions.transitionStyle = .border
        options.transitionStyle = defaultOptions.transitionStyle
        options.buttonSpacing = 4
        options.backgroundColor = #colorLiteral(red: 0.9467939734, green: 0.9468161464, blue: 0.9468042254, alpha: 1)
        
        return options
    }
    */
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.title = descriptor.title(forDisplayMode: .titleAndImage)
        action.image = descriptor.image(forStyle: .backgroundColor, displayMode: .titleAndImage)
        action.backgroundColor = descriptor.color

    }
}

enum ActionDescriptor {
    case edit, trash
    
    func title(forDisplayMode displayMode: ButtonDisplayMode) -> String? {
        guard displayMode != .imageOnly else { return nil }
        
        switch self {
        case .edit: return "Edit".localized
        case .trash: return "Trash".localized
        }
    }
    
    func image(forStyle style: ButtonStyle, displayMode: ButtonDisplayMode) -> UIImage? {
        guard displayMode != .titleOnly else { return nil }
        
        let name: String
        switch self {
        case .edit: name = "Edit"
        case .trash: name = "Trash"
        }
        
        return UIImage(named: style == .backgroundColor ? name : name + "-circle")
    }
    
    var color: UIColor {
        switch self {
        case .edit : return #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        case .trash: return #colorLiteral(red: 1, green: 0.2352941176, blue: 0.1882352941, alpha: 1)
        }
    }
}

enum ButtonDisplayMode {
    case titleAndImage, titleOnly, imageOnly
}

enum ButtonStyle {
    case backgroundColor, circular
}
