//
//  ChatController.swift
//  Alamofire
//
//  Created by jiang on 2019/3/27.
//


import UIKit
import HandyJSON
import BSCommon

class BSChatViewModel: BaseViewModel {
    var totalPages = 0
    var currentPage = 1
    var assistList = [AssistModel]()
    var supperList = [AssistModel]()
    let researchUserTypes:[UserType] = [.nurse,.director,.pi,.comDirector,.comNurse]
    var unHandleMeasureCount = 0
}

extension BSChatViewModel {
    ///获取会话状态（若无IM账号，后台自动创建）
    func getConvState(patientId:String, callBack: ((_ model: ConvStateModel) ->Void)?, failureCallBack: RequestFailed?) {
        DoctorChatProvider.request(.convState(patientId:patientId)) { (result) in
            self.checkJson(resp: result, onFail: failureCallBack, success: { (json) in
                if let model = JSONDeserializer<ConvStateModel>.deserializeFrom(json: json["data"].description) {
                    callBack?(model)
                }
                else{
                    failureCallBack?("数据错误",0)
                    YYLog("⭕️数据解析错误")
                }
            })
        }
    }
    
    ///消息已发送
    func replyPatient(patientId:String, taskId:String, callBack: ((_ model: ReplyModel) ->Void)?, failureCallBack: RequestFailed?) {
        let type = UserInfoManager.shareManager().getType()
        if type == .doctor{
            var taskDict:[String:String]? = ["taskId":taskId]
            if taskId.isEmpty{
                taskDict = nil
            }
            DoctorChatProvider.request(.replyPatient(patientId:patientId,task:taskDict)) { (result) in
                //从"data"字段取返回的状态数据到Model
                self.checkModel(resp: result, onFail: failureCallBack, success: { (model:ReplyModel) in
                    callBack?(model)
                })
            }
        }
        else if researchUserTypes.contains(type){
            ResearchChatProvider.request(.replyPatient(patientId:patientId)) { (result) in
                //无"data"字段，不做数据提取，请求成功即可
                self.checkJson(resp: result, onFail: failureCallBack, success: { (json) in
                    //callBack?(ReplyModel())
                })
            }
        }
    }
    
    ///消息已发送
    func replyStaff(staffId:String, callBack: ((_ model: ReplyModel) ->Void)?, failureCallBack: RequestFailed?) {
        let resBlock:Completion = { (result) in
            //无"data"字段，不做数据提取，请求成功即可
            self.checkJson(resp: result, onFail: failureCallBack, success: { (json) in
                callBack?(ReplyModel())
            })
        }
        let type = UserInfoManager.shareManager().getType()
        if type == .doctor{
            DoctorChatProvider.request(.replyStaff(staffId:staffId), completion: resBlock)
        }
        else if researchUserTypes.contains(type){
            ResearchChatProvider.request(.replyStaff(staffId:staffId), completion: resBlock)
        }
    }
    
    ///首页消息未读数量
    func homeUnreadCount(callBack: ((_ model: HomeUnreadCountModel) ->Void)?, failureCallBack: RequestFailed?) {
        DoctorChatProvider.request(.homeUnreadCount) { (result) in
            self.checkModel(resp: result, onFail: failureCallBack, success: { (model:HomeUnreadCountModel) in
                callBack?(model)
            })
        }
    }
    
    ///开启一次会话
    func createConv(patientId:String, callBack: ((_ model: OpenConvModel) ->Void)?, failureCallBack: RequestFailed?) {
        DoctorChatProvider.request(.createConv(patientId:patientId)) { (result) in
            self.checkModel(resp: result, onFail: failureCallBack, success: { (model:OpenConvModel) in
                callBack?(model)
            })
        }
    }
    
    ///我的助手成员列表
    func assistList(callBack: ((_ list: [AssistModel]) ->Void)?, failureCallBack: RequestFailed?) {
        let resBlock:Completion = { (result) in
            self.checkList(resp: result, onFail: failureCallBack, success: { (list:[AssistModel]) in
                self.assistList = list
                callBack?(list)
            })
        }
        
        let type = UserInfoManager.shareManager().getType()
        if type == .doctor{
            DoctorChatProvider.request(.assistList, completion: resBlock)
        }
        else if researchUserTypes.contains(type){
            ResearchChatProvider.request(.assistList, completion: resBlock)
        }
    }
    
    ///上级员工列表
    func upperList(callBack: ((_ list: [AssistModel]) ->Void)?, failureCallBack: RequestFailed?) {
        let resBlock:Completion = { (result) in
            self.checkList(resp: result, onFail: failureCallBack, success: { (list:[AssistModel]) in
                self.supperList = list
                callBack?(list)
            })
        }
        DoctorChatProvider.request(.upperList, completion: resBlock)
    }
    
    ///查询某个员工的im账号
    func getStaffImAccount( staffId:String, callBack: ((_ imAccount: String) ->Void)?, failureCallBack: RequestFailed?) {
        let resBlock:Completion = { (result) in
            self.checkJson(resp: result, onFail: failureCallBack, success: { (json) in
                callBack?(json["data"]["accId"].stringValue)
            })
        }
        ResearchChatProvider.request(.getStaffImAccount(staffId:staffId), completion: resBlock)
    }
    
    // 获取我的用户圈评论回复数
    func unreadCount(callBack: ((_ count: Int) ->Void)?, failureCallBack: RequestFailed?){
        DoctorChatProvider.request(.unreadCount) { result in
            self.checkJson(resp: result, onFail: failureCallBack, success: { (json) in
                callBack?(json["data"].intValue)
            })
        }
    }
    
    // 获取未处理记录的数量
    func countUnhandleMeasure(successCallBack: RequestSuccess?, failureCallBack: RequestFailed?) {
        DoctorChatProvider.request(.countUnhandleMeasure) { result in
            self.checkJson(resp: result, onFail: failureCallBack, success: { (json) in
                self.unHandleMeasureCount = json["data"]["unHandleMeasureCount"].intValue
                successCallBack?()
            })
        }
    }
    
    // 待处理的报警任务数量(暂时无用)
    func getUnusualTaskCount(callBack: ((_ count: Int) ->Void)?, failureCallBack: RequestFailed?){
        DoctorChatProvider.request(.getUnusualTaskCount) { result in
            self.checkJson(resp: result, onFail: failureCallBack, success: { (json) in
                callBack?(json["data"]["unProcessedTaskCount"].intValue)
            })
        }
    }
    
    // 社区Careleader完善资料任务数量
    func getComNurseCompleteDataCount(beginDate:String, endDate:String, callBack: ((_ count: Int) ->Void)?, failureCallBack: RequestFailed?){
        DoctorChatProvider.request(.getComNurseCompleteDataCount(beginDate:beginDate, endDate:endDate)) { result in
            self.checkJson(resp: result, onFail: failureCallBack, success: { (json) in
                callBack?(json["data"]["noDoneCount"].intValue)
            })
        }
    }
    
    ///社区常用联系人
    func topContacts( callBack: ((_ list: [TopContactModel]) ->Void)?, failureCallBack: RequestFailed?) {
        DoctorChatProvider.request(.topContacts) { (result) in
            self.checkList(resp: result, onFail: failureCallBack, success: { (list:[TopContactModel]) in
                callBack?(list)
            })
        }
    }
    
}
