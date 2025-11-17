//
//  AddressHeaderView.swift
//  Rent
//
//  Created by jiang on 2021/5/18.
//  Copyright © 2021 jiang. All rights reserved.
//

import UIKit

protocol AddressHeaderViewDelegate {
    func onTouchAddressEdit()
}

class AddressHeaderView: UIView {
    
    var delegate: AddressHeaderViewDelegate?
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "address")
        return imageView
    }()
    
    lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.text = "点击选择您的收货地址"
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "edit"), for: .normal)
        button.addTarget(self, action: #selector(touchEdit), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    
    //
    var model:AddressModel = AddressModel(){
        didSet{
            self.refresh()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    //初始化时将xib中的view添加进来
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layout()
    }

    func layout(){
        self.backgroundColor = UIUtils.getBackgroundColor()
        self.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(8)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
        }
        
        backView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(12)
            make.width.equalTo(20)
            make.height.equalTo(25)
        }
        
        backView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.height.equalTo(20)
        }
        
        backView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.height.equalTo(20)
        }
        
        backView.addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(10)
            make.height.equalTo(20)
        }
        
        backView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.height.equalTo(20)
        }
        
        backView.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-8)
            make.width.height.equalTo(20)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClicked(gest:)))
        self.addGestureRecognizer(tap)
    }
    
    func refresh(){
        if model.id.isEmpty{
            tipLabel.isHidden = false
            nameLabel.isHidden = true
            phoneLabel.isHidden = true
            addressLabel.isHidden = true
            editButton.isHidden = true
        }
        else{
            tipLabel.isHidden = true
            nameLabel.isHidden = false
            phoneLabel.isHidden = false
            addressLabel.isHidden = false
            editButton.isHidden = false
            
            nameLabel.text = model.receiveName
            phoneLabel.text = model.receivePhone
            addressLabel.text = "\(model.province)\(model.city)\(model.area)\(model.address)"
        }
    }

    @objc func touchEdit(){
        self.delegate?.onTouchAddressEdit()
    }
    
    @objc func tapClicked(gest: UIGestureRecognizer) {
        self.delegate?.onTouchAddressEdit()
    }

}
