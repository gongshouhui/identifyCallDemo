//
//  YSHRManagerHGViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/3/25.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRManagerHGViewController.h"
#import "YSHRManagerHGHeaderView.h"
#import "YSHRManagerDetailHeaderView.h"
#import "YSHRManagerSearchSGViewController.h"//搜索
#import "YSHRManagerTeamGViewController.h"//编制
#import "YSManagerPositionHGViewController.h"//入/离职
#import "YSHRManagerHGBTableViewCell.h"
#import "YSHRManagerInfoHGViewController.h"//Ta的资料
#import "YSHRMTWorkingViewController.h"//在岗
#import "YSHRInfoSelfHelpModel.h"
#import "YSNetManagerCache.h"
#import "YSHRMTDeptTreeModel.h"//部门树
#import "YSTeamCompilePostModel.h"//部门人员
#import "YSHRMTDeptTreeViewController.h"
#import "YSRightToLeftTransition.h"
#import "YSDeptTreePointModel.h"

//#define KtableView_Y 545*kHeightScale+10*kHeightScale-255*kHeightScale-kTopHeight+54//没有隐藏导航条

#define KtableView_Y 545*kHeightScale+kTopHeight-255*kHeightScale-10//隐藏导航条

@interface YSHRManagerHGViewController ()<YSHRManagerDidItemDelegate>

@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, assign) BOOL isDragging;
@property (nonatomic, strong) YSHRManagerHGHeaderView *headerView;
@property (nonatomic, strong) YSHRManagerHGHeaderView *upHeaderView;
@property (nonatomic, strong) NSMutableArray *dataDeparArray;
@property (nonatomic, strong) NSMutableArray *dataPersonArray;
@property (nonatomic, copy) NSString *deptId;
@property (nonatomic, strong) YSHRMTDeptTreeModel *headerModel;
@property (nonatomic, strong) NSMutableArray *choseDataDeptArray;
@property (nonatomic, copy) NSString *deptHiddenIDStr;
@property (nonatomic, strong) NSMutableArray *oldChoseArray;
@property (nonatomic, copy) NSString *deptFalseName;//后台不能返回 亚厦控股,用这个首次进入页面的值判断一下 顶部是显示 亚厦集团还是 亚厦控股


@end

@implementation YSHRManagerHGViewController

