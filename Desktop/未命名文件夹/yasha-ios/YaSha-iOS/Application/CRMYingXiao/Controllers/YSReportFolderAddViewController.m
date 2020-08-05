//
//  YSReportFolderAddViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/5/14.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSReportFolderAddViewController.h"
#import "YSFolderBackImgHolderView.h"
#import "YSMineFloderTableViewCell.h"
#import "YSSingleImagePickerPreviewViewController.h"
#import "YSMultipleImagePickerPreviewViewController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "YSMineMyFolderViewController.h"
#import "YSMyFolderDetailViewController.h"
#import "QMUIAlertController.h"
#import "QMUIAlertController.h"
#import "YSNewsAttachmentViewController.h"
#import "YSBottomTwoBtnCGView.h"


#define MaxSelectedImageCount 9
#define NormalImagePickingTag 1045
#define ModifiedImagePickingTag 1046
#define MultipleImagePickingTag 1047
#define SingleImagePickingTag 1048

static QMUIAlbumContentType const kAlbumContentType = QMUIAlbumContentTypeOnlyPhoto;

@interface YSReportFolderAddViewController ()<SWTableViewCellDelegate,QMUIImagePickerViewControllerDelegate, YSSingleImagePickerPreviewViewControllerDelegate, YSMultipleImagePickerPreviewViewControllerDelegate, QMUIAlbumViewControllerDelegate, UIDocumentInteractionControllerDelegate,UIWebViewDelegate, UIDocumentPickerDelegate>
@property (nonatomic, strong) QMUIPopupMenuView *rightPopupMenuView;
@property (nonatomic, strong) YSFolderBackImgHolderView *holderView;
@property (nonatomic, strong) UIImageView *singleImageView;
@property (nonatomic, strong) NSMutableArray *addPathArray;
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
@property (nonatomic, strong) QMUIAlertController *alertController;
@end

@implementation YSReportFolderAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附件列表";
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn addTarget:self action:@selector(clickedAddFolderAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [rightBtn setImage:[UIImage imageNamed:@"选项添加"] forState:(UIControlStateNormal)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    //底部有按钮的时候 使用[self loadBottomBtnView];
    
    // 以前选择的本地文件
    [self.view addSubview:self.holderView];
    if (self.addFolderArray.count == 0) {
        [self.view bringSubviewToFront:self.holderView];
    }else {
        for (YSNewsAttachmentModel *model in self.addFolderArray) {
            [self.addPathArray addObject:[AttachmentFolderPath stringByAppendingPathComponent:model.viewPath]];
        }
        [self.dataSourceArray addObjectsFromArray:self.addFolderArray];
    }
    if (self.dataSourceArray.count == 0) {
        //添加网络请求的文件
        [self.dataSourceArray addObjectsFromArray:self.fileNetworkArray];
    }else {
        [self.dataSourceArray insertObjects:self.fileNetworkArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:(NSMakeRange(0, self.fileNetworkArray.count))]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.addFolderBlock && self.dataSourceArray.count) {
        self.addFolderBlock(self.dataSourceArray);
    }
}
/*//底部有按钮的时候 使用
- (void)layoutTableView {
    self.tableView.frame = CGRectMake(0, kTopHeight, kSCREEN_WIDTH, kSCREEN_HEIGHT-kTopHeight-kBottomHeight-90*kHeightScale);
}

- (void)loadBottomBtnView {
    YSBottomTwoBtnCGView *bottomView = [[YSBottomTwoBtnCGView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [bottomView changeSubViewsWith:1];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, 70*kHeightScale));
        make.bottom.mas_equalTo(-kBottomHeight);
        make.left.mas_equalTo(0);
    }];
    @weakify(self);
    [[bottomView.leftBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        if (self.addFolderBlock) {
            if (self.dataSourceArray.count != 0) {
                [self.navigationController popViewControllerAnimated:YES]; self.addFolderBlock(self.dataSourceArray);
            }else {
                [QMUITips showInfo:@"请先选择文件" inView:self.view hideAfterDelay:1];
            }
            
        }
    }];
}*/
- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSMineFloderTableViewCell class] forCellReuseIdentifier:@"folderCellID"];
    /*if (@available(iOS 11, *)) {//底部有按钮的时候 使用
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
*/
}
// 添加附件选项
- (void)clickedAddFolderAction:(UIButton*)sender {
    [self.rightPopupMenuView layoutWithTargetView:sender];
    [self.rightPopupMenuView showWithAnimated:YES];
}

