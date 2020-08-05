//
//  YSAttendanceWFooterView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/12/13.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSAttendanceWFooterView.h"
#import "YSPictureBtnView.h"
#import "YSSingleImagePickerPreviewViewController.h"
#import "YSMultipleImagePickerPreviewViewController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface YSAttendanceWFooterView ()<QMUIImagePickerViewControllerDelegate, QMUIAlbumViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *imgArray;


@end

@implementation YSAttendanceWFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self loadSubViews];
    }
    return self;
}
- (void)loadSubViews {
    //事由说明
    UILabel *tvLabe = [UILabel new];
    tvLabe.text = @"事由说明";
    tvLabe.textColor = [UIColor colorWithHexString:@"#000000"];
    tvLabe.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(16)];
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@*", tvLabe.text]];
    //找出特定字符在整个字符串中的位置
    NSRange redRange = NSMakeRange([[contentStr string] rangeOfString:@"*"].location, [[contentStr string] rangeOfString:@"*"].length);
    //修改特定字符的颜色
    [contentStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
    //修改特定字符的字体大小
    [contentStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:redRange];
    tvLabe.attributedText = contentStr;
    [self addSubview:tvLabe];
    [tvLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(30*kHeightScale);
    }];
    
    
    self.markTV = [UITextView new];
    self.markTV.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(16)];
    [self addSubview:self.markTV];
    [self.markTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*kWidthScale);
        make.right.mas_equalTo(-10*kHeightScale);
        make.top.mas_equalTo(tvLabe.mas_bottom).offset(8*kHeightScale);
        make.height.mas_equalTo(110*kHeightScale);
    }];
    
    self.markLab = [[UILabel alloc] init];
    self.markLab.text = @"请填写事由说明";
    self.markLab.textColor = [UIColor colorWithHexString:@"#B1B1B1"];
    self.markLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(14)];
    [self addSubview:self.markLab];
    [self.markLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.markTV.mas_top).offset(2*kHeightScale);
        make.left.mas_equalTo(self.markTV.mas_left).offset(2*kHeightScale);
    }];
    
    _numberLab = [UILabel new];
    _numberLab.text = [NSString stringWithFormat:@"0/%@", self.totlaNum];
    _numberLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(12)];
    _numberLab.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
    [self addSubview:_numberLab];
    [_numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.markTV.mas_right).offset(-2);
        make.top.mas_equalTo(self.markTV.mas_bottom);
    }];
    
    //照片
    NSMutableArray *pictureArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 3; i++) {
        YSPictureBtnView *btnView = [[YSPictureBtnView alloc] init];
        btnView.tag = 1025+i;
        btnView.hidden = YES;
        if (i==0) {
            btnView.hidden = NO;
        }
        [btnView.choseBtn addTarget:self action:@selector(authorizationPresentAlbumViewController) forControlEvents:(UIControlEventTouchUpInside)];
        [btnView.clearBtn addTarget:self action:@selector(clearBtnImgAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btnView];
        [pictureArray addObject:btnView];
    }
    [pictureArray mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedItemLength:(100*kWidthScale) leadSpacing:(kSCREEN_WIDTH-100*kWidthScale*3)/4 tailSpacing:(kSCREEN_WIDTH-100*kWidthScale*3)/4];
    [pictureArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.markTV.mas_bottom).offset(10*kHeightScale);
        make.height.mas_equalTo(100*kHeightScale);
    }];
    
}
/*
- (void)loadSubViews {
    //照片
    UILabel *pictureLab = [UILabel new];
    pictureLab.text = @"上传照片";
    pictureLab.textColor = [UIColor colorWithHexString:@"#B1B1B1"];
    pictureLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(14)];
    [self addSubview:pictureLab];
    [pictureLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15*kWidthScale);
        make.top.mas_equalTo(6*kHeightScale);
    }];
    NSMutableArray *pictureArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 3; i++) {
        YSPictureBtnView *btnView = [[YSPictureBtnView alloc] init];
        btnView.tag = 1025+i;
        btnView.hidden = YES;
        if (i==0) {
            btnView.hidden = NO;
        }
        [btnView.choseBtn addTarget:self action:@selector(authorizationPresentAlbumViewController) forControlEvents:(UIControlEventTouchUpInside)];
        [btnView.clearBtn addTarget:self action:@selector(clearBtnImgAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btnView];
        [pictureArray addObject:btnView];
    }
    [pictureArray mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedItemLength:(100*kWidthScale) leadSpacing:(kSCREEN_WIDTH-100*kWidthScale*3)/4 tailSpacing:(kSCREEN_WIDTH-100*kWidthScale*3)/4];
    [pictureArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pictureLab.mas_bottom);
        make.height.mas_equalTo(100*kHeightScale);
    }];
    
    //事件说明
    UIView *eventView = [UIView new];
    eventView.backgroundColor = [UIColor colorWithHexString:@"#FFFFF5"];
    [self addSubview:eventView];
    [eventView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(130*kHeightScale);
        make.height.mas_equalTo(30*kHeightScale);
    }];
    
    UILabel *tvLabe = [UILabel new];
    tvLabe.text = @"事由说明";
    tvLabe.textColor = [UIColor colorWithHexString:@"#B1B1B1"];
    tvLabe.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(14)];
    tvLabe.backgroundColor = [UIColor colorWithHexString:@"#FFFFF5"];
    [eventView addSubview:tvLabe];
    [tvLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(30*kHeightScale);
    }];
    
    
    self.markTV = [UITextView new];
    self.markTV.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(16)];
    self.markTV.layer.borderColor = [UIColor colorWithHexString:@"#EEEEEE"].CGColor;
    self.markTV.layer.borderWidth = 1;
    [self addSubview:self.markTV];
    [self.markTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10*kWidthScale);
        make.right.bottom.mas_equalTo(-10*kHeightScale);
        make.top.mas_equalTo(eventView.mas_bottom).offset(10*kHeightScale);
    }];
    
    self.markLab = [[UILabel alloc] init];
    self.markLab.text = @"请填写事由说明";
    self.markLab.textColor = [UIColor colorWithHexString:@"#B1B1B1"];
    self.markLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(14)];
    [self addSubview:self.markLab];
    [self.markLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.markTV.mas_top).offset(2*kHeightScale);
        make.left.mas_equalTo(self.markTV.mas_left).offset(2*kHeightScale);
    }];
    
    
}
*/
#pragma mark--取消选中
- (void)clearBtnImgAction:(UIButton*)sender {
    YSPictureBtnView *btnView = (YSPictureBtnView *)sender.superview;
    [self.imgArray removeObjectAtIndex:(btnView.tag-1025)];
    [self changePictureViewWithImg];
}

