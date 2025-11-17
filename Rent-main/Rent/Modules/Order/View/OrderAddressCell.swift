//
//  OrderAddressCell.swift
//  Rent
//
//  Created by jiang on 2020/9/12.
//  Copyright © 2020 jiang. All rights reserved.
//

import UIKit

class OrderAddressCell: UITableViewCell {

    // 图标
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIUtils.getDefautImage()
        return imageView
    }()

    // 地址
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.textColor = UIColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: StringUtils.FONT_LARGE)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        layoutUI()
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// UI
    func setupUI() {
        self.contentView.addSubview(self.iconImageView)
        self.contentView.addSubview(self.addressLabel)
    }
    
    /// Layout
    func layoutUI() {
        self.iconImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(45)
            make.left.equalToSuperview().offset(12)
        }
        
        self.addressLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.iconImageView.snp.right).offset(10)
            make.height.equalTo(20)
        }
    }
    
    var model: AddressModel? {
        didSet {
            guard let item = model else {
                return
            }
            self.addressLabel.text = item.address
        }
    }
    
}
