//
//  YSMineViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/8.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSMineViewController.h"
#import "YSApplicationModel.h"
#import "YSPersonalInformViewController.h"    // 个人信息
#import "YSChangePasswordViewController.h"    // 修改密码
#import "YSThemeViewController.h"    // 换肤
#import "YSSettingViewController.h"    // 设置
#import "YSAboutViewController.h"    // 关于
#import "YSPersonalInformationModel.h"

#import "AppDelegate.h"
#import "AppDelegate+YSSetupAPP.h"
#import <WXApi.h>
#import "YSFlowTenderViewController.h"
#import "YSDepartmentModel.h"
#import "YSHRInfoHepSelfHeader.h"
#import "YSHRInfoSelfHelpModel.h"
#import "YSHRInfoSelfHelpCell.h"
#import "YSMineMyFolderViewController.h"//我的文件


@interface YSMineViewController ()<QMUIMoreOperationControllerDelegate, QMUINavigationControllerDelegate, QMUIImagePreviewViewDelegate,YSHRInfoHepSelfHeaderDelegate>

@property (nonatomic, strong) YSHRInfoHepSelfHeader *mineTopView;
@property (nonatomic,strong) YSHRInfoSelfHelpModel *selfHelpModel;
@property (nonatomic, strong) QMUIImagePreviewViewController *imagePreviewViewController;
@property (nonatomic, strong) YSPersonalInformationModel *personalInformationModel;
@property (nonatomic, strong) QMUIMoreOperationController *moreOperationController;
@property (nonatomic,strong)RLMNotificationToken *token;
@end

@implementation YSMineViewController
- (YSHRInfoHepSelfHeader *)mineTopView
{
    if (!_mineTopView) {
        _mineTopView = [[YSHRInfoHepSelfHeader alloc]init];
        _mineTopView.backgroundColor = [UIColor whiteColor];
        _mineTopView.delegate = self;
    }
    return _mineTopView;
}
- (void)initTableView {
    [super initTableView];
    self.tableView.backgroundColor = kGrayColor(238);
    self.tableView.scrollEnabled = NO;
    self.tableView.mj_header.hidden = YES;
    self.tableView.mj_footer.hidden = YES;
    self.mineTopView.frame = CGRectMake(0, 0, 0, 235*kHeightScale);
    self.tableView.tableHeaderView = self.mineTopView;
    self.tableView.sectionFooterHeight = 0.0;
    self.tableView.sectionHeaderHeight = 0.0;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 16*kWidthScale, 0, 0);
    [self setUpData];//静态表格
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertUpdate) name:@"update" object:nil];
    [self doNetworking];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置导航栏渐变色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage gradientImageWithBounds:CGRectMake(0, 0, kSCREEN_WIDTH, kTopHeight) andColors:@[[UIColor colorWithHexString:@"#546AFD"],[UIColor colorWithHexString:@"#2EC1FF"]] andGradientType:1]  forBarMetrics:UIBarMetricsDefault];
    [self judgeExcellentEmploye];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate updateAPPWithAlert:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [QMUITips hideAllTipsInView:self.view];
    [self.token invalidate];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    if ([self.selfHelpModel.cover.isExcellentEmployee integerValue] == 1) {
        return UIStatusBarStyleDefault;
    }
    return UIStatusBarStyleLightContent;
}
- (void)setUpData {
    
    NSMutableArray *sectionArr1 = [NSMutableArray arrayWithCapacity:10];
    [sectionArr1 addObject:@{@"id":@(0),@"imageName":@"mine_info",@"name":@"个人信息",@"className":@"YSHRInfoSelfHelpController"}];
    [sectionArr1 addObject:@{@"id":@(1),@"imageName":@"mine_setting",@"name":@"设置",@"className":@"YSSettingViewController"}];
    [sectionArr1 addObject:@{@"id":@(2),@"imageName":@"mine_share",@"name":@"分享",@"className":@"YSHRFamilyInfoController"}];
    [sectionArr1 addObject:@{@"id":@(3),@"imageName":@"mine_contact",@"name":@"通讯录更新",@"className":@"YSHREduExperienceController"}];
    [sectionArr1 addObject:@{@"id":@(4),@"imageName":@"YS_mine_down",@"name":@"无新版",@"className":@"YSHREduExperienceController"}];
    [sectionArr1 addObject:@{@"id":@(5),@"imageName":@"YS_mine_folderImg",@"name":@"我的文件",@"className":@"YSMineMyFolderViewController"}];
    [sectionArr1 addObject:@{@"id":@(6),@"imageName":@"",@"name":@"退出登录",@"className":@"YSHREduExperienceController"}];
    self.dataSourceArray  = [[NSArray yy_modelArrayWithClass:[YSApplicationModel class] json:sectionArr1] copy];
    
    [self ys_reloadData];
}
- (void)doNetworking {
    [QMUITips showLoading:@"加载中..." inView:self.view];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,selfHelpDetails] isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"信息自助%@",response);
        [QMUITips hideAllToastInView:self.view animated:YES];
        if ([response[@"code"] integerValue] == 1) {
            self.selfHelpModel = [YSHRInfoSelfHelpModel yy_modelWithJSON:response[@"data"]];
            self.mineTopView.infoModel = self.selfHelpModel.cover;
            [self judgeExcellentEmploye];
        }else{
            [QMUITips showError:response[@"msg"] inView:self.view hideAfterDelay:0.7];
        }
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:YES];
    } progress:nil];
    
}

