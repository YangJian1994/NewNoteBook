//
//  NoteInfoViewController.swift
//  NoteBook
//
//  Created by 物联网331 on 2017/9/27.
//  Copyright © 2017年 物联网331. All rights reserved.
//

import UIKit
//导入自动布局框架
import SnapKit

class NoteInfoViewController: UIViewController {
    
    var noteModel: NoteModel?
    
    //标题文本框
    var titleTextField: UITextField?
    
    //记事内容文本
    var bodyTextView: UITextView?
    
    //记事所属分组
    var group: String?
    
    //是否是新内容
    var isNew = false

    override func viewDidLoad() {
        super.viewDidLoad()
        //消除导航对布局的影响
        self.edgesForExtendedLayout = UIRectEdge()
        self.view.backgroundColor = UIColor.white
        self.title = "记事"
        
        //监听键盘事件
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardBeShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
        //进行界面的加载
        installUI()
        
        //进行导航功能按钮的加载
        installNavigationItem()
    }
    
    func installNavigationItem() {
        let itemSave = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addNote))
        
        let itemDelete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        
        self.navigationItem.rightBarButtonItems = [itemSave, itemDelete]
    }
    
    func addNote() {
        if isNew {
            if titleTextField?.text != nil && titleTextField!.text!.characters.count > 0 {
                noteModel = NoteModel()
                noteModel?.title = titleTextField?.text
                noteModel?.body = bodyTextView?.text
                
                let dateFomatter = DateFormatter()
                dateFomatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                noteModel?.time = dateFomatter.string(from: Date())
                noteModel?.group = group
                DataManager.addNote(note: noteModel!)
                self.navigationController!.popViewController(animated: true)
            }
        } else {
            if titleTextField?.text != nil && titleTextField!.text!.characters.count > 0 {
                noteModel?.title = titleTextField?.text!
                noteModel?.body = bodyTextView?.text
                let dateFomatter = DateFormatter()
                dateFomatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                noteModel?.time = dateFomatter.string(from: Date())
                DataManager.updateNote(note: noteModel!)
                self.navigationController!.popViewController(animated: true)
            }
        }
    }
    
    func deleteNote() {
        let alertController = UIAlertController(title: "警告", message: "你确定删除此条记事吗", preferredStyle: .alert)
        let action = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let action2 = UIAlertAction(title: "删除", style: .destructive, handler: { (UIAlertAction) -> Void in
            if !self.isNew {
                DataManager.deleteNote(note: self.noteModel!)
                self.navigationController!.popViewController(animated: true)
            }
        })
        alertController.addAction(action)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func keyBoardBeShow(notification: Notification) {
        let userInfo = notification.userInfo!
        let frameinfo = userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject
        
        let height = frameinfo.cgRectValue.size.height
        
        bodyTextView?.snp.updateConstraints({ (maker) in
            maker.bottom.equalTo(-30-height)
        })
        
        UIView.animate(withDuration: 0.3, animations: { () in
            self.view.layoutIfNeeded()
        })
    }
    
    func keyBoardBeHidden(notification: Notification) {
        bodyTextView?.snp.updateConstraints({ (maker) in
            maker.bottom.equalTo(-30)
        })
        
        UIView.animate(withDuration: 0.3, animations: { () in
            self.view.layoutIfNeeded()
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        bodyTextView?.resignFirstResponder()
        titleTextField?.resignFirstResponder()
    }


    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func installUI() {
        titleTextField = UITextField()
        self.view.addSubview(titleTextField!)
        titleTextField?.borderStyle = .none
        titleTextField?.placeholder = "请输入记事标题"
        titleTextField?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(30)
            maker.left.equalTo(30)
            maker.right.equalTo(-30)
            maker.height.equalTo(30)
        })
        
        let line = UIView()
        self.view.addSubview(line)
        line.backgroundColor = UIColor.gray
        line.snp.makeConstraints({ (maker) in
            maker.left.equalTo(15)
            maker.top.equalTo(titleTextField!.snp.bottom).offset(5)
            maker.right.equalTo(-15)
            maker.height.equalTo(0.5)
        })
        bodyTextView = UITextView()
        bodyTextView?.layer.borderColor = UIColor.gray.cgColor
        bodyTextView?.layer.borderWidth = 0.5
        self.view.addSubview(bodyTextView!)
        bodyTextView?.snp.makeConstraints({ (maker) in
            maker.left.equalTo(30)
            maker.right.equalTo(-30)
            maker.top.equalTo(line.snp.bottom).offset(10)
            maker.bottom.equalTo(-30)
        })
        
        if !isNew {
            titleTextField?.text = noteModel?.title
            bodyTextView?.text = noteModel?.body
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
