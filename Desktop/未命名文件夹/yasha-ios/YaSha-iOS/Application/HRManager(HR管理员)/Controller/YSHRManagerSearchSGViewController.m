//
//  YSHRManagerSearchSGViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/3/26.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRManagerSearchSGViewController.h"
#import "UIView+Extension.h"
#import "YSTeamCompilePostModel.h"
#import "YSHRManagerInfoHGViewController.h"//Ta的资料
#import "YSHRMTCompileDetailViewController.h"// 编制详情
#import "YSHRMAttendanceOtherTableViewCell.h"//考勤记录 打卡时间cell
#import "YSHRMSSubAllTableViewCell.h"//绩效cell
#import "YSHRMSSubAllTableViewCell.h"//考勤汇总的详情cell
#import "YSContactModel.h"
#import "YSMangEntryPosityTableViewCell.h"//在岗cell
#import "YSFlowModel.h"
#import "YSFlowDetailPageController.h"
#import "YSFlowCustomDetailController.h"

#define KSearchPageSize 19
@interface YSHRManagerSearchSGViewController ()<UISearchBarDelegate>
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, assign) RefreshStateType refreshType;

@end

@implementation YSHRManagerSearchSGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self ys_shouldShowSearchBar];
    [self.searchField becomeFirstResponder];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}

// 从新配置搜索框
- (void)ys_shouldShowSearchBar {
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.backgroundImage = UIImageMake(@"hrMRTSearchBackImg");
    self.searchBar.barTintColor = [UIColor lightGrayColor];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = self.placeholderStr;
   
    if (@available(iOS 13.0, *)) {
        self.searchField =self.searchBar.searchTextField;
    }else {
		 // 通过 KVC 获取 UISearchBar 的私有变量 searchField，设置 UISearchBar 样式
        self.searchField = [self.searchBar valueForKey:@"_searchField"];
    }
    [self.searchBar setImage:UIImageMake(@"searchTFHRIMg") forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [self.searchBar setPositionAdjustment:UIOffsetMake(-8, 0) forSearchBarIcon:UISearchBarIconSearch];
    
    if (self.searchField) {
//        [[self.searchField rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(id x) {
//            weakSelf.keyWord = weakSelf.searchField.text;
//            weakSelf.pageNumber = 1;
//            [weakSelf refreshSearchDataWith:(RefreshStateTypeHeader)];
//        }];
//        [self.searchField setBackgroundColor:[UIColor colorWithRed:0.97 green:0.96 blue:0.96 alpha:1.00]];
        self.searchField.backgroundColor = [UIColor whiteColor];
        self.searchField.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(12)];
    }
    [self.navView addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.mas_equalTo(CGSizeMake(293*kWidthScale, 36*kHeightScale));
        make.bottom.mas_equalTo(self.navView.mas_bottom).offset(-(kTopHeight-36*kHeightScale-kStatusBarHeight)/2);
        make.left.mas_equalTo(self.navView.mas_left).offset(16*kWidthScale);
    }];
}
- (void)initTableView {
    [super initTableView];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 16*kWidthScale, 0, -16*kWidthScale);
    self.tableView.rowHeight = 48*kHeightScale;
    [self.tableView registerClass:[YSHRMAttendanceOtherTableViewCell class] forCellReuseIdentifier:@"hrmotherlistCEll"];
    [self.tableView registerClass:[YSHRMSSubAllTableViewCell class] forCellReuseIdentifier:@"levelreward"];
    [self.tableView registerClass:[YSHRMSSubAllTableViewCell class] forCellReuseIdentifier:@"subOtherAllCell"];
    [self.tableView registerClass:[YSMangEntryPosityTableViewCell class] forCellReuseIdentifier:@"workPellCellid"];
        if (@available(iOS 11.0, *)) {
            self.tableView.estimatedRowHeight = 0;
            self.tableView.estimatedSectionFooterHeight = 0;
            self.tableView.estimatedSectionHeaderHeight = 0;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    YSWeak;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf refreshSearchDataWith:(RefreshStateTypeHeader)];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf refreshSearchDataWith:(RefreshStateTypeFooter)];
    }];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}
