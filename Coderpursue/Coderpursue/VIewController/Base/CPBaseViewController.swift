//
//  CPBaseViewController.swift
//  Coderpursue
//
//  Created by wenghengcong on 15/12/30.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

import UIKit

class CPBaseViewController: UIViewController,UIGestureRecognizerDelegate {

    var topOffset: CGFloat = 64.0
    var leftItem:UIButton? {
        didSet{
            
            if let left = leftItem {
                setLeftBarItem(left)
            }
            
        }
    }
    
    var rightItem:UIButton? {
        didSet{
            
            if let right = rightItem {
                setRightBarItem(right)
            }
        }
    }
    
    var leftItemImage:UIImage? {
        didSet{
            leftItem!.setImage(leftItemImage, forState: .Normal)
        }
    }
    
    var leftItemSelImage:UIImage? {
        didSet{
            leftItem!.setImage(leftItemSelImage, forState: .Selected)
        }
    }
    
    var rightItemImage:UIImage? {
        didSet{
            rightItem!.setImage(rightItemImage, forState: .Normal)
        }
    }
    
    var rightItemSelImage:UIImage? {
        didSet{
            rightItem!.setImage(rightItemSelImage, forState: .Selected)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customView()
    }
    
    func customView() {
        self.view.backgroundColor = UIColor.viewBackgroundColor()
        //下面语句添加在CPBaseNavigationController中无效
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationBarBackgroundColor()
        self.navigationController?.navigationBar.titleTextAttributes = CPStyleGuide.navTitleTextAttributes()
        //返回按钮颜色与文字
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        //启用滑动返回（swipe back）
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        
        customLeftItem()
        customRightItem()
    }
    
    func customLeftItem() {
        
        leftItem = UIButton()
        leftItem!.setImage(UIImage(named: "arrow_left"), forState: .Normal)
        leftItem!.setImage(UIImage(named: "arrow_left"), forState: .Selected)
        
        leftItem!.frame = CGRectMake(0, 5, 25, 25)
        leftItem!.addTarget(self, action: #selector(CPBaseViewController.navigationShouldPopOnBackButton), forControlEvents: .TouchUpInside)
        leftItem!.hidden = false
        
        //.... Set Right/Left Bar Button item
        let leftBarButton = UIBarButtonItem.init(customView: leftItem!)
        let leftSpace = UIBarButtonItem.init(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        leftSpace.width = -8;      //越小越靠左
        
        self.navigationItem.leftBarButtonItems = [leftSpace,leftBarButton]

    }
    
    func customRightItem() {
        
        rightItem = UIButton()
        
        rightItem!.frame = CGRectMake(0, 5, 25, 25)
        rightItem!.addTarget(self, action: #selector(CPBaseViewController.rightItemAction(_:)), forControlEvents: .TouchUpInside)
        rightItem!.hidden = true
        
        //.... Set Right/Left Bar Button item
        let rightBarButton = UIBarButtonItem(customView: rightItem!)
        
        let rightSpace = UIBarButtonItem.init(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        rightSpace.width = -29;    //越小越靠右
        
        self.navigationItem.rightBarButtonItems = [rightSpace,rightBarButton]
        
    }
    
    func setLeftBarItem(left:UIButton) {
        
        //.... Set Right/Left Bar Button item
        let leftBarButton = UIBarButtonItem.init(customView: left)
        let leftSpace = UIBarButtonItem.init(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        leftSpace.width = -8;      //越小越靠左
        
        self.navigationItem.leftBarButtonItems = [leftSpace,leftBarButton]
    }
    
    func setRightBarItem(right:UIButton) {
        
        let rightBarButton = UIBarButtonItem(customView: right)

        let rightSpace = UIBarButtonItem.init(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        rightSpace.width = -29;    //越小越靠右
        
        self.navigationItem.rightBarButtonItems = [rightSpace,rightBarButton]
        
    }
    
}


extension CPBaseViewController : NavigationControllerBackButtonDelegate {
    
    func navigationShouldPopOnBackButton() -> Bool {
        leftItemAction(leftItem!)
        return false
    }
    
    func leftItemAction(sender:UIButton?) {
        
    }
    
    func rightItemAction(sender:UIButton?) {
        
    }
}

