//
//  YSFlowMapViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/30.
//

#import "YSFlowMapViewController.h"

@interface YSFlowMapViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation YSFlowMapViewController

- (void)initSubviews {
    [super initSubviews];
    self.title = @"流程图";
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self.view);
    }];
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
     [mutableURLRequest addValue:[YSUtility getHTTPHeaderFieldDictionary][@"X-Content"] forHTTPHeaderField:@"X-Content"];
    [self.webView loadRequest:mutableURLRequest];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [QMUITips showLoading:@"加载中..." inView:self.view];
    DLog(@"start load");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [QMUITips hideAllTipsInView:self.view];
    DLog(@"end load");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [QMUITips hideAllTipsInView:self.view];
}

@end
