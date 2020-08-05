//
//  YSFlowTemplateViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/28.
//

#import "YSFlowTemplateViewController.h"

@interface YSFlowTemplateViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation YSFlowTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"考评模板";
    _webView = [[UIWebView alloc] init];
    DLog(@"=====%@",self.urlStr);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [_webView loadRequest:request];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self.view);
    }];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [QMUITips showLoadingInView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [QMUITips hideAllToastInView:self.view animated:YES];
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