- (void)layoutTableView {
    self.tableView.frame = CGRectMake(0, kTopHeight, kSCREEN_WIDTH, kSCREEN_HEIGHT-kTopHeight-kBottomHeight);

}
- (void)doNetworking {
    if (self.keyWord.length < 1) {
        return;
    }
    if (self.refreshType == RefreshStateTypeHeader) {
        // 先取消上次请求
        [YSNetManager ys_cancelRequestWithURL:[NSString stringWithFormat:@"%@%@", YSDomain, self.searchURLStr]];
    }
    [QMUITips showLoadingInView:self.view];
    [self.view bringSubviewToFront:self.navView];
    [self.paramDic setObject:self.keyWord forKey:self.searchParamStr];
    [self.paramDic setObject:@(self.pageNumber) forKey:@"pageIndex"];
    if ([[self.paramDic allKeys] containsObject:@"pageNumber"]) {
        [self.paramDic setObject:@(self.pageNumber) forKey:@"pageNumber"];
    }
    [self.paramDic setObject:@(KSearchPageSize) forKey:@"pageSize"];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, self.searchURLStr] isNeedCache:NO parameters:self.paramDic successBlock:^(id response) {
        [QMUITips hideAllToastInView:self.view animated:NO];
        DLog(@"搜索地址:%@\n-搜索结果:%@", self.searchURLStr,response);
        
        if (1 == [[response objectForKey:@"code"] integerValue]) {
            if ([[response objectForKey:@"msg"] isEqualToString:@"暂无数据"]) {
                [QMUITips showInfo:@"暂无数据" inView:self.view hideAfterDelay:0.7];
            }
            NSArray *responseArray = [NSArray new];
            switch (self.searchVCType) {
                case TeamHRSearchTypeDefint:
                {
                    responseArray = [NSArray yy_modelArrayWithClass:[YSTeamCompilePostModel class] json:[response objectForKey:@"data"]];
                    
                }
                    break;
                    
                case TeamHRSearchTypeCompile:
                {
                    responseArray = [NSArray yy_modelArrayWithClass:[YSTeamCompilePostModel class] json:[[response objectForKey:@"data"] objectForKey:@"list"]];
                    
                }
                    break;
                    
                case TeamHRSearchTypeCompileDetail:
                case TeamHRSearchTypePosition:
                case TeamHRSearchTypePerformance:
                case TeamHRSearchTypeAttendHoliday:
                case TeamHRSearchTypeAttendWork:
                case TeamHRSearchTypeAttendBusiness:
                case TeamHRSearchTypeAttendOutWark:
                case TeamHRSearchTypeAttendLate:
                case TeamHRSearchTypeAttendAbsenteeism:
                {
                    responseArray = [NSArray yy_modelArrayWithClass:[YSTeamCompilePostModel class] json:[[response objectForKey:@"data"] objectForKey:@"data"]];
                    
                }
                    break;
                    
                case TeamHRSearchTypeAttendRecord:
                case TeamHRSearchTypeAttendList:
                {
                    responseArray = [NSArray yy_modelArrayWithClass:[YSTeamCompilePostModel class] json:[[response objectForKey:@"data"] objectForKey:@"rows"]];
                    
                }
                    break;
                case TeamHRSearchTypeWork:
                {
                    responseArray = [NSArray yy_modelArrayWithClass:[YSTeamCompilePostModel class] json:[[response objectForKey:@"data"] objectForKey:@"peopleList"]];
                    
                }
                    break;
                default:
                    break;
            }
            
            if (self.refreshType == RefreshStateTypeHeader) {
                self.dataSourceArray = [NSMutableArray arrayWithArray:responseArray];
                if (self.searchVCType == TeamHRSearchTypeAttendRecord || self.searchVCType == TeamHRSearchTypeAttendList || self.searchVCType == TeamHRSearchTypePerformance) {
                    [self handelAllDataAddModelImgWith:self.dataSourceArray withIdStr:@"code"];
                }
                if (self.searchVCType >= TeamHRSearchTypeAttendHoliday && self.searchVCType <= TeamHRSearchTypeAttendWork) {
                    // 考勤记录/打卡时间增加头像
                    [self handelAllDataAddModelImgWith:self.dataSourceArray withIdStr:@"personCode"];
                }
                if (self.searchVCType == TeamHRSearchTypeWork) {
                    [self handelAllDataAddModelImgWith:self.dataSourceArray withIdStr:@"employcode"];
                }
            }else {
                if (self.searchVCType == TeamHRSearchTypeAttendRecord || self.searchVCType == TeamHRSearchTypeAttendList || self.searchVCType == TeamHRSearchTypePerformance) {
                    NSMutableArray *dataModellArray = [NSMutableArray arrayWithArray:responseArray];
                    [self handelAllDataAddModelImgWith:dataModellArray withIdStr:@"code"];
                    [self.dataSourceArray addObjectsFromArray:responseArray];
                }else if (self.searchVCType >= TeamHRSearchTypeAttendHoliday && self.searchVCType <= TeamHRSearchTypeAttendWork) {
                    // 考勤记录/打卡时间增加头像
                    NSMutableArray *dataModellArray = [NSMutableArray arrayWithArray:responseArray];
                    [self handelAllDataAddModelImgWith:dataModellArray withIdStr:@"personCode"];

                    [self.dataSourceArray addObjectsFromArray:responseArray];
                }else if (self.searchVCType == TeamHRSearchTypeWork) {
                    [self handelAllDataAddModelImgWith:self.dataSourceArray withIdStr:@"employcode"];
                }else {
                    [self.dataSourceArray addObjectsFromArray:responseArray];
                }
            }
            if ([responseArray count] < KSearchPageSize || [responseArray count] > KSearchPageSize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.tableView.mj_footer resetNoMoreData];
            }
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:NO];
    } progress:nil];
}
// 增加头像
- (void)handelAllDataAddModelImgWith:(NSMutableArray* _Nonnull)dataArray withIdStr:(NSString*)userID {
    if (dataArray.count == 0) {
        return;
    }
    [dataArray enumerateObjectsUsingBlock:^(YSTeamCompilePostModel  * compileModel, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *modelDic = [compileModel yy_modelToJSONObject];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@", [modelDic objectForKey:userID]];
        RLMResults *results = [[YSContactModel objectsWithPredicate:predicate]  sortedResultsUsingKeyPath:@"userId" ascending:YES];
        if ([results count] != 0) {
            YSContactModel *resultsModel = results[0];
            compileModel.headImage = [NSString stringWithFormat:@"%@_S.jpg", resultsModel.headImg];
        }
    }];
    
}



