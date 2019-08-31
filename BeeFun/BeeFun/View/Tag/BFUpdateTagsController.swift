//
//  BFUpdateTagsController.swift
//  BeeFun
//
//  Created by WengHengcong on 28/05/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper

class BFUpdateTagsController: BFBaseViewController {
    
    var repoModel: ObjRepos?
    /// repoModel原来的tag列表
    var oriStatTags: [String]?
    /// 已添加tags
    var workingTags: [String] = []
    /// 缓存的tags：alltags-workingtags
    var stashTags: [String] = []
    /// 所有的tags
    var allTags: [String] = []
    
    var workingTagsView = UIView()
    var workingButtongs: [UIButton] = []
    var allTagsView = UIScrollView()
    var allButtons: [UIButton] = []
    /// 输入新tag
    let inputNewViewTag = 2222
    var inputNewTagView: UITextField = UITextField()
    var inputWillShowText: String? = ""
    var showAllTagLabel = UILabel()
    
    var tagFilter: TagFilter = TagFilter()

    let lineH: CGFloat = 50
    
    /// 弹出浮窗的tag值
    let popupViewTag = 1000
    /// 需要移除的index
    var removeWorkingIndex: Int = 0
    var tagsValueChanged: Bool = false
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tags".localized
        rightItem?.setTitle("Save".localized, for: .normal)
        rightItem?.isHidden = false
        utc_loadTags()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removePopView(sender: nil)
    }
    // MARK: - 导航栏
    override func leftItemAction(_ sender: UIButton?) {
        
        if workingTags == oriStatTags {
            tagsValueChanged = false
        } else {
            tagsValueChanged = true
        }
        
        if tagsValueChanged {
            let alertController = UIAlertController(title: "Save Tags?".localized, message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { (_) in
                _ = self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(cancelAction)
            
            let savelAction = UIAlertAction(title: "Save".localized, style: .default) { (_) in
                self.saveReposToDatabase()
            }
            alertController.addAction(savelAction)
            self.present(alertController, animated: true, completion: {
            })
            return
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    /// 保存
    override func rightItemAction(_ sender: UIButton?) {
        saveReposToDatabase()
    }
    
    // MARK: - data
    func utc_loadTags() {

        if let owner = UserManager.shared.login {
            tagFilter.owner = owner
        }
        tagFilter.page = 1
        tagFilter.pageSize = 100000
        tagFilter.sord = "desc"
        tagFilter.sidx = "name"
        
        var dict: [String: Any] = [:]
        do {
            dict = try JSONSerialization.jsonObject(with: try JSONEncoder().encode(tagFilter), options: []) as! [String: Any]
        } catch {
            print("tag filter is error")
        }
        
        BeeFunProvider.sharedProvider.request(BeeFunAPI.getAllTags(filter: dict) ) { (result) in

            switch result {
            case let .success(response):
                do {
                    if let allTag: GetAllTagResponse = Mapper<GetAllTagResponse>().map(JSONObject: try response.mapJSON()) {
                        if let code = allTag.codeEnum, code == BFStatusCode.bfOk {
                            if let data = allTag.data {
                                DispatchQueue.main.async {
                                    self.handleGetAllTagsRequestResponse(data: data)
                                }
                            }
                        }
                    }
                } catch {
                }
            case .failure: break
            }
        }
    }
    
    func handleGetAllTagsRequestResponse(data: [ObjTag]) {
        allTags.removeAll()
        for tagObj in data {
            if let tagName = tagObj.name {
                allTags.append(tagName)
            }
        }
        if let model = repoModel {
            if let tags = model.star_tags {
                workingTags = tags
            }
        }

        //针对all tag进行隐藏
        allTags.removeAll("All".localized)
        workingTags.removeAll("All".localized)
        stashTags = allTags.difference(workingTags)
        
        tagsViewInit()
    }
    
    /// 保存数据
    func saveReposToDatabase() {
        if repoModel != nil {
            //交集
            //如果原来repo tag列表为空，那么强制赋空
            if oriStatTags == nil {
                oriStatTags = []
            }
            var change = true
            if oriStatTags == workingTags {
                change = false
            }
            var delTags = oriStatTags!.difference(workingTags)
            var addTags = workingTags.difference(oriStatTags!)
            
            var star_tagsStr = ""
            for (index, tagName) in workingTags.enumerated() {
                if index == 0 {
                    star_tagsStr = tagName
                } else {
                    star_tagsStr += ",\(tagName)"
                }
            }
            
            if let repoid = repoModel?.id {
                BeeFunProvider.sharedProvider.request(BeeFunAPI.addTagToRepo(change: change, star_tags: star_tagsStr, delete_tags: delTags, repoId: repoid)) { (result) in
                    switch result {
                    case let .success(response):
                        do {
                            if let allTag: BeeFunResponseModel = Mapper<BeeFunResponseModel>().map(JSONObject: try response.mapJSON()) {
                                if let code = allTag.codeEnum, code == BFStatusCode.bfOk {
                                    NotificationCenter.default.post(name: NSNotification.Name.BeeFun.RepoUpdateTag, object: nil, userInfo: ["star_tags": self.workingTags])
                                    _ = self.navigationController?.popViewController(animated: true)
                                } else {
                                    JSMBHUDBridge.showError("Update Failure".localized)
                                }
                            }
                        } catch {
                        }
                    case .failure: break
                    }
                }
            }
        }
    }
    
    func makeNewTagObj(name: String) -> ObjTag {
        let tag = ObjTag()
        if !name.isEmpty {
            tag.name = name
            tag.owner = UserManager.shared.login
        }
        return tag
    }
    
    // MARK: - view
    func tagsViewInit() {
        
        workingTagsView.frame = CGRect(x: 0, y: uiTopBarHeight, w: ScreenSize.width, h: lineH)
        view.addSubview(workingTagsView)
    
        allTagsView.backgroundColor = UIColor(hex: "#f0eff3")
        view.addSubview(allTagsView)

        inputNewTagView.placeholder = "input tag".localized
        inputNewTagView.font = UIFont.bfSystemFont(ofSize: 17.0)
        inputNewTagView.textColor = UIColor.bfRedColor
        inputNewTagView.tag = inputNewViewTag
        inputNewTagView.delegate = self
//        inputNewTagView.clearButtonMode = .always
        inputNewTagView.returnKeyType = .done
        workingTagsView.addSubview(inputNewTagView)
        
        layoutAllView()
    }
    // MARK: - 添加按钮
    func addWorkingButtons() {
        if workingButtongs.count > 0 {
            workingButtongs.removeAll()
            for view in workingTagsView.subviews where view.tag != inputNewViewTag {
                view.removeFromSuperview()
            }
        }
        
        for (index, tag) in workingTags.enumerated() {
            let tagB = UIButton()
            tagB.tag = index
            tagB.setTitle(tag, for: .normal)
            tagB.setTitleColor(UIColor.bfRedColor, for: .normal)
            tagB.setTitleColor(UIColor.white, for: .selected)
            tagB.titleLabel?.font = UIFont.bfSystemFont(ofSize: 15.0)
            tagB.radius = 15.0
            tagB.borderWidth = 1.0/UIScreen.main.scale
            tagB.borderColor = .bfRedColor
            tagB.tag = index
            tagB.addTarget(self, action: #selector(workingButtonTouchAction(sender:)), for: .touchUpInside)
            workingButtongs.append(tagB)
            workingTagsView.addSubview(tagB)
        }
    }
    
    func addInputTextField() {
        if !workingTagsView.subviews.contains(inputNewTagView) {
            workingTagsView.addSubview(inputNewTagView)
        }
    }
    
    func addAllButtons() {
        if allButtons.count > 0 {
            allButtons.removeAll()
            allTagsView.removeAllSubViews()
        }
        
        showAllTagLabel.text = "All Tags".localized
        showAllTagLabel.font = UIFont.bfSystemFont(ofSize: 15.0)
        showAllTagLabel.textColor = UIColor(hex: "#8b9693")
        allTagsView.addSubview(showAllTagLabel)
        
        for (index, tag) in allTags.enumerated() {
            let tagB = UIButton()
            tagB.tag = index
            tagB.setTitle(tag, for: .normal)
            tagB.setTitleColor(UIColor.black, for: .normal)
            tagB.setTitleColor(UIColor.bfRedColor, for: .selected)
            tagB.titleLabel?.font = UIFont.bfSystemFont(ofSize: 15.0)
            tagB.radius = 15.0
            tagB.borderWidth = 1.0/UIScreen.main.scale
            tagB.tag = index
            tagB.addTarget(self, action: #selector(allButtonTouchAction(sender:)), for: .touchUpInside)
            allButtons.append(tagB)
            allTagsView.addSubview(tagB)
        }
    }
    
    // MARK: - 布局按钮
    func layoutAllView() {
        addWorkingButtons()
        addInputTextField()
        addAllButtons()
        //包含布局input text field
        layoutWorkingButtons()
        layoutAllButtons()
    }
    
    func layoutWorkingButtons() {
        /// 两个按钮之间的间距
        let btnOutsideMargin: CGFloat = 5
        /// 按钮内部两边的间距宽度
        let btnInsideMargin: CGFloat = 20
        /// 按钮的高度
        let btnH: CGFloat = 30
        /// 行间距
        let rowsYMargin: CGFloat = (lineH-btnH)/2.0
        /// 第一列距离边距的长度
        let firstColumnXMargin: CGFloat = 10
        
        for (index, btn) in workingButtongs.enumerated() {
            var lastF = CGRect.zero
            var nowY: CGFloat = rowsYMargin
            var nowX = firstColumnXMargin
            
            if index != 0 {
                lastF = workingButtongs[index-1].frame
                nowY = lastF.y
                nowX += lastF.x + lastF.width + btnOutsideMargin
            }
            
            var nowW: CGFloat = 0
            if let tagsTitle = btn.currentTitle {
                nowW = tagsTitle.width(with: lineH, font: btn.titleLabel!.font) + btnInsideMargin
            }
            let nextX: CGFloat = nowX + nowW
            if nextX > ScreenSize.width {
                nowY += btnH + rowsYMargin
                nowX = firstColumnXMargin
            }
            let nowF = CGRect(x: nowX, y: nowY, w: nowW, h: btnH)
            btn.frame = nowF
        }
        
        let lastTagFrame = workingButtongs.last?.frame ?? CGRect.zero
        let inputTextH = lineH
        var inputTextW: CGFloat = 80
        if let inputTagName = inputWillShowText {
            let newWidth = inputTagName.width(with: inputTextH, font: inputNewTagView.font!)
            if newWidth > 80 {
                inputTextW = newWidth + 40
            }
        }
        var inputTextY = lastTagFrame.y-10
        var inputTextX = lastTagFrame.x + lastTagFrame.width + 10.0
        let inputRight = inputTextX + inputTextW

        if inputRight > ScreenSize.width {
            inputTextX = firstColumnXMargin
            inputTextY = lastTagFrame.y + lineH-10
            inputTextW = ScreenSize.width
        }
        
        if inputTextY < 0 {
            inputTextY = 0
        }
        
//        inputNewTagView.backgroundColor = UIColor.red
        inputNewTagView.frame = CGRect(x: inputTextX, y: inputTextY, w: inputTextW, h: inputTextH)
        workingTagsView.frame = CGRect(x: 0, y: uiTopBarHeight, w: ScreenSize.width, h: inputNewTagView.y+inputTextH)
    }
    
    func layoutAllButtons() {
        /// 两个按钮之间的间距
        let btnOutsideMargin: CGFloat = 5
        /// 按钮内部两边的间距宽度
        let btnInsideMargin: CGFloat = 20
        /// 按钮的高度
        let btnH: CGFloat = 30
        /// 行间距
        let rowsYMargin: CGFloat = (lineH-btnH)/2.0
        /// 第一列距离边距的长度
        let firstColumnXMargin: CGFloat = 10
        
        let showLabelH: CGFloat = 35
        for (index, btn) in allButtons.enumerated() {
            var lastF = CGRect.zero
            var nowY: CGFloat = showLabelH
            var nowX = firstColumnXMargin
            
            if index != 0 {
                lastF = allButtons[index-1].frame
                nowY = lastF.y
                nowX += lastF.x + lastF.width + btnOutsideMargin
            }
            
            var nowW: CGFloat = 0
            if let tagsTitle = btn.currentTitle {
                nowW = tagsTitle.width(with: lineH, font: btn.titleLabel!.font) + btnInsideMargin
            }
            let nextX: CGFloat = nowX + nowW
            if nextX > ScreenSize.width {
                nowY += btnH + rowsYMargin
                nowX = firstColumnXMargin
            }
            let nowF = CGRect(x: nowX, y: nowY, w: nowW, h: btnH)
            btn.frame = nowF
            if let tag = btn.currentTitle {
                if workingTags.contains(tag) {
                    btn.isSelected = true
                    btn.borderColor = .bfRedColor
                    btn.backgroundColor = UIColor.white
                } else {
                    btn.isSelected = false
                    btn.borderColor = UIColor(hex: "#cccbcf")!
                    btn.backgroundColor = UIColor(hex: "#f3f2f5")
                }
            }
        }
        showAllTagLabel.frame = CGRect(x: 10, y: 0, w: ScreenSize.width, h: showLabelH)
        allTagsView.frame = CGRect(x: 0, y: workingTagsView.bottom, w: ScreenSize.width, h: ScreenSize.height-showAllTagLabel.bottom)
        if let lastFrame = allButtons.last?.frame {
            allTagsView.contentSize = CGSize(width: ScreenSize.width, height: lastFrame.y+lastFrame.height+100)
        } else {
            allTagsView.contentSize = allTagsView.frame.size
        }

    }
    
    // MARK: - 所有标签按钮点击动作
    /// 点击所有标签按钮的动作
    @objc func allButtonTouchAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.borderColor = .bfRedColor
            sender.backgroundColor = UIColor.white
            addTagToWorkArea(sender: sender)
        } else {
            sender.borderColor = UIColor(hex: "#cccbcf")!
            sender.backgroundColor = UIColor(hex: "#f3f2f5")
            removeTagFromWorkArea(sender: sender)
        }
        
    }
    
    /// 将tag移入工作区
    func addTagToWorkArea(sender: UIButton) {
        if let newTag = sender.currentTitle {
            workingTags.append(newTag)
            layoutAllView()
        }
    }
    /// 将tag移出工作区
    func removeTagFromWorkArea(sender: UIButton) {
        if let newTag = sender.currentTitle {
            workingTags.removeAll(newTag)
            layoutAllView()
        }
    }

    // MARK: - 工作区按钮动作
    /// 点击工作区标签按钮的动作
    @objc func workingButtonTouchAction(sender: UIButton) {
        //按钮本身置换颜色
        //选中：背景红色，文字白色
        //未选中：背景白色，文字红色
        sender.isSelected = !sender.isSelected
        for btn in workingButtongs where btn != sender {
            btn.isSelected = false
            btn.backgroundColor = UIColor.white
        }
        if sender.isSelected {
            sender.backgroundColor = UIColor.bfRedColor
            addPopView(sender: sender)
        } else {
            sender.backgroundColor = UIColor.white
            removePopView(sender: sender)
        }
 
    }
    
    func addPopView(sender: UIButton) {
        
        // 移除其他按钮上面的小浮窗
        for btn in workingButtongs where btn != sender {
            removePopView(sender: btn)
        }
        
        removeWorkingIndex = sender.tag
        //弹出小浮窗
        let popBtn = UIButton()
        popBtn.setTitle("Delete".localized, for: .normal)
        popBtn.titleLabel?.font = UIFont.bfSystemFont(ofSize: 13.0)
        popBtn.setTitleColor(UIColor.white, for: .normal)
        popBtn.setBackgroundImage(UIImage(named: "tag_pop"), for: .normal)
        popBtn.titleEdgeInsets = UIEdgeInsets(top: -8, left: 0, bottom: 0, right: 0)
        popBtn.addTarget(self, action: #selector(removeTagTouchAction(sender:)), for: .touchUpInside)
        let w: CGFloat = 50
        let h: CGFloat = 50
        let x = sender.centerX - w/2.0
        let y = sender.y+uiTopBarHeight-h
        popBtn.frame = CGRect(x: x, y: y, w: w, h: h)
        popBtn.tag = popupViewTag
        UIApplication.shared.keyWindow?.addSubview(popBtn)
    }
    
    func removePopView(sender: UIButton?) {
        if let pop = UIApplication.shared.keyWindow?.viewWithTag(popupViewTag) {
            pop.removeFromSuperview()
        }
    }
    /// 小浮窗移除tag
    @objc func removeTagTouchAction(sender: UIButton) {
        sender.removeFromSuperview()
        if !workingButtongs.isBeyond(index: removeWorkingIndex) {
            removeTagFromWorkArea(sender: workingButtongs[removeWorkingIndex])
        }

    }
    
}

extension BFUpdateTagsController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        removePopView(sender: nil)
        if range.length == 1 && string.length == 0 {
            //按了删除键，且UITextField还有字符
            return true
        }
        if textField.text != nil && !textField.text!.isEmpty {
            inputWillShowText = textField.text! + string
        } else {
            inputWillShowText = string
        }
        layoutAllView()
        return true
    }
    
    func keyboardInputShouldDelete(_ textField: UITextField) -> Bool {
        removePopView(sender: nil)
        if textField.text == nil || textField.text!.isEmpty {
            //按了删除键，UITextField无字符
            if workingTags.count > 0 && !workingTags.isEmpty {
                workingTags.removeLast()
                layoutAllView()
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        removePopView(sender: nil)
        saveWorktagsSuccessful()
        return true
    }
    
    func saveWorktagsSuccessful() {
        if checkTagsInDatabase() {
            //将其tag加到working tags区域，并重新刷新布局
            if let newTag = inputNewTagView.text?.trimmed {
                workingTags.append(newTag)
                inputNewTagView.text = nil
                layoutAllView()
            }
        }
    }
    
    func checkTagsInDatabase() -> Bool {
        inputNewTagView.endEditing(true)
        //1. 先检查text是否为空
        if inputNewTagView.text != nil && !inputNewTagView.text!.isEmpty {
            //2. 是否存在该tag
            if let tagName = inputNewTagView.text?.trimmed {
                if allTags.contains(tagName) {
                    JSMBHUDBridge.showError("Already exists!".localized, view: self.view)
                    return false
                } else {
                    return true
                }
            } else {
                return false
            }
        } else {
            JSMBHUDBridge.showError("No tag to save".localized, view: self.view)
            return false
        }
    }
}
