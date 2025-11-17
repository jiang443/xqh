//
//  ImagePickerView.h
//  TZImagePickerController
//
//  Created by jiang on 2019/9/27.
//  Copyright © 2017年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImagePickerViewDelegate <NSObject>

@optional
/** 点击了添加按钮 */
- (void)imageDidAdd;
/** 点击了删除按钮 */
- (void)imageDidDelete;
/** 点击了按钮 */
- (void)imageDidClicked;
/** 移动了按钮 */
- (void)imageDidMoved;

@end

@interface ImagePickerView : UIView

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic) BOOL showTakePhotoBtn;  ///< 在内部显示拍照按钮
@property BOOL sortAscending;     ///< 照片排列按修改时间升序
@property BOOL allowPickingVideo; ///< 允许选择视频
@property BOOL allowPickingImage; ///< 允许选择图片
@property BOOL allowPickingGif;
@property BOOL allowPickingOriginalPhoto; ///< 允许选择原图
@property BOOL showSheet;       ///< 显示一个sheet,把拍照按钮放在外面
@property NSInteger maxCount;   ///< 照片最大可选张数，设置为1即为单选模式
@property NSInteger columnNumber;   //选择器中，每行照片数量
@property NSInteger colNumberToEdit;   //展示器中，每行照片数量
@property BOOL allowCrop;
@property BOOL needCircleCrop;
@property BOOL allowPickingMuitlpleVideo;

@property UIViewController *parentVc;
@property id<ImagePickerViewDelegate> delegate;
@property NSMutableArray *selectedPhotos;
@property NSMutableArray *selectedAssets;

/// Change By 黄文岳 2019-3-12
@property CGFloat itemWH;   // item宽高
@property CGFloat margin;   // item间距


@end