- (void)refreshSearchDataWith:(RefreshStateType)type {
    self.refreshType = type;
    if (type== RefreshStateTypeHeader) {
        self.pageNumber = 1;
    }else {
        self.pageNumber++;
    }
    [self doNetworking];
}

#pragma mark - UISearchBarDelegateDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.pageNumber = 1;
    self.keyWord = searchBar.text;
    [self refreshSearchDataWith:(RefreshStateTypeHeader)];
}

#pragma mark--tableView
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSTeamCompilePostModel *model = self.dataSourceArray[indexPath.row];
    NSString *companyStr = @"";
    NSString *deptStr = @"";
    NSString *name = @"";
#pragma mark--考勤
    if (self.searchVCType == TeamHRSearchTypeAttendRecord || self.searchVCType == TeamHRSearchTypeAttendList) {

        YSHRMAttendanceOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hrmotherlistCEll" forIndexPath:indexPath];
        switch (self.searchVCType) {
            case TeamHRSearchTypeAttendRecord:
            {//考勤-记录
                companyStr = [YSUtility cancelNullData:model.name];
                deptStr = [YSUtility cancelNullData:model.typeName];
                [cell.headerImg sd_setImageWithURL:[NSURL URLWithString:model.headImage] placeholderImage:[UIImage imageNamed:@"managerHeaderBackIHG"]];
            }
                break;
            case TeamHRSearchTypeAttendList:
            {//考勤-打卡时间
                companyStr = [YSUtility cancelNullData:model.name];
                if ([model.startRwork isEqualToString:@""] || [model.startRwork isEqual:[NSNull null]]) {
                    deptStr = [NSString stringWithFormat:@"上班打卡 -"];
                }else {
                    deptStr = [NSString stringWithFormat:@"上班打卡 %@", model.startRwork];
                }
                if ([model.endRwork isEqualToString:@""] || [model.endRwork isEqual:[NSNull null]]) {
                    name = [NSString stringWithFormat:@"下班打卡 -"];
                }else {
                    name = [NSString stringWithFormat:@"下班打卡 %@", model.endRwork];
                }
                cell.rightLab.textAlignment = NSTextAlignmentLeft;
                [cell.headerImg sd_setImageWithURL:[NSURL URLWithString:model.headImage] placeholderImage:[UIImage imageNamed:@"managerHeaderBackIHG"]];

            }
                break;
                
            default:
                break;
        }
        cell.nameLab.text = companyStr;
        cell.hiddenLab.text = deptStr;
        cell.rightLab.text = name;
        return cell;
    }
