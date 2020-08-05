//
//  YSIdentPhoneHelpViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/27.
//

#import "YSIdentPhoneHelpViewController.h"

@interface YSIdentPhoneHelpViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation YSIdentPhoneHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"使用帮助";
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    [self.view addSubview:self.webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, kSCREEN_HEIGHT));
    }];
    NSURL *url = [NSURL URLWithString:@"https://app.chinayasha.com/help/callkit.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode != 200) {
            [self loadHTMLString];
        }
    }];
    [dataTask resume];
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self loadHTMLString];
}

/** 网络加载失败时加载本地数据 */
- (void)loadHTMLString {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CallKit_help" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *basePath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:basePath];
    [self.webView loadHTMLString:htmlString baseURL:baseURL];
}

@end
