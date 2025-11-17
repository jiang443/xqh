//
//  UserInfoModel.swift
//  Rent
//
//  Created by jiang 2019/2/27.
//  Copyright © 2019年 jiang. All rights reserved.
//

import UIKit
import HandyJSON

public struct UserInfoModel: HandyJSON {
    public var name = ""
    public var isBindWx = 0
    public var orgName = ""
    public var userType = 0
    public var email = ""
    public var area = ""
    public var unionId = ""
    public var headPic = ""
    public var orgType = ""
    public var businessLicense = ""
    public var id = 0
    public var phone = ""
    public var nickName = ""
    public var address = ""
    
    public var accId = ""
    public var token = ""
    public var pushAlias = ""
    
    public var account: String{
        set{
            self.phone = newValue
        }
        get{
            return self.phone
        }
    }
    
    public init() {}
}


public enum BussinessRole: Int {
    case nurseLeader = 1
    case nurse = 2
    case areaLeader = 3
    case contact = 4    //
    case doctor = 5 //员工
    case pi = 10
    case director = 11  //
    case researchNurse = 12 // Careleader
    case comDirector = 13
    case comNurse = 14
    
    
    ///获取身份名称
    public func getName() -> String{
        var res = ""
        switch self {
        case .nurseLeader:
            res = "员工A"
        case .nurse:
            res = "员工B"
        case .areaLeader:
            res = "TSM" //
        case .contact:
            res = "TSO" //
        case .doctor:
            res = "员工C"  //
        case .pi:
            res = "员工D"
        case .director:
            res = "指导专家"
        case .researchNurse:
            res = "Careleader"    // Careleader
        case .comDirector:
            res = "中心主任"
        case .comNurse:
            res = "社区Careleader"
        default:
            break
        }
        return res
    }
}
