//
//  PublishViewController.swift
//  Rent
//
//  Created by jiang on 2020/1/30.
//  Copyright © 2020 jiang. All rights reserved.
//

import BSCommon
import BSBase

class PublishViewController: BSBaseViewController {
    var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "config"), for: .normal)
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(touchClose), for: .touchUpInside)
        button.backgroundColor = UIUtils.getThemeColor()
        return button
    }()
    
    var publishButton: UIButton = {
        let button = UIButton()
        button.setTitle("发布", for: .normal)
        button.titleLabel?.font = TextFont_16
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(publish), for: .touchUpInside)
        button.backgroundColor = UIUtils.getThemeColor()
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发布页"
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupUI(){
        self.view.backgroundColor = UIUtils.getBackgroundColor()
        self.view.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
            make.width.height.equalTo(44)
        }
        
        self.view.addSubview(publishButton)
        publishButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(40)
        }
    }
    
    @objc func touchClose(){
        self.dismiss(animated: true, completion: nil)
    }

    @objc func publish(){
        let publishVc = WebViewController()
        publishVc.url = "http://47.115.94.36:9004/apppage/release"
//        publishVc.url = "http://192.168.0.96:9004/Release/index"
        publishVc.title = "发布"
        self.navigationController?.pushViewController(publishVc, animated: true)
    }
}
