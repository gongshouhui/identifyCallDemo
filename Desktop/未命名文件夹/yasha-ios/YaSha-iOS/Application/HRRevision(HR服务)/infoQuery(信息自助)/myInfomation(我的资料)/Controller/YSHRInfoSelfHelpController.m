//
//  YSInfoSelfHelpController.m
//  YaSha-iOS
//
//  Created by 蘑菇加 on 2017/12/8.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRInfoSelfHelpController.h"
#import "YSHRInfoHepSelfHeader.h"
#import "YSHRInfoSelfHelpCell.h"
#import "YSApplicationModel.h"
#import "YSPersonalInformationModel.h"
#import "YSHRInfoSelfHelpModel.h"
#import "YSHRPersonalInfoViewController.h"//个人信息
#import "YSHREduExperienceController.h"//教育经历
#import "YSHRVoiceInfoController.h"//语音信息
#import "YSHRFamilyInfoController.h"//家庭信息
#import "YSHREmergencyContactController.h"//紧急联系人
#import "YSHRJobsInfoController.h" //岗位信息
#import "UIImage+YSImage.h"
#import "UIView+Extension.h"
@interface YSHRInfoSelfHelpController ()<YSHRInfoHepSelfHeaderDelegate,QMUIImagePreviewViewDelegate>
@property (nonatomic,strong) YSHRInfoHepSelfHeader *headerView;
@property (nonatomic,strong) YSHRInfoSelfHelpModel *selfHelpModel;
@property (nonatomic,strong) QMUIImagePreviewViewController *imagePreviewViewController;
@end

@implementation YSHRInfoSelfHelpController


- (YSHRInfoHepSelfHeader *)headerView
{
    if (!_headerView) {
        _headerView = [[YSHRInfoHepSelfHeader alloc]init];
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerView.delegate = self;
    }
    return _headerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    [self setNaviView];
    // Do any additional setup after loading the view.
}
- (void)layoutTableView {
    self.tableView.frame = CGRectMake(0, kTopHeight, kSCREEN_WIDTH, kSCREEN_HEIGHT-kTopHeight-kBottomHeight);
}
- (void)setNaviView {
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kTopHeight)];
    [navView setGradientBackgroundWithColors:@[kUIColor(84, 106, 253, 1),kUIColor(46, 193, 255, 1)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(10*kWidthScale, 2*kHeightScale+kStatusBarHeight, 28*kWidthScale, 38*kHeightScale);
    [btn setImage:[UIImage imageNamed:@"返回白"] forState:UIControlStateNormal];
    btn.imageView.contentMode = UIViewContentModeCenter;
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:btn];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(90*kWidthScale, kStatusBarHeight+11*kHeightScale, 195*kWidthScale, 22*kHeightScale)];
    titleLabel.text = @"个人信息";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(18)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [navView addSubview:titleLabel];
    [self.view addSubview:navView];
}
- (void)initTableView{
    [super initTableView];
    
    if (@available(iOS 11.0, *)) {
            self.tableView.estimatedRowHeight = 0;
            self.tableView.estimatedSectionFooterHeight = 0;
            self.tableView.estimatedSectionHeaderHeight = 0;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    self.tableView.backgroundColor = kGrayColor(238);
    self.tableView.mj_header.hidden = YES;
    self.tableView.mj_footer.hidden = YES;
//    self.headerView.frame = CGRectMake(0, 0, 0, 235*kHeightScale);
//    self.tableView.tableHeaderView = self.headerView;
    self.tableView.sectionFooterHeight = 0.0;
    self.tableView.sectionHeaderHeight = 0.0;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0);
    [self setUpData];//静态表格
    [self doNetworking];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [TalkingData trackPageBegin:@"信息自助"];
}

//设置统计离开该模块
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"信息自助"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}

