//
//  DebugUtils.swift
//  AfterDoctor
//
//  Created by jiang on 2019/11/3.
//  Copyright © 2017年 jiang. All rights reserved.
//

import UIKit
import Bugly
import Moya

public class DebugUtils:NSObject {

    public class func reportError(name:String, detail:String){
        let exception = NSException(name: NSExceptionName(rawValue: name),
                                    reason: detail,
                                    userInfo: nil)
        Bugly.report(exception)
    }

}
