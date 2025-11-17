//
//  CommonViewModel.swift
//  BSChat-Images
//
//  Created by jiang on 2019/9/9.
//

import UIKit
import AliyunOSSiOS

public class CommonViewModel: BaseViewModel {
    var stsModel = STSModel()
    var client:OSSClient?
    
    /// 申请stsToken
    func getStsToken(onSuccess: @escaping (_ model:STSModel) -> Void, failureCallBack: RequestFailed?) {
        CommonProvider.request(.getStsToken) { result in
            self.checkModel(resp: result, onFail: failureCallBack, success: { (model:STSModel) in
                self.stsModel = model
                onSuccess(model)
            })
        }
    }
    
    // 上传图片
    public func uploadImage(image:UIImage, onSuccess: ((_ url:String) -> Void)?, failureCallBack: RequestFailed?) {
        var model = self.stsModel
        
        ///内嵌函数，上传操作
        func upload(){
            let endPointSuffix = "oss-cn-shenzhen.aliyuncs.com"
            if self.client == nil{
                let credential = OSSStsTokenCredentialProvider(accessKeyId:                                model.AccessKeyId,
                               secretKeyId: model.AccessKeySecret,
                               securityToken: model.SecurityToken)
                YYLog("accessKeyId = \(model.AccessKeyId), secretKeyId = \(model.AccessKeySecret), securityToken = \(model.SecurityToken)")
                self.client = OSSClient.init(endpoint: "https://" + endPointSuffix, credentialProvider: credential)
            }
            
            // 图片的前缀
            let prefix = "bs2/doctor/default/iOS"
            let bucketName = "idt-blood-sugar"
            let objectKey = prefix + TimeUtils.getCurrentTimeString("yyyyMMddHHmmss") + StringUtils.returnRandomString(withCount: 8, type: 0)! + ".png"
            
            let imageData = ImageCenter.resizeImage(image)
            let put = OSSPutObjectRequest()
            put.bucketName = bucketName
            put.uploadingData = imageData
            put.objectKey = objectKey
            let imageUrl = "https://" + bucketName + "." + endPointSuffix + "/" + objectKey
            YYLog("imageUrl = \(imageUrl)")
            
            let putTask = self.client!.putObject(put)
            putTask.continue ({ (task) -> Any? in
                if task.error == nil {
                    ThreadUtils.threadOnMain {
                        onSuccess?(imageUrl)
                    }
                } else {
                    YYLog(task.error!.localizedDescription)
                    ThreadUtils.threadOnMain {
                        failureCallBack?("上传图片失败", 0)
                    }
                }
                return nil
            })
        }
        
        if model.AccessKeyId.isEmpty{
            self.getStsToken(onSuccess: { (sModel) in
                self.stsModel = sModel
                model = sModel
                upload()
            }, failureCallBack: failureCallBack)
        }
        else{
            upload()
        }
    }

}