- (YSHRManagerHGHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[YSHRManagerHGHeaderView alloc] initWithFrame:(CGRectMake(0, 0, kSCREEN_WIDTH, 545*kHeightScale)) withType:YES];
        [_headerView.detailBtn addTarget:self action:@selector(lookPersonInfo) forControlEvents:(UIControlEventTouchUpInside)];
        [_headerView.titBtn addTarget:self action:@selector(backInitialState:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _headerView;
}

- (YSHRManagerHGHeaderView *)upHeaderView {
    if (!_upHeaderView) {
        _upHeaderView = [[YSHRManagerHGHeaderView alloc] initWithFrame:(CGRectMake(0, kTopHeight, kSCREEN_WIDTH, 255*kHeightScale)) withType:NO];
        [_upHeaderView.detailBtn addTarget:self action:@selector(lookPersonInfo) forControlEvents:(UIControlEventTouchUpInside)];
        [_upHeaderView.titBtn addTarget:self action:@selector(backInitialState:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _upHeaderView;
}
- (void)initTableView {
	[super initTableView];
	self.tableView.tableHeaderView = self.headerView;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.backgroundColor = [UIColor whiteColor];
	[self.tableView registerClass:[YSHRManagerHGBTableViewCell class] forCellReuseIdentifier:@"bottomCellPerson"];
	YSWeak;
	self.headerView.choseOptionBtnBlock = ^(NSInteger index_btn) {
		[weakSelf clickdeNumberOptionAction:index_btn];
	};
	self.upHeaderView.choseOptionBtnBlock = ^(NSInteger index_btn) {
		[weakSelf clickdeNumberOptionAction:index_btn];
	};
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的团队";
    // 初始图片向下
    self.isDown = YES;
    self.headerModel = nil;
    self.deptId = @"";
    self.deptHiddenIDStr = @"";
    // 从本地取部门信息
    NSDictionary *dataDic = [YSNetManagerCache ys_httpCacheWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getDeptTree] parameters:nil];
    if (0 != [[dataDic objectForKey:@"data"] count]) {
        NSDictionary *deptTreeDic = [dataDic objectForKey:@"data"][0];
        self.deptFalseName = [deptTreeDic objectForKey:@"name"];
        self.deptHiddenIDStr = [deptTreeDic objectForKey:@"id"];
    }
	
    [self initTableView];
    [self hideMJRefresh];
    self.view.backgroundColor = [UIColor whiteColor];
    // 初始headerView545 滑动headerView366
    [self backInitialState:nil];
    [self.view addSubview:self.upHeaderView];
    self.upHeaderView.alpha = 0;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self ys_showManagerScreenBar];
}

- (void)layoutTableView {
    if (self.isDown) {
        [super layoutTableView];
    }else {
        self.tableView.frame = CGRectMake(0, 240*kHeightScale+kTopHeight, kSCREEN_WIDTH, kSCREEN_HEIGHT-240*kHeightScale-kBottomHeight-kTopHeight);
    }
}




#pragma mark--处理请求到的部门数据
- (void)handelGetDeptDataWith:(NSDictionary*)dataDic {
    
    if (self.choseDataDeptArray) {
        for (NSInteger i = self.dataDeparArray.count-1; i > 0; i--) {
            if (i > [self.choseDataDeptArray[0] integerValue]) {
                // 将数据源中 选中之后的分区的数据源删除
                [self.dataDeparArray removeObjectAtIndex:i];
            }
        }
    }
    
    if ([[dataDic objectForKey:@"companyChildren"] count] != 0) {
        [self.dataDeparArray addObject:[dataDic objectForKey:@"companyChildren"]];
    }
    if ([[dataDic objectForKey:@"children"] count] != 0) {
        [self.dataDeparArray addObject:[dataDic objectForKey:@"children"]];
    }
    [self.tableView reloadData];
}
// 朱门用来处理请求子集部门的数据
- (void)handelGetDeptChirdenListDataWith:(NSArray*)listData {
    for (NSInteger i = self.dataDeparArray.count-1; i > 0; i--) {
        if (i > [self.choseDataDeptArray[0] integerValue]) {
            // 将数据源中 选中之后的分区的数据源删除
            [self.dataDeparArray removeObjectAtIndex:i];
        }
    }

    NSMutableArray *childrenArray  = [NSMutableArray new];
    for (NSDictionary *childrenDic in listData) {
        [childrenArray addObject:childrenDic];
    }
    if (childrenArray.count != 0) {
        [self.dataDeparArray addObject:childrenArray];
    }

}
#pragma mark--刷新顶部个人信息
- (void)upHeaderSubViewInfoData{
    
    self.headerView.titleLab.text = self.headerModel.name;
    self.headerView.nameLab.text = self.headerModel.leader.name;
    [self.headerView.positionBtn setTitle:self.headerModel.leader.userPost forState:(UIControlStateNormal)];
    self.headerView.numberLab.text = self.headerModel.leader.no;
    self.headerView.briefLb.text = [NSString stringWithFormat:@"%@ | %@", [YSUtility cancelNullData:self.headerModel.leader.deptName], [YSUtility cancelNullData:self.headerModel.leader.jobStation]];
    [self.headerView.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", YSImageDomain, self.headerModel.leader.userImgUrl]] placeholderImage:[UIImage imageNamed:@"头像_mine"]];
    
    self.upHeaderView.titleLab.text = self.headerModel.name;
    self.upHeaderView.nameLab.text = self.headerModel.leader.name;
    [self.upHeaderView.positionBtn setTitle:self.headerModel.leader.userPost forState:(UIControlStateNormal)];
    self.upHeaderView.numberLab.text = self.headerModel.leader.no;
    self.upHeaderView.briefLb.text = [NSString stringWithFormat:@"%@ | %@", [YSUtility cancelNullData:self.headerModel.leader.deptName], [YSUtility cancelNullData:self.headerModel.leader.jobStation]];
    [self.upHeaderView.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", YSImageDomain, self.headerModel.leader.userImgUrl]] placeholderImage:[UIImage imageNamed:@"头像_mine"]];


}

// 查看详情Ta资料
- (void)lookPersonInfo {
    DLog(@"点击头像 查看详情");
    if (self.headerModel.leader.no) {
        YSHRManagerInfoHGViewController *infoVC = [[YSHRManagerInfoHGViewController alloc] init];
        infoVC.userNo = self.headerModel.leader.no;
        [self.navigationController pushViewController:infoVC animated:YES];
    }
}
// 返回界面初始状态
- (void)backInitialState:(UIButton*)sender {
    [self.dataDeparArray removeAllObjects];
    [self.dataPersonArray removeAllObjects];
    [self.oldChoseArray removeAllObjects];
    [self.choseDataDeptArray removeAllObjects];
    self.deptId = @"";

    if (sender) {
        self.isDown = NO;
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:(CGRectZero)];
        self.upHeaderView.alpha = 1;
        [self layoutTableView];
    }
    [self loadData];
    
}
// 首次进入 点击部门树 (点击右上角 我的团队) 点击返回按钮 用该方法
- (void)loadData {
    [QMUITips showLoadingInView:self.view];
    [self.view bringSubviewToFront:self.navView];
    dispatch_group_t group_data = dispatch_group_create();
    dispatch_group_enter(group_data);
    dispatch_group_async(group_data, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 获取查询管理部门或者所在部门
#pragma mark--请求部门的数据
            NSDictionary *paramDic = [NSDictionary dictionaryWithObject:self.deptId forKey:@"deptId"];
            [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, selfMessageDept] isNeedCache:NO parameters:paramDic successBlock:^(id response) {
                DLog(@"部门的数据:%@", response);
                dispatch_group_leave(group_data);
                if (1== [[response objectForKey:@"code"] integerValue] && 0 != [[response objectForKey:@"data"] count]) {
                    [self handelGetDeptDataWith:[response objectForKey:@"data"][0]];
                    //顶部个人信息视图赋值
                    self.headerModel = [YSHRMTDeptTreeModel yy_modelWithJSON:[response objectForKey:@"data"][0]];
                    
                }else {
                    // 刷新顶部个人信息视图 没有数据的时候 也要将顶部置空
                    self.headerModel = [YSHRMTDeptTreeModel new];
                }
                // 开始刷新顶部个人信息视图
                [self upHeaderSubViewInfoData];
            } failureBlock:^(NSError *error) {
                dispatch_group_leave(group_data);
            } progress:nil];
        
    });
    dispatch_group_enter(group_data);
    dispatch_group_async(group_data, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
#pragma mark--请求人员的数据
        // 查询部门人员
        NSDictionary *paramDic = [NSDictionary dictionaryWithObject:[YSUtility judgeIsEmpty:self.deptId] ? self.deptHiddenIDStr:self.deptId forKey:@"deptId"];
            [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, selfMessageAllPerson] isNeedCache:NO parameters:paramDic successBlock:^(id response) {
                DLog(@"人员的数据:%@", response);
                dispatch_group_leave(group_data);
                if (1 == [[response objectForKey:@"code"] integerValue]) {
                    self.dataPersonArray = [NSMutableArray arrayWithArray:[YSDataManager getTeamMyAllAuthorizedData:response]];
                }
                [self.tableView reloadData];
            } failureBlock:^(NSError *error) {
                dispatch_group_leave(group_data);
            } progress:nil];
    });
    dispatch_group_enter(group_data);
    dispatch_group_async(group_data, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
#pragma mark--请求编制/在岗/入/离职的数据
        // 查询统计信息
            NSDictionary *paramDic = [NSDictionary dictionaryWithObject:self.deptId forKey:@"deptIds"];
            [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, getAuthorizedStrengthTotal] isNeedCache:NO parameters:paramDic successBlock:^(id response) {
                DLog(@"编制详情统计:%@", response);
                dispatch_group_leave(group_data);
                if (1==[[response objectForKey:@"code"] integerValue]) {
                    if (self.isDown) {
                        [self.headerView upBottomNumberDataWith:response[@"data"]];
                    }
                    [self.upHeaderView upBottomNumberDataWith:response[@"data"]];
                    
                }
            } failureBlock:^(NSError *error) {
                dispatch_group_leave(group_data);
                
            } progress:nil];
    });
    dispatch_group_notify(group_data, dispatch_get_main_queue(), ^{
        [QMUITips hideAllToastInView:self.view animated:NO];
    });
}
// 请求子集部门
- (void)loadDeptListData {
    [QMUITips showLoadingInView:self.view];
    [self.view bringSubviewToFront:self.navView];
    dispatch_group_t group_data = dispatch_group_create();
    dispatch_group_enter(group_data);
    dispatch_group_async(group_data, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
#pragma mark--请求子部门的数据
        // 获取子部门
        NSDictionary *paramDic = [NSDictionary dictionaryWithObject:self.deptId forKey:@"deptId"];
        [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, getDeptList] isNeedCache:NO parameters:paramDic successBlock:^(id response) {
            DLog(@"子集部门的数据:%@", response);
            dispatch_group_leave(group_data);
            if (1== [[response objectForKey:@"code"] integerValue]) {
                [self handelGetDeptChirdenListDataWith:[response objectForKey:@"data"]];
            }

        } failureBlock:^(NSError *error) {
            dispatch_group_leave(group_data);
        } progress:nil];
        
    });
    dispatch_group_enter(group_data);
    dispatch_group_async(group_data, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
#pragma mark--请求部门人员的数据
        // 查询部门人员
        NSDictionary *paramDic = [NSDictionary dictionaryWithObject:self.deptId forKey:@"deptId"];
        [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, selfMessageAllPerson] isNeedCache:NO parameters:paramDic successBlock:^(id response) {
            DLog(@"人员的数据:%@", response);
            dispatch_group_leave(group_data);
            if (1 == [[response objectForKey:@"code"] integerValue]) {
                self.dataPersonArray = [NSMutableArray arrayWithArray:[YSDataManager getTeamMyAllAuthorizedData:response]];
            }
        } failureBlock:^(NSError *error) {
            dispatch_group_leave(group_data);
        } progress:nil];
    });
    dispatch_group_enter(group_data);
    dispatch_group_async(group_data, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
#pragma mark--请求编制/在岗/入/离职的数据
        // 查询统计信息
        NSDictionary *paramDic = [NSDictionary dictionaryWithObject:self.deptId forKey:@"deptIds"];
        [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, getAuthorizedStrengthTotal] isNeedCache:NO parameters:paramDic successBlock:^(id response) {
            DLog(@"编制/在岗/入/离职的统计数据:%@", response);
            dispatch_group_leave(group_data);
            if (1==[[response objectForKey:@"code"] integerValue]) {
                if (self.isDown) {
                    [self.headerView upBottomNumberDataWith:response[@"data"]];
                }
                [self.upHeaderView upBottomNumberDataWith:response[@"data"]];
                
            }
        } failureBlock:^(NSError *error) {
            dispatch_group_leave(group_data);
            
        } progress:nil];
    });
    dispatch_group_notify(group_data, dispatch_get_main_queue(), ^{
        [QMUITips hideAllToastInView:self.view animated:NO];
        [self.tableView reloadData];
    });
}

