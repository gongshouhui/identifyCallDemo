//
//  YSContactDetailViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/8.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSContactDetailViewController.h"
#import "YSContactDetailHeaderView.h"
#import "YSContactInnerViewController.h"
#import "YSContactDetailCell.h"
#import "YSDepartmentModel.h"

static NSString *cellIdentifier = @"ContactDetailCell";

@interface YSContactDetailViewController ()<QMUINavigationControllerDelegate, QMUIImagePreviewViewDelegate>

@property (nonatomic, strong) YSContactDetailHeaderView *contactDetailHeaderView;
@property (nonatomic, strong) QMUIImagePreviewViewController *imagePreviewViewController;
@property (nonatomic, strong) QMUIButton *addToCommonContactButton;

@end

@implementation YSContactDetailViewController

- (QMUIButton *)addToCommonContactButton {
	if (!_addToCommonContactButton) {
		_addToCommonContactButton = [[QMUIButton alloc] init];
		_addToCommonContactButton.backgroundColor = kThemeColor;
		[_addToCommonContactButton setTitle:@"添加常用联系人" forState:UIControlStateNormal];
		[_addToCommonContactButton setTitleColor:UIColorWhite forState:UIControlStateNormal];
		_addToCommonContactButton.titleLabel.font = UIFontMake(16);
		[_addToCommonContactButton mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.right.mas_equalTo(self.view);
			make.bottom.mas_equalTo(self.view.mas_bottom).offset(-kBottomHeight);
			make.height.mas_equalTo(50*kHeightScale);
		}];
	}
	return _addToCommonContactButton;
}
- (void)initTableView {
	[super initTableView];
	_contactDetailHeaderView = [[YSContactDetailHeaderView alloc] init];
	[_contactDetailHeaderView setContactModel:_contactModel contactDetailType:_contactDetailType];
	YSWeak;
	[[_contactDetailHeaderView.avatarButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		[weakSelf handleImageButtonEvent:weakSelf.contactDetailHeaderView.avatarButton];
	}];
	[self monitorAction];
	self.tableView.tableHeaderView = _contactDetailHeaderView;
	[self.tableView registerClass:[YSContactDetailCell class] forCellReuseIdentifier:cellIdentifier];
	[self setupDatasource];
}
- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
	[super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
	self.title = @"个人信息";
	//    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"关闭" tintColor:UIColorWhite position:QMUINavigationButtonPositionRight target:self action:@selector(close)];
}

- (void)close {
	// 从通讯录进来的返回至通讯录前一页，否则只返回
	for (int i = 0; i < self.rt_navigationController.rt_viewControllers.count; i ++) {
		UIViewController *viewController = self.rt_navigationController.rt_viewControllers[i];
		if ([viewController isKindOfClass:[YSContactInnerViewController class]]) {
			YSContactInnerViewController *innerViewController = (YSContactInnerViewController *)viewController;
			if (innerViewController.isRootDirectory) {
				[self.rt_navigationController popToViewController:self.rt_navigationController.rt_viewControllers[i-1] animated:YES complete:nil];
			}
		} else {
			if ([viewController isKindOfClass:[YSContactDetailViewController class]]) {
				[self.rt_navigationController popToViewController:self.rt_navigationController.rt_viewControllers[i-1] animated:YES];
			}
		}
	}
}

#pragma mark - QMUINavigationTitleViewDelegate

//- (UIColor *)titleViewTintColor {
//    return [UIColor whiteColor];
//}

#pragma mark - QMUINavigationControllerDelegate
- (BOOL)shouldSetStatusBarStyleLight {
	return StatusbarStyleLightInitially;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return StatusbarStyleLightInitially ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}
//
//- (UIImage *)navigationBarBackgroundImage {
//    return UIImageMake(@"contact_navigationBar");
//}



- (void)setupDatasource {
	switch (_contactDetailType) {
		case YSContactDetailInner:
		{
			BOOL showContact = YES;//默认yes
			//判断是否显示联系方式
			//1、查询所属部门的showContact字段值
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@",self.contactModel.deptId];
			
			YSDepartmentModel *department =  [YSDepartmentModel objectsWithPredicate:predicate].firstObject;
			if ([department.showContact isEqualToString:@"0"]){//部门设置不显示，s下面所有人员不显示
				showContact = NO;
			}else{//1或null的情况，部门层级不做限制,由个人决定
				showContact = self.contactModel.showContact;
			}
			
			
			
			
			
			
			self.dataSource = @[@{@"name": @"工号",
								  @"detail": _contactModel.userId,
								  @"type": @"normal"},
								@{@"name": @"部门",
								  @"detail": _contactModel.deptName,
								  @"type": @"normal"},
								@{@"name": @"岗位",
								  @"detail": _contactModel.jobStation,
								  @"type": @"normal"},
								@{@"name": @"手机",
								  @"detail": showContact?_contactModel.mobile:@"",
								  @"type": @"phone"},
								@{@"name": @"短号",
								  @"detail": showContact?_contactModel.shortPhone:@"",
								  @"type": @"phone"},
								@{@"name": @"座机号码",
								  @"detail":showContact? _contactModel.phone:@"",
								  @"type": @"phone"},
								@{@"name": @"座机短号",
								  @"detail": _contactModel.shortWorkPhone,
								  @"type": @"phone"},
								@{@"name": @"办公地址",
								  @"detail": _contactModel.workAddress,
								  @"type": @"normal"},
								@{@"name": @"企业邮箱",
								  @"detail": showContact?_contactModel.email:@"",
								  @"type": @"normal"}];
			break;
		}
		case YSContactDetailOuter:
		{
			break;
		}
		case YSContactDetailAddress:
		{
			self.dataSource = @[@{@"name": @"手机号码",
								  @"detail": _contactModel.mobilePhone,
								  @"type": @"phone"},
								@{@"name": @"来源",
								  @"detail": @"手机通讯录",
								  @"type": @"normal"}];
			[self.view addSubview:self.addToCommonContactButton];
			break;
		}
		case YSContactDetailCommon:
		{
			break;
		}
	}
}


