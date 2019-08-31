//
//  JSViewController.swift
//  LoveYou
//
//  Created by WengHengcong on 2016/10/31.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit

class JSViewController: UIViewController, UIGestureRecognizerDelegate {

    var topOffset: CGFloat = 64.0

    var leftItem: UIButton? {
        didSet {

            if let left = leftItem {
                setLeftBarItem(left)
            }

        }
    }

    var rightItem: UIButton? {
        didSet {

            if let right = rightItem {
                setRightBarItem(right)
            }
        }
    }

    var leftItemImage: UIImage? {
        didSet {
            leftItem!.setImage(leftItemImage, for: UIControlState())
        }
    }

    var leftItemSelImage: UIImage? {
        didSet {
            leftItem!.setImage(leftItemSelImage, for: .selected)
        }
    }

    var rightItemImage: UIImage? {
        didSet {
            rightItem!.setImage(rightItemImage, for: UIControlState())
        }
    }

    var rightItemSelImage: UIImage? {
        didSet {
            rightItem!.setImage(rightItemSelImage, for: .selected)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        customView()
    }

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

        leftItem!.frame = CGRect(x: 0, y: 5, width: 25, height: 25)
        leftItem!.addTarget(self, action: #selector(JSViewController.navigationShouldPopOnBackButton), for: .touchUpInside)
        leftItem!.isHidden = false

        //.... Set Right/Left Bar Button item
        let leftBarButton = UIBarButtonItem(customView: leftItem!)
        let leftSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftSpace.width = -8;      //越小越靠左

        self.navigationItem.leftBarButtonItems = [leftSpace, leftBarButton]

    }

    func customRightItem() {

        rightItem = UIButton()

        rightItem!.frame = CGRect(x: 0, y: 5, width: 25, height: 25)
        rightItem!.addTarget(self, action: #selector(JSViewController.rightItemAction(_:)), for: .touchUpInside)
        rightItem!.isHidden = true

        //.... Set Right/Left Bar Button item
        let rightBarButton = UIBarButtonItem(customView: rightItem!)

        let rightSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        rightSpace.width = -8;    //越小越靠右

        self.navigationItem.rightBarButtonItems = [rightSpace, rightBarButton]

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

extension JSViewController : NavigationControllerBackButtonDelegate {

    @objc func navigationShouldPopOnBackButton() -> Bool {
        leftItemAction(leftItem!)
        return false
    }

    func leftItemAction(_ sender: UIButton?) {

    }

    @objc func rightItemAction(_ sender: UIButton?) {

    }
}
