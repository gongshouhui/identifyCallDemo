//
//  YSFlowNotiContentController.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/3/1.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowNotiContentController.h"
#import <WebKit/WebKit.h>
@interface YSFlowNotiContentController ()<WKNavigationDelegate>
@property (nonatomic,strong) UILabel *contentLb;
@property (nonatomic,strong)  WKWebView *webView;
@property (nonatomic,strong) UILabel *timeLb;
@end

@implementation YSFlowNotiContentController
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc]init];
        _webView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 0.1);
        _webView.navigationDelegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}
- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [[UILabel alloc]init];
        _timeLb.textColor = kGrayColor(51);
        _timeLb.font = [UIFont systemFontOfSize:14];
        [self.webView.scrollView addSubview:_timeLb];
    }
    return _timeLb;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发文内容";
    if (@available(iOS 11.0, *)) {//正常情况下安全区域64，adjustcontentinset
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    NSString *contentStr = [NSString stringWithFormat:@"%@<br/><p align='right'>%@</p><p align='right'>%@</p><br/>",self.contentText,self.ownerName,self.timeStr];
    [self.webView loadHTMLString:contentStr baseURL:nil];
}
- (void)viewDidLayoutSubviews {
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        if(@available(iOS 11.0,*)){
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(0);
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(kTopHeight);
            make.bottom.mas_equalTo(0);
        }
    }];
}

#pragma mark -- WKWebView 点击链接
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //修改字体大小 300%
    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '200%'" completionHandler:nil];
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
