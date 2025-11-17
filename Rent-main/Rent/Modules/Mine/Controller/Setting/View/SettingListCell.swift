//
//  SettingListCell.swift
//  Rent
//
//  Created by jiang 2019/2/28.
//  Copyright © 2019年 jiang. All rights reserved.
//

import UIKit

class SettingListCell: UITableViewCell {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: StringUtils.TITLE_FONT_SIZE)
        label.textColor = UIColor.darkGray
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
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
    }
    
    var title: String? {
        didSet {
            guard let _ = title else {
                return
            }
            self.titleLabel.text = title
        }
    }
    


}
