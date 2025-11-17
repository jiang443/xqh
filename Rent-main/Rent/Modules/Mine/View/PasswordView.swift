//
//  PasswordView.swift
//  BSNurse
//
//  Created by jiang 2019/4/3.
//  Copyright © 2019年 iDoctor. All rights reserved.
//

import UIKit

class PasswordView: UIView {

    /// 开始编辑
    var textDidBeginEditing: (() -> Void)?

    /// 结束编辑
    var textDidEndEditing: (() -> Void)?

    /// 输入值改变
    var textValueChange: ((_ text: String) -> Void)?
    
    /// 输入完成
    var inputFinish: ((_ text: String) -> Void)?
    
    lazy var textFiled: UITextField = {
        let textField = UITextField()
        textField.keyboardType = UIKeyboardType.numberPad
        textField.tintColor = UIColor.clear
        textField.textColor = UIColor.clear
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFiledDidChange(_:)), for: UIControl.Event.editingChanged)
        return textField
    }()
    
    lazy var borderView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.color(withHexString: "#CCCCCC").cgColor
        view.layer.borderWidth = 1
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var pswLabel1: UILabel = {
        let label = UILabel()
        label.backgroundColor = TextColor_3
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.isHidden = true
        return label
    }()
    
    lazy var pswLabel2: UILabel = {
        let label = UILabel()
        label.backgroundColor = TextColor_3
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.isHidden = true
        return label
    }()

    lazy var pswLabel3: UILabel = {
        let label = UILabel()
        label.backgroundColor = TextColor_3
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.isHidden = true
        return label
    }()

    lazy var pswLabel4: UILabel = {
        let label = UILabel()
        label.backgroundColor = TextColor_3
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.isHidden = true
        return label
    }()

    lazy var pswLabel5: UILabel = {
        let label = UILabel()
        label.backgroundColor = TextColor_3
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.isHidden = true
        return label
    }()

    lazy var pswLabel6: UILabel = {
        let label = UILabel()
        label.backgroundColor = TextColor_3
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.isHidden = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// UI
    func setupUI() {
        self.addSubview(self.textFiled)
        self.textFiled.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        self.addSubview(self.borderView)
        self.borderView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.borderView.addSubview(self.pswLabel1)
        self.pswLabel1.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
            make.centerX.equalToSuperview().multipliedBy(1.0 / 6.0)
        }
        
        let line1 = UIView()
        line1.backgroundColor = UIColor.color(withHexString: "#CCCCCC")
        self.borderView.addSubview(line1)
        line1.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(1)
            make.centerX.equalToSuperview().multipliedBy(1.0 / 3.0)
        }
        
        self.borderView.addSubview(self.pswLabel2)
        self.pswLabel2.snp.makeConstraints { (make) in
            make.centerY.width.height.equalTo(self.pswLabel1)
            make.centerX.equalToSuperview().multipliedBy(1.0 / 2.0)
        }
        
        let line2 = UIView()
        line2.backgroundColor = UIColor.color(withHexString: "#CCCCCC")
        self.borderView.addSubview(line2)
        line2.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(line1)
            make.centerX.equalToSuperview().multipliedBy(2.0 / 3.0)
        }

        self.borderView.addSubview(self.pswLabel3)
        self.pswLabel3.snp.makeConstraints { (make) in
            make.centerY.width.height.equalTo(self.pswLabel1)
            make.centerX.equalToSuperview().multipliedBy(5.0 / 6.0)
        }
        
        let line3 = UIView()
        line3.backgroundColor = UIColor.color(withHexString: "#CCCCCC")
        self.borderView.addSubview(line3)
        line3.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(line1)
            make.centerX.equalToSuperview()
        }

        self.borderView.addSubview(self.pswLabel4)
        self.pswLabel4.snp.makeConstraints { (make) in
            make.centerY.width.height.equalTo(self.pswLabel1)
            make.centerX.equalToSuperview().multipliedBy(7.0 / 6.0)
        }
        
        let line4 = UIView()
        line4.backgroundColor = UIColor.color(withHexString: "#CCCCCC")
        self.borderView.addSubview(line4)
        line4.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(line1)
            make.centerX.equalToSuperview().multipliedBy(4.0 / 3.0)
        }

        self.borderView.addSubview(self.pswLabel5)
        self.pswLabel5.snp.makeConstraints { (make) in
            make.centerY.width.height.equalTo(self.pswLabel1)
            make.centerX.equalToSuperview().multipliedBy(9.0 / 6.0)
        }
        
        let line5 = UIView()
        line5.backgroundColor = UIColor.color(withHexString: "#CCCCCC")
        self.borderView.addSubview(line5)
        line5.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(line1)
            make.centerX.equalToSuperview().multipliedBy(5.0 / 3.0)
        }

        self.borderView.addSubview(self.pswLabel6)
        self.pswLabel6.snp.makeConstraints { (make) in
            make.centerY.width.height.equalTo(self.pswLabel1)
            make.centerX.equalToSuperview().multipliedBy(11.0 / 6.0)
        }
    }
    
    /// Action
    @objc func textFiledDidChange(_ textFiled: UITextField) {
        
        let inputStr = textFiled.text ?? ""
        
        YYLog("text = \(inputStr)")

        switch inputStr.count {
        case 0:
            self.pswLabel1.isHidden = true
            self.pswLabel2.isHidden = true
            self.pswLabel3.isHidden = true
            self.pswLabel4.isHidden = true
            self.pswLabel5.isHidden = true
            self.pswLabel6.isHidden = true
        case 1:
            self.pswLabel1.isHidden = false
            self.pswLabel2.isHidden = true
            self.pswLabel3.isHidden = true
            self.pswLabel4.isHidden = true
            self.pswLabel5.isHidden = true
            self.pswLabel6.isHidden = true
        case 2:
            self.pswLabel1.isHidden = false
            self.pswLabel2.isHidden = false
            self.pswLabel3.isHidden = true
            self.pswLabel4.isHidden = true
            self.pswLabel5.isHidden = true
            self.pswLabel6.isHidden = true
        case 3:
            self.pswLabel1.isHidden = false
            self.pswLabel2.isHidden = false
            self.pswLabel3.isHidden = false
            self.pswLabel4.isHidden = true
            self.pswLabel5.isHidden = true
            self.pswLabel6.isHidden = true
        case 4:
            self.pswLabel1.isHidden = false
            self.pswLabel2.isHidden = false
            self.pswLabel3.isHidden = false
            self.pswLabel4.isHidden = false
            self.pswLabel5.isHidden = true
            self.pswLabel6.isHidden = true
        case 5:
            self.pswLabel1.isHidden = false
            self.pswLabel2.isHidden = false
            self.pswLabel3.isHidden = false
            self.pswLabel4.isHidden = false
            self.pswLabel5.isHidden = false
            self.pswLabel6.isHidden = true
        case 6:
            self.pswLabel1.isHidden = false
            self.pswLabel2.isHidden = false
            self.pswLabel3.isHidden = false
            self.pswLabel4.isHidden = false
            self.pswLabel5.isHidden = false
            self.pswLabel6.isHidden = false
        default:
            break
        }
        
        textValueChange?(inputStr)

        if inputStr.count >= 6 {
            // 结束编辑
            DispatchQueue.main.async {
                textFiled.resignFirstResponder()
            }
            inputFinish?(inputStr)
        }
    }
    
    /// 获取密码
    var password: String {
        return self.textFiled.text ?? ""
    }

}

extension PasswordView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textDidBeginEditing?()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textDidEndEditing?()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let inputText = textField.text ?? ""
        
        if string.count == 0 { // 删除
            return true
        }
        
        if inputText.count > 5 {
            return false
        }
        
        // 限制只能输入数字，不能输入特殊字符
        let length = string.lengthOfBytes(using: String.Encoding.utf8)
        
        for loopIndex in 0..<length {
            
            let char = (string as NSString).character(at: loopIndex)
            
            if char < 48 || char > 57 {
                return false
            }
        }
        return true
    }
}