// 点击数字选项
- (void)clickdeNumberOptionAction:(NSInteger)index {
    switch (index) {//部门名称的时候 会有一个死值判断 亚厦控股
        case 0:
            {//编制
                YSHRManagerTeamGViewController *teamVC = [YSHRManagerTeamGViewController new];
                teamVC.deptIds = self.deptId;
//                teamVC.deptName = self.headerModel.name;
                teamVC.deptName = self.headerView.titleLab.text;
                [self.navigationController pushViewController:teamVC animated:YES];
            }
            break;
        case 1:
            {//在岗
                YSHRMTWorkingViewController *workVC = [YSHRMTWorkingViewController new];
                workVC.deptIds = self.deptId;
//                workVC.deptName = self.headerModel.name;
                 workVC.deptName = self.headerView.titleLab.text;
                [self.navigationController pushViewController:workVC animated:YES];
            }
            break;
        case 2:
            {//入职
                YSManagerPositionHGViewController *positonVC = [YSManagerPositionHGViewController new];
                positonVC.positionType = PositionVCTypeEntry;
                positonVC.deptIds = self.deptId;
//                positonVC.deptName = self.headerModel.name;
                 positonVC.deptName = self.headerView.titleLab.text;
                [self.navigationController pushViewController:positonVC animated:YES];
            }
            break;
        case 3:
            {//离职
                YSManagerPositionHGViewController *positonVC = [YSManagerPositionHGViewController new];
                positonVC.positionType = PositionVCTypeLeave;
                positonVC.deptIds = self.deptId;
//                positonVC.deptName = self.headerModel.name;
                 positonVC.deptName = self.headerView.titleLab.text;
                [self.navigationController pushViewController:positonVC animated:YES];
            }
            break;
        default:
            break;
    }
}
#pragma mark--tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.isDown || self.dataDeparArray.count == section) {
        return 0.1;
    }else {
        return 84*kHeightScale;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 && self.isDown) {
        return [[UIView alloc] init];
    }else if (section == self.dataDeparArray.count) {
        return nil;
    }else {
        YSHRManagerDetailHeaderView *detailView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"companyHeaderSTR"];
        if (!detailView) {
             detailView = [[YSHRManagerDetailHeaderView alloc] initWithReuseIdentifier:@"companyHeaderSTR" withType:ItemSizeTypeCompany];
            detailView.delegate = self;
        }
        DLog(@"区头数据:%@--分区:%ld", self.dataDeparArray[section], section);
