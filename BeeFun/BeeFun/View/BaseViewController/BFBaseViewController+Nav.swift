//
//  BFBaseViewController+Nav.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/4/16.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

extension BFBaseViewController {

    func customView() {

        self.view.backgroundColor = UIColor.bfViewBackgroundColor
        //下面语句添加在CPBaseNavigationController中无效
        self.navigationController?.navigationBar.barTintColor = UIColor.bfRedColor
        self.navigationController?.navigationBar.titleTextAttributes = BFStyleGuide.navTitleTextAttributes()
        //返回按钮颜色与文字
        self.navigationController?.navigationBar.tintColor = UIColor.white

        //启用滑动返回（swipe back）
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self

        customLeftItem()
        customRightItem()
        
    }

    func customLeftItem() {

        leftItem = UIButton()
        leftItem!.setImage(UIImage(named: "arrow_left"), for: UIControlState())
        leftItem!.setImage(UIImage(named: "arrow_left"), for: .selected)
        leftItem?.titleLabel?.font = UIFont.bfSystemFont(ofSize: 17.0)
        leftItem?.setTitleColor(.white, for: .normal)
        leftItem?.setTitleColor(UIColor.bfLineBackgroundColor, for: .disabled)
        leftItem!.addTarget(self, action: #selector(BFBaseViewController.navigationShouldPopOnBackButton), for: .touchUpInside)
        leftItem!.isHidden = false
        layoutLeftItem()
    }
    
    func layoutLeftItem() {
        if leftItem?.currentImage != nil {
            leftItem!.frame = CGRect(x: 0, y: 5, width: 25, height: 25)
        } else {
            leftItem!.frame = CGRect(x: 0, y: 5, width: 40, height: 25)
        }
        let leftBarButton = UIBarButtonItem(customView: leftItem!)
        let leftSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftSpace.width = -8;      //越小越靠左
        self.navigationItem.leftBarButtonItems = [leftSpace, leftBarButton]
    }

    func customRightItem() {
        rightItem = UIButton()
        rightItem?.titleLabel?.font = UIFont.bfSystemFont(ofSize: 17.0)
        rightItem?.titleLabel?.adjustsFontSizeToFitWidth = true
        rightItem?.titleLabel?.minimumScaleFactor = 0.7
        rightItem?.setTitleColor(.white, for: .normal)
        rightItem?.setTitleColor(UIColor.bfLineBackgroundColor, for: .disabled)
        rightItem!.addTarget(self, action: #selector(BFBaseViewController.rightItemAction(_:)), for: .touchUpInside)
        rightItem!.isHidden = true
        layoutRightItem()
    }
    
    func layoutRightItem() {
        if rightItem?.currentImage != nil {
            rightItem!.frame = CGRect(x: 0, y: 5, width: 25, height: 25)
        } else {
            rightItem!.frame = CGRect(x: 0, y: 5, width: 40, height: 25)
        }

        if #available(iOS 11, *) {
            let view = UIView(frame: CGRect(x: 0, y: 5, w: 0, h: 25))
            view.backgroundColor = .blue
            
            if rightItem?.currentImage != nil {
                rightItem!.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            } else {
                rightItem!.frame = CGRect(x: 0, y: 0, width: 40, height: 25)
            }
            
            view.addSubview(rightItem!)
            let rightBarButton = UIBarButtonItem(customView: view)
            
            self.navigationItem.rightBarButtonItem = rightBarButton
        } else {
            //.... Set Right/Left Bar Button item
            let rightBarButton = UIBarButtonItem(customView: rightItem!)
            let rightSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            rightSpace.width = -8;    //越小越靠右
            self.navigationItem.rightBarButtonItems = [rightSpace, rightBarButton]
        }
    }

    func setLeftBarItem(_ left: UIButton) {
        //.... Set Right/Left Bar Button item
        let leftBarButton = UIBarButtonItem(customView: left)
        let leftSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftSpace.width = -8;      //越小越靠左
        self.navigationItem.leftBarButtonItems = [leftSpace, leftBarButton]
    }

    func setRightBarItem(_ right: UIButton) {
        let rightBarButton = UIBarButtonItem(customView: right)
        let rightSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        rightSpace.width = -8;    //越小越靠右
        self.navigationItem.rightBarButtonItems = [rightSpace, rightBarButton]
    }
}

extension BFBaseViewController: NavigationControllerBackButtonDelegate {

    @objc func navigationShouldPopOnBackButton() -> Bool {
        leftItemAction(leftItem!)
        return false
    }

    /// 导航栏左边按钮点击
    ///
    /// - Parameter sender: <#sender description#>
    @objc func leftItemAction(_ sender: UIButton?) {

    }

    /// 导航栏右边按钮点击
    ///
    /// - Parameter sender: <#sender description#>
    @objc func rightItemAction(_ sender: UIButton?) {

    }
    
}