- (void)judgeExcellentEmploye {
    //根据是否是优秀员工 更改导航栏
    if ([self.selfHelpModel.cover.isExcellentEmployee integerValue] == 1) {
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage gradientImageWithBounds:CGRectMake(0, 0, kSCREEN_WIDTH, kTopHeight) andColors:@[[UIColor colorWithHexString:@"#F5EADD"],[UIColor colorWithHexString:@"#FFFFFF"]] andGradientType:1]  forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FF000000"]}];
        
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.dataSourceArray.count - 1) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = [self.dataSourceArray[indexPath.row] name] ;
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#191F25"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor redColor];
        return cell;
    }else{
        YSHRInfoSelfHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSInfoSelfHelpCell"];
        if (cell == nil) {
            cell = [[YSHRInfoSelfHelpCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSInfoSelfHelpCell"];
        }
        YSApplicationModel *model = self.dataSourceArray[indexPath.row];
        cell.model = model;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YSApplicationModel *model = self.dataSourceArray[indexPath.row];
    NSInteger index = [model.id integerValue];
    switch (index) {
        case 2:
        {
            [self.moreOperationController showFromBottom];
            
        }
            break;
        case 3:
        {
            RLMResults *results = [YSDepartmentModel allObjects];
            //数据库开始写入时回调一次，写入完成时回调一次,改动时也会调用一次
            YSWeak;
            self.token = [results addNotificationBlock:^(RLMResults<YSDepartmentModel *> *results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
                YSStrong;
                if (!change || error || ![results count]) {
                    return ;
                }
                [QMUITips hideAllTipsInView:strongSelf.view];
                [QMUITips showSucceed:@"更新成功" inView:strongSelf.view hideAfterDelay:1.5];
                [weakSelf.token invalidate];
                
            }];
            [QMUITips showLoadingInView:self.view];
            //更新通讯录 删除以前的
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate saveContactWithAll:YES];
        }
            break;
        case 4:
        {
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate updateAPPWithAlert:YES];
            break;
        }
        case 6:
        {
            [self logout];
            break;
        }
        default:
        {
            Class someClass = NSClassFromString(model.className);
            UIViewController *viewController = [[someClass alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
    }
}

#pragma mark - QMUIMoreOperationDelegate

- (void)moreOperationController:(QMUIMoreOperationController *)moreOperationController didSelectItemView:(QMUIMoreOperationItemView *)itemView {
    [self itemAction:itemView.tag];
}

- (void)itemAction:(int)index {
    if ([WXApi isWXAppInstalled]) {
        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
        sendReq.bText = NO;
        //0 = 好友列表 1 = 朋友圈 2 = 收藏
        sendReq.scene = index;
        
        WXMediaMessage *mediaMessage = [WXMediaMessage message];
        mediaMessage.title = @"亚厦门户";
        mediaMessage.description = @"移动办公好帮手";
        [mediaMessage setThumbImage:[UIImage imageNamed:@"亚厦门户logo"]];
        
        WXWebpageObject *webpageObject = [WXWebpageObject object];
        webpageObject.webpageUrl = YSDownloadDomain;
        
        mediaMessage.mediaObject = webpageObject;
        sendReq.message = mediaMessage;
        
        [WXApi sendReq:sendReq];
    } else {
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction *action) {
        }];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"去下载" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
            NSURL *wechatUrl = [NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id414478124?mt=8"];
            [[UIApplication sharedApplication] openURL:wechatUrl];
        }];
        
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"提示" message:@"您的手机未安装微信，无法分享" preferredStyle:QMUIAlertControllerStyleAlert];
        [alertController addAction:action1];
        [alertController addAction:action2];
        [alertController showWithAnimated:YES];
    }
    [_moreOperationController hideToBottom];
}

