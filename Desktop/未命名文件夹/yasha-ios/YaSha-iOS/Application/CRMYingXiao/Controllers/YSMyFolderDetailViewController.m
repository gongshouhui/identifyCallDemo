//
//  YSMyFolderDetailViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/5/13.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSMyFolderDetailViewController.h"

@interface YSMyFolderDetailViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) QMUIAlertController *alertController;


@end

@implementation YSMyFolderDetailViewController


- (void)initSubviews {
    [super initSubviews];
    self.title = @"文件详情";
    [QMUITips showLoadingInView:self.view];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kTopHeight)];
    //支持手势缩放
    _webView.scalesPageToFit = YES;
    NSString *path = [AttachmentFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", self.attachmentModel.viewPath]];
    DLog(@"查看的文件的路径:%@", path);
    NSData *data = [NSData dataWithContentsOfFile:path];
    [_webView loadData:data MIMEType:self.mimeType textEncodingName:@"UTF-8" baseURL:[NSURL fileURLWithPath:NSTemporaryDirectory()]];
    _webView.delegate = self;
    [self.view addSubview:self.webView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [QMUITips showLoadingInView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [QMUITips hideAllToastInView:self.view animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [QMUITips hideAllToastInView:self.view animated:YES];
    [[QMUITips showInfo:@"请求超时" inView:self.view] hideAnimated:NO afterDelay:1.5];
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
