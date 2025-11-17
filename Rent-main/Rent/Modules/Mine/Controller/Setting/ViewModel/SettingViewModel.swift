//
//  SettingViewModel.swift
//  Rent
//
//  Created by jiang 2019/2/28.
//  Copyright © 2019年 jiang. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class SettingViewModel: NSObject {

    let datasource = [["修改密码"],
                      ["关于版本", "检查更新"]]
    
    var clientVersion = ""  // 最新的版本号
    var isForce = 0         // 更新内容
    var updateContent = ""  // 更新内容
}

extension SettingViewModel {
    
    // 修改密码
    func changePassword(oldPassword: String, newPassword: String, callBack: RequestSuccess?) {

    }

}
