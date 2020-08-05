//
//  YSMQImageSelectCellCell.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/10/26.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSMQImageSelectCellCell.h"
#import "YSImageSelectedCell.h"
#import "YSPMSMQPlanBigPhotoViewController.h"
@interface YSMQImageSelectCellCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;

@end
@implementation YSMQImageSelectCellCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		[self initUI];
	}
	return self;
}
- (void)initUI{
	[self creatCollectionView];
}

- (void)creatCollectionView {
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	// 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
	[layout setScrollDirection:UICollectionViewScrollDirectionVertical];
	layout.minimumInteritemSpacing = 5;// 垂直方向的间距
	layout.minimumLineSpacing = 5; // 水平方向的间距
	layout.itemSize = CGSizeMake(110*kWidthScale, 110*kWidthScale);
	layout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);
	_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
	_collectionView.scrollEnabled = NO;
	_collectionView.backgroundColor = [UIColor whiteColor];
	_collectionView.dataSource = self;
	_collectionView.delegate = self;
	[self.collectionView registerClass:[YSImageSelectedCell class] forCellWithReuseIdentifier:@"cell"];
	[self addSubview:_collectionView];
	[_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(0);
		make.left.mas_equalTo(15);
		make.right.mas_equalTo(-15);
		make.height.mas_equalTo(110*kHeightScale);
		make.bottom.mas_equalTo(-10);
	}];
}
- (void)setDataArray:(NSMutableArray *)dataArray {
	_dataArray = dataArray;
	//重置tableView的高度，让他自适应
	CGFloat height = 0.0;
	height = (self.dataArray.count/3) * 110*kHeightScale + (self.dataArray.count%3 > 0? 110*kHeightScale:0);
	[_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(0);
		make.left.mas_equalTo(15);
		make.right.mas_equalTo(-15);
		make.height.mas_equalTo(height + 5);
		make.bottom.mas_equalTo(-10);
	}];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.dataArray.count;
	
}

/** cell的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	YSImageSelectedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
	cell.image = self.dataArray[indexPath.row];
	if (indexPath.row == self.dataArray.count - 1) {//加号图片
		cell.closeBtn.hidden = YES;
	}else{
		cell.closeBtn.hidden = NO;
	}
	YSWeak;
	[[cell.closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		[weakSelf.dataArray removeObjectAtIndex:indexPath.row];
		weakSelf.selectedImageBlock(weakSelf.dataArray);
	}];
	//[cell setCollectionViewCell:self.dataArray andIndexPath:indexPath];
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == self.dataArray.count -1) {
		[self authorizationPresentAlbumViewController];
	}else{
		NSMutableArray *imageArr = [NSMutableArray arrayWithArray:[self.dataArray copy]];
		[imageArr removeLastObject];
		YSPMSMQPlanBigPhotoViewController *PMSPlanBigPhotoViewController = [[YSPMSMQPlanBigPhotoViewController alloc]init];
		PMSPlanBigPhotoViewController.imageData = imageArr;
		PMSPlanBigPhotoViewController.index = indexPath.row;
		[[YSUtility getCurrentViewController] presentViewController:PMSPlanBigPhotoViewController animated:YES completion:nil];
	}
	
}

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
	imagePickerViewController.maximumSelectImageCount = 9;
	imagePickerViewController.view.tag = albumViewController.view.tag;
	imagePickerViewController.allowsMultipleSelection = YES;
	
	return imagePickerViewController;
}

#pragma mark - QMUIImagePickerViewControllerDelegate

- (void)imagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController didFinishPickingImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
	// 储存最近选择了图片的相册，方便下次直接进入该相册
	[QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerViewController.assetsGroup ablumContentType:QMUIAlbumContentTypeAll userIdentify:nil];
	id imageObject = self.dataArray.lastObject;
	[self.dataArray removeLastObject];
    __weak typeof(self) weakSelf = self;
	[imagePickerViewController dismissViewControllerAnimated:YES completion:^{
		for (QMUIAsset *asset in imagesAssetArray) {
            //ios11图片
            [asset requestImageData:^(NSData *imageData, NSDictionary<NSString *,id> *info, BOOL isGIF, BOOL isHEIC) {
                     
                if (isHEIC) {
                    [weakSelf.dataArray addObject:[UIImage imageWithData:UIImageJPEGRepresentation(asset.originImage, 1)]];
                    if ([imagesAssetArray indexOfObject:asset] == imagesAssetArray.count-1) {
                        [weakSelf.dataArray addObject:imageObject];
                        if (weakSelf.selectedImageBlock) {
                            weakSelf.selectedImageBlock(weakSelf.dataArray);
                        }
                    }
                }else {
                    [weakSelf.dataArray addObject:asset.originImage];
                    if ([imagesAssetArray indexOfObject:asset]== imagesAssetArray.count-1) {
                        [weakSelf.dataArray addObject:imageObject];
                        if (weakSelf.selectedImageBlock) {
                            weakSelf.selectedImageBlock(weakSelf.dataArray);
                        }
                    }
                }
            }];
		}
		
		
	}];
}

// 预览相册
- (QMUIImagePickerPreviewViewController *)imagePickerPreviewViewControllerForImagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController {
	QMUIImagePickerPreviewViewController *imagePickerPreviewViewController = [[QMUIImagePickerPreviewViewController alloc] init];
	imagePickerViewController.maximumSelectImageCount = 9;
	return imagePickerPreviewViewController;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
}

@end