#pragma mark--tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72*kHeightScale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSourceArray.count != 0) {
        self.holderView.hidden = YES;
    }else {
        self.holderView.hidden = NO;
    }
    return self.dataSourceArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSMineFloderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"folderCellID" forIndexPath:indexPath];
    cell.delegate = self;
    YSNewsAttachmentModel *model = self.dataSourceArray[indexPath.row];
    cell.rightUtilityButtons = [self rightArrayBtn];
    if ([self.fileNetworkArray containsObject:model]) {
        // 网络请求的model文件
        cell.folderNetworkModel = model;
    }else {
        // 本地选中的文件
        cell.folderModel = model;
    }
    DLog(@"文件路径:%@", [AttachmentFolderPath stringByAppendingPathComponent:model.viewPath]);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSNewsAttachmentModel *model = self.dataSourceArray[indexPath.row];
    if ([self.fileNetworkArray containsObject:model]) {
        YSNewsAttachmentViewController *NewsAttachmentViewController = [[YSNewsAttachmentViewController alloc]init];
        NewsAttachmentViewController.attachmentModel = model;
        NewsAttachmentViewController.attachmentModel.fileName = model.name;
        [self.navigationController pushViewController:NewsAttachmentViewController animated:YES];
        return;
    }
    NSString *mineType = [self mineType:[[model.fileName componentsSeparatedByString:@"."] lastObject]];
    if ([mineType isEqualToString:@""]) {
        [self exportFileToOtherApp:[AttachmentFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", model.viewPath]]];
    } else {
        YSWeak;
        _alertController = [QMUIAlertController alertControllerWithTitle:@"打开方式" message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"直接打开" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
            YSMyFolderDetailViewController *detailVC = [YSMyFolderDetailViewController new];
            detailVC.attachmentModel = model;
            detailVC.mimeType = mineType;
            [weakSelf.navigationController pushViewController:detailVC animated:YES];
        }];
        [_alertController addAction:action1];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"其他应用打开" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
            [weakSelf exportFileToOtherApp:[AttachmentFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", model.viewPath]]];
        }];
        [_alertController addAction:action2];
        QMUIAlertAction *cancelAction = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil];
        [_alertController addAction:cancelAction];
        
        [_alertController showWithAnimated:YES];
        
    }
    
}

- (NSString *)mineType:(NSString*)name {
    if ([name isEqualToString:@"txt"]) {
        return @"text/plain";
    }else if ([name isEqualToString:@"doc"]) {
        return @"application/msword";
    }else if ([name isEqualToString:@"docx"]) {
        return @"application/vnd.openxmlformats-officedocument.wordprocessingml.document";
    }else if ([name isEqualToString:@"wps"] || [name isEqualToString:@"WPS"]) {
        return @"application/vnd.ms-works";
    }else if ([name isEqualToString:@"pdf"] || [name isEqualToString:@"PDF"]) {
        return @"application/pdf";
    }
    else if ([name isEqualToString:@"ppt"] || [name isEqualToString:@"PPT"]) {
        return @"application/vnd.ms-powerpoint";
    }else if ([name isEqualToString:@"pptx"] || [name isEqualToString:@"PPTX"]) {
        return @"application/vnd.openxmlformats-officedocument.presentationml.presentation";
    }else if ([name isEqualToString:@"pps"] || [name isEqualToString:@"PPS"]) {
        return @"application/vnd.ms-powerpoint";
    }
    else if ([name isEqualToString:@"jpg"] || [name isEqualToString:@"jpeg"] || [name isEqualToString:@"JPG"] || [name isEqualToString:@"JPEG"]) {
        return @"image/jpeg";
    }else if ([name isEqualToString:@"png"] || [name isEqualToString:@"PNG"]) {
        return @"image/png";
    }else if ([name isEqualToString:@"gif"] || [name isEqualToString:@"GIF"]) {
        return @"image/gif";
    }else if ([name isEqualToString:@"bmp"] || [name isEqualToString:@"BMP"]) {
        return @"image/bmp";
    }
    else if ([name isEqualToString:@"xls"]) {
        return @"application/vnd.ms-excel";
    }else if ([name isEqualToString:@"xlsx"]) {
        return @"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
    }else if ([name isEqualToString:@"webp"]) {
        return @"image/webp";
    }
    return @"";
    
}
#pragma mark--其他类型的文件
- (void)exportFileToOtherApp:(NSString*)filePath {
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    _documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
    
    [_documentInteractionController setDelegate:self];
    
    if ([[[filePath componentsSeparatedByString:@"."] lastObject] isEqualToString:@"rar"] || [[[filePath componentsSeparatedByString:@"."] lastObject] isEqualToString:@"RAR"]) {
        
        CGRect rect = CGRectMake(self.view.bounds.size.width, 40.0, 0.0, 0.0);
        [_documentInteractionController presentOpenInMenuFromRect:rect inView:self.view animated:YES];
    }else {
        [_documentInteractionController presentPreviewAnimated:YES];
    }
    
}
#pragma mark--UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
    
}
#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [QMUITips showLoadingInView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [QMUITips hideAllToastInView:self.view animated:NO];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [QMUITips hideAllToastInView:self.view animated:NO];
    [[QMUITips showInfo:@"请求超时" inView:self.view] hideAnimated:NO afterDelay:1.5];
}
#pragma mark--SWTableViewDelegate
- (NSArray*)rightArrayBtn {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithHexString:@"#F73035"] title:@"删除"];
    
    return rightUtilityButtons;
}
// 按钮从左向右排列 从0开始
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
   // 只有一个删除按钮
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row < self.fileNetworkArray.count) {
        // 网络文件 只用删除本地数组 本地没有 不用删除(self.addPathArray)
        [self.fileNetworkArray removeObjectAtIndex:indexPath.row];
    }else {
        // 本地文件 只删除本地的判断数据 不用删除网络的数组(self.fileNetworkArray)
        [self.addPathArray removeObjectAtIndex:indexPath.row];
    }
    [self.dataSourceArray removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
    // 清空了文件列表 将上级页面的文件数组也清空
    if (self.addFolderBlock && self.dataSourceArray.count == 0) {
        self.addFolderBlock(self.dataSourceArray);
    }
}

