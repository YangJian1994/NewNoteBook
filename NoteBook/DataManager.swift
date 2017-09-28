//
//  DataManager.swift
//  NoteBook
//
//  Created by 物联网331 on 2017/9/25.
//  Copyright © 2017年 物联网331. All rights reserved.
//
import SQLiteSwift3

class DataManager: NSObject{
    
    //创建一个数据库操作对象属性（类属性）
    static var sqlHandle: SQLiteSwift3?
    
    //标记是否已经打开数据库
    static var isOpen = false
    
    //对分组数据进行存储的类方法
    class func saveGroup(name: String) {
        if !isOpen {
            self.openDataBase()
        }
        
        //创建一个数据表字段对象
        let key = SQLiteKeyObject()
        
        key.name = "groupName"
        
        key.fieldType = TEXT
        
        key.modificationType = UNIQUE
        
        if sqlHandle == nil  {
            //如果表不存在，则创建
            sqlHandle!.createTable(withName: "groupTable", keys: [key])
        }
        //进行数据的插入
        sqlHandle!.insertData(["groupName":name], intoTable: "groupTable")
    }
    
    //获取分组数据的类方法
    class func getGroupData() -> [String] {
        if !isOpen {
            self.openDataBase()
        }
        
        //创建查询请求对象
        let request = SQLiteSearchRequest()
        
        var array = Array<String>()
        
        sqlHandle?.searchData(withReeuest: request, inTable: "groupTable", searchFinish: {
                (success, dataArray) in
            dataArray?.forEach({ (element) in
                    array.append(element.values.first! as! String)
            })
        })
        
        return array
    }
    
    //打开数据库
    class func openDataBase() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        let file = path + "/DataBase.sqlite"
        
        sqlHandle = SQLiteSwift3.openDB(file)
        
        isOpen = true
    }
    
    //添加记事的方法
    class func addNote(note: NoteModel) {
        if !isOpen {
            self.openDataBase()
        }
        
        if sqlHandle == nil {
            self.createNoteTable()
        }
        
        sqlHandle!.insertData(note.toDictionary(), intoTable: "noteTable")
    }
    
    //获取记事方法
    class func getNote(group: String) -> [NoteModel] {
        if !isOpen {
            self.openDataBase()
        }
        
        let request = SQLiteSearchRequest()
        
        request.contidion = "ownGroup=\"\(group)\""
        
        var array = Array<NoteModel>()
        
        sqlHandle?.searchData(withReeuest: request, inTable: "noteTable", searchFinish: { (success, dataArray) in
            dataArray?.forEach({ (element) in
                let note = NoteModel()
                note.time = element["time"] as! String?
                note.title = element["title"] as! String?
                note.body = element["body"] as! String?
                note.group = element["ownGroup"] as! String?
                note.noteId = element["noteId"] as! Int?
                array.append(note)
            })
        })
        return array
    }
    //创建记事表
    class func createNoteTable() {
        let key1 = SQLiteKeyObject()
        key1.name = "noteId"
        key1.fieldType = INTEGER
        key1.modificationType = PRIMARY_KEY
        
        let key2 = SQLiteKeyObject()
        key2.name = "ownGroup"
        key2.fieldType = TEXT
        
        let key3 = SQLiteKeyObject()
        key3.name = "body"
        key3.fieldType = TEXT
        key3.tSize = 400
        
        let key4 = SQLiteKeyObject()
        key4.name = "title"
        key4.fieldType = TEXT
        
        let key5 = SQLiteKeyObject()
        key5.name = "time"
        key5.fieldType = TEXT
        
        sqlHandle!.createTable(withName: "noteTable", keys: [key1, key2, key3, key4, key5])
    }
    
    //更新记事内容
    class func updateNote(note: NoteModel) {
        if !isOpen {
            self.openDataBase()
        }
        
        sqlHandle?.updateData(note.toDictionary(), intoTable: "noteTable", while: "noteId = \(note.noteId!)", isSecurity: true)
    }
    
    //删除记事内容
    class func deleteNote(note: NoteModel) {
        if !isOpen {
            self.openDataBase()
        }
        sqlHandle?.deleteData("noteId = \(note.noteId!)", intoTable: "noteTable", isSecurity: true)
    }
    
    //删除一个分组，将其下的所有记事都删除
    class func deleteGroup(name: String) {
        if !isOpen {
            self.openDataBase()
        }
        sqlHandle?.deleteData("ownGroup =\"\(name)\"", intoTable: "noteTable", isSecurity: true)
        
        sqlHandle?.deleteData("GroupName = \"\(name)\"", intoTable: "groupTable", isSecurity: true)
    }
    
}


