//
//  AddressListCell.swift
//  Rent
//
//  Created by jiang on 2021/5/19.
//  Copyright © 2021 jiang. All rights reserved.
//


import BSCommon

protocol AddressListCellDelegate {
    func editAddress(index: Int)
}

class AddressListCell: UITableViewCell {
    
    var delegate: AddressListCellDelegate?
    
    var index = 0
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "address")
        return imageView
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
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// UI
    func setupUI() {
        
        self.contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(12)
            make.width.equalTo(18)
            make.height.equalTo(18)
        }
        
        self.contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.height.equalTo(20)
        }
        
        self.contentView.addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalTo(nameLabel.snp.right).offset(10)
            make.height.equalTo(20)
        }
        
        self.contentView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.height.equalTo(20)
        }
        
        self.contentView.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
            make.width.height.equalTo(18)
        }
        
    }
    
    var model: AddressModel? {
        didSet {
            guard let item = model else {
                return
            }
            if item.isSelected{
                iconImageView.image = UIImage(named: "selected")
            }
            else{
                iconImageView.image = UIImage(named: "not_selected")
            }
            nameLabel.text = item.receiveName
            phoneLabel.text = item.receivePhone
            addressLabel.text = "\(item.province)\(item.city)\(item.area)\(item.address)"
        }
    }
    
    @objc func touchEdit(){
        self.delegate?.editAddress(index: self.index)
    }

}

