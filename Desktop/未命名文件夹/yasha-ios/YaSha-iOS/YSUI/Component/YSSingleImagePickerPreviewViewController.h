//
//  YSSingleImagePickerPreviewViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/25.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>

@class YSSingleImagePickerPreviewViewController;

@protocol YSSingleImagePickerPreviewViewControllerDelegate <QMUIImagePickerPreviewViewControllerDelegate>

@required
- (void)imagePickerPreviewViewController:(YSSingleImagePickerPreviewViewController *)imagePickerPreviewViewController didSelectImageWithImagesAsset:(QMUIAsset *)imageAsset;

@end

@interface YSSingleImagePickerPreviewViewController : QMUIImagePickerPreviewViewController

@property(nonatomic, weak) id<YSSingleImagePickerPreviewViewControllerDelegate> delegate;
@property(nonatomic, strong) QMUIAssetsGroup *assetsGroup;

@end
