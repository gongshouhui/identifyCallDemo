//
//  YSFormImagePickerCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/25.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFormImagePickerCell.h"
#import "YSSingleImagePickerPreviewViewController.h"
#import "YSMultipleImagePickerPreviewViewController.h"

#define MaxSelectedImageCount 9
#define NormalImagePickingTag 1045
#define ModifiedImagePickingTag 1046
#define MultipleImagePickingTag 1047
#define SingleImagePickingTag 1048

static QMUIAlbumContentType const kAlbumContentType = QMUIAlbumContentTypeAll;

@interface YSFormImagePickerCell ()<QMUIImagePickerViewControllerDelegate, YSSingleImagePickerPreviewViewControllerDelegate, YSMultipleImagePickerPreviewViewControllerDelegate>

@property (nonatomic, strong) UIImageView *singleImageView;

@end

@implementation YSFormImagePickerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self addTitleLabel];
    [self addSingleImageView];
}
- (void)addSingleImageView {
    _singleImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_singleImageView];
    [_singleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.mas_right).offset(-30);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

- (void)setCellModel:(YSFormRowModel *)cellModel {
    [super setCellModel:cellModel];
    _singleImageView.image = cellModel.image;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (self.selected == selected) return;
    //[super setSelected:selected animated:animated];
    [self authorizationPresentAlbumViewControllerWithTitle:@"选择多张图片"];
}

- (void)authorizationPresentAlbumViewControllerWithTitle:(NSString *)title {
    if ([QMUIAssetsManager authorizationStatus] == QMUIAssetAuthorizationStatusNotDetermined) {
        [QMUIAssetsManager requestAuthorization:^(QMUIAssetAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentAlbumViewControllerWithTitle:title];
            });
        }];
    } else {
        [self presentAlbumViewControllerWithTitle:title];
    }
}

- (void)presentAlbumViewControllerWithTitle:(NSString *)title {
    // 创建一个 QMUIAlbumViewController 实例用于呈现相簿列表
    QMUIAlbumViewController *albumViewController = [[QMUIAlbumViewController alloc] init];
     albumViewController.albumViewControllerDelegate = self;
    albumViewController.contentType = kAlbumContentType;
    albumViewController.title = title;
    if ([title isEqualToString:@"选择单张图片"]) {
        albumViewController.view.tag = SingleImagePickingTag;
    } else if ([title isEqualToString:@"选择多张图片"]) {
        albumViewController.view.tag = MultipleImagePickingTag;
    } else if ([title isEqualToString:@"调整界面"]) {
        albumViewController.view.tag = ModifiedImagePickingTag;
        albumViewController.albumTableViewCellHeight = 70;
    } else {
        albumViewController.view.tag = NormalImagePickingTag;
    }
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:albumViewController];
    
    // 获取最近发送图片时使用过的相簿，如果有则直接进入该相簿
    QMUIAssetsGroup *assetsGroup = [QMUIImagePickerHelper assetsGroupOfLastestPickerAlbumWithUserIdentify:nil];
    if (assetsGroup) {
        QMUIImagePickerViewController *imagePickerViewController = [self imagePickerViewControllerForAlbumViewController:albumViewController];
        
        [imagePickerViewController refreshWithAssetsGroup:assetsGroup];
        imagePickerViewController.title = [assetsGroup name];
        [navigationController pushViewController:imagePickerViewController animated:NO];
    }
    [[YSUtility getCurrentViewController] presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - QMUIAlbumViewControllerDelegate

- (QMUIImagePickerViewController *)imagePickerViewControllerForAlbumViewController:(QMUIAlbumViewController *)albumViewController {
    QMUIImagePickerViewController *imagePickerViewController = [[QMUIImagePickerViewController alloc] init];
    imagePickerViewController.imagePickerViewControllerDelegate = self;
    imagePickerViewController.maximumSelectImageCount = MaxSelectedImageCount;
    imagePickerViewController.view.tag = albumViewController.view.tag;
    if (albumViewController.view.tag == SingleImagePickingTag) {
        imagePickerViewController.allowsMultipleSelection = NO;
    }
    if (albumViewController.view.tag == ModifiedImagePickingTag) {
        imagePickerViewController.minimumImageWidth = 65;
    }
    return imagePickerViewController;
}


#pragma mark - QMUIImagePickerViewControllerDelegate

- (void)imagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController didFinishPickingImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    // 储存最近选择了图片的相册，方便下次直接进入该相册
    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerViewController.assetsGroup ablumContentType:kAlbumContentType userIdentify:nil];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (QMUIAsset *imageAsset in imagesAssetArray) {
        [mutableArray addObject:imageAsset.originImage];
    }
    [self.sendImageDataSubject sendNext:[mutableArray copy]];
    // 默认设置第一张
    [imagesAssetArray[0] requestImageData:^(NSData *imageData, NSDictionary<NSString *,id> *info, BOOL isGIF, BOOL isHEIC) {
        UIImage *targetImage = [UIImage imageWithData:imageData];
        if (isHEIC) {
            // iOS 11 中新增 HEIF/HEVC 格式的资源，直接发送新格式的照片到不支持新格式的设备，照片可能会无法识别，可以先转换为通用的 JPEG 格式再进行使用。
            // 详细请浏览：https://github.com/QMUI/QMUI_iOS/issues/224
            targetImage = [UIImage imageWithData:UIImageJPEGRepresentation(targetImage, 1)];
        }
        [self performSelector:@selector(setSingleImageView:) withObject:targetImage afterDelay:0.5];
    }];
}

