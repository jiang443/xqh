//
//  BorderTextField.swift
//  BSNurse
//
//  Created by jiang 2019/4/4.
//  Copyright © 2019年 tmpName. All rights reserved.
//

import UIKit

class BorderTextField: UIView {
    
    /// 输入框
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ""
        textField.textColor = TextColor_6
        textField.font = TextFont_13
        textField.placeholderColor = UIColor.color(withHexString: "#CCCCCC")
        textField.delegate = self
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.color(withHexString: "#CCCCCC").cgColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// UI
    func setupUI() {
        self.addSubview(self.textField)
        self.textField.addTarget(self, action: #selector(changeTextField(_:)), for: UIControl.Event.editingChanged)
        self.textField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
        
    }
    /// 字数限制
    var limitCount = 0
    
    /// 是否只能输入数字
    var isOnlyNumber = false
    
    var isSecureTextEntry = false {
        didSet {
            self.textField.isSecureTextEntry = isSecureTextEntry
        }
    }
    
    var placeholder = "" {
        didSet {
            self.textField.placeholder = placeholder
        }
    }
    
    var content: String {
        return self.textField.text ?? ""
    }
    
    var keyboardType: UIKeyboardType = .default {
        didSet {
            self.textField.keyboardType = keyboardType
        }
    }
    
    /// Action
    @objc func changeTextField(_ sender: UITextField) {
        YYLog(sender.text)
        
        if limitCount > 0 {
            guard let _ :UITextRange = sender.markedTextRange else {
                if (sender.text! as NSString).length > limitCount {
                    sender.text = (sender.text! as NSString).substring(to:limitCount)
                }
                return
            }
        }
    }
    
}

extension BorderTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if isOnlyNumber {
            // 限制只能输入数字，不能输入特殊字符
            let length = string.lengthOfBytes(using: String.Encoding.utf8)
            
            for loopIndex in 0..<length {
                
                let char = (string as NSString).character(at: loopIndex)
                
                if char < 48 || char > 57 {
                    return false
                }
            }
        }
        return true
    }
}
