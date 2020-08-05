//
//  YSFlowDetailsViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/7/30.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowCustomDetailController.h"
#import "YSFlowDetailsConerNavView.h"
#import "YSFlowDetailsHeaderView.h"
#import "YSFlowFormListCell.h"
#import "YSFlowRecordListCell.h"
#import "LCSelectMenuView.h"
#import "YSFlowRecordListModel.h"
#import "YSFlowMapViewController.h"
#import "UIView+Extension.h"
#import "YSFlowDocumentationViewController.h"
#import "YSFlowAssociatedViewController.h"
#import "YSFlowSubFormListViewController.h"
#import "YSContactModel.h"
static NSString *cellPostscriptList = @"FlowPostscriptListCell";
static NSString *cellExaminationList = @"FlowExaminationListCell";
static NSString *cellIdentifierFlow = @"FlowTransferListCell";

@interface YSFlowCustomDetailController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,YSFlowRecordListCellDelegate>
@property (nonatomic,strong) UIView *navView;
@property (nonatomic,strong) YSFlowDetailsConerNavView *coverNavView;
@property (nonatomic,strong) YSFlowDetailsHeaderView *functionHeaderView;
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) UIButton *footButton;
@property (nonatomic, strong) YSFlowFormModel *flowFormModel;
@property (nonatomic,assign) BOOL scrollFlag; //手动滚动标志，防止点击菜单滚动触发didScroll代理方法造成菜单定位死循环
@property (nonatomic,strong) LCSelectMenuView *selectMenu;
@property (nonatomic,strong) NSMutableArray *sectionLocationHeaderArray;
@property (nonatomic,strong) NSMutableArray *dataSourceArray;
@property (nonatomic,strong) NSMutableArray *recordArray;
@property (nonatomic,strong) NSMutableArray *turnArray;
@property (nonatomic,strong) NSMutableArray *postscriptArray;
@property (nonatomic,assign) Boolean flagApprovalOne;
@property (nonatomic,assign) Boolean flagApprovalThree;
@property (nonatomic,copy) NSMutableArray *associaterArr;
@property (nonatomic,copy) NSArray *documentAr;
@property (nonatomic,strong) NSMutableArray *fileArray;
@property (nonatomic,strong) NSMutableDictionary *heightAtIndexPath;//缓存高度
@property (nonatomic, assign) BOOL isFailure;//网络失败提示

@end

@implementation YSFlowCustomDetailController

