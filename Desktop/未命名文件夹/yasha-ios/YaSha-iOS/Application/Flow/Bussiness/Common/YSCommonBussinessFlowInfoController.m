//
//  YSCommonBussinessFlowInfoController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/4.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonBussinessFlowInfoController.h"
#import "YSFlowRecordListCell.h"
#import "UIView+Extension.h"
#import "LCSelectMenuView.h"
#import "YSContactModel.h"
#import "YSFlowAssociatedViewController.h"
#import "YSFlowDocumentationViewController.h"
#import "YSFlowMapViewController.h"

#import "YSFlowFormBottomView.h"
#import "YSFlowHandleViewController.h"
#import "YSFlowFormListCell.h"
#import "YSFlowEditCell.h"
#import "YSFlowBackGroundCell.h"
#import "YSFlowEmptyCell.h"


@interface YSCommonBussinessFlowInfoController ()<UITableViewDataSource, UITableViewDelegate,YSFlowRecordListCellDelegate>
@property (nonatomic,strong) UIButton *footButton;
@property (nonatomic,assign) BOOL scrollFlag; //手动滚动标志，防止点击菜单滚动触发didScroll代理方法造成菜单定位死循环
@property (nonatomic,strong) NSMutableArray *sectionLocationHeaderArray;
@property (nonatomic,strong) NSArray *sectionTitleArray;


@end

@implementation YSCommonBussinessFlowInfoController

- (NSArray *)sectionTitleArray {
    if (!_sectionTitleArray) {
        _sectionTitleArray = @[@"提交者附言",@"处理记录",@"转阅记录"];
    }
    return _sectionTitleArray;
}
- (YSBaseBussinessFlowViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[YSBaseBussinessFlowViewModel alloc]initWithFlowTpe:_flowType andflowInfo:_flowModel];
    }
    return _viewModel;
}
- (NSMutableArray *)sectionLocationHeaderArray{
    if (!_sectionLocationHeaderArray) {
        _sectionLocationHeaderArray = [NSMutableArray array];
    }
    return _sectionLocationHeaderArray;
}
- (UIView *)navView {
    if (!_navView) {
        _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kTopHeight)];
        [_navView setGradientBackgroundWithColors:@[kUIColor(84, 106, 253, 1),kUIColor(46, 193, 255, 1)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        //返回按钮
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(10*kWidthScale, 2*kHeightScale+kStatusBarHeight, 28*kWidthScale, 38*kWidthScale);
        [btn setImage:[UIImage imageNamed:@"返回白"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:btn];
        
        //控制器标题title
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(90*kWidthScale, kStatusBarHeight+11*kHeightScale, 195*kWidthScale, 22*kHeightScale)];
        titleLabel.text = @"流程详情";
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        [_navView addSubview:titleLabel];
    }
    return _navView;
}

