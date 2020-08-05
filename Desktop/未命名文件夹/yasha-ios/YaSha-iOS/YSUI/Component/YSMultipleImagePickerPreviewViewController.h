//
//  YSMultipleImagePickerPreviewViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/26.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>

@class YSMultipleImagePickerPreviewViewController;

@protocol YSMultipleImagePickerPreviewViewControllerDelegate <QMUIImagePickerPreviewViewControllerDelegate>

@required
- (void)imagePickerPreviewViewController:(YSMultipleImagePickerPreviewViewController *)imagePickerPreviewViewController sendImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray;

@end

@interface YSMultipleImagePickerPreviewViewController : QMUIImagePickerPreviewViewController

@property(nonatomic, weak) id<YSMultipleImagePickerPreviewViewControllerDelegate> delegate;
@property(nonatomic, strong) QMUILabel *imageCountLabel;
@property(nonatomic, strong) QMUIAssetsGroup *assetsGroup;
@property(nonatomic, assign) BOOL shouldUseOriginImage;

@end
