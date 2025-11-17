///
//  MainManager.swift
//  XQH
//  公共函数管理类
//
//  Created by jiang on 2019/8/8.
//  Copyright © 2020年 tmpName. All rights reserved.
//

import Foundation
import HandyJSON

struct ConvStateModel: HandyJSON {
    var conv = Conv()
    var im = IM()
    
    //ext params
    var needLoadPatient = false
    var onTask = false
    var taskId = ""
    
    struct Conv: HandyJSON {
        ///会话发起人类型 1-用户 2-员工
        var initiatorType = 0
        ///会话开始时间
        var startTime = ""
        var endTime = ""
        var isEnd = 1
        var isFrozen = 0
        var isInBlacklist = 0
    }
    
    struct IM: HandyJSON {
        var accId = ""
    }
    
    ///从字典中获取数据
    mutating func getDataFrom(_ dict:[String:Any]){
        self.conv.initiatorType = dict.intValue(key: "initiatorType")
        self.conv.startTime = dict.stringValue(key: "startTime")
        self.conv.isEnd = dict.intValue(key: "isEnd")
        self.conv.isFrozen = dict.intValue(key: "isFrozen")
        self.conv.isInBlacklist = dict.intValue(key: "isInBlacklist")
        self.im.accId = dict.stringValue(key: "accId")
        self.needLoadPatient = dict.intValue(key: "needLoadPatient")==0 ? false : true
        self.onTask = dict.intValue(key: "onTask")==0 ? false : true
        self.taskId = dict.stringValue(key: "taskId")
    }
    
}
