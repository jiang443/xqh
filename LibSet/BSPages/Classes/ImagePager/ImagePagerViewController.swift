//
//  PagerViewController.swift
//  Alamofire
//
//  Created by jiang on 2019/6/28.
//

import UIKit
import BSBase
import BSCommon

open class ImagePagerViewController: BSBaseViewController {
    
    let cellId = "cellId"
    
    public var images = [UIImage](){
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    public var selectedIndex = 0
    
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.itemSize = CGSize.init(width: self.view.frame.width, height: self.view.frame.height)
        layout.minimumLineSpacing = 0.1
        layout.minimumInteritemSpacing = 0.1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImagePagerCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = true
        collectionView.layer.zPosition = 9999
        return collectionView
    }()
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.title = "1/\(self.images.count)"
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        let rect = self.view.frame
        //self.collectionView.contentOffset.x = rect.width * CGFloat(selectedIndex)
//        self.collectionView.selectItem(at: IndexPath(item: self.selectedIndex, section: 0), animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
        self.collectionView.setContentOffset(CGPoint.init(x: rect.width * CGFloat(self.selectedIndex), y: 0), animated: true)

    }
    
    public func deleteCurrent(){
//        collectionView.performBatchUpdates({
//            self.images.remove(at: self.selectedIndex)
//            collectionView.deleteItems(at: [IndexPath(item: self.selectedIndex, section: 0)])
//        }) { finished in
//            self.collectionView.reloadData()
//        }
    }
    
    
    deinit {
        //NotificationCenter.default.removeObserver(self)
    }
    
}

extension ImagePagerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("ImagePager count = \(self.images.count)")
        return self.images.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImagePagerCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImagePagerCell
        cell.image = self.images[indexPath.row]
        return cell
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / self.view.frame.width)
        self.selectedIndex = index
        self.title = "\(index + 1)/\(images.count)"
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let offset = self.collectionView.contentOffset
    }
}
