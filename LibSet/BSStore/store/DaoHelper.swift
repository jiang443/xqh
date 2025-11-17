//
//  DaoHelper.swift
//  Rent
//
//  Created by jiang on 19/3/15.
//  Copyright © 2019年 coshine. All rights reserved.
//

import Foundation
import SQLite
import BSCommon

final class DaoHelper {
    fileprivate static let dbVersion = 1
    fileprivate static var sharedInstance:DaoHelper?
    
    //表名
    static let patientTable = Table("Patient")
    
    //用户表
    static let id = Expression<String>("id")
    static let headImg = Expression<String>("headImg")
    static let gender = Expression<Int>("gender")
    static let displayName = Expression<String>("displayName")
    static let nickname = Expression<String>("nickname")
    static let userName = Expression<String>("userName")
    static let scanTime = Expression<String>("scanTime")
    static let comfirmTime = Expression<String>("comfirmTime")
    static let deviceNo = Expression<String>("deviceNo")
    static let schemaName = Expression<String>("schemaName")
    static let schemaRemark = Expression<String>("schemaRemark")
    static let address = Expression<String>("address")
    static let mobile = Expression<String>("mobile")
    static let remarkName = Expression<String>("remarkName")
    static let isComfirmed = Expression<Int>("isComfirmed")
    static let isSign = Expression<Int>("isSign")
    static let isSignLogin = Expression<Int>("isSignLogin")
    static let imAccId = Expression<String>("imAccId")
    static let unionId = Expression<String>("unionId")
    static let tbUpdateTime = Expression<Int>("tbUpdateTime")
    static let tbAddTime = Expression<Int>("tbAddTime")
    
    //========  dbVersion 1 新增  ==========
    static let tbIsMember = Expression<Int>("tbIsMember")
    
    var db:Connection?
    
    fileprivate init() throws{
        let user = UserInfoManager.shareManager().getUserInfo()
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        do {
            if db == nil{
                db = try Connection(path! + "/bs2Doctor_" + user.account + ".sqlite3")
                db?.busyTimeout = 1
            }
        }catch{
            print(error)
        }
        
        //创建用户表
        try db!.run(DaoHelper.patientTable.create(ifNotExists: true, block: { (t) -> Void in
            //t.column(DaoHelper.accountId, unique: true)
            t.column(DaoHelper.id, primaryKey: true)    //用户id
            t.column(DaoHelper.headImg)    //头像
            t.column(DaoHelper.gender)        //性别 1男2女
            t.column(DaoHelper.displayName)    //展示名称
            t.column(DaoHelper.nickname)    //昵称
            t.column(DaoHelper.userName)    //姓名
            t.column(DaoHelper.scanTime)    //扫码时间
            t.column(DaoHelper.comfirmTime)    //报到时间
            t.column(DaoHelper.deviceNo)
            t.column(DaoHelper.schemaName)        //测量方案名称
            t.column(DaoHelper.schemaRemark)      //测量方案备注
            t.column(DaoHelper.address)       //地址
            t.column(DaoHelper.mobile)        //手机
            t.column(DaoHelper.remarkName)    //备注名
            t.column(DaoHelper.isComfirmed)   //是否已报到 1是0否
            t.column(DaoHelper.isSign)        //是否与员工签约
            t.column(DaoHelper.isSignLogin)   //是否与登录员工签约 1是0否
            t.column(DaoHelper.imAccId)       //用户im账号
            t.column(DaoHelper.unionId)
            t.column(DaoHelper.tbUpdateTime)
            t.column(DaoHelper.tbAddTime)
        }))
        
        self.checkVersion()     //检查&升级数据库
    }
    
    static func getInstance() -> DaoHelper{
        if(sharedInstance == nil){
            do{
                sharedInstance = try DaoHelper()
            }catch{
                print(error)
                DebugUtils.reportError(name: "DB Instance Error", detail: error.localizedDescription)
            }
        }
        return sharedInstance!
    }
    
    static func closeDb(){
        ThreadUtils.threadOnDBQueue { () -> Void in
            DaoHelper.sharedInstance?.db = nil
            DaoHelper.sharedInstance = nil
        }
    }
    
    static func close(){
        DaoHelper.sharedInstance = nil
    }
    
    //数据库升级一个版本
    func updateFrom(_ oldVer:Int){
        do {
            switch oldVer {
            case 0:
                try db!.run(DaoHelper.patientTable.addColumn(DaoHelper.tbIsMember, defaultValue: 0))
            default:
                break
            }
        } catch{
            print("Update DB Error :::: \n\(error.localizedDescription)")
        }
    }
    
    //检查&升级数据库
    func checkVersion(){
        let user = UserInfoManager.shareManager().getUserInfo()
        let oldVersion = SettingUserDefault.getDatabaseVersion(user.account)
        SettingUserDefault.setDatabaseVersion(user.account,version: DaoHelper.dbVersion)
        if oldVersion < DaoHelper.dbVersion{
            for idx in oldVersion..<DaoHelper.dbVersion{
                updateFrom(idx)
            }
        }
    }
    
}