#pragma mark--setter&&getter
- (NSMutableArray *)addPathArray {
    if (!_addPathArray) {
        _addPathArray = [NSMutableArray new];
    }
    return _addPathArray;
}
- (YSFolderBackImgHolderView *)holderView {
    if (!_holderView) {
        _holderView = [[YSFolderBackImgHolderView alloc] initWithFrame:(CGRectMake(0, kTopHeight, kSCREEN_WIDTH, kSCREEN_HEIGHT-kTopHeight))];
        _holderView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    return _holderView;
}
- (QMUIPopupMenuView *)rightPopupMenuView {
    if (!_rightPopupMenuView) {
        _rightPopupMenuView = [[QMUIPopupMenuView alloc] init];
        _rightPopupMenuView.automaticallyHidesWhenUserTap = YES;
        _rightPopupMenuView.maskViewBackgroundColor = [UIColor clearColor];
        _rightPopupMenuView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.7];
        _rightPopupMenuView.itemTitleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(14)];
        _rightPopupMenuView.maximumWidth = 121*kWidthScale;
        _rightPopupMenuView.shouldShowItemSeparator = YES;
        _rightPopupMenuView.separatorInset = UIEdgeInsetsMake(0, _rightPopupMenuView.padding.left, 0, _rightPopupMenuView.padding.right);
        YSWeak;
        __weak __typeof(QMUIPopupMenuView*) weakPopView = _rightPopupMenuView;
        NSMutableArray *mutableArray = [NSMutableArray array];
        NSArray *nameArray = @[@"图片", @"我的文件", @"手机内存"];
        if (@available(iOS 11.0, *)) {
            nameArray = @[@"图片", @"我的文件", @"手机内存"];
        }else {
            nameArray = @[@"图片", @"我的文件"];
        }
        for (int i = 0; i < nameArray.count; i++) {
            QMUIPopupMenuItem *popupMenuItem = [QMUIPopupMenuItem itemWithImage:UIImageMake(nameArray[i]) title:nameArray[i] handler:^{
                switch (i) {
                    case 0:
                        {//图片
                            [weakPopView hideWithAnimated:YES completion:^(BOOL finished) {
                                [weakSelf authorizationPresentAlbumViewControllerWithTitle:@"选择多张图片"];
                            }];
                            
                        }
                        break;
                    case 1:
                        {//我的文件
                            [weakPopView hideWithAnimated:YES completion:^(BOOL finished) {
                                YSMineMyFolderViewController *folderVC = [YSMineMyFolderViewController new];
                                folderVC.isAdd = YES;
                                folderVC.addMyFolderBlock = ^(NSArray * _Nonnull modelArray) {
                                    for (YSNewsAttachmentModel *model in modelArray) {
                                        DLog(@"选中的文件:%@", model);
                                        if (![weakSelf.addPathArray containsObject:[AttachmentFolderPath stringByAppendingPathComponent:model.viewPath]]) {
                                            [weakSelf.addPathArray addObject:[AttachmentFolderPath stringByAppendingPathComponent:model.viewPath]];
                                            [weakSelf.dataSourceArray addObject:model];
                                        }
                                    }
                                    weakSelf.holderView.hidden = YES;
                                    [weakSelf.tableView reloadData];
                                };
                                [weakSelf.navigationController pushViewController:folderVC animated:YES];
                            }];
                            
                        }
                        break;
                    case 2:
                        {
                            [weakPopView hideWithAnimated:NO];
//                            [weakPopView hideWithAnimated:<#(BOOL)#> completion:<#^(BOOL finished)completion#>];
                            NSArray *documentTypes = @[@"public.content",
                                                       @"public.text", @"public.source-code ", @"public.image",@"public.mp3", @"public.audiovisual-content", @"com.adobe.pdf", @"com.apple.keynote.key", @"com.microsoft.word.doc", @"com.microsoft.excel.xls", @"com.microsoft.powerpoint.ppt",@"com.pkware.zip-archive",@"public.html"];
                            
                            UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes inMode:UIDocumentPickerModeOpen];
                            documentPicker.delegate = weakSelf;
                            documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
                            [weakSelf presentViewController:documentPicker animated:YES completion:nil];

                        }
                        break;
                    default:
                        break;
                }
                
            }];
            [popupMenuItem.button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            [mutableArray addObject:popupMenuItem];
        }
        _rightPopupMenuView.items = [mutableArray copy];
    }
    return _rightPopupMenuView;
}
// 打开文件
-(void)openFileViewController:(NSString *) file_url  {
    
    NSURL *file_URL = [NSURL fileURLWithPath:file_url];
    
    if (file_URL != nil) {
            UIDocumentInteractionController *fileInteractionController = [[UIDocumentInteractionController alloc] init];
            
            fileInteractionController = [UIDocumentInteractionController interactionControllerWithURL:file_URL];
            fileInteractionController.delegate = self;
        
        
        [fileInteractionController presentPreviewAnimated:YES];
    }
    
}
#pragma mark--选中沙盒外的文件
// ios11之后
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
	
    YSWeak;
    [QMUITips showLoading:@"正在下载" inView:weakSelf.view];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        BOOL fileUrlAuthozied = [url startAccessingSecurityScopedResource];
        if(fileUrlAuthozied){
            NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
            NSError *error;
            [fileCoordinator coordinateReadingItemAtURL:url options:0 error:&error byAccessor:^(NSURL *newURL) {
                [weakSelf dismissViewControllerAnimated:YES completion:NULL];
                //读取文件
                NSError *error = nil;
                NSString *fileName = [newURL lastPathComponent];
                NSData *fileData = [NSData dataWithContentsOfURL:newURL options:NSDataReadingMappedIfSafe error:&error];
                DLog(@"iCloud文件名字:%@",fileName);
                if (error || fileData.length < 1) {
                    //读取出错
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [QMUITips hideAllToastInView:weakSelf.view animated:NO];
                        [QMUITips showError:@"文件不可用" inView:weakSelf.view hideAfterDelay:1];
                    });
                }else{
                    //文件 上传或者其他操作
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                    [dateFormatter setDateFormat:@"yyyy-MM-ddHH-mm-ss"];
                    //当前时间字符串
                    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
                    if ([fileData writeToFile:[AttachmentFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", currentDateStr, fileName]] atomically:YES]) {
                        YSNewsAttachmentModel *model = [YSNewsAttachmentModel new];
                        model.fileName = fileName;
                        model.filePath = [YSUtility getFileSize:fileData.length/1024.0];
                        model.viewPath = [NSString stringWithFormat:@"%@.%@", currentDateStr, fileName];
                        model.createTime = [currentDateStr substringToIndex:10];
                        [weakSelf.addPathArray addObject:[AttachmentFolderPath stringByAppendingPathComponent:model.viewPath]];
                        [weakSelf.dataSourceArray addObject:model];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [QMUITips hideAllToastInView:weakSelf.view animated:NO];
                            [weakSelf.tableView reloadData];
                        });
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [QMUITips hideAllToastInView:weakSelf.view animated:NO];
                            [QMUITips showError:@"文件出错" inView:weakSelf.view hideAfterDelay:1];
                        });
                    }
                    
                }
            }];
            [url stopAccessingSecurityScopedResource];
        }else{
            //Error handling
            dispatch_async(dispatch_get_main_queue(), ^{
                [QMUITips hideAllToastInView:weakSelf.view animated:NO];
                [QMUITips showError:@"文件不可用" inView:weakSelf.view hideAfterDelay:1];
            });
        }
    });
}
/*
// ios8->11
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    NSArray *array = [[[urls lastObject] absoluteString] componentsSeparatedByString:@"/"];
    NSString *fileName = [array lastObject];
    fileName = [fileName stringByRemovingPercentEncoding];
    NSLog(@"iCloud文件名字--->>>>%@",fileName);
    if ([self iCloudEnable]) {
        // 从iCloud中下载
        }
}
*/
- (void)sendFileMessageWithURL:(NSURL *)url displayName:(NSString*)displayName {
}
// iClould是否可用
- (BOOL)iCloudEnable {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *url = [manager URLForUbiquityContainerIdentifier:nil];
    if (url != nil) {
        return YES;
    }
    
    [QMUITips showError:@"iCloud 不可用" inView:self.view hideAfterDelay:1];
    return NO;
}
/*
#pragma mark--上传照片
- (void)postImgDataWith:(YSNewsAttachmentModel*)model {
    [QMUITips showLoadingInView:self.view];
    [YSNetManager ys_uploadImageWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, uploadFileApi] parameters:nil imageArray:@[model.choseImg] file:@"file" successBlock:^(id response) {
        [QMUITips hideAllToastInView:self.view animated:NO];
    } failurBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:NO];
    } upLoadProgress:nil];
}*/
#pragma mark--图片选择
- (void)authorizationPresentAlbumViewControllerWithTitle:(NSString *)title {
    if ([QMUIAssetsManager authorizationStatus] == QMUIAssetAuthorizationStatusNotDetermined) {
        [QMUIAssetsManager requestAuthorization:^(QMUIAssetAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentAlbumViewControllerWithTitle:title];
            });
        }];
    } else {
        [self presentAlbumViewControllerWithTitle:title];
    }
}

