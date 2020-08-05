//
//  YSSingleImagePickerPreviewViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/25.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSSingleImagePickerPreviewViewController.h"

@interface YSSingleImagePickerPreviewViewController ()

@end

@implementation YSSingleImagePickerPreviewViewController {
    QMUIButton *_confirmButton;
}

@dynamic delegate;

- (void)initSubviews {
    [super initSubviews];
    _confirmButton = [[QMUIButton alloc] init];
    _confirmButton.qmui_outsideEdge = UIEdgeInsetsMake(-6, -6, -6, -6);
    [_confirmButton setTitleColor:self.toolBarTintColor forState:UIControlStateNormal];
    [_confirmButton setTitle:@"使用" forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(handleUserAvatarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_confirmButton sizeToFit];
    [self.topToolBarView addSubview:_confirmButton];
}

- (void)setDownloadStatus:(QMUIAssetDownloadStatus)downloadStatus {
    [super setDownloadStatus:downloadStatus];
    switch (downloadStatus) {
        case QMUIAssetDownloadStatusSucceed:
            _confirmButton.hidden = NO;
            break;
            
        case QMUIAssetDownloadStatusDownloading:
            _confirmButton.hidden = YES;
            break;
            
        case QMUIAssetDownloadStatusCanceled:
            _confirmButton.hidden = NO;
            break;
            
        case QMUIAssetDownloadStatusFailed:
            _confirmButton.hidden = YES;
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _confirmButton.frame = CGRectSetXY(_confirmButton.frame, CGRectGetWidth(self.topToolBarView.frame) - CGRectGetWidth(_confirmButton.frame) - 10, CGRectGetMinY(self.backButton.frame) + CGFloatGetCenter(CGRectGetHeight(self.backButton.frame), CGRectGetHeight(_confirmButton.frame)));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleUserAvatarButtonClick:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^(void) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerPreviewViewController:didSelectImageWithImagesAsset:)]) {
            QMUIAsset *imageAsset = [self.imagesAssetArray objectAtIndex:self.imagePreviewView.currentImageIndex];
            [self.delegate imagePickerPreviewViewController:self didSelectImageWithImagesAsset:imageAsset];
        }
    }];
}



@end

