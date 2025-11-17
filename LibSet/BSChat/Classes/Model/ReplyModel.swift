//
//  ReplyModel.swift
//  Alamofire
//
//  Created by jiang on 2019/4/19.
//

import Foundation
import HandyJSON

struct ReplyModel: HandyJSON {
    var conv = Conv()
    var taskResult = TaskResult()
    
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
    
    struct TaskResult: HandyJSON {
        var isComplete = 0
        var completeTime = ""
        var points = 0
    }
    
    
}