//        DLog(@"选中的数据:%@", self.oldChoseArray);
        if (self.dataDeparArray.count > section) {
            [detailView reloadCollectionViewWith:self.dataDeparArray[section] withChoseArray:self.choseDataDeptArray];
        }else {
            [detailView reloadCollectionViewWith:@[] withChoseArray:self.choseDataDeptArray];

        }
        detailView.oldChoseArray = self.oldChoseArray;
        for (int i = 0; i < self.oldChoseArray.count; i++) {
            if ([self.dataDeparArray[section] containsObject:self.oldChoseArray[i]]) {
                // 将所选中的cell移到中间
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.dataDeparArray[section] indexOfObject:self.oldChoseArray[i]] inSection:0];
                // 这个方法里面ChoseArray 暂时只是用数组的空与否来判断是否需要移动cell
                [detailView scrollToItemAtIndexPath:indexPath withChoseArray:self.choseDataDeptArray];

            }
        }
        /*
        if (self.choseDataDeptArray.count != 0 && section == [self.choseDataDeptArray[0] integerValue]) {
            // 将所选中的cell移到中间
            [detailView scrollToItemAtIndexPath:self.choseDataDeptArray[1] withChoseArray:self.choseDataDeptArray];
        }
*/
        return detailView;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 || self.dataDeparArray.count == section) {
        return 0.1;
    }
    return 10*kHeightScale;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72*kHeightScale;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isDown) {
        return 1;
    }else {
        return self.dataDeparArray.count+1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isDown) {
        return 1;
    }else if (section == self.dataDeparArray.count) {
        // 最后一个分区 显示的是人员
        if (!self.isDown) {
            return self.dataPersonArray.count;
        }
    }
    // 其他分区显示的是部门cell
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isDown) {
        // 第一个分区 一个箭头cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSHRManagerCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"YSHRManagerCell"];
            UIImageView *donwImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downYSManagerHG"]];
            donwImg.tag = 1010;
            [cell.contentView addSubview:donwImg];
            [donwImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(cell);
                make.size.mas_equalTo(CGSizeMake(18, 30));
            }];
            
        }
        if (self.isDown) {
            [(UIImageView*)[self.view viewWithTag:1010] setImage:[UIImage imageNamed:@"downYSManagerHG"]];
        }else {
            [(UIImageView*)[self.view viewWithTag:1010] setImage:[UIImage imageNamed:@"upYSManagerHG"]];
        }
        return cell;
    }else if (indexPath.section == self.dataDeparArray.count) {
        // 最后一个分区 显示的人员
        YSHRManagerHGBTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"bottomCellPerson" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.personModel = self.dataPersonArray[indexPath.row];
        return cell;
    }else {
        //其他分区 显示的部门 没有cell
        return nil;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && self.upHeaderView.alpha == 0) {
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:(CGRectZero)];
        self.isDown = NO;
        self.upHeaderView.alpha = 1;
        [self layoutTableView];
        [self.tableView reloadData];
    }else if (self.upHeaderView.alpha == 1) {
        YSTeamCompilePostModel *personModel = self.dataPersonArray[indexPath.row];

        // 人员分区
        YSHRManagerInfoHGViewController *infoVC = [[YSHRManagerInfoHGViewController alloc] init];
        infoVC.userNo = personModel.no;
        [self.navigationController pushViewController:infoVC animated:YES];
    }
}
#pragma mark--scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.upHeaderView.alpha == 0) {
        if (scrollView.contentOffset.y > 0) {
            self.upHeaderView.alpha = 1;
            self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:(CGRectZero)];
            self.isDown = NO;
            [self layoutTableView];
            self.tableView.scrollEnabled = NO;
            [self.tableView reloadData];
            self.tableView.scrollEnabled = YES;
        }
    }
}