#pragma mark--考勤汇总的详情
    else if (self.searchVCType >= TeamHRSearchTypeAttendHoliday && self.searchVCType <= TeamHRSearchTypeAttendWork) {
        YSHRMSSubAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subOtherAllCell" forIndexPath:indexPath];
        // 请假 迟到早退 以及其他类型 分三种
        switch (self.searchVCType) {
            case TeamHRSearchTypeAttendHoliday:
            {//请假
                cell.nameLab.text = [YSUtility cancelNullData:model.name];
                cell.typeLab.text = [YSUtility cancelNullData:model.subTypeStr];
                cell.timeLab.text = [YSUtility cancelNullData:model.time];
                cell.hoursLab.text = [NSString stringWithFormat:@"%@d", [YSUtility cancelNullData:model.day].length?[YSUtility cancelNullData:model.day]:@"0"];
            }
                break;
            case TeamHRSearchTypeAttendLate:
            {//迟到早退
                cell.selectionStyle = UITableViewCellSeparatorStyleNone;
                [cell.typeLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell.nameLab.mas_right).offset(40*kWidthScale);
                }];
                [cell.timeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(43*kWidthScale, 20*kHeightScale));
                    make.centerY.mas_equalTo(0);
                    make.left.mas_equalTo(cell.typeLab.mas_right).offset(43*kWidthScale);
                }];
                [cell.hoursLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell.timeLab.mas_right).offset(43*kWidthScale);
                }];
                cell.nameLab.text = [YSUtility cancelNullData:model.name];
                cell.typeLab.text = [YSUtility cancelNullData:model.typeName];
                cell.timeLab.text = [YSUtility cancelNullData:model.sdate];
                if ([model.typeTime floatValue] > 60.0) {
                    cell.hoursLab.text = [NSString stringWithFormat:@"%.0fh%.0fm", floorf([model.typeTime floatValue]/60), fmod([model.typeTime doubleValue], 60.0)];

                }else {
                    cell.hoursLab.text = [NSString stringWithFormat:@"%@m", model.typeTime];
                }
            }
                break;
            case TeamHRSearchTypeAttendWork:
            {// 加班
                cell.selectionStyle = UITableViewCellSeparatorStyleNone;
                cell.typeLab.hidden = YES;
                [cell.timeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(195*kWidthScale, 20*kHeightScale));
                    make.centerY.mas_equalTo(0);
                    make.left.mas_equalTo(cell.nameLab.mas_left).offset(97*kWidthScale);
                }];
                
                cell.nameLab.text = [YSUtility cancelNullData:model.name];
                cell.timeLab.text = [YSUtility cancelNullData:model.time];
                cell.hoursLab.hidden = YES;
