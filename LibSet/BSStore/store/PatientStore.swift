//
//  FansStore.swift
//  Rent
//
//  Created by jiang on 19/3/15.
//  Copyright © 2019年 tmpName. All rights reserved.
//

import Foundation
import SQLite
import BSCommon

public class PatientStore: BaseStore {
    fileprivate static let thisInstance = PatientStore()
    public var tbUpdateTime = 0
    
    public static func getInstance() -> PatientStore{
        thisInstance.isLogin = UserInfoManager.shareManager().isLogin()
        return thisInstance
    }

    fileprivate func copy(_ result:Row) -> StorePatientModel{
        let model = StorePatientModel()
        try? model.id = result.get(DaoHelper.id)
        try? model.headImg = result.get(DaoHelper.headImg)
        try? model.gender = result.get(DaoHelper.gender)
        try? model.displayName = result.get(DaoHelper.displayName)
        try? model.nickname = result.get(DaoHelper.nickname)
        try? model.userName = result.get(DaoHelper.userName)
        try? model.scanTime = result.get(DaoHelper.scanTime)
        try? model.comfirmTime = result.get(DaoHelper.comfirmTime)
        try? model.deviceNo = result.get(DaoHelper.deviceNo)
        try? model.schemaName = result.get(DaoHelper.schemaName)
        try? model.schemaRemark = result.get(DaoHelper.schemaRemark)
        try? model.address = result.get(DaoHelper.address)
        try? model.mobile = result.get(DaoHelper.mobile)
        try? model.remarkName = result.get(DaoHelper.remarkName)
        try? model.isComfirmed = result.get(DaoHelper.isComfirmed)
        try? model.isSign = result.get(DaoHelper.isSign)
        try? model.isSignLogin = result.get(DaoHelper.isSignLogin)
        try? model.imAccId = result.get(DaoHelper.imAccId)
        try? model.unionId = result.get(DaoHelper.unionId)
        try? model.tbUpdateTime = result.get(DaoHelper.tbUpdateTime)
        try? model.tbAddTime = result.get(DaoHelper.tbAddTime)
        try? model.tbIsMember = result.get(DaoHelper.tbIsMember)
        return model
    }
    
    fileprivate func copy(_ model:StorePatientModel) ->[Setter]{
        return [
            DaoHelper.id <- model.id,
            DaoHelper.headImg <- model.headImg,
            DaoHelper.gender <- model.gender,
            DaoHelper.displayName <- model.displayName,
            DaoHelper.nickname <- model.nickname,
            DaoHelper.userName <- model.userName,
            DaoHelper.scanTime <- model.scanTime,
            DaoHelper.comfirmTime <- model.comfirmTime,
            DaoHelper.deviceNo <- model.deviceNo,
            DaoHelper.schemaName <- model.schemaName,
            DaoHelper.schemaRemark <- model.schemaRemark,
            DaoHelper.address <- model.address,
            DaoHelper.mobile <- model.mobile,
            DaoHelper.remarkName <- model.remarkName,
            DaoHelper.isComfirmed <- model.isComfirmed,
            DaoHelper.isSign <- model.isSign,
            DaoHelper.isSignLogin <- model.isSignLogin,
            DaoHelper.imAccId <- model.imAccId,
            DaoHelper.unionId <- model.unionId,
            DaoHelper.tbUpdateTime <- model.tbUpdateTime,
            DaoHelper.tbAddTime <- model.tbAddTime,
            DaoHelper.tbIsMember <- model.tbIsMember
        ]
    }
    
    ///获取全部用户记录
    public func getAllPatient() ->Array<StorePatientModel> {
        var models = Array<StorePatientModel>()
        if !isLogin{
            return models
        }
        do{
            for result in try getDB().prepare(DaoHelper.patientTable) {
                models.append(copy(result))
            }
        }catch{
            print(error)
        }
        return models
    }
    
