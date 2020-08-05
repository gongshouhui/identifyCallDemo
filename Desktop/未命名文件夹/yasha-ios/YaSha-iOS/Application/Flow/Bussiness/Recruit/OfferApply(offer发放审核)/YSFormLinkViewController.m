//
//  YSFormLinkViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/10/19.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFormLinkViewController.h"

@interface YSFormLinkViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation YSFormLinkViewController
- (void)initSubviews {
    [super initSubviews];
    self.title = @"附件信息";
    self.webView = [[UIWebView alloc]init];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self.view);
    }];
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.webView loadRequest:mutableURLRequest];
//    NSURL *url = [NSURL URLWithString:self.urlString];
//
//    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
//
//    [self.webView loadRequest:request];

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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
