//
//  APISettingsViewController.swift
//  Rent
//
//  Created by jiang on 2018/5/27.
//  Copyright © 2018年 sanxin. All rights reserved.
//

import UIKit
import SwiftEventBus
import BSBase
import BSCommon

class APISettingsViewController: BaseViewController {

    let apiTextView = UITextView()
    let h5TextView = UITextView()
    let wxTextView = UITextView()
    var tmpConfigType = NetWorkConfig.configType
    
    /// 选择按钮
    lazy var selectButton: UIButton = {
        let button = UIButton()
        button.setTitle("选择环境", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIUtils.getThemeColor(), for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIUtils.getThemeColor().cgColor
        button.addTarget(self, action: #selector(touchSelect), for: .touchUpInside)
        return button
    }()
    
    /// 清空按钮
    lazy var cleanButton: UIButton = {
        let button = UIButton()
        button.setTitle("清空设置", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIUtils.getThemeColor(), for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIUtils.getThemeColor().cgColor
        button.addTarget(self, action: #selector(touchClean), for: .touchUpInside)
        return button
    }()
    
    /// 确定按钮
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("确定修改", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.red, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.addTarget(self, action: #selector(setConfig), for: .touchUpInside)
        return button
    }()
    
    
    override func initUI() {
        self.title = "环境设置"
        setNavTheme()
        self.apiTextView.text = NetWorkConfig.BASE_URL    //接口
        self.h5TextView.text = NetWorkConfig.H5_BASE_URL    //H5域名
        self.wxTextView.text = NetWorkConfig.H5_WX_DOMAIN
        
        self.view.addSubview(selectButton)
        self.view.addSubview(cleanButton)
        self.view.addSubview(confirmButton)
        
        layout()
    }
    
    func layout(){
        let apiLabel = UILabel()
        UIUtils.setLabel(apiLabel)
        apiLabel.text = "接口地址："
        self.view.addSubview(apiLabel)
        
        let h5Label = UILabel()
        UIUtils.setLabel(h5Label)
        h5Label.text = "App-H5地址："
        self.view.addSubview(h5Label)
        
        let wxLabel = UILabel()
        UIUtils.setLabel(wxLabel)
        wxLabel.text = "微信页面地址："
        self.view.addSubview(wxLabel)
        
        self.view.addSubview(apiTextView)
        self.view.addSubview(h5TextView)
        self.view.addSubview(wxTextView)
        apiTextView.addBorder()
        h5TextView.addBorder()
        wxTextView.addBorder()
        apiTextView.font = UIFont.systemFont(ofSize: 14)
        h5TextView.font = UIFont.systemFont(ofSize: 14)
        wxTextView.font = UIFont.systemFont(ofSize: 14)
        
        apiLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.top.equalTo(self.view).offset(30)
            make.height.equalTo(20)
            make.width.equalTo(150)
        }

        apiTextView.snp.makeConstraints { (make) in
            make.left.equalTo(apiLabel)
            make.right.equalTo(self.view).offset(-15)
            make.top.equalTo(apiLabel.snp.bottom)
            make.height.equalTo(60)
        }

        h5Label.snp.makeConstraints { (make) in
            make.left.height.height.equalTo(apiLabel)
            make.top.equalTo(apiTextView.snp.bottom).offset(10)
        }

        h5TextView.snp.makeConstraints { (make) in
            make.left.equalTo(apiLabel)
            make.right.equalTo(self.view).offset(-15)
            make.top.equalTo(h5Label.snp.bottom)
            make.height.equalTo(60)
        }

        wxLabel.snp.makeConstraints { (make) in
            make.left.height.height.equalTo(apiLabel)
            make.top.equalTo(h5TextView.snp.bottom).offset(10)
        }

        wxTextView.snp.makeConstraints { (make) in
            make.left.equalTo(apiLabel)
            make.right.equalTo(self.view).offset(-15)
            make.top.equalTo(wxLabel.snp.bottom)
            make.height.equalTo(60)
        }
        
        selectButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.width.equalTo(self.view).multipliedBy(0.35)
            make.height.equalTo(40)
            make.top.equalTo(wxTextView.snp.bottom).offset(20)
        }
        
        cleanButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-15)
            make.width.equalTo(self.view).multipliedBy(0.35)
            make.height.equalTo(40)
            make.top.equalTo(wxTextView.snp.bottom).offset(20)
        }
        
        confirmButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
            make.height.equalTo(40)
            make.top.equalTo(selectButton.snp.bottom).offset(20)
        }
    }
    
    @objc func setConfig(){
        let apiUrl = self.apiTextView.text!
        let h5Url = self.h5TextView.text!
        let wxUrl = self.wxTextView.text!
        if !apiUrl.hasPrefix("http"){
            YYHUD.showToast("接口地址无效")
            return
        }
        if !h5Url.hasPrefix("http"){
            YYHUD.showToast("H5地址无效")
            return
        }
        
        let userTyper = UserInfoManager.shareManager().getType()
        if userTyper == .doctor && !wxUrl.hasPrefix("http"){
            YYHUD.showToast("网页地址无效")
            return
        }
        var dict = [String:Any]()
        dict["h5"] = h5Url
        dict["wx"] = wxUrl
        dict["api"] = apiUrl
        NetWorkConfig.configType = self.tmpConfigType
        NetWorkConfig.configDict = dict
        NetWorkConfig.onDebug = true
        
        if userTyper == .doctor{
            GroupDefaults["API"] = apiUrl  //共享给Extension
        }
        DialogUtils.showMessage("设置成功，重启APP后本次设置失效！")
    }
    
    
    @objc func touchSelect(){
        let msg = "请检查自动填充内容，如有错误，请修改！"
        let alert = UIAlertController(title: "请选择需要的环境：", message: msg, preferredStyle: .actionSheet)
        alert.addAction(title: "开发", color: UIUtils.getTextBlueColor(), action: { action in
            self.tmpConfigType = .dev
            self.autoFill()
            DialogUtils.showMessage("请检查自动填充内容，如有错误，请修改！ 点击\"确定修改\"后生效。", title: "开发环境")
        })
        alert.addAction(title: "测试", color: UIUtils.getTextBlueColor(), action: { action in
            self.tmpConfigType = .test
            self.autoFill()
            DialogUtils.showMessage("请检查自动填充内容，如有错误，请修改！ 点击\"确定修改\"后生效。", title: "测试环境")
        })
        alert.addAction(title: "生产", color: UIUtils.getTextBlueColor(), action: { (action) in
            self.tmpConfigType = .pro
            self.autoFill()
            DialogUtils.showMessage("请检查自动填充内容，如有错误，请修改！ 点击\"确定修改\"后生效。", title: "生产环境")
        })
        alert.addCancelAction(title: "取消")
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func autoFill(){
        let dict = NetWorkConfig.getConfigs(type: tmpConfigType)
        self.apiTextView.text = dict.stringValue(key: "api")    //接口
        self.h5TextView.text = dict.stringValue(key: "h5")    //H5域名
        self.wxTextView.text = dict.stringValue(key: "wx")
    }
    
    @objc func touchClean(){
        self.apiTextView.text = ""
        self.h5TextView.text = ""
        self.wxTextView.text = ""
    }
}