#pragma mark-YSMHRManagerDelegate 点击区头
- (void)didCollectionItemActionWith:(NSArray*)dataArray {
    NSInteger index_chose = 0;
    for (int i = 0; i < self.dataDeparArray.count; i++) {
        if ([self.dataDeparArray[i] containsObject:dataArray[1]]) {
            index_chose = i;
        }
    }
    // 将老的选中 也显示出来
    if (self.oldChoseArray.count != 0) {
        if (index_chose > self.oldChoseArray.count-1) {
            // 先判断上次点击的是否跟本次点击的同级
            if (![[self.dataDeparArray objectAtIndex:index_chose] containsObject:[self.oldChoseArray lastObject]]) {
                // 不在同级 直接添加
                [self.oldChoseArray addObject:dataArray[1]];
            }else {
                // 在同级 先删除在添加
                [self.oldChoseArray removeLastObject];
                [self.oldChoseArray addObject:dataArray[1]];
            }
        }else if (index_chose <= self.oldChoseArray.count-1) {
            [self.oldChoseArray removeObjectsInRange:(NSMakeRange(index_chose, self.oldChoseArray.count-index_chose))];
            [self.oldChoseArray addObject:dataArray[1]];
        }
    }else {
        [self.oldChoseArray addObject:dataArray[1]];
    }

    //choseDataDeptArray 三个值 第一个是选中的模型所在tableView的分区数目 第二个是所选的模型在collectionView的位置 第三个是所选的模型
    [self.choseDataDeptArray removeAllObjects];
    
    [self.choseDataDeptArray addObject:@(index_chose)];
    [self.choseDataDeptArray addObjectsFromArray:dataArray];
    self.deptId = [dataArray[1] objectForKey:@"id"];

    if (![self.deptId isEqualToString:@""] && ![self.deptId isKindOfClass:[NSNull class]]) {
        [self.dataPersonArray removeAllObjects];
        [self loadDeptListData];
    }
    // 更新顶部个人视图 因为请求的子部门的接口 不返回leader
    self.headerModel = [YSHRMTDeptTreeModel yy_modelWithJSON:dataArray[1]];

    [self upHeaderSubViewInfoData];

}

