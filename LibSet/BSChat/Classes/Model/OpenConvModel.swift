//
//  OpenConvModel.swift
//  Alamofire
//
//  Created by jiang on 2019/4/20.
//

import HandyJSON

struct OpenConvModel: HandyJSON {
    var conv = Conv()
    
    struct Conv: HandyJSON {
        ///会话发起人类型 1-用户 2-员工
        var initiatorType = 0
        ///会话开始时间
        var startTime = ""
        var endTime = ""
        var isEnd = 1
        var isFrozen = 0
    }

    
}