#pragma mark -- 懒加载
- (NSMutableArray *)associaterArr {
	if (!_associaterArr) {
		_associaterArr = [NSMutableArray array];
	}
	return _associaterArr;
}
- (NSMutableArray *)fileArray {
	if (!_fileArray) {
		_fileArray = [NSMutableArray array];
	}
	return _fileArray;
}
- (NSMutableDictionary *)heightAtIndexPath {
	if (!_heightAtIndexPath) {
		_heightAtIndexPath = [NSMutableDictionary dictionary];
	}
	return _heightAtIndexPath;
}
- (UIView *)navView {
	if (!_navView) {
		_navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kTopHeight)];
		[_navView setGradientBackgroundWithColors:@[kUIColor(84, 106, 253, 1),kUIColor(46, 193, 255, 1)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
		UIButton *btn = [[UIButton alloc]init];
		btn.frame = CGRectMake(10*kWidthScale, 2*kHeightScale+kStatusBarHeight, 28*kWidthScale, 38*kHeightScale);
		[btn setImage:[UIImage imageNamed:@"返回白"] forState:UIControlStateNormal];
		btn.imageView.contentMode = UIViewContentModeCenter;
		[btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
		[_navView addSubview:btn];
		
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
			CGRect rect = [_ws.mainTableView rectForSection:index-1];
			CGFloat offsetY = rect.origin.y -44*kHeightScale;
			[_ws.mainTableView setContentOffset:CGPointMake(0, offsetY) animated:YES];
		}];
	}
	return _selectMenu;
}
- (UITableView *)mainTableView{
	if (!_mainTableView) {
		if (self.attendanceJumpStr.length > 0) {
			_mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight-kBottomHeight) style:UITableViewStyleGrouped];
		}else{
			_mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-50*kHeightScale-kTopHeight-kBottomHeight) style:UITableViewStyleGrouped];
		}
		_mainTableView.delegate = self;
		_mainTableView.dataSource = self;
		_mainTableView.bounces = NO;
		self.functionHeaderView = [[YSFlowDetailsHeaderView alloc]init];
		//关联流程监听事件
		[self.functionHeaderView.flowButton addTarget:self action:@selector(jumpView:) forControlEvents:UIControlEventTouchUpInside];
		//关联文档监听事件
		[self.functionHeaderView.documentButton addTarget:self action:@selector(jumpView:) forControlEvents:UIControlEventTouchUpInside];
		//流程视图监听事件
		[self.functionHeaderView.chartButton addTarget:self action:@selector(jumpView:) forControlEvents:UIControlEventTouchUpInside];
		_mainTableView.tableHeaderView = self.functionHeaderView;
		[_mainTableView addSubview:self.selectMenu];
	}
	return _mainTableView;
}
- (NSMutableArray *)sectionLocationHeaderArray{
	if (!_sectionLocationHeaderArray) {
		_sectionLocationHeaderArray = [NSMutableArray new];
	}
	return _sectionLocationHeaderArray;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.dataSourceArray = [NSMutableArray array];
	self.recordArray = [NSMutableArray array];
	self.postscriptArray = [NSMutableArray array];
	self.turnArray = [NSMutableArray array];
	[self.view addSubview:self.mainTableView];
	[self.view addSubview:self.navView];
	self.coverNavView = [[YSFlowDetailsConerNavView alloc]init];
	self.coverNavView.alpha = 0;
	[self.coverNavView.flowButton addTarget:self action:@selector(jumpView:) forControlEvents:UIControlEventTouchUpInside];
	[self.coverNavView.documentButton addTarget:self action:@selector(jumpView:) forControlEvents:UIControlEventTouchUpInside];
	[self.coverNavView.chartButton addTarget:self action:@selector(jumpView:) forControlEvents:UIControlEventTouchUpInside];
	[self.coverNavView.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.coverNavView];
	[self monitorAction];
	[self doNetworking];
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:NO];
}
//设置状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}
//返回上一页
- (void)back{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)doNetworking {
	[QMUITips showLoadingInView:self.view];
	//请求1
	NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/%@", YSDomain, getUserDefineDetailApi,self.cellModel.processDefinitionKey, self.cellModel.businessKey];
	//NSString *urlString = @"https://imapitest.chinayasha.com/yahu-rest/flowCenter/userDefine/getUserDefineDetail/MGJCW0003/MGJCW00034742";
	
	[YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
		DLog(@"获取自定义流程获取详情:%@", response);
		[QMUITips hideAllTipsInView:self.view];
		if ([response[@"code"] intValue] == 1) {
			self.flowFormModel = [YSFlowFormModel yy_modelWithJSON:response[@"data"]];
			self.coverNavView.titleLabel.text = self.flowFormModel.baseInfo.title;
			[self.functionHeaderView setHeaderModel:self.flowFormModel.baseInfo];
			self.attachArray = [YSDataManager getFlowFormAttachFileListData:response];
			NSArray  *formDataArray = self.flowFormModel.dataInfo;
			//备注：datetime这个字段会返回时间措或者时间格式，在转model的时候处理了
			for (int i = 0 ; i < formDataArray.count; i++) {
				YSFlowFormListModel *model = formDataArray[i];
				if ([model.fieldType isEqual:@"subform"]) {//子表单
					if (model.values.count > 0) {
						[self.dataSourceArray addObject:model];
					}
				}else if([model.fieldType isEqual:@"upload"]){//附件
					
					if (self.attachArray.count > 0) {
						[self.dataSourceArray addObject:model];
					}
				}else if([model.fieldType isEqual:@"usermsg"]){//人员信息控件
					
					if (model.value.length > 0) {
						[self.dataSourceArray addObject:model];
					}
					for (int i = 0; i < model.values.count; i++) {
						YSFlowFormListModel *model1 = model.values[i];
						[self.dataSourceArray addObject:model1];
					}
					
				}else if([model.fieldType isEqual:@"projectmsg"]){//项目控件
					
					if (model.value.length > 0) {
						[self.dataSourceArray addObject:model];
					}
					for (int i = 0; i < model.values.count; i++) {
						YSFlowFormListModel *model1 = model.values[i];
						[self.dataSourceArray addObject:model1];
					}
					
				}else if ([model.fieldType isEqual:@"deptadmin"]){//部门管理父子控件
					
					if (model.value.length > 0) {
						[self.dataSourceArray addObject:model];
					}
					for (int i = 0; i < model.values.count; i++) {
						YSFlowFormListModel *model1 = model.values[i];
						[self.dataSourceArray addObject:model1];
					}
					
				}else if ([model.fieldType isEqual:@"bistable"]){//业务底表
					
					if (model.value.length > 0) {
						[self.dataSourceArray addObject:model];
					}
					for (int i = 0; i < model.values.count; i++) {
						YSFlowFormListModel *model1 = model.values[i];
						[self.dataSourceArray addObject:model1];
					}
				}else if ([model.fieldType isEqual:@"linkedflow"]){//关联流程
					
					if (model.value.length > 0) {
						[self.dataSourceArray addObject:model];
						//将关联流程添加到表头的关联流程里
						NSData *jsonData = [model.value dataUsingEncoding:NSUTF8StringEncoding];
						NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
						for (NSDictionary *dic in array) {//将流程信息添加到数组里
							YSFlowListModel *flowModel = [[YSFlowListModel alloc]init];
							flowModel.businessKey = dic[@"code"];
							flowModel.fromName = dic[@"formName"];
							flowModel.processDefinitionKey = dic[@"formCode"];
							
							flowModel.processInstanceId = dic[@"procInstId"];
							flowModel.taskId = dic[@"taskId"];
							flowModel.flowStatusName = dic[@"processStatusName"];
							flowModel.startPersonName = dic[@"startPersonName"];
							flowModel.processType = [dic[@"processType"] integerValue] == 0?1:2;
							[self.associaterArr addObject:flowModel];
							
						}
						if (self.associaterArr.count > 0) {
							[self.functionHeaderView.flowButton setTitle:[NSString stringWithFormat:@"关联流程(%lu)",(unsigned long)self.associaterArr.count] forState:UIControlStateNormal];
						}
						
					}
				}
				else{
					[self.dataSourceArray addObject:model];
				}
			}
			//                for (int i = 0; i < self.postscriptArray.count; i++) {
			//                    YSFlowRecordListModel *cellModel = self.postscriptArray[i];
			//                    [self.fileArray addObjectsFromArray:[YSDataManager getFlowFormDocumentationListData:cellModel.mobileFileVos]];
			//                }
			if (self.attachArray.count > 0 || self.fileArray.count > 0 ||self.documentAr.count > 0) {
				[self.functionHeaderView.documentButton setTitle:[NSString stringWithFormat:@"关联文档(%lu)",self.attachArray.count+self.fileArray.count+self.documentAr.count] forState:UIControlStateNormal];
			}
			NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
			
			[self.mainTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
			
		}
	} failureBlock:^(NSError *error) {
		
		DLog(@"error:%@", error);
		self.isFailure = YES;
	} progress:nil];
	
	//请求2
	//提交者附言
	NSString *urlStringPS = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getPostscriptListApi, self.cellModel.businessKey];
	
	[YSNetManager ys_request_GETWithUrlString:urlStringPS isNeedCache:NO parameters:nil successBlock:^(id response) {
		DLog(@"获取提交者附言:%@", response);
		
		if ([response[@"code"] intValue] == 1) {
			self.postscriptArray =[[YSDataManager getFlowRecordListData:response] copy];
			for (NSDictionary *dic in response[@"data"]) {
				[self.fileArray addObjectsFromArray:[[NSArray yy_modelArrayWithClass:[YSNewsAttachmentModel class] json:dic[@"mobileFileVos"]] mutableCopy]];
			}
			if (self.attachArray.count > 0 || self.fileArray.count > 0 ||self.documentAr.count > 0) {
				[self.functionHeaderView.documentButton setTitle:[NSString stringWithFormat:@"关联文档(%lu)",self.attachArray.count+self.fileArray.count+self.documentAr.count] forState:UIControlStateNormal];
			}
			NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
			
			[self.mainTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
			
		}
	} failureBlock:^(NSError *error) {
		
		self.isFailure = YES;
		DLog(@"error:%@", error);
	} progress:nil];
	
	//请求2
	//审批记录
	NSString *urlStringRecord = [NSString stringWithFormat:@"%@%@/%@/1", YSDomain, getCommentsByProcessInstanceIdApi, self.cellModel.processInstanceId];
	
	[YSNetManager ys_request_GETWithUrlString:urlStringRecord isNeedCache:NO parameters:nil successBlock:^(id response) {
		DLog(@"审批记录:%@", response);
		//[QMUITips hideAllTipsInView:self.view];
		if ([response[@"code"] intValue] == 1) {
			self.recordArray = [[YSDataManager getFlowRecordListData:response] mutableCopy];
			//                [self.mainTableView reloadData];
			NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:2];
			
			[self.mainTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
			
		}
	} failureBlock:^(NSError *error) {
		
		self.isFailure = YES;
	} progress:nil];
	
	
	//请求2
	//转阅记录列表
	NSString *urlStringTurn = [NSString stringWithFormat:@"%@%@/%@/2", YSDomain, getCommentsByProcessInstanceIdApi, self.cellModel.processInstanceId];
	[YSNetManager ys_request_GETWithUrlString:urlStringTurn isNeedCache:NO parameters:nil successBlock:^(id response) {
		DLog(@"处理列表:%@", response);
		//[QMUITips hideAllTipsInView:self.view];
		if ([response[@"code"] intValue] == 1) {
			self.turnArray = [[YSDataManager getFlowRecordListData:response] mutableCopy];
			//                [self.mainTableView reloadData];
			NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:3];
			
			[self.mainTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
			
		}
	} failureBlock:^(NSError *error) {
		
		self.isFailure = YES;
	} progress:nil];
	
	//关联流程
	NSString *urlStringAssociated = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getRelateFlowVo,self.cellModel.businessKey];
	[YSNetManager ys_request_GETWithUrlString:urlStringAssociated isNeedCache:NO parameters:nil successBlock:^(id response) {
		DLog(@"关联流程列表:%@", response);
		NSArray *flowArray = [NSArray yy_modelArrayWithClass:[YSFlowListModel class] json:response[@"data"]];
		[self.associaterArr addObjectsFromArray:flowArray];
		if (self.associaterArr.count > 0) {
			[self.functionHeaderView.flowButton setTitle:[NSString stringWithFormat:@"关联流程(%lu)",(unsigned long)self.associaterArr.count] forState:UIControlStateNormal];
		}
	} failureBlock:^(NSError *error) {
		[QMUITips hideAllToastInView:self.view animated:YES];
		[QMUITips showError:@"系统繁忙,请稍后再试"];
	} progress:nil];
	
	
	//关联文档
	NSString *urlStringDocument = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getAttachmentApi, self.cellModel.businessKey];
	[YSNetManager ys_request_GETWithUrlString:urlStringDocument isNeedCache:NO parameters:nil successBlock:^(id response) {
		DLog(@"获取关联文档:%@", response);
		self.documentAr = [YSDataManager getFlowAttachFileListData:response];
		if (self.documentAr.count > 0||self.fileArray.count > 0|| self.attachArray.count > 0) {
			[self.functionHeaderView.documentButton setTitle:[NSString stringWithFormat:@"关联文档(%lu)",(unsigned long)self.documentAr.count+self.fileArray.count+self.attachArray.count] forState:UIControlStateNormal];
		}
		
	} failureBlock:^(NSError *error) {
		[QMUITips hideAllToastInView:self.view animated:YES];
		[QMUITips showError:@"系统繁忙,请稍后再试"];
		DLog(@"error:%@", error);
	} progress:nil];
}

