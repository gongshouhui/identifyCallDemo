//
//  YSMineMyFolderViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/5/10.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSMineMyFolderViewController.h"
#import "YSMineFloderTableViewCell.h"
#import "YSMineFolderBottomView.h"
#import "YSNewsAttachmentViewController.h"
#import "YSNewsAttachmentModel.h"
#import "YSMyFolderDetailViewController.h"


@interface YSMineMyFolderViewController ()<SWTableViewCellDelegate, UIDocumentInteractionControllerDelegate>
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) NSMutableArray *dataChoseArray;
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
@property (nonatomic, strong) QMUIAlertController *alertController;

@end

@implementation YSMineMyFolderViewController
- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"我的文件";
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [QMUITips showLoadingInView:self.view];
    [self checkMyFolder];
    DLog(@"文件:%@", self.dataSourceArray);
    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:self.isAdd ? @"取消" : @"多选" tintColor:[UIColor colorWithHexString:@"#54576A"] position:QMUINavigationButtonPositionRight target:self action:@selector(choseOrCancelBtnAction:)];
    if (self.isAdd) {
        [self choseOrCancelBtnAction:[QMUINavigationButton new]];
    }
}

- (void)layoutTableView {
    if (self.isEdit) {
        self.tableView.frame = CGRectMake(0, kTopHeight, kSCREEN_WIDTH, kSCREEN_HEIGHT-kTopHeight-kBottomHeight-70*kHeightScale);

    }else {
        self.tableView.frame = CGRectMake(0, kTopHeight, kSCREEN_WIDTH, kSCREEN_HEIGHT-kTopHeight-kBottomHeight);
    }
}

- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSMineFloderTableViewCell class] forCellReuseIdentifier:@"folderCellID"];
    if (@available(iOS 11, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)checkMyFolder {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    DLog(@"文件路径:%@", AttachmentFolderPath);
    NSArray *tempFileList = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:AttachmentFolderPath error:nil]];
    if ([tempFileList count] != 0) {
        for (NSString *fileName in tempFileList) {
            NSArray *nameArray = [fileName componentsSeparatedByString:@"."];
            
            YSNewsAttachmentModel *model = [YSNewsAttachmentModel new];
            model.fileName = [NSString stringWithFormat:@"%@.%@", nameArray[nameArray.count-2], [nameArray lastObject]];
            if ([[nameArray firstObject] length] >= 10) {
                model.createTime = [NSString stringWithFormat:@"%@", [[nameArray firstObject] substringToIndex:10]];
            } else {
                model.createTime = @"   ";
            }
            model.filePath = [self sizeOfFile:[self fileSizeAtPath:[AttachmentFolderPath stringByAppendingPathComponent:fileName]]];//文件大小
            model.fileType = [self fileTypeOfName:[nameArray lastObject]];
            model.viewPath = fileName;//文件在文件夹中的名字 删除/详情查看用
            if (model.fileType == 4) {
                NSData *imageData = [NSData dataWithContentsOfFile:[AttachmentFolderPath stringByAppendingPathComponent:fileName]];
                model.choseImg = [UIImage imageWithData:imageData];
            }
            [self.dataSourceArray addObject:model];
        }
    }
    [QMUITips hideAllToastInView:self.view animated:YES];
}
// 文件大小
- (long long)fileSizeAtPath:(NSString*)filePath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
    
}
- (NSString *)sizeOfFile:(long long )folderSize{
    
    if (folderSize < 1000.0) {
        return  [NSString stringWithFormat:@"%.2fB",folderSize * 1.0];
    }else if (folderSize >= 1000.0 && folderSize < (1000.0*1000.0)){
        return  [NSString stringWithFormat:@"%.2fKB",folderSize/1000.0];
    }if (folderSize >= (1000.0*1000.0) && folderSize < (1000.0*1000.0*1000.0)) {
        return [NSString stringWithFormat:@"%.2fMB", folderSize/(1000.0*1000.0)];
    }else{
        return [NSString stringWithFormat:@"%.2fGB", folderSize/(1000.0*1000.0*1000.0)];
    }
}