//                cell.hoursLab.text = [YSUtility cancelNullData:model.hour];
            }
                break;
            case TeamHRSearchTypeAttendBusiness:
            {// 出差
                cell.selectionStyle = UITableViewCellSeparatorStyleNone;
                cell.typeLab.hidden = YES;
                [cell.timeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(101*kWidthScale, 20*kHeightScale));
                    make.centerY.mas_equalTo(0);
                    make.left.mas_equalTo(cell.nameLab.mas_right).offset(48*kWidthScale);
                }];
                [cell.hoursLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell.timeLab.mas_right).offset(47*kWidthScale);
                }];
                
                cell.nameLab.text = [YSUtility cancelNullData:model.name];
                cell.timeLab.text = [YSUtility cancelNullData:model.time];
                cell.hoursLab.text = [NSString stringWithFormat:@"%@d", [YSUtility cancelNullData:model.hour].length?[YSUtility cancelNullData:model.hour]:@"0"];
            }
                break;
            case TeamHRSearchTypeAttendOutWark:
            {//因公外出
                cell.typeLab.hidden = YES;
                [cell.timeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(101*kWidthScale, 20*kHeightScale));
                    make.centerY.mas_equalTo(0);
                    make.left.mas_equalTo(cell.nameLab.mas_right).offset(48*kWidthScale);
                }];
                [cell.hoursLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell.timeLab.mas_right).offset(47*kWidthScale);
                }];
                
                cell.nameLab.text = [YSUtility cancelNullData:model.name];
                cell.timeLab.text = [YSUtility cancelNullData:model.time];
                cell.hoursLab.text = [NSString stringWithFormat:@"%@d", [YSUtility cancelNullData:model.day].length?[YSUtility cancelNullData:model.day] : @"0"];
            }
                break;
            case TeamHRSearchTypeAttendAbsenteeism:
            {
                cell.selectionStyle = UITableViewCellSeparatorStyleNone;
                cell.typeLab.hidden = YES;
                [cell.timeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(101*kWidthScale, 20*kHeightScale));
                    make.centerY.mas_equalTo(0);
                    make.left.mas_equalTo(cell.nameLab.mas_right).offset(48*kWidthScale);
                }];
                [cell.hoursLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell.timeLab.mas_right).offset(47*kWidthScale);
                }];
                
                cell.nameLab.text = [YSUtility cancelNullData:model.name];
                cell.timeLab.text = [YSUtility cancelNullData:model.absenteeismTime];
                cell.hoursLab.text = [NSString stringWithFormat:@"%@d", [YSUtility cancelNullData:model.absenteeismDay].length?[YSUtility cancelNullData:model.absenteeismDay] :@"0"];
            }
                break;
                
            default:
                break;
        }
        [cell.headerImg sd_setImageWithURL:[NSURL URLWithString:model.headImage] placeholderImage:[UIImage imageNamed:@"managerHeaderBackIHG"]];
        return cell;
    }
#pragma mark--部门绩效
    else if (self.searchVCType == TeamHRSearchTypePerformance) {
        
        YSHRMSSubAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"levelreward" forIndexPath:indexPath];
        cell.typeLab.hidden = YES;
        [cell.timeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70*kWidthScale, 20*kHeightScale));
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(cell.nameLab.mas_right).offset(65*kWidthScale);
        }];
        [cell.hoursLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(55*kWidthScale, 20*kHeightScale));
            
            make.left.mas_equalTo(cell.timeLab.mas_right).offset(64*kWidthScale);
        }];
        [cell.headerImg sd_setImageWithURL:[NSURL URLWithString:model.headImage] placeholderImage:[UIImage imageNamed:@"managerHeaderBackIHG"]];
        cell.nameLab.text = [YSUtility cancelNullData:model.name];
        cell.timeLab.text = [NSString stringWithFormat:@"半年度: %@", [YSUtility cancelNullData:model.halfYearPer]];
        cell.hoursLab.text = [NSString stringWithFormat:@"年度: %@", [YSUtility cancelNullData:model.yearPer]];
        return cell;

    }
