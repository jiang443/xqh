//
//  PagerCell.swift
//  Alamofire
//
//  Created by jiang on 2019/6/28.
//

import UIKit

class ImagePagerCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.contentView.backgroundColor = UIColor.black
        self.contentView.addSubview(self.imageView)
        self.imageView.backgroundColor = UIColor.yellow
        self.imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    var image: UIImage? {
        didSet {
            if let pic = image {
                self.imageView.image = pic
                var height:CGFloat = 0
                let width = self.frame.width
                height = width * (pic.size.height / pic.size.width)
                self.imageView.snp.removeConstraints()
                self.imageView.snp.makeConstraints { (make) in
                    make.left.right.centerY.equalToSuperview()
                    make.height.equalTo(height)
                }
            }
        }
    }
    
}