// 文件类型
- (NSInteger)fileTypeOfName:(NSString*)name {
    if ([name isEqualToString:@"word"]) {
        return 0;
    }else if ([name isEqualToString:@"ppt"]) {
        return 1;
    }else if ([name isEqualToString:@"excel"]) {
        return 2;
    }else if ([name isEqualToString:@"txt"]) {
        return 3;
    }else if ([name isEqualToString:@"jpeg"] || [name isEqualToString:@"png"] || [name isEqualToString:@"jpg"]) {
        return 4;
    }else if ([name isEqualToString:@"mp3"] || [name isEqualToString:@"wav"] || [name isEqualToString:@"wma"] || [name isEqualToString:@"3gp"] || [name isEqualToString:@"mp4"] || [name isEqualToString:@"avi"]) {
        return 5;
    }else if ([name isEqualToString:@"pdf"]) {
        return 6;
    }else if ([name isEqualToString:@"zip"]) {
        return 7;
    }else {
        return 100;
    }

}
- (void)choseOrCancelBtnAction:(QMUINavigationButton*)sender {
    YSWeak;
    sender = nil;
    [[self.view viewWithTag:442] removeFromSuperview];
    if (!self.isEdit) {
        self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"取消" tintColor:[UIColor colorWithHexString:@"#54576A"] position:QMUINavigationButtonPositionRight target:self action:@selector(choseOrCancelBtnAction:)];
        self.isEdit = YES;
        YSMineFolderBottomView *bottomView = [[YSMineFolderBottomView alloc] init];
        if (self.isAdd) {
            [bottomView.deleteBtn setTitle:@"确定(0)" forState:(UIControlStateNormal)];
            bottomView.deleteBtn.backgroundColor = [UIColor colorWithHexString:@"#B9D3F6"];
        }
        bottomView.tag = 442;
        __weak __typeof(YSMineFolderBottomView *) weakView = bottomView;
        bottomView.clickdeChoseBtnBlock = ^(BOOL isChose) {
            if (isChose) {
                // 点击全选按钮
                if (weakSelf.isAdd) {//YSReportFolderAddViewController跳转进来
                    [weakView.deleteBtn setTitle:[NSString stringWithFormat:@"确定(%ld)", weakSelf.dataSourceArray.count] forState:(UIControlStateNormal)];
                    weakView.deleteBtn.backgroundColor = [UIColor colorWithHexString:@"#2F86F6"];
                }else {
                    [weakView.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%ld)", weakSelf.dataSourceArray.count] forState:(UIControlStateNormal)];
                }
                weakSelf.dataChoseArray = [NSMutableArray arrayWithArray:weakSelf.dataSourceArray];
            }else {
                // 全不选
                if (weakSelf.isAdd) {//YSReportFolderAddViewController跳转进来
                    [weakView.deleteBtn setTitle:@"确定(0)" forState:(UIControlStateNormal)];
                    weakView.deleteBtn.backgroundColor = [UIColor colorWithHexString:@"#B9D3F6"];
                }else {
                    [weakView.deleteBtn setTitle:@"删除(0)" forState:(UIControlStateNormal)];

                }
                [weakSelf.dataChoseArray removeAllObjects];
            }
            [weakSelf.tableView reloadData];
        };
        @weakify(self);
        [[bottomView.deleteBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
            @strongify(self);
            if (weakSelf.isAdd) {
                //点击确定按钮
                if (weakSelf.addMyFolderBlock) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    weakSelf.addMyFolderBlock([weakSelf.dataChoseArray copy]);
                }
            }else {//点击 删除按按
                for (YSNewsAttachmentModel *model in weakSelf.dataChoseArray) {
                    NSError *err;
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    NSString *filePath = [AttachmentFolderPath stringByAppendingPathComponent:model.viewPath];
                    if ([fileManager fileExistsAtPath:filePath]) {
                        if ([fileManager removeItemAtPath:filePath error:&err]) {
                            [weakSelf.dataSourceArray removeObject:model];
                        }
                    }
                }
                if (weakSelf.dataSourceArray.count == 0) {
                    [weakView removeFromSuperview];
                }
                [weakSelf.dataChoseArray removeAllObjects];
                [weakSelf.tableView reloadData];
            }
        }];
        [self.view addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-kBottomHeight);
            make.left.right.mas_equalTo(self.view);
            make.height.mas_equalTo(70*kHeightScale);
        }];
    }else {
        self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"多选" tintColor:[UIColor colorWithHexString:@"#54576A"] position:QMUINavigationButtonPositionRight target:self action:@selector(choseOrCancelBtnAction:)];
        self.isEdit = NO;
    }
    [self layoutTableView];
    [self.tableView reloadData];
}

