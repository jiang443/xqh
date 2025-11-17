//
//  SettingLogoutCell.swift
//  Rent
//
//  Created by jiang 2019/2/28.
//  Copyright © 2019年 jiang. All rights reserved.
//

import UIKit

class SettingLogoutCell: UITableViewCell {

    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.text = "退出"
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// UI
    func setupUI() {
        self.contentView.addSubview(self.titleLabel)
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

}