- (QMUIImagePickerPreviewViewController *)imagePickerPreviewViewControllerForImagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController {
    if (imagePickerViewController.view.tag == MultipleImagePickingTag) {
        YSMultipleImagePickerPreviewViewController *imagePickerPreviewViewController = [[YSMultipleImagePickerPreviewViewController alloc] init];
        imagePickerPreviewViewController.delegate = self;
        imagePickerPreviewViewController.maximumSelectImageCount = MaxSelectedImageCount;
        imagePickerPreviewViewController.assetsGroup = imagePickerViewController.assetsGroup;
        imagePickerPreviewViewController.view.tag = imagePickerViewController.view.tag;
        return imagePickerPreviewViewController;
    } else if (imagePickerViewController.view.tag == SingleImagePickingTag) {
        YSSingleImagePickerPreviewViewController *imagePickerPreviewViewController = [[YSSingleImagePickerPreviewViewController alloc] init];
        imagePickerPreviewViewController.delegate = self;
        imagePickerPreviewViewController.assetsGroup = imagePickerViewController.assetsGroup;
        imagePickerPreviewViewController.view.tag = imagePickerViewController.view.tag;
        return imagePickerPreviewViewController;
    } else if (imagePickerViewController.view.tag == ModifiedImagePickingTag) {
        QMUIImagePickerPreviewViewController *imagePickerPreviewViewController = [[QMUIImagePickerPreviewViewController alloc] init];
        imagePickerPreviewViewController.delegate = self;
        imagePickerPreviewViewController.view.tag = imagePickerViewController.view.tag;
        imagePickerPreviewViewController.toolBarBackgroundColor = UIColorMake(66, 66, 66);
        return imagePickerPreviewViewController;
    } else {
        QMUIImagePickerPreviewViewController *imagePickerPreviewViewController = [[QMUIImagePickerPreviewViewController alloc] init];
        imagePickerPreviewViewController.delegate = self;
        imagePickerPreviewViewController.view.tag = imagePickerViewController.view.tag;
        return imagePickerPreviewViewController;
    }
}

#pragma mark - QMUIImagePickerPreviewViewControllerDelegate

- (void)imagePickerPreviewViewController:(QMUIImagePickerPreviewViewController *)imagePickerPreviewViewController didCheckImageAtIndex:(NSInteger)index {
   
}

#pragma mark - YSSingleImagePickerPreviewViewControllerDelegate

- (void)imagePickerPreviewViewController:(YSSingleImagePickerPreviewViewController *)imagePickerPreviewViewController didSelectImageWithImagesAsset:(QMUIAsset *)imageAsset {
    // 储存最近选择了图片的相册，方便下次直接进入该相册
    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerPreviewViewController.assetsGroup ablumContentType:kAlbumContentType userIdentify:nil];
    [self.sendImageDataSubject sendNext:@[imageAsset.originImage]];
    [imageAsset requestImageData:^(NSData *imageData, NSDictionary<NSString *,id> *info, BOOL isGIF, BOOL isHEIC) {
        UIImage *targetImage = [UIImage imageWithData:imageData];
        if (isHEIC) {
            // iOS 11 中新增 HEIF/HEVC 格式的资源，直接发送新格式的照片到不支持新格式的设备，照片可能会无法识别，可以先转换为通用的 JPEG 格式再进行使用。
            // 详细请浏览：https://github.com/QMUI/QMUI_iOS/issues/224
            targetImage = [UIImage imageWithData:UIImageJPEGRepresentation(targetImage, 1)];
        }
        [self performSelector:@selector(setSingleImageView:) withObject:targetImage afterDelay:0.5];
    }];
}

#pragma mark - YSMultipleImagePickerPreviewViewControllerDelegate

- (void)imagePickerPreviewViewController:(YSMultipleImagePickerPreviewViewController *)imagePickerPreviewViewController sendImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    // 储存最近选择了图片的相册，方便下次直接进入该相册
    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerPreviewViewController.assetsGroup ablumContentType:kAlbumContentType userIdentify:nil];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (QMUIAsset *imageAsset in imagesAssetArray) {
        [mutableArray addObject:imageAsset.originImage];
    }
    [self.sendImageDataSubject sendNext:[mutableArray copy]];
    // 默认设置第一张
    [imagesAssetArray[0] requestImageData:^(NSData *imageData, NSDictionary<NSString *,id> *info, BOOL isGIF, BOOL isHEIC) {
        UIImage *targetImage = [UIImage imageWithData:imageData];
        if (isHEIC) {
            // iOS 11 中新增 HEIF/HEVC 格式的资源，直接发送新格式的照片到不支持新格式的设备，照片可能会无法识别，可以先转换为通用的 JPEG 格式再进行使用。
            // 详细请浏览：https://github.com/QMUI/QMUI_iOS/issues/224
            targetImage = [UIImage imageWithData:UIImageJPEGRepresentation(targetImage, 1)];
        }
        [self performSelector:@selector(setSingleImageView:) withObject:targetImage afterDelay:0.5];
    }];
}

- (void)setSingleImageView:(UIImage *)image {
    _singleImageView.image = image;
}

@end