#pragma mark--tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72*kHeightScale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSMineFloderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"folderCellID" forIndexPath:indexPath];
    cell.delegate = self;
    YSNewsAttachmentModel *model = self.dataSourceArray[indexPath.row];
    if (self.isEdit) {
        if ([self.dataChoseArray containsObject:model]) {
            // 选中状态
            [cell.choseBtn setImage:[UIImage imageNamed:@"selected+normal"] forState:(UIControlStateNormal)];
        }else {
            //未选择
            [cell.choseBtn setImage:[UIImage imageNamed:@"unselected+normal"] forState:(UIControlStateNormal)];
        }
        //多选状态
        cell.choseBtn.hidden = NO;
        [cell.holderImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(51*kWidthScale);
        }];
    }else {
        cell.choseBtn.hidden = YES;
        [cell.choseBtn setImage:[UIImage imageNamed:@"unselected+normal"] forState:(UIControlStateNormal)];
        [cell.holderImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15*kWidthScale);
        }];
    }
    @weakify(self);
    [[[cell.choseBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        if (self.isAdd) {
            if ([model.filePath containsString:@"GB"]) {
                [QMUITips showInfo:@"文件过大,无法上传" inView:self.view hideAfterDelay:1];
                return;
            }
            if ([model.filePath containsString:@"MB"] &&[[[model.filePath componentsSeparatedByString:@"MB"] firstObject] floatValue] > KfileSize) {
                [QMUITips showInfo:@"文件过大,无法上传" inView:self.view hideAfterDelay:1];
                return;
            }
        }
        if ([self.dataChoseArray containsObject:model]) {
          //未选中-->选中
            [sender setImage:[UIImage imageNamed:@"unselected+normal"] forState:(UIControlStateNormal)];
            [self.dataChoseArray removeObject:model];
        }else {
            //选中-->未选中
            [sender setImage:[UIImage imageNamed:@"selected+normal"] forState:(UIControlStateNormal)];
            [self.dataChoseArray addObject:model];
        }
        YSMineFolderBottomView *bottomView = [self.view viewWithTag:442];
        __weak typeof(YSMineFolderBottomView *) weakView = bottomView;
        weakView.deleteBtn.enabled = YES;
        if (self.isAdd) {
            [weakView.deleteBtn setTitle:[NSString stringWithFormat:@"确定(%ld)", self.dataChoseArray.count] forState:(UIControlStateNormal)];
            weakView.deleteBtn.backgroundColor = [UIColor colorWithHexString:@"#2F86F6"];
        }else {
            [weakView.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%ld)", self.dataChoseArray.count] forState:(UIControlStateNormal)];
            weakView.deleteBtn.backgroundColor = [UIColor colorWithHexString:@"#F73035"];
        }
        if (self.dataChoseArray.count == self.dataSourceArray.count) {
            //全选
            [weakView.choseBtn setImage:[UIImage imageNamed:@"selected+normal"] forState:(UIControlStateNormal)];
        }else if (self.dataChoseArray.count != 0) {
            // 选中一部分
            [weakView.choseBtn setImage:[UIImage imageNamed:@"unselected+normal"] forState:(UIControlStateNormal)];
        }else {
            // 全不选
            [weakView.choseBtn setImage:[UIImage imageNamed:@"unselected+normal"] forState:(UIControlStateNormal)];
            if (self.isAdd) {
                weakView.deleteBtn.backgroundColor = [UIColor colorWithHexString:@"#B9D3F6"];
                [weakView.deleteBtn setTitle:@"确定(0)" forState:(UIControlStateNormal)];
            }else {
                weakView.deleteBtn.backgroundColor = [UIColor colorWithHexString:@"#F73035" alpha:0.3];
                [weakView.deleteBtn setTitle:@"删除(0)" forState:(UIControlStateNormal)];
            }
            weakView.deleteBtn.enabled = NO;
        }
    }];
    if (!self.isAdd) {
        cell.rightUtilityButtons = [self rightArrayBtn];
    }
    cell.folderModel = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSNewsAttachmentModel *model = self.dataSourceArray[indexPath.row];
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
#pragma mark--SWTableViewCellDelegate
- (NSArray *)rightArrayBtn {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithHexString:@"#F73035"] title:@"删除"];
    
    return rightUtilityButtons;
}
// 左边工具按钮点击时相应的方法 下标是用户点击的按钮的下标，左右按钮的是分开的，他们的按钮的顺序是从右到左，下标值从0到n.
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
}

// 右边工具按钮被点击的时候
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            {//删除按钮
                NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                YSNewsAttachmentModel *model = self.dataSourceArray[indexPath.row];
                NSError *err;
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSString *filePath = [AttachmentFolderPath stringByAppendingPathComponent:model.viewPath];
                if ([fileManager fileExistsAtPath:filePath]) {
                    if ([fileManager removeItemAtPath:filePath error:&err]) {
                        [self.dataSourceArray removeObject:model];
                        [self.tableView reloadData];
                    } else {
                        [QMUITips showInfo:@"删除失败" inView:self.view hideAfterDelay:1];
                    }
                } else {
                    [QMUITips showInfo:@"删除失败" inView:self.view hideAfterDelay:1];
                }
            }
            break;
            
        default:
            break;
    }
}

// 工具按钮点击或者代开的时候相应方法
- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state {
    
}

#pragma mark--setter&&getter
- (NSMutableArray *)dataChoseArray {
    if (!_dataChoseArray) {
        _dataChoseArray = [NSMutableArray new];
    }
    return _dataChoseArray;
}

/*
// prevent multiple cells from showing utilty buttons simultaneously
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell;

// prevent cell(s) from displaying left/right utility buttons
 - (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state;
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