#pragma mark--团队 其他
    else if (self.searchVCType == TeamHRSearchTypeWork) {
    
        YSMangEntryPosityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"workPellCellid" forIndexPath:indexPath];
        cell.workModel = self.dataSourceArray[indexPath.row];
        return cell;

    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sysyCellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"sysyCellID"];
        cell.textLabel.textColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.8];
        cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    }
    
    switch (self.searchVCType) {
        case TeamHRSearchTypeDefint:
        {//我的团队--总览
            companyStr = [YSUtility cancelNullData:model.cname];
            deptStr = [YSUtility cancelNullData:model.dname];
            name = [YSUtility cancelNullData:model.name];
        }
            break;
        case TeamHRSearchTypeCompile:
        {//我的团队--编制
            companyStr = [YSUtility cancelNullData:model.orgName];
            deptStr = [YSUtility cancelNullData:model.deptName];
            name = [YSUtility cancelNullData:model.postName];
        }
            break;
        case TeamHRSearchTypeCompileDetail:
        {//我的团队--编制详情
            companyStr = [YSUtility cancelNullData:model.postname];
            deptStr = [YSUtility cancelNullData:model.name];
            name = [YSUtility cancelNullData:model.level];
        }
            break;
        case TeamHRSearchTypePosition:
        {//我的团队--入/离职
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            companyStr = [YSUtility cancelNullData:model.postname];
            deptStr = [YSUtility cancelNullData:model.name];
            if ([[self.paramDic allKeys] containsObject:@"entryYear"]) {
                // 入职时间
                name = [YSUtility cancelNullData:model.enterTimeStr];
            }else {
                // 离职时间
                name = [YSUtility cancelNullData:model.leaveTimeStr];
            }
        }
            break;
        
        default:
            break;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@", companyStr, deptStr, name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSTeamCompilePostModel *model = self.dataSourceArray[indexPath.row];
    if (self.searchVCType >= TeamHRSearchTypeAttendHoliday && self.searchVCType <= TeamHRSearchTypeAttendOutWark) {
        // 请假/出差/因公外出-加班-跳转流程
        [self requestFlowInfoWtihModel:model];
        return;
    }else if (self.searchVCType == TeamHRSearchTypeAttendWork) {
        // 请假/出差/因公外出-加班-跳转流程
        [self requestFlowInfoWtihModel:model];
        return;
    }
    switch (self.searchVCType) {
        case TeamHRSearchTypeDefint:
        case TeamHRSearchTypeCompileDetail:
            {
                YSHRManagerInfoHGViewController *infoVC = [YSHRManagerInfoHGViewController new];
                infoVC.userNo = model.no;
                [self.navigationController pushViewController:infoVC animated:nil];
            }
            break;
            case TeamHRSearchTypeCompile:
        {
            YSHRMTCompileDetailViewController *detailVC = [YSHRMTCompileDetailViewController new];
            detailVC.deptIds = model.pkDept;
            detailVC.postName = model.postName;
            [self.navigationController pushViewController:detailVC animated:nil];
        }
            break;
        case TeamHRSearchTypePosition:
        {
            if ([[self.paramDic allKeys] containsObject:@"entryYear"]) {
                // 入职才能跳转
                YSHRManagerInfoHGViewController *infoVC = [YSHRManagerInfoHGViewController new];
                infoVC.userNo = model.no;
                [self.navigationController pushViewController:infoVC animated:nil];
            }
        }
            break;
            case TeamHRSearchTypeAttendRecord:
            case TeamHRSearchTypeAttendList:
            case TeamHRSearchTypePerformance:
        {
            YSHRManagerInfoHGViewController *infoVC = [YSHRManagerInfoHGViewController new];
            infoVC.userNo = model.code;
            [self.navigationController pushViewController:infoVC animated:nil];
        }
            break;
        case TeamHRSearchTypeWork:
        {
            YSHRManagerInfoHGViewController *infoVC = [YSHRManagerInfoHGViewController new];
            infoVC.userNo = model.employcode;
            [self.navigationController pushViewController:infoVC animated:nil];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)requestFlowInfoWtihModel:(YSTeamCompilePostModel*)model {
    NSInteger codeType = 10;
    switch (self.searchVCType) {
        case TeamHRSearchTypeAttendHoliday:
        {//请假
            codeType = 10;
        }
            break;
        case TeamHRSearchTypeAttendBusiness:
        {//出差
            codeType = 20;
        }
            break;
        case TeamHRSearchTypeAttendWork:
        {//加班
            codeType = 40;
        }
            break;
        case TeamHRSearchTypeAttendOutWark:
        {//因公外出
            codeType = 30;
        }
            break;
        default:
            break;
    }
    [QMUITips showLoadingInView:self.view];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain,getFlowInfo,model.billCode] isNeedCache:NO parameters:@{@"type":@(codeType)} successBlock:^(id response) {
        DLog(@"流程详情%@",response);
        if ([response[@"code"] integerValue] == 1) {
            [QMUITips hideAllToastInView:self.view animated:YES];
            YSFlowListModel *cellModel = [[ YSFlowListModel alloc]init];
            cellModel.businessKey = response[@"data"][@"businessKey"];
            cellModel.processDefinitionKey = response[@"data"][@"processDefinitionKey"];
            cellModel.processInstanceId = response[@"data"][@"processInstanceId"];
            if ([YSUtility cancelNullData:cellModel.businessKey].length < 1 ||[YSUtility cancelNullData:cellModel.processDefinitionKey].length < 1 || [YSUtility cancelNullData:cellModel.processInstanceId].length < 1) {
                [QMUITips showError:@"获取流程信息失败" inView:self.view hideAfterDelay:0.6];
                return ;
            }
            if (codeType == 20) {//出差流程
                //YSFlowTripFormListViewController
                //YSFlowTripChangeViewController
                YSFlowModel *flowModel = [YSUtility getFlowModelWithProcessDefinitionKey:cellModel.processDefinitionKey];
                YSFlowDetailPageController *flowDetailPageController = [[YSFlowDetailPageController alloc] init];
                flowDetailPageController.flowType = YSFlowTypeNone;
                //获得plist文件数据model
                flowDetailPageController.flowModel = flowModel;
                //获得流程列表数据model
                flowDetailPageController.cellModel = cellModel;
                [self.navigationController pushViewController:flowDetailPageController animated:YES];
                
            }else{
                YSFlowCustomDetailController *flowCustomDetailController = [[YSFlowCustomDetailController alloc]init];
                // YSFlowListModel
                flowCustomDetailController.cellModel = cellModel;
                flowCustomDetailController.attendanceJumpStr = @"跳转";
                [self.navigationController pushViewController:flowCustomDetailController animated:YES];
            }
            
        }
        [QMUITips hideAllToastInView:self.view animated:YES];
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:YES];
    } progress:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)back {
    [YSNetManager ys_cancelRequestWithURL:[NSString stringWithFormat:@"%@%@", YSDomain, self.searchURLStr]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark--setter&&getter
- (UIView *)navView {
    if (!_navView) {
        _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kTopHeight)];
        [_navView setGradientBackgroundWithColors:@[kUIColor(84, 106, 253, 1),kUIColor(46, 193, 255, 1)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(kSCREEN_WIDTH-12*kWidthScale-28*kWidthScale, kStatusBarHeight+(kNavigationBarHeight-12*kWidthScale-20*kHeightScale), 28*kWidthScale, 20*kHeightScale);
        [btn setTitle:@"取消" forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:btn];
    }
    return _navView;
}
- (NSMutableDictionary *)paramDic {
    if (!_paramDic) {
        _paramDic = [NSMutableDictionary new];
    }
    return _paramDic;
}
- (void)dealloc {
    DLog(@"搜索页面销毁");
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