#pragma mark--选择图片
- (void)authorizationPresentAlbumViewController {
    if ([QMUIAssetsManager authorizationStatus] == QMUIAssetAuthorizationStatusNotDetermined) {
        [QMUIAssetsManager requestAuthorization:^(QMUIAssetAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentAlbumViewController];
            });
        }];
    } else {
        [self presentAlbumViewController];
    }
}

- (void)presentAlbumViewController {
    // 创建一个 QMUIAlbumViewController 实例用于呈现相簿列表
    QMUIAlbumViewController *albumViewController = [[QMUIAlbumViewController alloc] init];
    albumViewController.albumViewControllerDelegate = self;
    albumViewController.contentType = QMUIAlbumContentTypeOnlyPhoto;
    albumViewController.title = @"选择多张图片";
    // 获取最近发送图片时使用过的相簿，如果有则直接进入该相簿
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:albumViewController];
    QMUIAssetsGroup *assetsGroup = [QMUIImagePickerHelper assetsGroupOfLastestPickerAlbumWithUserIdentify:nil];
    if (assetsGroup) {
        QMUIImagePickerViewController *imagePickerViewController = [self imagePickerViewControllerForAlbumViewController:albumViewController];
        
        [imagePickerViewController refreshWithAssetsGroup:assetsGroup];
        imagePickerViewController.title = [assetsGroup name];
        [navigationController pushViewController:imagePickerViewController animated:YES];
        
    }
    [[YSUtility getCurrentViewController] presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - QMUIAlbumViewControllerDelegate

- (QMUIImagePickerViewController *)imagePickerViewControllerForAlbumViewController:(QMUIAlbumViewController *)albumViewController {
    QMUIImagePickerViewController *imagePickerViewController = [[QMUIImagePickerViewController alloc] init];
    imagePickerViewController.imagePickerViewControllerDelegate = self;
    imagePickerViewController.maximumSelectImageCount = 3;
    imagePickerViewController.view.tag = albumViewController.view.tag;
    imagePickerViewController.allowsMultipleSelection = YES;
    
    return imagePickerViewController;
}

#pragma mark - QMUIImagePickerViewControllerDelegate

- (void)imagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController didFinishPickingImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    // 储存最近选择了图片的相册，方便下次直接进入该相册
    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerViewController.assetsGroup ablumContentType:QMUIAlbumContentTypeAll userIdentify:nil];
    NSArray *lastimgArray = [NSArray arrayWithArray:self.imgArray];
    [self.imgArray removeAllObjects];
    __weak typeof(self) weakSelf = self;
    [imagePickerViewController dismissViewControllerAnimated:YES completion:^{
        for (QMUIAsset *asset in imagesAssetArray) {
            //ios11图片
            YSNewsAttachmentModel *model = [YSNewsAttachmentModel new];
            [asset requestImageData:^(NSData *imageData, NSDictionary<NSString *,id> *info, BOOL isGIF, BOOL isHEIC) {
                     
                if (isHEIC) {
                    
                    model.choseImg = [UIImage imageWithData:UIImageJPEGRepresentation(asset.originImage, 0.5)];
                    model.fileType = 4;
                    NSString *fileNameStr = [[[[info objectForKey:@"PHImageFileURLKey"] absoluteString] componentsSeparatedByString:@"/"] lastObject];
                    if ([YSUtility judgeIsEmpty:fileNameStr]) {
                        // 因QMUI ios13无法获取PHImageFileURLKey 有时间更新QMUI
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        formatter.dateFormat = @"yyyyMMddHHmmss";
                        NSString *str = [formatter stringFromDate:[NSDate date]];
                        fileNameStr = [NSString stringWithFormat:@"%@.jpg",str];
                    }
                    model.fileName = [NSString stringWithFormat:@"%@.JPEG", [[fileNameStr componentsSeparatedByString:@"."] firstObject]];
                    [weakSelf.imgArray addObject:model];
                    //遍历到最后一个
                    if ([imagesAssetArray indexOfObject:asset] == imagesAssetArray.count-1) {
                        [weakSelf.imgArray addObjectsFromArray:lastimgArray];
                        [weakSelf handelQuestImgData];
                    }
                }else {
                    model.choseImg = asset.originImage;
                    model.fileType = 4;
                    model.fileName = [[[[info objectForKey:@"PHImageFileURLKey"] absoluteString] componentsSeparatedByString:@"/"] lastObject];
                    if ([YSUtility judgeIsEmpty:model.fileName]) {
                        // 因QMUI ios13无法获取PHImageFileURLKey 有时间更新QMUI
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        formatter.dateFormat = @"yyyyMMddHHmmss";
                        NSString *str = [formatter stringFromDate:[NSDate date]];
                        model.fileName = [NSString stringWithFormat:@"%@.jpg",str];
                    }
                    [weakSelf.imgArray addObject:model];
                    if ([imagesAssetArray indexOfObject:asset]== imagesAssetArray.count-1) {
                        [weakSelf.imgArray addObjectsFromArray:lastimgArray];
                        [weakSelf handelQuestImgData];
                    }
                }
            }];
        }
        
        
    }];
}