- (void)presentAlbumViewControllerWithTitle:(NSString *)title {
    // 创建一个 QMUIAlbumViewController 实例用于呈现相簿列表
    QMUIAlbumViewController *albumViewController = [[QMUIAlbumViewController alloc] init];
    albumViewController.albumViewControllerDelegate = self;
    albumViewController.contentType = kAlbumContentType;
    albumViewController.title = title;
    if ([title isEqualToString:@"选择单张图片"]) {
        albumViewController.view.tag = SingleImagePickingTag;
    } else if ([title isEqualToString:@"选择多张图片"]) {
        albumViewController.view.tag = MultipleImagePickingTag;
    } else if ([title isEqualToString:@"调整界面"]) {
        albumViewController.view.tag = ModifiedImagePickingTag;
        albumViewController.albumTableViewCellHeight = 70;
    } else {
        albumViewController.view.tag = NormalImagePickingTag;
    }
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:albumViewController];
    
    // 获取最近发送图片时使用过的相簿，如果有则直接进入该相簿
    QMUIAssetsGroup *assetsGroup = [QMUIImagePickerHelper assetsGroupOfLastestPickerAlbumWithUserIdentify:nil];
    if (assetsGroup) {
        QMUIImagePickerViewController *imagePickerViewController = [self imagePickerViewControllerForAlbumViewController:albumViewController];
        
        [imagePickerViewController refreshWithAssetsGroup:assetsGroup];
        imagePickerViewController.title = [assetsGroup name];
        [navigationController pushViewController:imagePickerViewController animated:NO];
    }
    [[YSUtility getCurrentViewController] presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - QMUIAlbumViewControllerDelegate

- (QMUIImagePickerViewController *)imagePickerViewControllerForAlbumViewController:(QMUIAlbumViewController *)albumViewController {
    QMUIImagePickerViewController *imagePickerViewController = [[QMUIImagePickerViewController alloc] init];
    imagePickerViewController.imagePickerViewControllerDelegate = self;
    imagePickerViewController.maximumSelectImageCount = MaxSelectedImageCount;
    imagePickerViewController.view.tag = albumViewController.view.tag;
    if (albumViewController.view.tag == SingleImagePickingTag) {
        imagePickerViewController.allowsMultipleSelection = NO;
    }
    if (albumViewController.view.tag == ModifiedImagePickingTag) {
        imagePickerViewController.minimumImageWidth = 65;
    }
    return imagePickerViewController;
}


#pragma mark - QMUIImagePickerViewControllerDelegate

- (void)imagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController didFinishPickingImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    // 储存最近选择了图片的相册，方便下次直接进入该相册
    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerViewController.assetsGroup ablumContentType:kAlbumContentType userIdentify:nil];
    if (imagesAssetArray.count != 0) {
        [QMUITips showLoadingInView:self.view];
    }
    YSWeak;
    for (int i = 0; i < imagesAssetArray.count; i++) {
        QMUIAsset *imageAsset = imagesAssetArray[i];
        YSNewsAttachmentModel *model = [YSNewsAttachmentModel new];
        [imageAsset requestImageData:^(NSData *imageData, NSDictionary<NSString *,id> *info, BOOL isGIF, BOOL isHEIC) {
            if ([YSUtility getSystemVersion] < 13.0) {
                if (![weakSelf.addPathArray containsObject:[[info objectForKey:@"PHImageFileURLKey"] absoluteString]]) {
                                PHAsset *asset = [imageAsset valueForKey:@"_phAsset"];
                                NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
                                formatter.dateFormat = @"yyyy-MM-dd";
                                formatter.timeZone = [NSTimeZone localTimeZone];
                                NSString *pictureTime = [formatter stringFromDate:asset.creationDate];
                                if (isHEIC) {
                                    // iOS 11 中新增 HEIF/HEVC 格式的资源，直接发送新格式的照片到不支持新格式的设备，照片可能会无法识别，可以先转换为通用的 JPEG 格式再进行使用。
                                    // 详细请浏览：https://github.com/QMUI/QMUI_iOS/issues/224
                                    model.choseImg = [UIImage imageWithData:UIImageJPEGRepresentation(imageAsset.originImage, 1)];
                                    NSString *fileNameStr = [[[[info objectForKey:@"PHImageFileURLKey"] absoluteString] componentsSeparatedByString:@"/"] lastObject];
                                    model.fileName = [NSString stringWithFormat:@"%@.JPEG", [[fileNameStr componentsSeparatedByString:@"."] firstObject]];
                                }else {
                                    model.choseImg = imageAsset.originImage;
                                    model.fileName = [[[[info objectForKey:@"PHImageFileURLKey"] absoluteString] componentsSeparatedByString:@"/"] lastObject];
                                }
                //                model.fileName = [[[[info objectForKey:@"PHImageFileURLKey"] absoluteString] componentsSeparatedByString:@"/"] lastObject];
                                model.filePath = [YSUtility getFileSize:imageData.length/1024.0];
                                model.fileType = 4;
                                model.createTime = pictureTime;
                                model.viewPath = [[info objectForKey:@"PHImageFileURLKey"] absoluteString];
                                DLog(@"相片信息:%@--相片名字:%@--所选文件大小:%@--相片创建时间的:%@", info, model.fileName, model.filePath, pictureTime);
                                [weakSelf.addPathArray addObject:model.viewPath];
                                [weakSelf.dataSourceArray addObject:model];
                //                [weakSelf postImgDataWith:model];
                            }
            }else {//ios13以上
                            PHAsset *asset = [imageAsset valueForKey:@"_phAsset"];
                            NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
                            formatter.dateFormat = @"yyyy-MM-dd";
                            formatter.timeZone = [NSTimeZone localTimeZone];
                            NSString *pictureTime = [formatter stringFromDate:asset.creationDate];
                            if (isHEIC) {
                                // iOS 11 中新增 HEIF/HEVC 格式的资源，直接发送新格式的照片到不支持新格式的设备，照片可能会无法识别，可以先转换为通用的 JPEG 格式再进行使用。
                                // 详细请浏览：https://github.com/QMUI/QMUI_iOS/issues/224
                                model.choseImg = [UIImage imageWithData:UIImageJPEGRepresentation(imageAsset.originImage, 1)];
                                NSString *fileNameStr = [[[[info objectForKey:@"PHImageFileURLKey"] absoluteString] componentsSeparatedByString:@"/"] lastObject];
                                if ([YSUtility judgeIsEmpty:fileNameStr]) {
                                    // 因QMUI ios13无法获取PHImageFileURLKey 有时间更新QMUI
                                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                    formatter.dateFormat = @"yyyyMMddHHmmss";
                                    NSString *str = [formatter stringFromDate:[NSDate date]];
                                    fileNameStr = [NSString stringWithFormat:@"%@.jpg",str];
                                }
                                model.fileName = [NSString stringWithFormat:@"%@.JPEG", [[fileNameStr componentsSeparatedByString:@"."] firstObject]];
                            }else {
                                model.choseImg = imageAsset.originImage;
                                model.fileName = [[[[info objectForKey:@"PHImageFileURLKey"] absoluteString] componentsSeparatedByString:@"/"] lastObject];
                                if ([YSUtility judgeIsEmpty:model.fileName]) {
                                    // 因QMUI ios13无法获取PHImageFileURLKey 有时间更新QMUI
                                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                    formatter.dateFormat = @"yyyyMMddHHmmss";
                                    NSString *str = [formatter stringFromDate:[NSDate date]];
                                    model.fileName = [NSString stringWithFormat:@"%@.jpg",str];
                                }
                            }
            //                model.fileName = [[[[info objectForKey:@"PHImageFileURLKey"] absoluteString] componentsSeparatedByString:@"/"] lastObject];
                            model.filePath = [YSUtility getFileSize:imageData.length/1024.0];
                            model.fileType = 4;
                            model.createTime = pictureTime;
                            model.viewPath = [[info objectForKey:@"PHImageFileURLKey"] absoluteString];
                            DLog(@"相片信息:%@--相片名字:%@--所选文件大小:%@--相片创建时间的:%@", info, model.fileName, model.filePath, pictureTime);
                            [weakSelf.addPathArray addObject:model.viewPath];
                            [weakSelf.dataSourceArray addObject:model];
            //                [weakSelf postImgDataWith:model];
                        }
            
            if (i == imagesAssetArray.count-1) {
                [QMUITips hideAllToastInView:weakSelf.view animated:YES];
                [weakSelf.tableView reloadData];
            }
        }];
    }
}