- (void)showMore:(UIButton *)btn {
	if (btn.tag == 1) {
		self.flagApprovalOne = YES;
	}
	if (btn.tag == 3) {
		self.flagApprovalThree = YES;
	}
	[self.mainTableView reloadData];
	
	[self markSectionHeaderLocation];
	
}

# pragma mark -- 视图跳转
- (void)jumpView:(UIButton *)btn {
	if (btn.tag == 10) {
		if (self.associaterArr.count > 0) {
			YSFlowAssociatedViewController *associatedViewController = [[YSFlowAssociatedViewController alloc]init];
			associatedViewController.businessKey = self.cellModel.businessKey;
			associatedViewController.dataSourceArray = [self.associaterArr mutableCopy];
			[self.navigationController pushViewController:associatedViewController animated:YES];
		}else {
			[QMUITips showInfo:@"暂无关联流程" inView:self.view hideAfterDelay:1.5];
		}
	}else if (btn.tag == 20){
		if (self.documentAr.count > 0 || self.fileArray.count > 0|| self.attachArray.count > 0) {
			YSFlowDocumentationViewController *flowAttachPageController = [[YSFlowDocumentationViewController alloc] init];
			NSMutableArray *attachArray = [NSMutableArray array];
			[attachArray addObjectsFromArray:self.attachArray];
			[attachArray addObjectsFromArray:self.fileArray];
			[attachArray addObjectsFromArray:self.documentAr];
			flowAttachPageController.attachArray = attachArray;
			[self.navigationController pushViewController:flowAttachPageController animated:YES];
		}else{
			[QMUITips showInfo:@"暂无关联文档" inView:self.view hideAfterDelay:1.5];
		}
		
	}else if (btn.tag == 30){
		YSFlowMapViewController *flowMapViewController = [[YSFlowMapViewController alloc] init];
		flowMapViewController.urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getApplyMapByIdForMobileApi, self.cellModel.processInstanceId];
		[self.navigationController pushViewController:flowMapViewController animated:YES];
	}
}

