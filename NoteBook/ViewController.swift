//
//  ViewController.swift
//  NoteBook
//
//  Created by 物联网331 on 2017/9/25.
//  Copyright © 2017年 物联网331. All rights reserved.
//

import UIKit


class ViewController: UIViewController, HomeButtonDelegate {
    
    var homeView: HomeView?
    var dataArray: Array<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "点滴生活"
        
        //取消导航栏对页面布局的影响
        self.edgesForExtendedLayout = UIRectEdge()
        dataArray = DataManager.getGroupData()
        self.installUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func installUI() {
        homeView = HomeView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-64))
        self.view.addSubview(homeView!)
        homeView?.dataArray = dataArray
        homeView?.updateLayout()
        
        //设置代理
        homeView?.homeButtonDelegate = self
        
        installNavigationItem()
    }
    
    func installNavigationItem() {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGroup))
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    func addGroup() {
        let alertController = UIAlertController(title: "添加记事分组", message: "添加的分组名不能与已有的分组重复或为空", preferredStyle: .alert)
        //向警告框中添加一个文本输入框
        alertController.addTextField { (textField) in
            textField.placeholder = "请输入记事分组名称"
        }
        
        //向警告框中添加一个取消按钮
        let alertItem = UIAlertAction(title: "取消", style: .cancel, handler: { (UIAlertAction) in return})
        
        //向警告框中添加一个确定按钮
        let alertItemAdd = UIAlertAction(title: "确定", style: .default, handler: { (UIAlertAction) -> Void in
            var exist = false
            self.dataArray?.forEach({ (element) in
                if element == alertController.textFields?.first!.text || alertController.textFields?.first!.text?.characters.count == 0 {
                    exist = true
                }
            })
            if exist {
                print("该项目已经存在！")
                return
            }
            self.dataArray?.append(alertController.textFields!.first!.text!)
            self.homeView?.dataArray = self.dataArray
            self.homeView?.updateLayout()
            DataManager.saveGroup(name: alertController.textFields!.first!.text!)
            
        })
        alertController.addAction(alertItem)
        alertController.addAction(alertItemAdd)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func homeButtonClick(title: String) {
        let controller = NoteListTableViewController()
        controller.name = title
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataArray = DataManager.getGroupData()
        self.homeView?.dataArray = dataArray
        self.homeView?.updateLayout()
    }
    
}

