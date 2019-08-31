//
//  BFEditUserController.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/4/17.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit
import Moya
import ObjectMapper
import Alamofire

class BFEditUserController: BFBaseViewController {
    
    var cellModels: [JSCellModel] = []
    var switchCell: JSSwitchCell?
    var cells: [JSBaseCell] = []

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        euc_viewInit()
        euc_dataInit()
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

    // MARK: - Action
    
    override func leftItemAction(_ sender: UIButton?) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func rightItemAction(_ sender: UIButton?) {
        if euc_dataChange() {
            //有值改变 
            euc_save()
        } else {
            //所有值均未变
            popToLastView()
        }
    }
    
    /// 保存
    func euc_save() {
        
        view.endEditing(true)
        
        // name,  email,  blog,  company,  location,  hireable,  bio
        let name = textFiledValue(index: 0) ?? ""
        let email = textFiledValue(index: 1) ?? ""
        let blog = textFiledValue(index: 2) ?? ""
        let company = textFiledValue(index: 3) ?? ""
        let location = textFiledValue(index: 4) ?? ""
        let bio = textFiledValue(index: 5) ?? ""
        let hire = switchCell?.value ?? false

        let para: Parameters = [
            "name": name,
            "email": email,
            "blog": blog,
            "company": company,
            "location": location,
            "hireable": hire,
            "bio": bio
        ]
        
        var request = URLRequest(url: URL(string: "https://api.github.com/user")!)
        request.httpMethod = HTTPMethod.patch.rawValue
        request.setValue(AppToken.shared.access_token ?? "", forHTTPHeaderField: "Authorization")
        request.setValue("15.0", forHTTPHeaderField: "timeoutInterval")
        request.setValue("BeeFun", forHTTPHeaderField: "User-Agent")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let paraData = para.jsonData()
        request.httpBody = paraData
        
        let hud = JSMBHUDBridge.showHud(view: self.view)
        Alamofire.request(request).responseJSON { (response) in
            hud.hide(animated: true)
            let message = kNetworkErrorTip
            if response.response?.statusCode == BFStatusCode.ok.rawValue {
                switch response.result {
                case .success:
                    if let gitUser: ObjUser = Mapper<ObjUser>().map(JSONObject: response.result.value) {
                        ObjUser.saveUserInfo(gitUser)
                        //post successful noti
                        //更新用户信息
                        UserManager.shared.updateUserInfo()
                        _ = self.navigationController?.popViewController(animated: true)
                    } else {
                    }
                case .failure:
                    JSMBHUDBridge.showError(message, view: self.view)
                }
            }
        }

    }
    
    /// 返回上一页
    func popToLastView() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - view
    func euc_viewInit() {
        title = "Edit".localized
        
        rightItem?.setTitle("Save".localized, for: .normal)
        rightItem?.isHidden = false
        
        refreshHidden = .all
        view.addSubview(tableView)
        view.backgroundColor = .white
        self.tableView.frame = CGRect(x: 0, y: topOffset, w: ScreenSize.width, h: ScreenSize.height-topOffset)
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func euc_dataInit() {
        
        // name,  email,  blog,  company,  location,  hireable,  bio
        //0
        let nameM = JSCellModelFactory.eidtInit(type: JSCellType.edit.rawValue, id: "name", key: "Name".localized, value: UserManager.shared.login?.localized, placeholder: "".localized)
        cellModels.append(nameM)
        //1
        let emailM = JSCellModelFactory.eidtInit(type: JSCellType.edit.rawValue, id: "email", key: "Email".localized, value: UserManager.shared.user?.email?.localized, placeholder: "".localized)
        cellModels.append(emailM)
        //2
        let blogM = JSCellModelFactory.eidtInit(type: JSCellType.edit.rawValue, id: "blog", key: "Blog".localized, value: UserManager.shared.user?.blog?.localized, placeholder: "".localized)
        cellModels.append(blogM)
        //3
        let companyM = JSCellModelFactory.eidtInit(type: JSCellType.edit.rawValue, id: "company", key: "Company".localized, value: UserManager.shared.user?.company?.localized, placeholder: "".localized)
        cellModels.append(companyM)
        //4
        let locM = JSCellModelFactory.eidtInit(type: JSCellType.edit.rawValue, id: "location", key: "Location".localized, value: UserManager.shared.user?.location?.localized, placeholder: "".localized)
        cellModels.append(locM)
        //5
        let hireM = JSCellModelFactory.switchInit(type: JSCellType.switched.rawValue, id: "hireable", key: "Hireable".localized, switched: UserManager.shared.user?.hireable)
        cellModels.append(hireM)
        //6
        let bioM = JSCellModelFactory.eidtInit(type: JSCellType.edit.rawValue, id: "bio", key: "Bio".localized, value: UserManager.shared.user?.bio?.localized, placeholder: "".localized)
        cellModels.append(bioM)
        
        tableView.reloadData()
    }
    
    func euc_dataChange() -> Bool {
    
        if !cells.isEmpty && cells.count >= 6 {
            
            if UserManager.shared.user?.login !=  textFiledValue(index: 0) || UserManager.shared.user?.email !=  textFiledValue(index: 1) || UserManager.shared.user?.company !=  textFiledValue(index: 2) || UserManager.shared.user?.company !=  textFiledValue(index: 3) || UserManager.shared.user?.location !=  textFiledValue(index: 4) || UserManager.shared.user?.login !=  textFiledValue(index: 5) {
                return true
            }
        
            if UserManager.shared.user?.hireable != switchCell?.value {
                return true
            }
            return false
        }
        
        return false
    }
    
    func textFiledValue(index: Int) -> String? {
        if cells.isEmpty {
            return nil
        }
        
        if cells.isBeyond(index: index) {
            return nil
        }
        
        if let cell = cells[index] as? JSEditCell {
            return cell.value
        }
        
        return nil
    }
    
}

extension BFEditUserController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cellModel = cellModels[row]
        
        if row == 5 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "EditUserIdentifierSwtich") as? JSSwitchCell
            if cell == nil {
                cell = JSCellFactory.cell(type:cellModel.type!) as? JSSwitchCell
            }
            cell?.model = cellModel
            cell?.bothEndsLine(row, all: cellModels.count)
            switchCell = cell
            return cell!
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "EditUserIdentifier") as? JSEditCell
        if cell == nil {
            cell = JSCellFactory.cell(type:cellModel.type!) as? JSEditCell
        }
        cell?.model = cellModel
        cell?.bothEndsLine(row, all: cellModels.count)
        cells.append(cell!)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        
    }
}