#pragma -mark- tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return self.dataSourceArray.count;
	}else if (section == 1){
		return self.flagApprovalOne ? self.postscriptArray.count: (self.postscriptArray.count > 3 ?  3:self.postscriptArray.count);
	}else if (section == 2){
		return self.recordArray.count;
	}else if (section == 3){
		return self.flagApprovalThree ? self.turnArray.count: (self.turnArray.count > 3 ?  3:self.turnArray.count);
	}else{
		return 0;
	}
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 200*kHeightScale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return UITableViewAutomaticDimension;
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return 0.01;
	}else{
		return 40*kHeightScale;
	}
}
//在数据加载完后，从新设置定位位置
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	[self markSectionHeaderLocation];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return nil;
	}else{
		NSArray *titleArray = @[@"提交者附言",@"处理记录",@"转阅记录"];
		UIView *view = [[UIView alloc]init];
		view.backgroundColor = [UIColor colorWithRed:243/255.0 green:244/255.0 blue:245/255.0 alpha:1];
		UILabel *label = [[UILabel alloc]init];
		label.font = [UIFont systemFontOfSize:12];
		label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
		if (section == 1) {
			label.text = [NSString stringWithFormat:@"%@(%lu)",titleArray[section-1],(unsigned long)self.postscriptArray.count];
		}else if (section == 2) {
			label.text = [NSString stringWithFormat:@"%@(%lu)",titleArray[section-1],(unsigned long)self.recordArray.count];
		}else if (section == 3){
			label.text = [NSString stringWithFormat:@"%@(%lu)",titleArray[section-1],(unsigned long)self.turnArray.count];
		}else {
			label.text = titleArray[section];
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if(section == 1 && self.postscriptArray.count > 0){
		return 40*kHeightScale;
	}else if (section == 2 && self.recordArray.count > 0) {
		return 0.01*kHeightScale;
	}else if (section == 3 && self.turnArray.count > 0) {
		return 40*kHeightScale;
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
			if ((self.flagApprovalOne || self.postscriptArray.count <= 3)&&self.postscriptArray.count >0) {
				[footButton setTitle:@"没有更多了" forState:UIControlStateNormal];
				[footButton setTitleColor:kGrayColor(204) forState:UIControlStateNormal];
			}
			if (!self.flagApprovalOne && self.postscriptArray.count >3) {
				[footButton setTitle:@"查看全部" forState:UIControlStateNormal];
				[footButton setTitleColor:kUIColor(0, 122, 255, 1) forState:UIControlStateNormal];
			}
		}
		if (section == 3) {
			if (self.flagApprovalThree || (self.turnArray.count <= 3 && self.turnArray.count >0)) {
				[footButton setTitle:@"没有更多了" forState:UIControlStateNormal];
				[footButton setTitleColor:kGrayColor(204) forState:UIControlStateNormal];
			}
			if (!self.flagApprovalThree && self.turnArray.count >3) {
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	if(indexPath.section == 0){
		YSFlowFormListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSFlowFormListCell"];
		if (cell == nil) {
			cell = [[YSFlowFormListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSFlowFormListCell"];
		}
		if (self.dataSourceArray.count > 0) {
			YSFlowFormListModel *cellModel = self.dataSourceArray[indexPath.row];
			[cell setCellModel:cellModel];
		}
		return cell;
	}else {
		YSFlowRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSFlowRecordListCell"];
		if (cell == nil) {
			cell = [[YSFlowRecordListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSFlowRecordListCell"];
		}
		cell.delegate = self;
		YSFlowRecordListModel *cellModel = nil;
		if (indexPath.section == 1) {
			cellModel = self.postscriptArray[indexPath.row];
		}else if (indexPath.section == 2){
			cellModel = self.recordArray[indexPath.row];
		}else{
			cellModel = self.turnArray[indexPath.row];
		}
		[cell setRecordListCellModel:cellModel andIndexPath:indexPath];
		
		return cell;
	}
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// 子表单跳转到新页面显示
	YSFlowFormListModel *cellModel = self.dataSourceArray[indexPath.row];
	if ([cellModel.fieldType isEqual:@"subform"]) {
		YSFlowSubFormListViewController *flowSubFormListViewController = [[YSFlowSubFormListViewController alloc] init];
		flowSubFormListViewController.dataSource = cellModel.values;
		flowSubFormListViewController.titleString = cellModel.lableName;
		[self.navigationController pushViewController:flowSubFormListViewController animated:YES];
		// url跳转
	}
	if ([cellModel.fieldType isEqual:@"url"]) {
		YSFlowMapViewController *flowMapViewController = [[YSFlowMapViewController alloc] init];
		flowMapViewController.title = cellModel.lableName;
		flowMapViewController.urlString = cellModel.value;
		[self.navigationController pushViewController:flowMapViewController animated:YES];
	}
}

- (void)callPhone:(NSString *)userId andTableViewCell:(YSFlowRecordListCell *) cell {
	YSWeak;
	[[[cell.callButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
		RLMResults *results = [YSContactModel objectsWhere:[NSString stringWithFormat:@"userId = '%@'AND isOrg = NO AND delFlag = '1' AND postStatus = '1' AND status = '1' AND isPublic != '0'", userId]];
		//点击立即联系，直接拨打人员信息中的手机字段号码，不需确认，点击一次即呼出。
		//若人员的手机字段号码为空，则默认拨打座机号码字段内容，不需确认，点击一次即呼出。
		//若上述两个字段内容均为空，则提示暂无可用号码（参考设计样式）
		if (results.count != 0) {
			YSContactModel *contactModel = results[0];
			if (contactModel.mobile.length) {
				[YSUtility openUrlWithType:YSOpenUrlCall urlString:contactModel.mobile];
			}else if (contactModel.phone.length) {
				[YSUtility openUrlWithType:YSOpenUrlCall urlString:contactModel.phone];
			}else{
				[QMUITips showError:@"暂无可用号码" inView:weakSelf.view hideAfterDelay:1.0];
			}
			
			
		} else {
			[QMUITips showError:@"暂无可用号码" inView:weakSelf.view hideAfterDelay:1.0];
		}
	}];
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
		CGRect headerFrame = [self.mainTableView rectForHeaderInSection:indexPath.section];
		//第一组的偏移量比其他组少10
		CGFloat offsetHeaderY = (headerFrame.origin.y+10*i-kTopHeight);
		NSLog(@"offsetFootY is %f",offsetHeaderY);
		[self.sectionLocationHeaderArray addObject:[NSNumber numberWithFloat:offsetHeaderY]];
	}
}

- (void)hangOnMenu:(CGFloat)offsetY{
	//    NSLog(@"=========%f",offsetY);
	if (offsetY > 110*kHeightScale) {
		//防止多次更改页面层级
		if ([self.selectMenu.superview isEqual:self.view]) {
			self.functionHeaderView.alpha = 0;
			self.navView.alpha = 0;
			self.coverNavView.alpha = 1;
			self.selectMenu.alpha = 1;
			return;
		}
		//加载到view上
		self.selectMenu.frame = CGRectMake(0, kTopHeight, SCREEN_WIDTH, 44);
		
		[self.selectMenu  setGradientBackgroundWithColors:@[kUIColor(84, 106, 253, 1),kUIColor(46, 193, 255, 1)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
		[self.view addSubview:self.selectMenu];
	}else{
		self.functionHeaderView.alpha = 1;
		self.navView.alpha = 1;
		self.coverNavView.alpha = 0;
		self.selectMenu.alpha = 0;
		
	}
}

- (void)dealloc {
	DLog(@"========释放");
}
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
#pragma YSFlowRecordListCellDelegate  代理方法
- (void)recordListCellCallButtonDidClick:(NSString *)userid
{
	RLMResults *results = [YSContactModel objectsWhere:[NSString stringWithFormat:@"userId = '%@'AND isOrg = NO AND delFlag = '1' AND postStatus = '1' AND status = '1' AND isPublic != '0'",userid]];
	//点击立即联系，直接拨打人员信息中的手机字段号码，不需确认，点击一次即呼出。
	//若人员的手机字段号码为空，则默认拨打座机号码字段内容，不需确认，点击一次即呼出。
	//若上述两个字段内容均为空，则提示暂无可用号码（参考设计样式）
	if (results.count != 0) {
		YSContactModel *contactModel = results[0];
		if (contactModel.mobile.length) {
			[YSUtility openUrlWithType:YSOpenUrlCall urlString:contactModel.mobile];
		}else if (contactModel.phone.length) {
			[YSUtility openUrlWithType:YSOpenUrlCall urlString:contactModel.phone];
		}else{
			[QMUITips showError:@"暂无可用号码" inView:self.view hideAfterDelay:1.0];
		}
		
		
	} else {
		[QMUITips showError:@"暂无可用号码" inView:self.view hideAfterDelay:1.0];
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
