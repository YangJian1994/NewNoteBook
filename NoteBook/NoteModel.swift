//
//  NoteModel.swift
//  NoteBook
//
//  Created by 物联网331 on 2017/9/26.
//  Copyright © 2017年 物联网331. All rights reserved.
//
import Foundation

class NoteModel: NSObject{
    var time: String?
    
    var title: String?
    
    var body: String?
    
    var group: String?
    
    var noteId: Int?
    
    func toDictionary() -> Dictionary<String, Any> {
        var dict:[String:Any] = ["time": time!, "title": title!, "body": body!, "ownGroup": group!]
        
        if let id = noteId {
            dict["noteId"] = id
        }
        
        return dict
    }
}
