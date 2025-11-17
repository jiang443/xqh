//
//  ResetPasswordCell.swift
//  Rent
//
//  Created by jiang 2019/3/4.
//  Copyright © 2019年 jiang. All rights reserved.
//

import UIKit

class ResetPasswordCell: UITableViewCell {

    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "6-16个字符，区分大小写"
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        setupUI()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// UI
    func setupUI() {
        self.contentView.addSubview(self.textField)
        self.textField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(35)
            make.centerY.equalToSuperview()
        }
    }
}