// 点击导航条的搜索按钮
- (void)clickedSeachBarAction {
    YSHRManagerSearchSGViewController *searchVC = [YSHRManagerSearchSGViewController new];
    searchVC.placeholderStr = @"请输入姓名/工号";
    searchVC.searchURLStr = selfMessageAllPerson;
    searchVC.searchParamStr = @"keyword";
    
    NSMutableDictionary *paramDic = [NSMutableDictionary new];
    [paramDic setObject:self.deptHiddenIDStr forKey:@"departmentIds"];
    [paramDic setObject:@"" forKey:@"deptId"];
    searchVC.paramDic = paramDic;
    [self.navigationController pushViewController:searchVC animated:YES];
}
// 点击导航条上组织筛选按钮
- (void)clickedScreenBarAction {
    
    NSDictionary *dataDic = [YSNetManagerCache ys_httpCacheWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getDeptTree] parameters:nil];
    if (0 == [[dataDic objectForKey:@"data"] count]) {
        [QMUITips showInfo:@"无部门可选" inView:self.view hideAfterDelay:0.5];
        return;
    }
    YSHRMTDeptTreeViewController *deptVC = [YSHRMTDeptTreeViewController new];
    deptVC.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.4];
//    deptVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    // 自定义的模态动画
    deptVC.modalPresentationStyle = UIModalPresentationCustom;
    deptVC.transitioningDelegate = [YSRightToLeftTransition sharedYSTransition];
    
    deptVC.deptArray = [NSMutableArray arrayWithArray:[dataDic objectForKey:@"data"]];
    DLog(@"部门信息:%@", deptVC.deptArray);
    YSWeak;
    deptVC.choseDeptTreeBlock = ^(YSDeptTreePointModel * _Nonnull model) {
        weakSelf.deptId = model.point_id;
        [weakSelf.dataDeparArray removeAllObjects];
        [weakSelf.dataPersonArray removeAllObjects];
        [weakSelf.oldChoseArray removeAllObjects];
        [weakSelf.choseDataDeptArray removeAllObjects];
        weakSelf.tableView.tableHeaderView = [[UIView alloc] initWithFrame:(CGRectZero)];
        weakSelf.isDown = NO;
        weakSelf.upHeaderView.alpha = 1;
        [weakSelf layoutTableView];
        [weakSelf loadData];
    };
    [self presentViewController:deptVC animated:YES completion:nil];
}