- (QMUIImagePickerPreviewViewController *)imagePickerPreviewViewControllerForImagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController {
    if (imagePickerViewController.view.tag == MultipleImagePickingTag) {
        YSMultipleImagePickerPreviewViewController *imagePickerPreviewViewController = [[YSMultipleImagePickerPreviewViewController alloc] init];
        imagePickerPreviewViewController.delegate = self;
        imagePickerPreviewViewController.maximumSelectImageCount = MaxSelectedImageCount;
        imagePickerPreviewViewController.assetsGroup = imagePickerViewController.assetsGroup;
        imagePickerPreviewViewController.view.tag = imagePickerViewController.view.tag;
        return imagePickerPreviewViewController;
    } else if (imagePickerViewController.view.tag == SingleImagePickingTag) {
        YSSingleImagePickerPreviewViewController *imagePickerPreviewViewController = [[YSSingleImagePickerPreviewViewController alloc] init];
        imagePickerPreviewViewController.delegate = self;
        imagePickerPreviewViewController.assetsGroup = imagePickerViewController.assetsGroup;
        imagePickerPreviewViewController.view.tag = imagePickerViewController.view.tag;
        return imagePickerPreviewViewController;
    } else if (imagePickerViewController.view.tag == ModifiedImagePickingTag) {
        QMUIImagePickerPreviewViewController *imagePickerPreviewViewController = [[QMUIImagePickerPreviewViewController alloc] init];
        imagePickerPreviewViewController.delegate = self;
        imagePickerPreviewViewController.view.tag = imagePickerViewController.view.tag;
        imagePickerPreviewViewController.toolBarBackgroundColor = UIColorMake(66, 66, 66);
        return imagePickerPreviewViewController;
    } else {
        QMUIImagePickerPreviewViewController *imagePickerPreviewViewController = [[QMUIImagePickerPreviewViewController alloc] init];
        imagePickerPreviewViewController.delegate = self;
        imagePickerPreviewViewController.view.tag = imagePickerViewController.view.tag;
        return imagePickerPreviewViewController;
    }
}