    ///按条件查询用户
    public func getPatients(bind:Bool?,sign:Bool?,confirm:Bool?,isMember:Int) ->Array<StorePatientModel> {
        var models = Array<StorePatientModel>()
        if !isLogin{
            return models
        }
        do{
            var predicate = DaoHelper.id != ""
            if bind != nil{
                predicate = predicate && (bind! ? DaoHelper.deviceNo != "" : DaoHelper.deviceNo == "")
            }
            if sign != nil{
                predicate = predicate && (sign! ? DaoHelper.isSignLogin == 1 : DaoHelper.isSignLogin == 0)
            }
            if confirm != nil{
                predicate = predicate && (confirm! ? DaoHelper.isComfirmed == 1 : DaoHelper.isComfirmed == 0)
            }
            predicate = predicate && DaoHelper.tbIsMember == isMember
            let resTable = DaoHelper.patientTable.filter(predicate)
            for result in try getDB().prepare(resTable) {
                models.append(copy(result))
            }
        }catch{
            print(error)
        }
        return models
    }
    
    public func delAllPatients(){
        if !isLogin{
            return
        }
        do{
            let db = getDB()
            try db.transaction {
                for result in try db.prepare(DaoHelper.patientTable) {
                    let id = try result.get(DaoHelper.id)
                    let row = DaoHelper.patientTable.filter(DaoHelper.id == id)
                    try db.run(row.delete())
                }
            }
        }catch{
            print(error)
        }
    }
    
    public func getPatient(_ id:String)->StorePatientModel?{
        if !isLogin{
            return nil
        }
        if let row = try? getDB().pluck(DaoHelper.patientTable.filter(DaoHelper.id == id)){
            if row != nil{
                return self.copy(row)
            }
            return nil
        }
        return nil
    }
    
    
    public func getPatientInfo(_ imAccId:String)->StorePatientModel?{
        if !isLogin{
            return nil
        }
        let row = try! getDB().pluck(DaoHelper.patientTable.filter(DaoHelper.imAccId == imAccId))
        if row == nil{
            return nil
        }else{
            return copy(row!)
        }
    }
    
    
    ///存储一个用户
    @discardableResult public func savePatient(_ model : StorePatientModel)->Int {
        if !isLogin{
            return 0
        }
        do{
            //try getDB().run("update sqlite_sequence SET seq = 1 where name = 'Patient'")
            let rowId = try getDB().run(DaoHelper.patientTable.insert(or: .replace,copy(model)))
            return Int(rowId)
        }catch{
            print(error.localizedDescription)
            return 0
        }
    }
    
    ///存储多个用户
    @discardableResult public func savePatients(_ models : [StorePatientModel])->Int {
        if !isLogin{
            return 0
        }
        do{
            let db = getDB()
            try db.transaction {
                let thisUpdateTime = TimeUtils.getCurrentTimeInterval() //本次更新时间
                self.tbUpdateTime = thisUpdateTime
                for model in models{
                    model.tbUpdateTime = thisUpdateTime
                    if model.tbAddTime == 0{
                        model.tbAddTime = thisUpdateTime
                    }
                    try db.run(DaoHelper.patientTable.insert(or: .replace,self.copy(model)))
                }
            }
            return 666
        }catch{
            print(error.localizedDescription)
            return 0
        }
    }
    
    public func updatePatient(_ model : StorePatientModel) {
        if !isLogin{
            return
        }
        let row = DaoHelper.patientTable.filter(DaoHelper.id == model.id)
        do{
            try getDB().run(row.update(copy(model)))
        }catch{
            print("update patientDB failed. ")
        }
    }
    
    public func delPatient(_ id:String){
        if !isLogin{
            return
        }
        let row = DaoHelper.patientTable.filter(DaoHelper.id == id)
        do{
            try getDB().run(row.delete())
        }catch{}
    }
    
    ///删除过期的数据
    public func delOutdated(){
        if !isLogin || self.tbUpdateTime == 0{
            return
        }
        do{
            let resTable = DaoHelper.patientTable.filter(DaoHelper.tbUpdateTime < self.tbUpdateTime-3600)
            try getDB().run(resTable.delete())
        }catch{
            print(error)
        }
    }
    
    
}

