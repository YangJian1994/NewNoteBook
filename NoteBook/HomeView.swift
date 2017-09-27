//
//  HomeView.swift
//  NoteBook
//
//  Created by 物联网331 on 2017/9/25.
//  Copyright © 2017年 物联网331. All rights reserved.
//

import UIKit

class HomeView: UIScrollView {
    
    let interitemSpacing = 15
    
    let lineSpacing = 25
    
    var dataArray: Array<String>?
    
    var itemArray: Array<UIButton> = Array<UIButton>()
    
    var homeButtonDelegate: HomeButtonDelegate?
    
    func updateLayout() {
        //按钮的宽度
        let itemWidth = (self.frame.size.width - CGFloat(4 * interitemSpacing)) / 3
        //按钮的高度
        let itemHeight = itemWidth/3*4
        
        //将界面上面已有的按钮移除
        itemArray.forEach({ (element) in
            element.removeFromSuperview()
        })
        
        itemArray.removeAll()
        
        if dataArray != nil && dataArray!.count > 0 {
            for index in 0..<dataArray!.count {
                let btn = UIButton(type: .system)
                btn.setTitle(dataArray![index], for: .normal)
                
                btn.frame = CGRect(x: CGFloat(interitemSpacing) + CGFloat(index%3) * (itemWidth + CGFloat(interitemSpacing)), y: CGFloat(lineSpacing) + CGFloat(index/3) * (itemHeight + CGFloat(lineSpacing)), width: itemWidth, height: itemHeight)
                
                btn.backgroundColor = UIColor(red: 1, green: 242/255.0, blue: 216/255.0, alpha: 1)
                
                //设置按钮圆角
                btn.layer.masksToBounds = true
                btn.layer.cornerRadius = 15
                btn.setTitleColor(UIColor.gray, for: .normal)
                btn.tag = index
                btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
                self.addSubview(btn)
                
                //将按钮实例添加到数组中
                itemArray.append(btn)
            }
            self.contentSize = CGSize(width: 0, height: itemArray.last!.frame.origin.y + itemArray.last!.frame.size.height + CGFloat(lineSpacing))
        }
        
    }
    
    func btnClick(btn: UIButton) {
        if homeButtonDelegate != nil {
            print("存在")
            homeButtonDelegate?.homeButtonClick(title: dataArray![btn.tag])
        }
    }
}

protocol HomeButtonDelegate {
    func homeButtonClick(title: String)
}

