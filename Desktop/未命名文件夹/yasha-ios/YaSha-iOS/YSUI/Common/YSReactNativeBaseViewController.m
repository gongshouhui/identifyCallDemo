//
//  YSReactNativeBaseViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/9/17.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSReactNativeBaseViewController.h"
#import "YSReactNativeManager.h"
#import "YSWebViewViewController.h"

@interface YSReactNativeBaseViewController ()

@end

@implementation YSReactNativeBaseViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)dealloc{
    [QMUITips hideAllToastInView:self.view animated:NO];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navagateBack) name:@"YSModuleNavigateBack" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToWebView:) name:@"YSModuleRNToWebView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenLoading) name:@"YSModuleRNhiddenLoad" object:nil];
    
    RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:[YSReactNativeManager shareInstance].bridge
                                                     moduleName:self.pageName
                                              initialProperties:self.initialProperty];
    self.view = rootView;
    [QMUITips showLoadingInView:self.view];

}

+ (instancetype)RNPageWithName:(NSString*)pageName initialProperty:(NSDictionary*)initialProperty{
    YSReactNativeBaseViewController *vc = [[YSReactNativeBaseViewController alloc] initWithPageName:pageName initialProperty:initialProperty];
    return vc;
}

- (instancetype)initWithPageName:(NSString*)pageName initialProperty:(NSDictionary*)initialProperty{
    if(self = [super init]){
        self.pageName = pageName;
        self.initialProperty = initialProperty;
    }
    return self;
}

- (void)hiddenLoading{
    [QMUITips hideAllToastInView:self.view animated:NO];

}

-(void)jumpToWebView:(NSNotification*)notification{
    YSWebViewViewController *webViewVC = [YSWebViewViewController new];
    webViewVC.url = [notification.userInfo objectForKey:@"url"];
    webViewVC.urlShowType = [notification.userInfo objectForKey:@"urlShowType"];
    [self.navigationController pushViewController:webViewVC animated:YES];
}
- (void)navagateBack{
    [self.navigationController popViewControllerAnimated:YES];
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