#pragma mark - logout

- (void)logout {
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction *action) {
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [YSUtility logout];
        [delegate setLoginControllerWithAlert:NO];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"提示" message:@"是否退出登录" preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
}

- (void)alertUpdate {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    YSHRInfoSelfHelpCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.nameLb.text = @"发现新版本，点击更新";
    cell.nameLb.textColor = UIColorRed;
}

#pragma mark - 头像预览
- (void)hrInfoHepSelfHeaderImageViewDidClick:(YSHRInfoHepSelfHeader *)mineTopView {
    if (!self.imagePreviewViewController) {
        self.imagePreviewViewController = [[QMUIImagePreviewViewController alloc] init];
        self.imagePreviewViewController.imagePreviewView.delegate = self;
        self.imagePreviewViewController.imagePreviewView.currentImageIndex = 0;
    }
    [self.imagePreviewViewController startPreviewFromRectInScreen:CGRectMake(kSCREEN_WIDTH/2.0-37*kWidthScale, 80*kHeightScale+kTopHeight, 74*kWidthScale, 74*kWidthScale) cornerRadius:mineTopView.headImageView.layer.cornerRadius];
}

#pragma mark - QMUIImagePreviewViewDelegate

- (NSUInteger)numberOfImagesInImagePreviewView:(QMUIImagePreviewView *)imagePreviewView {
    return 1;
}

- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView renderZoomImageView:(QMUIZoomImageView *)zoomImageView atIndex:(NSUInteger)index {
    zoomImageView.image = self.mineTopView.headImageView.image;
}

- (QMUIImagePreviewMediaType)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView assetTypeAtIndex:(NSUInteger)index {
    return QMUIImagePreviewMediaTypeImage;
}

#pragma mark - QMUIZoomImageViewDelegate

- (void)singleTouchInZoomingImageView:(QMUIZoomImageView *)zoomImageView location:(CGPoint)location {
    self.mineTopView.headImageView.image = zoomImageView.image;
    [self.imagePreviewViewController endPreviewToRectInScreen:CGRectMake(kSCREEN_WIDTH/2.0-37*kWidthScale,22*kHeightScale+kTopHeight,73*kWidthScale, 73*kWidthScale)];
}

#pragma mark - 懒加载
- (QMUIMoreOperationController *)moreOperationController {
    if (!_moreOperationController) {
        _moreOperationController = [[QMUIMoreOperationController alloc] init];
        _moreOperationController.cancelButtonTitleColor = kThemeColor;
        _moreOperationController.delegate = self;
        _moreOperationController.items = @[@[[QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"微信")        title:@"微信好友" tag:0 handler:nil],
                                             [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"Action_Moments") title:@"朋友圈" tag:1 handler:nil]]];
    }
    return _moreOperationController;
}
@end

