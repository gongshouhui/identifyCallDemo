//
//  YSNewsAttachmentViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/10.
//

#import "YSNewsAttachmentViewController.h"

@interface YSNewsAttachmentViewController ()<UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) QMUIAlertController *alertController;
@property (nonatomic, strong) NSMutableArray *albumsArray;
@property (nonatomic, strong) UIImage *saveImage;

@end

@implementation YSNewsAttachmentViewController

- (NSMutableArray *)albumsArray {
    if (!_albumsArray) {
        _albumsArray = [NSMutableArray array];
    }
    return _albumsArray;
}

- (void)initSubviews {
    [super initSubviews];
    self.title = @"附件详情";
    NSDictionary *para = @{@"filePath":_attachmentModel.filePath};
    [QMUITips showLoadingInView:self.view];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getFileViewPath] isNeedCache:NO parameters:para successBlock:^(id response) {
        DLog(@"获取文件公用地址:%@", response);
        [QMUITips hideAllToastInView:self.view animated:YES];
        if ([response[@"code"] integerValue] == 1) {
            _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kTopHeight)];
            if (![response[@"data"] length]) {
                [QMUITips showError:@"暂不支持查看" inView:self.view hideAfterDelay:2];
                return ;
            }
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:response[@"data"]]];
            //支持手势缩放
            _webView.scalesPageToFit = YES;
            [_webView loadRequest:request];
            _webView.delegate = self;
            [self.view addSubview:self.webView];
            // 长按手势处理保存网页图片
            UILongPressGestureRecognizer* longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:nil];
            longPressed.delegate = self;
            [self.webView addGestureRecognizer:longPressed];
        }
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:YES];
        [QMUITips showError:@"请求失败" inView:self.view hideAfterDelay:1.5];
    } progress:nil];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"保存" position:QMUINavigationButtonPositionRight target:self action:@selector(saveAttachment)];
}

- (void)saveAttachment {
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
    DLog(@"======%@--文件路径%@",_attachmentModel.filePath, AttachmentFolderPath);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-ddHH-mm-ss"];
    //当前时间字符串
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    [YSNetManager ys_downLoadFileWithUrlString:_attachmentModel.filePath parameters:nil savaPath:[AttachmentFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", currentDateStr, _attachmentModel.fileName]] successBlock:^(id response) {
        DLog(@"下载成功:%@", response);
        [QMUITips showSucceed:@"下载成功" inView:self.view hideAfterDelay:1.0];
//        [QMUITips hideAllToastInView:self.view animated:YES];
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } downLoadProgress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
//        NSString *progress = [NSString stringWithFormat:@"下载进度：%.2lld%%", 100 * bytesProgress / totalBytesProgress];
//        [QMUITips showLoading:progress inView:self.view];
    }];
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
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint touchPoint = [gestureRecognizer locationInView:self.webView];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    NSString *urlToSave = [self.webView stringByEvaluatingJavaScriptFromString:imgURL];
    if (urlToSave.length != 0) {
        [self showImageOptionsWithUrl:urlToSave];
    }
    return NO;
}

- (void)showImageOptionsWithUrl:(NSString *)imageUrl {
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    _saveImage = [UIImage imageWithData:imageData];
    if ([QMUIAssetsManager authorizationStatus] == QMUIAssetAuthorizationStatusNotDetermined) {
        [QMUIAssetsManager requestAuthorization:^(QMUIAssetAuthorizationStatus status) {
            // requestAuthorization:(void(^)(QMUIAssetAuthorizationStatus status))handler 不在主线程执行，因此涉及 UI 相关的操作需要手工放置到主流程执行。
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == QMUIAssetAuthorizationStatusAuthorized) {
                    [self saveImageToAlbum];
                } else {
                    [YSUIHelper showAlertWhenSavedPhotoFailureByPermissionDenied];
                }
            });
        }];
    } else if ([QMUIAssetsManager authorizationStatus] == QMUIAssetAuthorizationStatusNotAuthorized) {
        [YSUIHelper showAlertWhenSavedPhotoFailureByPermissionDenied];
    } else {
        [self saveImageToAlbum];
    }
}

- (void)saveImageToAlbum {
    if (!_alertController) {
        _alertController = [QMUIAlertController alertControllerWithTitle:@"保存到指定相册" message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
        // 显示空相册，不显示智能相册
        [[QMUIAssetsManager sharedInstance] enumerateAllAlbumsWithAlbumContentType:QMUIAlbumContentTypeAll showEmptyAlbum:YES showSmartAlbumIfSupported:NO usingBlock:^(QMUIAssetsGroup *resultAssetsGroup) {
            if (resultAssetsGroup) {
                [_albumsArray addObject:resultAssetsGroup];
                QMUIAlertAction *action = [QMUIAlertAction actionWithTitle:[resultAssetsGroup name] style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                    QMUIImageWriteToSavedPhotosAlbumWithAlbumAssetsGroup(_saveImage, resultAssetsGroup, ^(QMUIAsset *asset, NSError *error) {
                        if (asset) {
                            [QMUITips showSucceed:[NSString stringWithFormat:@"已保存到相册-%@", [resultAssetsGroup name]] inView:self.navigationController.view hideAfterDelay:1.0];
                        } else {
                            DLog(@"%@", error);
                        }
                    });
                }];
                [_alertController addAction:action];
            } else {
                QMUIAlertAction *cancelAction = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil];
                [_alertController addAction:cancelAction];
            }
        }];
    }
    [_alertController showWithAnimated:YES];
}

@end
