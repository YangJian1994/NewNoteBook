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
    
    class func saveGroup(name: String) {
        if !isOpen {
            self.openDataBase()
        }
        
        let key = SQLiteKeyObject()
        
        key.name = "groupName"
        
        key.fieldType = TEXT
        
        key.modificationType = UNIQUE
        
        if sqlHandle == nil  {
            sqlHandle!.createTable(withName: "groupTable", keys: [key])
        }
        
        sqlHandle!.insertData(["groupName":name], intoTable: "groupTable")
    }
    
    class func getGroupData() -> [String] {
        if !isOpen {
            self.openDataBase()
        }
        
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
    
    class func openDataBase() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        let file = path + "/DataBase.sqlite"
        
        sqlHandle = SQLiteSwift3.openDB(file)
        
        isOpen = true
    }
    
    class func addNote(note: NoteModel) {
        if !isOpen {
            self.openDataBase()
        }
        
        if sqlHandle == nil {
            self.createNoteTable()
        }
        
        sqlHandle!.insertData(note.toDictionary(), intoTable: "noteTable")
    }
    
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
    
    class func updateNote(note: NoteModel) {
        if !isOpen {
            self.openDataBase()
        }
        
        sqlHandle?.updateData(note.toDictionary(), intoTable: "noteTable", while: "noteId = \(note.noteId!)", isSecurity: true)
    }
    
    class func deleteNote(note: NoteModel) {
        if !isOpen {
            self.openDataBase()
        }
        sqlHandle?.deleteData("noteId = \(note.noteId!)", intoTable: "noteTable", isSecurity: true)
    }
    
    class func deleteGroup(name: String) {
        if !isOpen {
            self.openDataBase()
        }
        sqlHandle?.deleteData("ownGroup =\"\(name)\"", intoTable: "noteTable", isSecurity: true)
        
        sqlHandle?.deleteData("GroupName = \"\(name)\"", intoTable: "groupTable", isSecurity: true)
    }
    
}