- (LCSelectMenuView *)selectMenu{
    if (!_selectMenu) {
        _selectMenu = [LCSelectMenuView new];
        _selectMenu.alpha = 0;
        _selectMenu.frame = CGRectMake(0, kTopHeight, SCREEN_WIDTH, 44*kHeightScale);
        _selectMenu.titleArray = @[@"申请表单",@"附言记录",@"处理记录",@"转阅记录"];
        __weak typeof(self) _ws = self;
        [_selectMenu setPageSelectBlock:^(NSInteger index) {
            _ws.scrollFlag = YES;
            CGRect rect = [_ws.tableView rectForSection:index-1];
            CGFloat offsetY = rect.origin.y -44*kHeightScale;
            [_ws.tableView setContentOffset:CGPointMake(0, offsetY) animated:YES];
        }];
    }
    return _selectMenu;
}
- (YSFlowDetailsHeaderView *)functionHeaderView {
    if (!_functionHeaderView) {
        _functionHeaderView = [[YSFlowDetailsHeaderView alloc]init];
        [_functionHeaderView.flowButton setTitle:@"关联流程（0）" forState:UIControlStateNormal];
        [_functionHeaderView.documentButton setTitle:@"关联文档（0）" forState:UIControlStateNormal];
        [_functionHeaderView.flowButton addTarget:self action:@selector(jumpView:) forControlEvents:UIControlEventTouchUpInside];
        [_functionHeaderView.documentButton addTarget:self action:@selector(jumpView:) forControlEvents:UIControlEventTouchUpInside];
        [_functionHeaderView.chartButton addTarget:self action:@selector(jumpView:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _functionHeaderView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, kSCREEN_WIDTH, kSCREEN_HEIGHT-kTopHeight-kBottomHeight - 50*kHeightScale) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.bounces = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        _tableView.separatorColor = kGrayColor(224);
    }
    return _tableView;
}
- (UIButton *)footButton {
    if (!_footButton) {
        _footButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_footButton setTitle:@"查看全部" forState:UIControlStateNormal];
        [_footButton setTitleColor:kUIColor(0, 122, 255, 1) forState:UIControlStateNormal];
        [_footButton setTitle:@"没有更多了" forState:UIControlStateSelected];
        [_footButton setTitleColor:kGrayColor(204) forState:UIControlStateSelected];
        [_footButton addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footButton;
}

- (instancetype)initWithFlowType:(YSFlowType)type andFlowInfo:(YSFlowListModel *)flowModel {
    if (self = [super init]) {
        self.flowType = type;
        self.flowModel = flowModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.functionHeaderView;
    [self.tableView addSubview:self.selectMenu];
    
    self.coverNavView = [[YSFlowDetailsConerNavView alloc]init];
    self.coverNavView.alpha = 0;
    [self.coverNavView.flowButton addTarget:self action:@selector(jumpView:) forControlEvents:UIControlEventTouchUpInside];
    [self.coverNavView.documentButton addTarget:self action:@selector(jumpView:) forControlEvents:UIControlEventTouchUpInside];
    [self.coverNavView.chartButton addTarget:self action:@selector(jumpView:) forControlEvents:UIControlEventTouchUpInside];
    [self.coverNavView.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.coverNavView];
    //底部视图
    _flowFormBottomView = [[YSFlowFormBottomView alloc] init];
    [_flowFormBottomView setCellModel:_flowModel withFlowType:_flowType];
    [self.view addSubview:_flowFormBottomView];
    [_flowFormBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kBottomHeight);
        make.height.mas_equalTo(50*kHeightScale);
    }];
  
    if (_flowType == YSFlowTypeTodo && _flowModel.turnRead) {
        [_flowFormBottomView removeFromSuperview];
        self.tableView.frame = CGRectMake(0, kTopHeight, kSCREEN_WIDTH, kSCREEN_HEIGHT-kTopHeight-kBottomHeight);//移除
    }
    
    [self getCommonData];
    [self.viewModel checkTrans];
    [self monitorAction];
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

# pragma mark -- 设置状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - 获取数据
- (void)getCommonData {
    [self.viewModel fetchAssociaterFlowList:^{
        [self.functionHeaderView.flowButton setTitle:self.viewModel.associateBtnTitle forState:UIControlStateNormal];
    }];
    [self.viewModel fetchPostscriptList:^{
         [self.functionHeaderView.documentButton setTitle:self.viewModel.documentBtnTitle forState:UIControlStateNormal];
        [self.tableView reloadData];
    }];
    [self.viewModel fetchCommentsByProcess:^{
        [self.tableView reloadData];
        [self markSectionHeaderLocation];
        
    }];
    [self.viewModel fetchTurnReadList:^{
        [self.tableView reloadData];
        [self markSectionHeaderLocation];
    }];
	//获取关联文档
	[self.viewModel fetchAssociaterDocumentList:^{
	 [self.functionHeaderView.documentButton setTitle:self.viewModel.documentBtnTitle forState:UIControlStateNormal];
	}];
   
}


# pragma mark -- 视图跳转
- (void)jumpView:(UIButton *)btn {
    if (btn.tag == 10) {
        if (self.viewModel.associaterArr.count > 0) {
            YSFlowAssociatedViewController *associatedViewController = [[YSFlowAssociatedViewController alloc]init];
            associatedViewController.businessKey = self.flowModel.businessKey;
            associatedViewController.dataSourceArray = [self.viewModel.associaterArr mutableCopy];
            [self.navigationController pushViewController:associatedViewController animated:YES];
        }else {
            [QMUITips showInfo:@"暂无关联流程" inView:self.view hideAfterDelay:1.5];
        }
    }else if (btn.tag == 20){
        if (self.viewModel.attachArray.count > 0) {
            YSFlowDocumentationViewController *flowAttachPageController = [[YSFlowDocumentationViewController alloc] init];
			flowAttachPageController.attachArray = self.viewModel.attachArray;
            [self.navigationController pushViewController:flowAttachPageController animated:YES];
        }else{
            [QMUITips showInfo:@"暂无关联文档" inView:self.view hideAfterDelay:1.5];
        }
        
    }else if (btn.tag == 30){
        YSFlowMapViewController *flowMapViewController = [[YSFlowMapViewController alloc] init];
        flowMapViewController.urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getApplyMapByIdForMobileApi, self.flowModel.processInstanceId];
        [self.navigationController pushViewController:flowMapViewController animated:YES];
    }
}




# pragma mark -- tableView delegate
//在数据加载完后，从新设置定位位置
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self markSectionHeaderLocation];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.viewModel.dataSourceArray.count;
    }else if (section == 1){
        return self.postscriptSeeMore ? self.viewModel.postscriptArray.count: (self.viewModel.postscriptArray.count > 3 ?  3:self.viewModel.postscriptArray.count);
    }else if (section == 2){
        return self.viewModel.handleRecordArray.count;
    }else if (section == 3){
        return self.turnSeeMore ? self.viewModel.turnReadArray.count: (self.viewModel.turnReadArray.count > 3 ?  3:self.viewModel.turnReadArray.count);
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0://表单内容
        {
            NSDictionary *dataDic = self.viewModel.dataSourceArray[indexPath.row];
            if ([dataDic[@"special"] integerValue] == BussinessFlowCellEdit) {
                YSFlowEditCell *cell = [[YSFlowEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.titleLb.text = dataDic[@"title"];
                return cell;
            }else if([dataDic[@"special"] integerValue] == BussinessFlowCellBG){
                YSFlowBackGroundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSFlowBackGroundCell"];
                if (cell == nil) {
                    cell = [[YSFlowBackGroundCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSFlowBackGroundCell"];
                }
                cell.lableNameLabel.text = dataDic[@"title"];
                cell.valueLabel.text = dataDic[@"content"];
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kSCREEN_WIDTH);
                return cell;
                
            }else if([dataDic[@"special"] integerValue] == BussinessFlowCellEmpty){
				YSFlowEmptyCell *cell = [[YSFlowEmptyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil background:dataDic[@"bgColor"]];
                 cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kSCREEN_WIDTH);
                return cell;
                
            }else{
                YSFlowFormListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSFlowFormListCell"];
                
                if (cell == nil) {
                    cell = [[YSFlowFormListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSFlowFormListCell"];
                }
                [cell setCommonBusinessFlowDetailWithDictionary:self.viewModel.dataSourceArray[indexPath.row]];
                return cell;
            }
            
        }
            break;
		case 1://提交者附言
        {
            YSFlowFormListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSFlowFormListCell"]; //出列可重用的cell
            if (cell == nil) {
                cell = [[YSFlowFormListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSFlowFormListCell"];
            }
            [cell setCommonBusinessFlowDetailWithDictionary:self.viewModel.postscriptArray[indexPath.row]];
            return cell;
        }
            break;
        case 2://处理记录
        {
            YSFlowRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSFlowRecordListCell"]; //出列可重用的cell
			cell.delegate = self;
            if (cell == nil) {
                cell = [[YSFlowRecordListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSFlowRecordListCell"];
            }
            if (self.viewModel.handleRecordArray.count > 0) {
                YSFlowRecordListModel *model = self.viewModel.handleRecordArray[indexPath.row];
                [cell setRecordListCellModel:model andIndexPath:indexPath];

            }
            return cell;
        }
            break;
        default://转阅记录
        {
            YSFlowRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSFlowRecordListCell"]; //出列可重用的cell
            if (cell == nil) {
                cell = [[YSFlowRecordListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSFlowRecordListCell"];
            }
            if (self.viewModel.turnReadArray.count > 0) {
                YSFlowRecordListModel *cellModel = self.viewModel.turnReadArray[indexPath.row];
                [cell setRecordListCellModel:cellModel andIndexPath:indexPath];
            }
            return cell;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }else{
        return 42*kHeightScale;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3 && self.viewModel.turnReadArray.count > 0) {
        return 42*kHeightScale;
    }else if(section == 1 && self.viewModel.postscriptArray.count > 0){
        return 42*kHeightScale;
    }else{
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return nil;
    }else{
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        UIButton *footButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (section == 1) {
            if ((self.postscriptSeeMore || self.viewModel.postscriptArray.count <= 3)&&self.viewModel.postscriptArray.count >0) {
                [footButton setTitle:@"没有更多了" forState:UIControlStateNormal];
                [footButton setTitleColor:kGrayColor(204) forState:UIControlStateNormal];
            }
            if (!self.postscriptSeeMore && self.viewModel.postscriptArray.count >3) {
                [footButton setTitle:@"查看全部" forState:UIControlStateNormal];
                [footButton setTitleColor:kUIColor(0, 122, 255, 1) forState:UIControlStateNormal];
            }
        }
        if (section == 3) {
            if (self.turnSeeMore || (self.viewModel.turnReadArray.count <= 3 && self.viewModel.turnReadArray.count >0)) {
                [footButton setTitle:@"没有更多了" forState:UIControlStateNormal];
                [footButton setTitleColor:kGrayColor(204) forState:UIControlStateNormal];
            }
            if (!self.turnSeeMore && self.viewModel.turnReadArray.count >3) {
                [footButton setTitle:@"查看全部" forState:UIControlStateNormal];
                [footButton setTitleColor:kUIColor(0, 122, 255, 1) forState:UIControlStateNormal];
            }
        }
        footButton.tag = section;
        [footButton addTarget:self action:@selector(showMore:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:footButton];
        [footButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        return view;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }else{
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:243/255.0 green:244/255.0 blue:245/255.0 alpha:1];
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        if (section == 1) {
            label.text = [NSString stringWithFormat:@"%@(%lu)",self.sectionTitleArray[section-1],(unsigned long)self.viewModel.postscriptArray.count];
        }else if (section == 2) {
            label.text = [NSString stringWithFormat:@"%@(%lu)",self.sectionTitleArray[section-1],(unsigned long)self.viewModel.handleRecordArray.count];
        }else if (section == 3){
            label.text = [NSString stringWithFormat:@"%@(%lu)",self.sectionTitleArray[section-1],(unsigned long)self.viewModel.turnReadArray.count];
        }else {
            label.text = self.sectionTitleArray[section];
        }
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view.mas_top).offset(8);
            make.left.mas_equalTo(view.mas_left).offset(16);
            make.bottom.mas_equalTo(view.mas_bottom).offset(-8);
            make.right.mas_equalTo(view.mas_right).offset(-16);
        }];
        return view;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30*kHeightScale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


//
- (void)showMore:(UIButton *)btn {
    if (btn.tag == 1) {
        self.postscriptSeeMore = YES;
    }
    if (btn.tag == 3) {
        self.turnSeeMore = YES;
    }
    [self.tableView reloadData];
    
    [self markSectionHeaderLocation];
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.scrollFlag = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= 0) {
        self.coverNavView.alpha = 0;
    }else{
        //悬浮菜单
        [self hangOnMenu:offsetY];
        //菜单联动
        [self updateMenuTitle:offsetY];
    }
}

/**
 联动过程步骤title
 */
- (void)updateMenuTitle:(CGFloat)contentOffsetY{
    if(!_scrollFlag){
        //遍历
        for (int i = 0; i<self.sectionLocationHeaderArray.count; i++) {
            //最后一个按钮
            if (i == self.sectionLocationHeaderArray.count - 1) {
                if (contentOffsetY >= [self.sectionLocationHeaderArray[i] floatValue]) {
                    [self.selectMenu setCurrentPage:i];
                }
            }else{
                if (contentOffsetY >= [self.sectionLocationHeaderArray[i] floatValue] && contentOffsetY < [self.sectionLocationHeaderArray[i+1] floatValue]) {
                    [self.selectMenu setCurrentPage:i];
                }
            }
        }
    }
}


- (void)markSectionHeaderLocation{
    
    self.sectionLocationHeaderArray = nil;
    //计算对应每个分组头的位置
    for (int i = 0; i < self.selectMenu.titleArray.count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
        CGRect headerFrame = [self.tableView rectForHeaderInSection:indexPath.section];
        //第一组的偏移量比其他组少10
        //        CGFloat offsetHeaderY = (headerFrame.origin.y+10*(i+1)+kTopHeight+44*kHeightScale);
        CGFloat offsetHeaderY = (headerFrame.origin.y-kTopHeight);
        [self.sectionLocationHeaderArray addObject:[NSNumber numberWithFloat:offsetHeaderY]];
    }
}

- (void)hangOnMenu:(CGFloat)offsetY{
    
    if (offsetY > 130) {
        //防止多次更改页面层级
        if ([self.selectMenu.superview isEqual:self.view]) {
            self.functionHeaderView.alpha = 0;
            self.navView.alpha = 0;
            self.coverNavView.alpha = 1;
            self.selectMenu.alpha = 1;
            return;
        }
        //加载到view上
        self.selectMenu.frame = CGRectMake(0, kTopHeight, SCREEN_WIDTH, 44*kHeightScale);
        
        [self.selectMenu  setGradientBackgroundWithColors:@[kUIColor(84, 106, 253, 1),kUIColor(46, 193, 255, 1)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        [self.view addSubview:self.selectMenu];
    }else{
        self.functionHeaderView.alpha = 1;
        self.navView.alpha = 1;
        self.coverNavView.alpha = 0;
        self.selectMenu.alpha = 0;
    }
}

/** 处理/转阅 */
- (void)monitorAction {
    YSWeak;
    [_flowFormBottomView.sendActionSubject subscribeNext:^(UIButton *button) {
        YSStrong;
        YSFlowHandleViewController *flowHandleViewController = [[YSFlowHandleViewController alloc] init];
        flowHandleViewController.cellModel = strongSelf.flowModel;
        if (button.tag == 0) {
            QMUIAlertAction *action0 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
                
            }];
            QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"审批" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                flowHandleViewController.flowHandleType = FlowHandleTypeApproval;
                [strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
            }];
            QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"驳回" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                flowHandleViewController.flowHandleType = FlowHandleTypeReject;
                [strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
            }];
            QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"审批并加签" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                flowHandleViewController.flowHandleType = FlowHandleTypeAdd;
                [strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
            }];
            QMUIAlertAction *action4 = [QMUIAlertAction actionWithTitle:@"转办" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                flowHandleViewController.flowHandleType = FlowHandleTypeChange;
                [strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
            }];
            QMUIAlertAction *action5 = [QMUIAlertAction actionWithTitle:@"暂存" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                flowHandleViewController.flowHandleType = FlowHandleTypeSave;
                [strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
            }];
            QMUIAlertAction *action6 = [QMUIAlertAction actionWithTitle:@"评审" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                flowHandleViewController.flowHandleType = FlowHandleTypeReview;
                [strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
            }];
            
            QMUIAlertAction *action7 = [QMUIAlertAction actionWithTitle:@"协同" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                flowHandleViewController.flowHandleType = YSFlowHandleTypeSynergy;
                [strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
            }];
            
            QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:QMUIAlertControllerStyleActionSheet];
            
            [alertController addAction:action0];
            
            if( [strongSelf.flowModel.taskType isEqualToString:FlowTaskPS]){
                [alertController addAction:action6];
            }else if([strongSelf.flowModel.taskType isEqualToString:FlowTaskXT]){
                [alertController addAction:action7];
            }else{
                [alertController addAction:action1];
                [alertController addAction:action2];
                [alertController addAction:action3];
            }
            
            [alertController addAction:action4];
            [alertController addAction:action5];
            [alertController showWithAnimated:YES];
        } else if (button.tag == 2) {
            flowHandleViewController.flowHandleType = FlowHandleTypeRevoke;
            [strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
        } else {
            flowHandleViewController.flowHandleType = FlowHandleTypeTrans;
            [strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
            
        }
    }];
}

#pragma YSFlowRecordListCellDelegate  代理方法
- (void)recordListCellCallButtonDidClick:(NSString *)userid {
	[self.viewModel callPhone:userid withFailueBlock:^(NSString * _Nonnull message) {
		[QMUITips showError:@"暂无可用号码" inView:self.view hideAfterDelay:1.0];
	}];
}
#pragma mark -- 返回上一页
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
