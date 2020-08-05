//
//  YSSupplyBidInvitingInfoController.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/1/2.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSSupplyBidInvitingInfoController.h"
#import <WebKit/WebKit.h>
#define KWEBVIEWHEIGHT kSCREEN_HEIGHT - kMenuViewHeight - kTopHeight
@interface YSSupplyBidInvitingInfoController ()<WKNavigationDelegate>
@property (nonatomic,strong)  WKWebView *webView;
@end

@implementation YSSupplyBidInvitingInfoController
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc]init];
        _webView.navigationDelegate = self;
        [self.view addSubview:_webView];
        _webView.frame = CGRectMake(-(KWEBVIEWHEIGHT - kSCREEN_WIDTH)/2, (KWEBVIEWHEIGHT - kSCREEN_WIDTH)/2, KWEBVIEWHEIGHT, kSCREEN_WIDTH);
        _webView.transform = CGAffineTransformMakeRotation (M_PI_2);
    }
    return _webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self doNetworking];
    //self.title = @"投标信息";
    
}
- (void)initSubviews {
    [super initSubviews];
    
}
- (void)doNetworking {
    [QMUITips showLoadingInView:self.view];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain,getBidDetailAPI,self.bidID] isNeedCache:NO parameters:nil successBlock:^(id response) {
        [QMUITips hideAllTipsInView:self.view];
        if ([response[@"code"] integerValue] == 1) {
                 NSString *urlStr = response[@"data"];
                if (urlStr.length) {//url是否存在
                    [self hideEmptyView];
                    [self.webView  loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
                }else{
                    [self ys_emptyView];
                }
            }else{
               [self ys_emptyView];
            }
        
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllTipsInView:self.view];
        [self ys_emptyView];
    } progress:nil];
}
#pragma mark - wkwebView代理方法
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [QMUITips showLoadingInView:self.view];
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [QMUITips hideAllTipsInView:self.view];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    [QMUITips hideAllTipsInView:self.view];
    [QMUITips showError:@"加载失败" inView:self.view hideAfterDelay:.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
////是否支持转屏
//-(BOOL)shouldAutorotate
//{
//    return NO;
//
//}
//
////支持哪些转屏方向
//-(NSUInteger)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskLandscape;
//    //return self.orietation;
//}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation != self.orietation);
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
