//
//  YSHRManagerInfoHGViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/1.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRManagerInfoHGViewController.h"
#import "UIView+Extension.h"
#import "YSHRManagerAllInfoScrollView.h"//Ta的信息
#import "YSHRManagerAttendanceGSView.h"//考勤
#import "YSHRManagerTGTrainingView.h"//培训
#import "YSHRManagerPerformanceGSView.h"//绩效
#import "YSHRMInfoAssetsGSView.h"//资产
#import "YSHRInfoSelfHelpModel.h"
#import "YSHRMInfoChartModel.h"

#import "YSHRJobsInfoController.h"//岗位信息
#import "YSHRMPostInfoPerViewController.h"//入职信息
#import "YSHRPersonalInfoViewController.h"//基本信息
#import "YSHRFamilyInfoController.h"//家庭信息
#import "YSHREduExperienceController.h"//学历信息
#import "YSContactModel.h"


#define KContent_Height (kSCREEN_HEIGHT-kTopHeight-kBottomHeight)

@interface YSHRManagerInfoHGViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *bottomTitlLab;
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, strong) YSHRManagerAllInfoScrollView *infoView;//个人信息
@property (nonatomic, strong) YSHRManagerAttendanceGSView *attendanceView;//考勤
@property (nonatomic, strong) YSHRManagerTGTrainingView *trainingView;//培训
@property (nonatomic, strong) YSHRManagerPerformanceGSView *performanceView;//绩效
@property (nonatomic, strong) YSHRMInfoAssetsGSView *assetsView;//资产
@property (nonatomic, strong) YSHRInfoSelfHelpModel *selfHelpModel;

@property (nonatomic, strong) YSHRMInfoChartModel *chartModel;


@end

@implementation YSHRManagerInfoHGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Ta的资料";
    [self.tableView removeFromSuperview];
    [self hideMJRefresh];
    [self loadSubViews];
    [self.view setGradientBackgroundWithColors:@[kUIColor(84, 106, 253, 1),kUIColor(46, 193, 255, 1)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    //查询员工个信息
    [self doNetworking];
    //查询员工资料(培训、考勤、培训、资产)
    [self getHRInfoNetwork];
}

- (void)loadSubViews {
    
    YSWeak;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:(CGRectMake(0, kTopHeight, kSCREEN_WIDTH,KContent_Height))];
    scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, KContent_Height*5);
    scrollView.tag = 241;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
//    scrollView.bounds = NO;
    [self.view addSubview:scrollView];