#pragma mark--setter&&getter
- (NSMutableArray *)oldChoseArray {
    if (!_oldChoseArray) {
        _oldChoseArray = [NSMutableArray new];
    }
    return _oldChoseArray;
}
- (NSMutableArray *)choseDataDeptArray {
    if (!_choseDataDeptArray) {
        _choseDataDeptArray = [NSMutableArray new];
    }
    return _choseDataDeptArray;
}
- (NSMutableArray *)dataDeparArray {
    if (!_dataDeparArray) {
        _dataDeparArray = [NSMutableArray new];
    }
    return _dataDeparArray;
}
- (NSMutableArray *)dataPersonArray {
    if (!_dataPersonArray) {
        _dataPersonArray = [NSMutableArray new];
    }
    return _dataPersonArray;
}
- (void)temaBack {
    if (self.upHeaderView.alpha == 1) {
        self.isDown = YES;
        self.dataDeparArray = [NSMutableArray new];
        self.dataDeparArray = [NSMutableArray new];
        self.dataPersonArray = [NSMutableArray new];
        self.oldChoseArray = [NSMutableArray new];
        self.choseDataDeptArray = [NSMutableArray new];
        [self layoutTableView];
        self.tableView.tableHeaderView = self.headerView;
        [self backInitialState:nil];
//        [self.tableView reloadData];
        self.upHeaderView.alpha = 0;
    }else {
//        [YSNetManager ys_cancelRequestWithURL:[NSString stringWithFormat:@"%@%@", YSDomain, selfMessageDept]];
//        [YSNetManager ys_cancelRequestWithURL:[NSString stringWithFormat:@"%@%@", YSDomain, selfMessageAllPerson]];
//        [YSNetManager ys_cancelRequestWithURL:[NSString stringWithFormat:@"%@%@", YSDomain, getAuthorizedStrengthTotal]];
        [QMUITips hideAllToastInView:self.view animated:NO];
        [YSNetManager ys_cancelAllRequest];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)dealloc {
    DLog(@"我的团队页面销毁");
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
