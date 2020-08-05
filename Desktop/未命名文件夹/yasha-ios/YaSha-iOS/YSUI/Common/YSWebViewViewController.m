//
//  YSWebViewViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/10/8.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSWebViewViewController.h"
#import "UIWebView+YSFullImg.h"
@interface YSWebViewViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation YSWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [QMUITips showLoadingInView:self.view];
    //班车时间表 保存到本地; 保存到相册时候 去掉
    if ([self.urlShowType isEqualToString:@"1"]) {
        [self saveBusAttachment];
    }
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, kSCREEN_HEIGHT));
    }];
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
//    [QMUITips showLoadingInView:self.view];
    /*班车时间表 保存到相册的时候 打开 记得下面webViewDidFinishLoad 去掉 return
    if ([self.urlShowType isEqualToString:@"1"]) {
        [self.webView imageRepresentation:^(UIImage * _Nonnull img) {
            UIImageWriteToSavedPhotosAlbum(img, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
        }];
    }
    */
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([self.urlShowType isEqualToString:@"1"]) {
        return;
    }
    [QMUITips hideAllToastInView:self.view animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [QMUITips hideAllToastInView:self.view animated:YES];
    [[QMUITips showInfo:@"网址请求超时" inView:self.view] hideAnimated:NO afterDelay:1.5];
}

#pragma mark--保存到相册
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [QMUITips hideAllToastInView:self.view animated:YES];
    if (!error) {
        NSLog(@"成功");
        [QMUITips showSucceed:@"保存成功,请去相册查看" inView:self.view hideAfterDelay:2];
    }else {
        NSLog(@"失败 - %@",error);
        [QMUITips showSucceed:@"保存失败" inView:self.view hideAfterDelay:2];
        
    }
    
    
}


#pragma mark--保存到本地
- (void)saveBusAttachment {
    DLog(@"保存");
    NSFileManager *fileManager = [NSFileManager defaultManager];
     BOOL isDir = FALSE;
     BOOL isDirExist = [fileManager fileExistsAtPath:AttachmentFolderPath isDirectory:&isDir];
    if(!(isDirExist && isDir)){
        BOOL bCreateDir = [fileManager createDirectoryAtPath:AttachmentFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(bCreateDir){
            DLog(@"创建文件夹成功，文件路径%@",AttachmentFolderPath);
        }else {
            DLog(@"创建文件夹失败！");
        }
    }
    DLog(@"======%@--文件路径%@",self.url, AttachmentFolderPath);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //当前时间字符串
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    [YSNetManager ys_downLoadFileWithUrlString:self.url parameters:nil savaPath:[AttachmentFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"亚厦班车一览表 %@.pdf",currentDateStr]] successBlock:^(id response) {
        DLog(@"下载成功:%@", response);
        [QMUITips hideAllToastInView:self.view animated:YES];
        [QMUITips showSucceed:@"成功下载到:我的->我的文件" inView:self.view hideAfterDelay:2.0];
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
        [QMUITips hideAllToastInView:self.view animated:YES];
    } downLoadProgress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
    }];
}

#pragma mark - url 中文格式化
- (NSString *)strUTF8Encoding:(NSString *)str {
    /*! ios9适配的话 打开第一个 */
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 9.0) {
        return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    } else {
        return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
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