#pragma mark--Ta的资料
    _infoView = [[YSHRManagerAllInfoScrollView alloc] initWithFrame:(CGRectMake(0, 0, kSCREEN_WIDTH, KContent_Height))];
    [scrollView addSubview:_infoView];
    _infoView.clickedInfoBtnBlock = ^(NSInteger btn_tag) {
        switch (btn_tag) {
            case 0:
                {//岗位信息
                    YSHRJobsInfoController *vc = [[YSHRJobsInfoController alloc]init];
                    vc.profileModel = weakSelf.selfHelpModel.cover;
                    vc.modelArr = weakSelf.selfHelpModel.psnorgs;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                break;
            case 1:
                {//入职信息
                    YSHRMPostInfoPerViewController *vc = [[YSHRMPostInfoPerViewController alloc]init];
                    vc.profileModel = weakSelf.selfHelpModel;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                break;
            case 2:
                {//基本信息
                    YSHRPersonalInfoViewController *vc = [[YSHRPersonalInfoViewController alloc]init];
                    vc.profileModel = weakSelf.selfHelpModel.profile;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                break;
            case 3:
                {//家庭信息
                    YSHRFamilyInfoController *vc = [[YSHRFamilyInfoController alloc]init];
                    vc.modelArr = weakSelf.selfHelpModel.familys;
                    vc.linkmansArr = weakSelf.selfHelpModel.linkmans;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                break;
            case 4:
                {//学历信息
                    YSHREduExperienceController *vc = [[YSHREduExperienceController alloc]init];
                    vc.eduModel = weakSelf.selfHelpModel.edus;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                break;
            default:
                break;
        }
        
    };
    // 点击 考勤 培训 绩效 资产
    _infoView.choseOtherBtnBlock = ^(NSInteger btn_tag) {
        [weakSelf changeScrollViewShowContentHeightWith:btn_tag];
    };
#pragma mark--考勤页面
    _attendanceView = [[YSHRManagerAttendanceGSView alloc] initWithFrame:(CGRectMake(0, KContent_Height, kSCREEN_WIDTH, KContent_Height))];
    @weakify(self);
    [[_attendanceView.bottomBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        [self changeScrollViewShowContentHeightWith:1];
    }];
    [scrollView addSubview:_attendanceView];
    
    
#pragma mark--培训 YSHRManagerTGTrainingView.h
    _trainingView = [[YSHRManagerTGTrainingView alloc] initWithFrame:(CGRectMake(0, KContent_Height*2, kSCREEN_WIDTH, KContent_Height))];
    [[_trainingView.bottomBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        [self changeScrollViewShowContentHeightWith:2];
    }];
    [scrollView addSubview:_trainingView];
    
#pragma mark--绩效 YSHRManagerPerformanceGSView
    _performanceView = [[YSHRManagerPerformanceGSView alloc] initWithFrame:(CGRectMake(0, KContent_Height*3, kSCREEN_WIDTH, KContent_Height))];
    [[_performanceView.bottomBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        [self changeScrollViewShowContentHeightWith:3];
    }];
    [scrollView addSubview:_performanceView];

#pragma mark--资产 YSHRMInfoAssetsGSView 
    _assetsView = [[YSHRMInfoAssetsGSView alloc] initWithFrame:(CGRectMake(0, KContent_Height*4, kSCREEN_WIDTH, KContent_Height))];
    [[_assetsView.bottomBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        [self changeScrollViewShowContentHeightWith:4];
    }];
    [scrollView addSubview:_assetsView];
    
}


- (void)doNetworking {
    [super doNetworking];
     [self.view bringSubviewToFront:self.navView];
    NSDictionary *paramDic = [NSDictionary dictionaryWithObject:self.userNo forKey:@"userNo"];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, selfHelpDetails] isNeedCache:NO parameters:paramDic successBlock:^(id response) {
        DLog(@"团队员工个人信息:%@", response);
        [QMUITips hideAllToastInView:self.view animated:YES];
        if ([[response objectForKey:@"code"] integerValue] == 1) {
            self.selfHelpModel = [YSHRInfoSelfHelpModel yy_modelWithJSON:response[@"data"]];

            self.infoView.nameLab.text = self.selfHelpModel.cover.name;
            self.infoView.numberLab.text = self.selfHelpModel.cover.no;
            [self.infoView.positionBtn setTitle:self.selfHelpModel.cover.levelId forState:(UIControlStateNormal)];
            [self.infoView.headerImg sd_setImageWithURL:[NSURL URLWithString:self.selfHelpModel.cover.headImg] placeholderImage:[UIImage imageNamed:@"managerHeaderBackIHG"]];
            if (self.selfHelpModel.cover.deptName) {
                self.infoView.breftLab.text = [NSString stringWithFormat:@"%@ | %@", [YSUtility cancelNullData:self.selfHelpModel.cover.deptName], [YSUtility cancelNullData:self.selfHelpModel.cover.jobStation]];
            }
        }
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:NO];
    } progress:nil];
}

// 查询员工资料(培训、考勤、培训、资产)
- (void)getHRInfoNetwork {
    [QMUITips showLoadingInView:self.view];
     [self.view bringSubviewToFront:self.navView];
//    NSString *timeStr = [NSString stringWithFormat:@"%ld",[[[NSDate date] dateByAddingHours:8] year]];

    NSMutableDictionary *paramDic = [NSMutableDictionary new];
//    [paramDic setObject:timeStr forKey:@"year"];
    [paramDic setObject:self.userNo forKey:@"userNo"];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, getHRInfo] isNeedCache:NO parameters:paramDic successBlock:^(id response) {
        [QMUITips hideAllToastInView:self.view animated:NO];
        DLog(@"培训、考勤、培训、资产:%@", response);
        if (1 == [[response objectForKey:@"code"] integerValue]) {
            self.chartModel = [YSHRMInfoChartModel yy_modelWithJSON:response[@"data"]];

            [self upSubViewData];
        }
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:NO];

    } progress:nil];
}


