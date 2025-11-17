//
//  GuidePageViewController.swift
//  Rent
//
//  Created by jiang 2019/2/26.
//  Copyright © 2019年 jiang. All rights reserved.
//

import UIKit
import AVKit

class GuidePageViewController: BSBaseViewController {
    
    let cellId = "cellId"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.itemSize = CGSize.init(width: ScreenWidth, height: ScreenHeight)
        layout.minimumLineSpacing = 0.1
        layout.minimumInteritemSpacing = 0.1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GuidePageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    /// 启动视频第一帧
    lazy var videoFirstPageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = UIScreen.main.bounds
        imageView.image = UIImage(named: "videoFirstPage.jpg")
        return imageView
    }()
    
    // 播放器
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    
    // 跳过按钮
    lazy var jumpBtn: WYDrawCircleProgressButton = {
        let button = WYDrawCircleProgressButton.init(frame: CGRect(x: ScreenWidth - 66, y: 35, width: 48, height: 48))
        button.addTarget(self, action: #selector(jumpBtnClicked), for: .touchUpInside)
        button.setTitle("跳过", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = TextFont_15
        button.lineWidth = 2
        //        jumpBtn.trackColor = UIColor.clear
        //        jumpBtn.progressColor = UIUtils.getThemeColor()
        button.trackColor = UIColor.clear
        button.progressColor = UIColor.white
        return button
    }()

    // 标记视频是否播放完成
    var isPlayFinish = false
    
    lazy var viewModel: GuidePageViewModel = {
        return GuidePageViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SettingUserDefault.setFistLaunchTime(TimeUtils.getCurrentTimeString("yyyy-MM-dd HH:mm:ss"))
        
        self.view.addSubview(self.collectionView)
        //self.collectionView.isHidden = true
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // 添加启动视频
        //setupVideo()
        // 跳过按钮
        //setupJumpBtn()

        // 监听APP的状态
        addObserver()
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func appDidEnterBackground() {
        YYLog("退到后台")
        if !isPlayFinish {
            YYLog("暂停播放")
            self.player.pause()
        } else {
            YYLog("播放完毕")
        }
    }
    
    @objc func appDidEnterForeground() {
        YYLog("进到前台")
        if !isPlayFinish {
            YYLog("接着播放")
            self.player.play()
        } else {
            YYLog("播放完毕")
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupVideo() {
        // 显示第一帧图片，防止白屏
        self.view.addSubview(self.videoFirstPageImageView)
        
        //定义一个视频文件路径
        let filePath = Bundle.main.path(forResource: "launch_video", ofType: "mp4")
        let videoURL = URL(fileURLWithPath: filePath!)
        //定义一个playerItem，并监听相关的通知
        let playerItem = AVPlayerItem(url: videoURL)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: playerItem)
        //定义一个视频播放器，通过playerItem径初始化
        //        let player = AVPlayer(playerItem: playerItem)
        //定义一个视频播放器，通过本地文件路径初始化
        //        let player = AVPlayer(url: videoURL)
        //        //设置大小和位置（全屏）
        //        let playerLayer = AVPlayerLayer(player: player)
        
        //定义一个视频播放器，通过playerItem径初始化
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = UIScreen.main.bounds
        //添加到界面上
        self.view.layer.addSublayer(playerLayer)
        //开始播放
        player.play()
        
    }
    
    // 跳过按钮
    func setupJumpBtn() {
        self.view.addSubview(self.jumpBtn)
        self.jumpBtn.startAnimationDurarion(duration: 26.5)
    }

    //视频播放完毕响应
    @objc func playerDidFinishPlaying() {
        YYLog("播放完毕!")
        self.collectionView.isHidden = false
        self.videoFirstPageImageView.isHidden = true
        self.playerLayer.isHidden = true
        self.playerLayer.player = nil
        self.playerLayer.removeFromSuperlayer()
        self.isPlayFinish = true
        YYLog("player = \(self.playerLayer)")
        self.jumpBtn.isHidden = true
    }
    
    // 点击跳过按钮
    @objc func jumpBtnClicked() {
        YYLog("跳过")
        self.player.pause()
        self.jumpBtn.progressLayer.removeAllAnimations()
        self.playerDidFinishPlaying()
    }
}

extension GuidePageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GuidePageCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GuidePageCell
        
        cell.image = self.viewModel.imageList[indexPath.row]
        cell.isShowBtn = indexPath.row == self.viewModel.imageList.count - 1
        cell.finishCallBack = {
            print("finish")
            //            let loginVc = LoginViewController()
            //            self.present(loginVc, animated: true, completion: nil)
            
            SettingUserDefault.setGuideShowed(true)
            UIUtils.getAppDelegate().launch()
            
        }
        return cell
    }
}