- (void)handelQuestImgData {
    if (self.imgArray.count > 3) {
        [self.imgArray removeObjectsInRange:(NSMakeRange(2, self.imgArray.count-3))];
    }
    // 图片赋值
    [self changePictureViewWithImg];
    if (self.selectedImageBlock) {
        self.selectedImageBlock(self.imgArray);
    }
}
// 图片显示隐藏
- (void)changePictureViewWithImg {
    
    for (int i = 0; i < 3; i++) {
        YSPictureBtnView *btnView = [self viewWithTag:1025+i];
        [btnView.choseBtn setImage:[UIImage imageNamed:@"addImg"] forState:(UIControlStateNormal)];
        btnView.clearBtn.hidden = YES;
        if(i != 0){
            btnView.hidden = YES;
        }
    }
    
    if (self.imgArray.count==1) {
        YSPictureBtnView *btnView = [self viewWithTag:1025];
        YSNewsAttachmentModel *model = self.imgArray[0];
        [btnView.choseBtn setImage:model.choseImg forState:(UIControlStateNormal)];
        btnView.clearBtn.hidden = NO;
        btnView.hidden = NO;
        [[self viewWithTag:1026] setHidden:NO];
        
    }else if (self.imgArray.count==2){
        YSPictureBtnView *btnView = [self viewWithTag:1025];
        YSNewsAttachmentModel *model = self.imgArray[0];
        [btnView.choseBtn setImage:model.choseImg forState:(UIControlStateNormal)];
        btnView.clearBtn.hidden = NO;
        
        YSNewsAttachmentModel *model1 = self.imgArray[1];
        [(YSPictureBtnView*)[self viewWithTag:1026] setHidden:NO];
        [[(YSPictureBtnView*)[self viewWithTag:1026] choseBtn] setImage:model1.choseImg forState:UIControlStateNormal];
        [[(YSPictureBtnView*)[self viewWithTag:1026] clearBtn] setHidden:NO];
        
        [(YSPictureBtnView*)[self viewWithTag:1027] setHidden:NO];
    }else if (self.imgArray.count==3){
        YSPictureBtnView *btnView = [self viewWithTag:1025];
        YSNewsAttachmentModel *model = self.imgArray[0];
        [btnView.choseBtn setImage:model.choseImg forState:(UIControlStateNormal)];
        btnView.clearBtn.hidden = NO;
        
        YSNewsAttachmentModel *model1 = self.imgArray[1];
        [(YSPictureBtnView*)[self viewWithTag:1026] setHidden:NO];
        [[(YSPictureBtnView*)[self viewWithTag:1026] choseBtn] setImage:model1.choseImg forState:UIControlStateNormal];
        [[(YSPictureBtnView*)[self viewWithTag:1026] clearBtn] setHidden:NO];
        
        YSNewsAttachmentModel *model2 = self.imgArray[2];
        [(YSPictureBtnView*)[self viewWithTag:1027] setHidden:NO];
        [[(YSPictureBtnView*)[self viewWithTag:1027] choseBtn] setImage:model2.choseImg forState:UIControlStateNormal];
        [[(YSPictureBtnView*)[self viewWithTag:1027] clearBtn] setHidden:NO];
    }
}

// 预览相册
- (QMUIImagePickerPreviewViewController *)imagePickerPreviewViewControllerForImagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController {
    QMUIImagePickerPreviewViewController *imagePickerPreviewViewController = [[QMUIImagePickerPreviewViewController alloc] init];
    imagePickerViewController.maximumSelectImageCount = 9;
    return imagePickerPreviewViewController;
}

- (NSMutableArray*)imgArray {
    if (!_imgArray) {
        _imgArray = [NSMutableArray new];
    }
    return _imgArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