- (void)upSubViewData {
    // 考勤
    [self.attendanceView.circleChart updateChartByCurrent:@(self.chartModel.KQ.attendance)];
    
    if (fmod(self.chartModel.KQ.attendance, 1.0) > 0.0) {
        [self.attendanceView updateNumberByStr:[NSString stringWithFormat:@"%.1f", self.chartModel.KQ.attendance]];
    }else {
        [self.attendanceView updateNumberByStr:[NSString stringWithFormat:@"%.0f", self.chartModel.KQ.attendance]];
    }
    self.attendanceView.shouldDay.text = [NSString stringWithFormat:@"%.1f", self.chartModel.KQ.shouldWorkday];
    self.attendanceView.finishDay.text = [NSString stringWithFormat:@"%.1f", self.chartModel.KQ.normalWorkday];
    self.attendanceView.bottomTitleLab.text = [NSString stringWithFormat:@"高于%.0f%%的YASHAers", self.chartModel.KQ.moreAttendanceToOthers];
    //培训
    self.trainingView.shouldNumLab.text = [NSString stringWithFormat:@"%d", [[self.chartModel.PX.pxOfYear objectForKey:@"trainNum"] intValue]];
    self.trainingView.finishTimeLab.text = [NSString stringWithFormat:@"%.1f", [[self.chartModel.PX.pxOfYear objectForKey:@"realClassHours"] floatValue]];
    self.trainingView.bottomTitleLab.text = [NSString stringWithFormat:@"培训目标达成率%.1f%%", [[self.chartModel.PX.pxOfYear objectForKey:@"completionRate"] floatValue]];
   // 更新折线数据
//    self.trainingView.lineChatView.dataArrOfPoint = @[@0.0, @30.0, @41.7, @60.0];
    self.trainingView.lineChatView.dataArrOfPoint = @[@(self.chartModel.PX.pxOfFirstSeason), @(self.chartModel.PX.pxOfSecondSeason), @(self.chartModel.PX.pxOfThirdSeason), @(self.chartModel.PX.pxOfFourthSeason)];
    // 绩效
    self.performanceView.shouldNumLab.text = [YSUtility cancelNullData:self.chartModel.JX.halfYearPer];
    self.performanceView.finishTimeLab.text = [YSUtility cancelNullData:self.chartModel.JX.yearPer];
    self.performanceView.bottomTitleLab.hidden = YES;
    // indexArray 第一个值是1代表年度最亮 2代表半年半亮
    [_performanceView upSubViewsValueWith:@[@1, self.chartModel.JX.yearPer]];
    [_performanceView upSubViewsValueWith:@[@2, self.chartModel.JX.halfYearPer]];
    
    // 资产
    [self.assetsView upSubViewsWith:@[@(self.chartModel.ZC.paNumber), @(self.chartModel.ZC.pfNumber), @(self.chartModel.ZC.psNumber)] withType:1];
    [self.assetsView upSubViewsWith:@[@(self.chartModel.ZC.caNumber), @(self.chartModel.ZC.cfNumber), @(self.chartModel.ZC.csNumber)] withType:2];
    self.assetsView.personLab.text = [NSString stringWithFormat:@"%d", self.chartModel.ZC.paNumber];
    self.assetsView.dutyLab.text = [NSString stringWithFormat:@"%d", self.chartModel.ZC.caNumber];
}

#pragma mark--scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat content_Y = scrollView.contentOffset.y;
    if (content_Y >= 0 && content_Y < KContent_Height) {
        self.navTitleLabe.text = @"Ta的资料";
    }else if (content_Y >= KContent_Height && content_Y < KContent_Height*2){
        self.navTitleLabe.text = @"考勤";
    }else if (content_Y >= KContent_Height*2 && content_Y < KContent_Height*3){
        self.navTitleLabe.text = @"培训";
    }else if (content_Y >= KContent_Height*3 && content_Y < KContent_Height*4){
        self.navTitleLabe.text = @"绩效";
    }else if (content_Y >= KContent_Height*4 && content_Y < KContent_Height*5){
        self.navTitleLabe.text = @"资产";
    }
}
- (void)changeScrollViewShowContentHeightWith:(NSInteger)index {
    {
        UIScrollView *scrollView = [self.view viewWithTag:241];
        switch (index) {
            case 0:
            {//考勤
                self.navTitleLabe.text = @"考勤";
                [scrollView setContentOffset:(CGPointMake(0, KContent_Height)) animated:YES];
            }
                break;
            case 1:
            {//培训
                self.navTitleLabe.text = @"培训";
                [scrollView setContentOffset:(CGPointMake(0, KContent_Height*2)) animated:YES];
            }
                break;
            case 2:
            {//绩效
                self.navTitleLabe.text = @"绩效";
                [scrollView setContentOffset:(CGPointMake(0, KContent_Height*3)) animated:YES];
            }
                break;
            case 3:
            {//资产
                self.navTitleLabe.text = @"资产";
                [scrollView setContentOffset:(CGPointMake(0, KContent_Height*4)) animated:YES];
            }
                break;
            case 4:
            {//返回了顶部
                self.navTitleLabe.text = @"Ta的资料";
                [scrollView setContentOffset:(CGPointMake(0, 0)) animated:YES];
            }
            default:
                break;
        }
    }
}

- (void)dealloc {
  
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