#pragma mark - QMUIImagePickerPreviewViewControllerDelegate

- (void)imagePickerPreviewViewController:(QMUIImagePickerPreviewViewController *)imagePickerPreviewViewController didCheckImageAtIndex:(NSInteger)index {
    
}

#pragma mark - YSSingleImagePickerPreviewViewControllerDelegate

- (void)imagePickerPreviewViewController:(YSSingleImagePickerPreviewViewController *)imagePickerPreviewViewController didSelectImageWithImagesAsset:(QMUIAsset *)imageAsset {
    // 储存最近选择了图片的相册，方便下次直接进入该相册
    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerPreviewViewController.assetsGroup ablumContentType:kAlbumContentType userIdentify:nil];
    // 获得图片数组
//    [self.sendImageDataSubject sendNext:@[imageAsset.originImage]];
}

#pragma mark - YSMultipleImagePickerPreviewViewControllerDelegate

- (void)imagePickerPreviewViewController:(YSMultipleImagePickerPreviewViewController *)imagePickerPreviewViewController sendImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    // 储存最近选择了图片的相册，方便下次直接进入该相册
    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerPreviewViewController.assetsGroup ablumContentType:kAlbumContentType userIdentify:nil];
    // 获得图片数组
    if (imagesAssetArray.count != 0) {
        [QMUITips showLoadingInView:self.view];
    }
    YSWeak;
    for (int i = 0; i < imagesAssetArray.count; i++) {
        QMUIAsset *imageAsset = imagesAssetArray[i];
        YSNewsAttachmentModel *model = [YSNewsAttachmentModel new];
        [imageAsset requestImageData:^(NSData *imageData, NSDictionary<NSString *,id> *info, BOOL isGIF, BOOL isHEIC) {
            if ([YSUtility getSystemVersion] < 13.0) {
                if (![weakSelf.addPathArray containsObject:[[info objectForKey:@"PHImageFileURLKey"] absoluteString]]) {
                                PHAsset *asset = [imageAsset valueForKey:@"_phAsset"];
                                NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
                                formatter.dateFormat = @"yyyy-MM-dd";
                                formatter.timeZone = [NSTimeZone localTimeZone];
                                NSString *pictureTime = [formatter stringFromDate:asset.creationDate];
                                if (isHEIC) {
                                    // iOS 11 中新增 HEIF/HEVC 格式的资源，直接发送新格式的照片到不支持新格式的设备，照片可能会无法识别，可以先转换为通用的 JPEG 格式再进行使用。
                                    // 详细请浏览：https://github.com/QMUI/QMUI_iOS/issues/224
                                    model.choseImg = [UIImage imageWithData:UIImageJPEGRepresentation(imageAsset.originImage, 1)];
                                    NSString *fileNameStr = [[[[info objectForKey:@"PHImageFileURLKey"] absoluteString] componentsSeparatedByString:@"/"] lastObject];
                                    model.fileName = [NSString stringWithFormat:@"%@.JPEG", [[fileNameStr componentsSeparatedByString:@"."] firstObject]];
                                }else {
                                    model.choseImg = imageAsset.originImage;
                                    model.fileName = [[[[info objectForKey:@"PHImageFileURLKey"] absoluteString] componentsSeparatedByString:@"/"] lastObject];
                                }
                //                model.fileName = [[[[info objectForKey:@"PHImageFileURLKey"] absoluteString] componentsSeparatedByString:@"/"] lastObject];
                                model.filePath = [YSUtility getFileSize:imageData.length/1024.0];
                                model.fileType = 4;
                                model.createTime = pictureTime;
                                model.viewPath = [[info objectForKey:@"PHImageFileURLKey"] absoluteString];
                                DLog(@"相片信息:%@--相片名字:%@--所选文件大小:%@--相片创建时间的:%@", info, model.fileName, model.filePath, pictureTime);
                                [weakSelf.addPathArray addObject:model.viewPath];
                                [weakSelf.dataSourceArray addObject:model];
                //                [weakSelf postImgDataWith:model];
                            }
            }else {//ios13以上
                            PHAsset *asset = [imageAsset valueForKey:@"_phAsset"];
                            NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
                            formatter.dateFormat = @"yyyy-MM-dd";
                            formatter.timeZone = [NSTimeZone localTimeZone];
                            NSString *pictureTime = [formatter stringFromDate:asset.creationDate];
                            if (isHEIC) {
                                // iOS 11 中新增 HEIF/HEVC 格式的资源，直接发送新格式的照片到不支持新格式的设备，照片可能会无法识别，可以先转换为通用的 JPEG 格式再进行使用。
                                // 详细请浏览：https://github.com/QMUI/QMUI_iOS/issues/224
                                model.choseImg = [UIImage imageWithData:UIImageJPEGRepresentation(imageAsset.originImage, 1)];
                                NSString *fileNameStr = [[[[info objectForKey:@"PHImageFileURLKey"] absoluteString] componentsSeparatedByString:@"/"] lastObject];
                                if ([YSUtility judgeIsEmpty:fileNameStr]) {
                                    // 因QMUI ios13无法获取PHImageFileURLKey 有时间更新QMUI
                                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                    formatter.dateFormat = @"yyyyMMddHHmmss";
                                    NSString *str = [formatter stringFromDate:[NSDate date]];
                                    fileNameStr = [NSString stringWithFormat:@"%@.jpg",str];
                                }
                                model.fileName = [NSString stringWithFormat:@"%@.JPEG", [[fileNameStr componentsSeparatedByString:@"."] firstObject]];
                            }else {
                                model.choseImg = imageAsset.originImage;
                                model.fileName = [[[[info objectForKey:@"PHImageFileURLKey"] absoluteString] componentsSeparatedByString:@"/"] lastObject];
                                if ([YSUtility judgeIsEmpty:model.fileName]) {
                                    // 因QMUI ios13无法获取PHImageFileURLKey 有时间更新QMUI
                                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                    formatter.dateFormat = @"yyyyMMddHHmmss";
                                    NSString *str = [formatter stringFromDate:[NSDate date]];
                                    model.fileName = [NSString stringWithFormat:@"%@.jpg",str];
                                }
                            }
            //                model.fileName = [[[[info objectForKey:@"PHImageFileURLKey"] absoluteString] componentsSeparatedByString:@"/"] lastObject];
                            model.filePath = [YSUtility getFileSize:imageData.length/1024.0];
                            model.fileType = 4;
                            model.createTime = pictureTime;
                            model.viewPath = [[info objectForKey:@"PHImageFileURLKey"] absoluteString];
                            DLog(@"相片信息:%@--相片名字:%@--所选文件大小:%@--相片创建时间的:%@", info, model.fileName, model.filePath, pictureTime);
                            [weakSelf.addPathArray addObject:model.viewPath];
                            [weakSelf.dataSourceArray addObject:model];
            //                [weakSelf postImgDataWith:model];
                        }
            
            if (i == imagesAssetArray.count-1) {
                [QMUITips hideAllToastInView:weakSelf.view animated:YES];
                [weakSelf.tableView reloadData];
            }
        }];
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
