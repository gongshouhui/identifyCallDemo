//
//  YSScanSignController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/12/10.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSScanSignController.h"
#import "YSAssetsScanView.h"
@interface YSScanSignController ()
/**扫描组件*/
@property (nonatomic, strong) MTBBarcodeScanner *barcodeScanner;
@property (nonatomic,strong) YSAssetsScanView *assetsScanView;
@end

@implementation YSScanSignController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor blackColor];
	_assetsScanView = [[YSAssetsScanView alloc] init];
	_assetsScanView.cancelButton.hidden = YES;
	[self.view addSubview:_assetsScanView];
	_barcodeScanner = [[MTBBarcodeScanner alloc] initWithPreviewView:_assetsScanView];
	YSWeak;
	_barcodeScanner.didStartScanningBlock = ^{
		weakSelf.barcodeScanner.scanRect = weakSelf.assetsScanView.viewOfInterest.frame;
	};
   
}
- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
	
	[self scan];
}
#pragma mark - 扫描方法
- (void)scan {
	[MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
		if (success) {
			NSError *error = nil;
			[self.barcodeScanner startScanningWithResultBlock:^(NSArray<AVMetadataMachineReadableCodeObject *> *codes) {
				
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
//				DLog(@"识别结果:%@", result);
//				dispatch_async(dispatch_get_main_queue(), ^{
//					YSAssetsScanDetailViewController *assetsScanDetailViewController = [[YSAssetsScanDetailViewController alloc] init];
//					assetsScanDetailViewController.isCheck = _isCheck;
//					assetsScanDetailViewController.titleString = @"扫描结果";
//					assetsScanDetailViewController.id = result;
//					assetsScanDetailViewController.checkId = _id;
//					[self.navigationController pushViewController:assetsScanDetailViewController animated:YES];
//				});
			} error:&error];
		}
	}];
	
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
