//
//  YSAssetsScanViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/12.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSAssetsScanViewController.h"
#import "YSAssetsScanView.h"
#import "YSAssetsScanViewController.h"
#import "YSAssetsScanDetailViewController.h"

@interface YSAssetsScanViewController ()

@property (nonatomic, strong) MTBBarcodeScanner *barcodeScanner;
@property (nonatomic, strong) YSAssetsScanView *assetsScanView;

@end

@implementation YSAssetsScanViewController

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
	[super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
	self.title = @"二维码";
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"闪光灯" style:UIBarButtonItemStylePlain target:self action:@selector(openLight)];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self setNavigationItemsIsInEditMode:YES animated:YES];
	
	self.view.backgroundColor = [UIColor whiteColor];
	_assetsScanView = [[YSAssetsScanView alloc] init];
	[[_assetsScanView.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		[self.navigationController popViewControllerAnimated:YES];
	}];
	_barcodeScanner = [[MTBBarcodeScanner alloc] initWithPreviewView:_assetsScanView];
	[self.view addSubview:_assetsScanView];
	[self scan];
}

- (void)initSubviews {
	[super initSubviews];
}

- (void)scan {
	[MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
		if (success) {
			NSError *error = nil;
			[_barcodeScanner startScanningWithResultBlock:^(NSArray<AVMetadataMachineReadableCodeObject *> *codes) {
				_barcodeScanner.scanRect = _assetsScanView.viewOfInterest.frame;
				AVMetadataMachineReadableCodeObject *codeObject = [codes firstObject];
				NSString *tempString = [NSString stringWithFormat:@"%@", codeObject.stringValue];
				NSString *result;
				if ([tempString canBeConvertedToEncoding:NSISOLatin1StringEncoding]) {
					result = [NSString stringWithCString:[tempString cStringUsingEncoding:NSISOLatin1StringEncoding] encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
				} else {
					result = tempString;
				}
				if (!result) {
					
				}
				DLog(@"识别结果:%@", result);
				dispatch_async(dispatch_get_main_queue(), ^{
					YSAssetsScanDetailViewController *assetsScanDetailViewController = [[YSAssetsScanDetailViewController alloc] init];
					assetsScanDetailViewController.isCheck = _isCheck;
					assetsScanDetailViewController.titleString = @"扫描结果";
					assetsScanDetailViewController.id = result;
					assetsScanDetailViewController.checkId = _id;
					[self.navigationController pushViewController:assetsScanDetailViewController animated:YES];
				});
			} error:&error];
		}
	}];
}

- (void)openLight {
	_barcodeScanner.torchMode = !_barcodeScanner.torchMode;
}

- (void)viewWillDisappear:(BOOL)animated {
	[_barcodeScanner stopScanning];
	[super viewWillDisappear:animated];
}

@end
