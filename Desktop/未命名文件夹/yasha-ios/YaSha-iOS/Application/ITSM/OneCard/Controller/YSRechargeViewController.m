//
//  YSRechargeViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/25.
//

#import "YSRechargeViewController.h"
#import <AlipaySDK/AlipaySDK.h>

@interface YSRechargeViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation YSRechargeViewController

//设置统计开始进入该模块
- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"一卡通充值"];
}

- (void)viewWillDisappear:(BOOL)animated {
      [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"一卡通充值"];
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"一卡通充值";
}

- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self doNetworking];
}

- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, getOneCardSignatureApi];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"一卡通签名:%@", response);
        if ([response[@"code"] intValue] == 1) {
            NSString *timestamp = response[@"data"][@"timestamp"];
            NSString *sign = response[@"data"][@"sign"];
            NSURL *url = [NSURL URLWithString:YSRechargeDomain];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
            [request setHTTPMethod:@"POST"];
            NSString *bodyString = [NSString stringWithFormat:@"mh_client=myapp&mh_percode=%@&mh_accname=%@&mh_timestamp=%@&mh_sign=%@", [YSUtility getUID], [YSUtility getName], timestamp, sign];
            NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:bodyData];
            [self.webView loadRequest:request];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    DLog(@"start");
    [QMUITips showLoading:@"加载中..." inView:self.view];
	
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // NOTE: ------  对alipays:相关的scheme处理 -------
    // NOTE: 若遇到支付宝相关scheme，则跳转到本地支付宝App
    NSString* reqUrl = request.URL.absoluteString;
    
    __weak YSRechargeViewController* wself = self;
    BOOL isIntercepted = [[AlipaySDK defaultService] payInterceptorWithUrl:[request.URL absoluteString] fromScheme:@"yasha" callback:^(NSDictionary *result) {
        // 处理支付结果
        DLog(@"支付结果:%@", result);
        if ([result[@"resultCode"] integerValue] == 9000) {
            // isProcessUrlPay 代表 支付宝已经处理该URL
            if ([result[@"isProcessUrlPay"] boolValue]) {
                // returnUrl 代表 第三方App需要跳转的成功页URL
                NSString* urlStr = result[@"returnUrl"];
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
                [wself.webView loadRequest:request];
            }
        }
    }];
    
    if (isIntercepted) {
        return NO;
    }
    return YES;
    
    
//    if ([reqUrl hasPrefix:@"alipays://"] || [reqUrl hasPrefix:@"alipay://"]) {
//        // NOTE: 跳转支付宝App
//        BOOL bSucc = [[UIApplication sharedApplication] openURL:request.URL];
//
//        // NOTE: 如果跳转失败，则跳转itune下载支付宝App
//        if (!bSucc) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
//                                                           message:@"未检测到支付宝客户端，请安装后重试。"
//                                                          delegate:self
//                                                 cancelButtonTitle:@"立即安装"
//                                                 otherButtonTitles:nil];
//            [alert show];
//        }
//        return NO;
//    }
//    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // NOTE: 跳转itune下载支付宝App
    NSString* urlStr = @"https://itunes.apple.com/cn/app/zhi-fu-bao-qian-bao-yu-e-bao/id333206289?mt=8";
    NSURL *downloadUrl = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL:downloadUrl];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [QMUITips hideAllToastInView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    DLog(@"%@", error);
    [QMUITips hideAllToastInView:self.view animated:YES];
    
}

@end