- (void)monitorAction {
	YSWeak;
	[_contactDetailHeaderView.sendActionSubject subscribeNext:^(QMUIButton *button) {
		YSStrong;
		// 0（单聊）、1（拨打电话）、2（发送短信）
		switch (button.tag) {
				
			case 1010:
			{
				[YSUtility openUrlWithType:YSOpenUrlCall urlString:strongSelf.contactModel.mobile];
				break;
			}
			case 1011:
			{
				[YSUtility openUrlWithType:YSOpenUrlSendMsg urlString:strongSelf.contactModel.mobile];
				break;
			}
			default:
				break;
		}
	}];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	YSContactDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[YSContactDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	NSDictionary *rowDict = self.dataSource[indexPath.row];
	[cell setRowDict:rowDict];
    if (([rowDict[@"name"] isEqualToString:@"手机"] || [rowDict[@"name"] isEqualToString:@"短号"] || [rowDict[@"name"] isEqualToString:@"座机号码"] || [rowDict[@"name"] isEqualToString:@"座机短号"]) && [self.contactModel.isExcellentEmployee integerValue] == 1) {
        cell.detailLabel.textColor = [UIColor colorWithHexString:@"#FFC19A6C"];
    }else {
        cell.detailLabel.textColor = [UIColor darkTextColor];
    }
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *rowDict = self.dataSource[indexPath.row];
	if ([rowDict[@"type"] isEqual:@"phone"]) {
		[YSUtility openUrlWithType:YSOpenUrlCall urlString:rowDict[@"detail"]];
	}
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewAutomaticDimension;
}
- (void)handleImageButtonEvent:(UIButton *)button {
	if (!self.imagePreviewViewController) {
		self.imagePreviewViewController = [[QMUIImagePreviewViewController alloc] init];
		self.imagePreviewViewController.imagePreviewView.delegate = self;
		self.imagePreviewViewController.imagePreviewView.currentImageIndex = 0;
	}
	[self.imagePreviewViewController startPreviewFromRectInScreen:CGRectMake(kSCREEN_WIDTH/2.0-37*kWidthScale, 50+kTopHeight, 74*kWidthScale, 74*kWidthScale) cornerRadius:self.contactDetailHeaderView.avatarButton.layer.cornerRadius];
}

#pragma mark - QMUIImagePreviewViewDelegate

- (NSUInteger)numberOfImagesInImagePreviewView:(QMUIImagePreviewView *)imagePreviewView {
	return 1;
}

- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView renderZoomImageView:(QMUIZoomImageView *)zoomImageView atIndex:(NSUInteger)index {
	NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@_L.jpg", _contactModel.headImg]];
	[zoomImageView.imageView sd_setImageWithURL:imageURL placeholderImage:nil options:(SDWebImageRefreshCached) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
		//	NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
		//	UIImage *image = [UIImage imageWithData:imageData];
			zoomImageView.image = image;
	}];

	
}

- (QMUIImagePreviewMediaType)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView assetTypeAtIndex:(NSUInteger)index {
	return QMUIImagePreviewMediaTypeImage;
}

#pragma mark - QMUIZoomImageViewDelegate

- (void)singleTouchInZoomingImageView:(QMUIZoomImageView *)zoomImageView location:(CGPoint)location {
	//[self.contactDetailHeaderView.avatarButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_M.jpg", _contactModel.headImg]] forState:UIControlStateNormal];
	[self.contactDetailHeaderView.avatarButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_M.jpg", _contactModel.headImg]] forState:UIControlStateNormal placeholderImage:UIImageMake(@"头像") options:(SDWebImageRefreshCached)];
	[self.imagePreviewViewController endPreviewToRectInScreen:CGRectMake(kSCREEN_WIDTH/2.0-37*kWidthScale, 50+kTopHeight, 74*kWidthScale, 74*kHeightScale)];
}

@end
