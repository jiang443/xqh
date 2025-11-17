//
//  FindNewVersionView.swift
//  Rent
//
//  Created by jiang 2019/5/21.
//  Copyright © 2019年 jiang. All rights reserved.
//

import UIKit

class FindNewVersionView: UIView {

    /// 立即更新
    var updateVersionCallback: (() -> Void)?

    lazy var popView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 45, y: (ScreenHeight - 310) * 0.5 + 5 , width: ScreenWidth - 90, height: 310))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bj_update")
        return imageView
    }()
    
    lazy var updateBtn: UIButton = {
        let button = UIButton()
        button.setTitle("立即更新", for: .normal)
        button.setTitleColor(UIColor.color(withHexString: "#2BA8FF"), for: .normal)
        button.titleLabel?.font = TextFont_15
        button.addTarget(self, action: #selector(updateBtnClicked), for: .touchUpInside)
        return button
    }()

    lazy var cancelBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_close"), for: .normal)
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return button
    }()
    
    lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.color(withHexString: "#EEEEEE")
        return view
    }()
    
    lazy var bottomContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "更新内容"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = TextColor_6
        return label
    }()
    
    lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.text = "（v1.0.0）"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = TextColor_6
        return label
    }()
    
    lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.textColor = TextColor_9
        textView.font = TextFont_13
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// UI
    func setupUI() {
        self.addSubview(self.popView)
        
        self.addSubview(self.topImageView)
        self.topImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.popView).offset(-48)
            make.left.right.equalTo(self.popView)
            make.height.equalTo(155)
        }
        
        self.popView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(119)
            make.left.equalToSuperview().offset(18)
            make.height.equalTo(15)
        }
        
        self.popView.addSubview(self.versionLabel)
        self.versionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel.snp.right).offset(0)
            make.bottom.equalTo(self.titleLabel)
        }
        
        self.popView.addSubview(self.contentTextView)
        self.contentTextView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(7)
            make.left.equalToSuperview().offset(13)
            make.right.equalToSuperview().offset(-13)
            make.bottom.equalToSuperview().offset(-50)
        }
        
        self.popView.addSubview(self.updateBtn)
        self.updateBtn.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(42)
        }
        
        self.popView.addSubview(self.line)
        self.line.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.updateBtn.snp.top)
            make.height.equalTo(1)
        }

        self.addSubview(self.cancelBtn)
        self.cancelBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.popView.snp.bottom).offset(17)
            make.width.height.equalTo(30)
        }

    }
    
    /// Data    
    var isForce = 0 {
        didSet {
            self.cancelBtn.isHidden = isForce == 1
        }
    }
    
    var clientVersion = "" {
        didSet {
            self.versionLabel.isHidden = clientVersion.isEqualTo(str: "")
            self.versionLabel.text = "（v\(clientVersion)）"
        }
    }
    
    var updateContent = "" {
        didSet {
//            var attr = NSMutableAttributedString.init(string: "1.更新内容更新内容更新内容更新内容更新内容更新内容更新内容;\n2.更新内容更新内新内容;\n3.更新内容更新更新内容内新内容更新内容更新内容更新内容;\n4.更新内容更新更新内容内新内容;\n5.更新内容更新更新内容内新内容;\n6.更新内容更新更新内容内新内容。")
            let attr = NSMutableAttributedString.init(string: updateContent)
            attr.addAttribute(NSAttributedString.Key.font, value: TextFont_13, range: NSMakeRange(0, attr.length))
            attr.addAttribute(NSAttributedString.Key.foregroundColor, value: TextColor_9, range: NSMakeRange(0, attr.length))
            // 设置行间距
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 8
            paragraphStyle.alignment = .left
            attr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attr.length))
            self.contentTextView.attributedText = attr
        }
    }
    
    
    /// Action
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    @objc func updateBtnClicked() {
        
        updateVersionCallback?()
        
        if self.isForce == 1 { // 强制更新不会消失提醒框
            
        } else {
            dismiss()
        }
    }
    
    @objc func show() {
        UIUtils.getAppDelegate().window?.rootViewController?.view.addSubview(self)
        
//        UIView.animate(withDuration: 0.3, animations: {
////            self.popView.mj_y = (ScreenHeight - 310) * 0.5 + 5
//        }) { finish in
//            
//        }
    }
    
    @objc func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
//            self.popView.mj_y = ScreenHeight + 10
            self.alpha = 0
        }) { finish in
            self.removeFromSuperview()
        }
    }
}
