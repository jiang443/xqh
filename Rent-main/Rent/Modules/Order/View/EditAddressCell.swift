//
//  EditAddressCell.swift
//  Rent
//
//  Created by jiang on 2021/5/19.
//  Copyright © 2021 jiang. All rights reserved.
//

import UIKit
import FSTextView

class EditAddressCell: UITableViewCell {

    lazy var titlelabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    lazy var textView: FSTextView = {
        let textView = FSTextView()
        textView.placeholder = "请输入"
        return textView
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
        self.contentView.addSubview(self.titlelabel)
        self.titlelabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(16)
        }
        
        self.contentView.addSubview(self.textView)
        self.textView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.left.greaterThanOrEqualTo(titlelabel.snp.right)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.7)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview()
        }
    }
    
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    var model = AddressModel() {
        didSet {
            switch indexPath.row {
            case 0:
                self.titlelabel.text = "收货人"
                self.textView.text = model.receiveName
            case 1:
                self.titlelabel.text = "手机号"
                self.textView.text = model.receivePhone
            case 2:
                self.titlelabel.text = "所在地区"
                self.textView.text = "\(model.province)\(model.city)\(model.area)"
            case 3:
                self.titlelabel.text = "详细地址"
                self.textView.text = model.address
            default:
                break
            }
        }
    }
}