- (void)setUpData{
    NSMutableArray *sectionArr1 = [NSMutableArray arrayWithCapacity:10];
    [sectionArr1 addObject:@{@"id":@(0),@"imageName":@"gangwei",@"name":@"岗位信息",@"className":@"YSHRJobsInfoController"}];
    [sectionArr1 addObject:@{@"id":@(1),@"imageName":@"jiben",@"name":@"基本信息",@"className":@"YSHRPersonalInfoViewController"}];
     [sectionArr1 addObject:@{@"id":@(2),@"imageName":@"jiating",@"name":@"家庭信息",@"className":@"YSHRFamilyInfoController"}];
    [sectionArr1 addObject:@{@"id":@(3),@"imageName":@"xueli",@"name":@"学历信息",@"className":@"YSHREduExperienceController"}];
    self.dataSourceArray  = [[NSArray yy_modelArrayWithClass:[YSApplicationModel class] json:sectionArr1] copy];
    
    [self ys_reloadData];
    
    
}
- (void)doNetworking {
    [QMUITips showLoading:@"加载中..." inView:self.view];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,selfHelpDetails] isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"信息自助%@",response);
        if ([response[@"code"] integerValue] == 1) {
            [QMUITips hideAllToastInView:self.view animated:YES];
            self.selfHelpModel = [YSHRInfoSelfHelpModel yy_modelWithJSON:response[@"data"]];
            self.headerView.infoModel = self.selfHelpModel.cover;
           
        }else{
            [QMUITips showError:response[@"msg"] inView:self.view];
        }
    } failureBlock:^(NSError *error) {
      [QMUITips hideAllToastInView:self.view animated:YES];
    } progress:nil];
    
}

#pragma mark  - tableView代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YSHRInfoSelfHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSInfoSelfHelpCell"];
    if (cell == nil) {
        cell = [[YSHRInfoSelfHelpCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSInfoSelfHelpCell"];
    }
    YSApplicationModel *model = self.dataSourceArray[indexPath.row];
    cell.model = model;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48*kHeightScale;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YSApplicationModel *model = self.dataSourceArray[indexPath.row];
    switch ([model.id integerValue]) {
        case 0://岗位
        {
            YSHRJobsInfoController *vc = [[YSHRJobsInfoController alloc]init];
            vc.profileModel = self.selfHelpModel.cover;
            vc.modelArr = self.selfHelpModel.psnorgs;
            [self.navigationController pushViewController:vc animated:YES];
           
            
        }
            break;
        case 1://
        {
            YSHRPersonalInfoViewController *vc = [[YSHRPersonalInfoViewController alloc]init];
            vc.profileModel = self.selfHelpModel.profile;
            [self.navigationController pushViewController:vc animated:YES];
          
            
        }
            break;
        case 2:
        {
            YSHRFamilyInfoController *vc = [[YSHRFamilyInfoController alloc]init];
            vc.modelArr = self.selfHelpModel.familys;
            vc.linkmansArr = self.selfHelpModel.linkmans;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 3:
        {
            YSHREduExperienceController *vc = [[YSHREduExperienceController alloc]init];
            vc.eduModel = self.selfHelpModel.edus;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 4:
        {
            YSHREmergencyContactController *vc = [[YSHREmergencyContactController alloc]init];
            if (self.selfHelpModel.linkmans.count) {
                vc.linkManModel = self.selfHelpModel.linkmans[0];//紧急联系人默认只显示一个
            }
           
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        default:
            break;
    }
    
    
}
#pragma mark - 头像预览
- (void)hrInfoHepSelfHeaderImageViewDidClick:(YSHRInfoHepSelfHeader *)headerView {
        if (!self.imagePreviewViewController) {
            self.imagePreviewViewController = [[QMUIImagePreviewViewController alloc] init];
            self.imagePreviewViewController.imagePreviewView.delegate = self;
            self.imagePreviewViewController.imagePreviewView.currentImageIndex = 0;
        }
        [self.imagePreviewViewController startPreviewFromRectInScreen:CGRectMake(kSCREEN_WIDTH/2.0-37*kWidthScale, 80*kHeightScale+kTopHeight, 74*kWidthScale, 74*kWidthScale) cornerRadius:headerView.headImageView.layer.cornerRadius];
}

#pragma mark - QMUIImagePreviewViewDelegate

- (NSUInteger)numberOfImagesInImagePreviewView:(QMUIImagePreviewView *)imagePreviewView {
    return 1;
}

- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView renderZoomImageView:(QMUIZoomImageView *)zoomImageView atIndex:(NSUInteger)index {
    zoomImageView.image = self.headerView.headImageView.image;
}

- (QMUIImagePreviewMediaType)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView assetTypeAtIndex:(NSUInteger)index {
    return QMUIImagePreviewMediaTypeImage;
}

#pragma mark - QMUIZoomImageViewDelegate

- (void)singleTouchInZoomingImageView:(QMUIZoomImageView *)zoomImageView location:(CGPoint)location {
    self.headerView.headImageView.image = zoomImageView.image;
    [self.imagePreviewViewController endPreviewToRectInScreen:CGRectMake(kSCREEN_WIDTH/2.0-37*kWidthScale,22*kHeightScale+kTopHeight,73*kWidthScale, 73*kWidthScale)];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
