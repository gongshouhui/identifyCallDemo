
//  YSEMSApplyTripViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/8.
//

#import "YSEMSApplyTripViewController.h"
#import "YSFormRowModel.h"
#import "YSContactModel.h"
#import "YSFormCommonCell.h"
#import "YSChoosePeopleVC.h"
#import "YSDingDingHeader.h"
#import "YSInternalModel.h"
#import "YSPersonalInformationModel.h"
#import "YSEMSAddTripViewController.h"
#import "YSEMSProListViewController.h"
#import "YSEMSProPageController.h"
#import "YSFormDatePickerCell.h"
#import "YSFormSwitchCell.h"
#import "YSContactSelectPersonViewController.h"

//现在可读性太差，没时间改。cell里面也不好动。。。,用model来记录两个页面的数据还有cell的数据，现在是rac传过来的，也可以不传在cell里面记录
@interface YSEMSApplyTripViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *configArray;
////通知传过去的内容
//NSDictionary *trip = @{@"rowModelArray": rowModelArray,
//@"payload": self.payload,
//@"buyTickets": [self.payload[@"buyTickets"] isEqual:@""] ? @"0" : @"1"};
//里面trip字典，一个行程一个字典
@property (nonatomic, strong) NSMutableArray *tripArray;
/**上传参数*/
@property (nonatomic, strong) NSMutableDictionary *payload;
@property (nonatomic, strong) NSMutableArray *tripListArray;
/**添加一个想成将是否车票代买添加进去，然后遍历只要有一个行程需要火车票代买，就必须填写身份证*/
@property (nonatomic, strong) NSMutableArray *buyTicketsArray;
@property (nonatomic, assign) BOOL needIdCard;
@property (nonatomic, assign) BOOL isProMember;

@property (nonatomic, strong) YSPersonalInformationModel *personalInformationModel;
@end

@implementation YSEMSApplyTripViewController

static NSString *cellIdentifier = @"FormCommonCell";
- (NSMutableArray *)configArray {
	if (!_configArray) {
		_configArray = [NSMutableArray array];
		NSMutableArray *section0Array = [NSMutableArray array];
		YSFormRowModel *model0 = [[YSFormRowModel alloc] init];
		model0.rowName = @"YSFormDetailCell";
		model0.necessary = YES;
		model0.title = @"出差人";//点击cell跳转选人
		model0.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		model0.paraKey = @"businessPname";
		
		YSFormRowModel *model1 = [[YSFormRowModel alloc] init];
		model1.rowName = @"YSFormDetailCell";
		model1.necessary = YES;
		model1.title = @"所属公司";
		
		YSFormRowModel *model2 = [[YSFormRowModel alloc] init];
		model2.rowName = @"YSFormTextFieldCell";
		model2.necessary = YES;
		model2.title = @"出差事由";
		model2.placeholder = @"请输入";
		model2.paraKey = @"remark";
		model2.editable = YES;
		
		YSFormRowModel *model3 = [[YSFormRowModel alloc] init];
		model3.rowName = @"YSFormDetailCell";
		model3.necessary = YES;
		model3.title = @"职务级别";
		model3.paraKey = @"jobLevelName";
		
		YSFormRowModel *model4 = [[YSFormRowModel alloc] init];
		model4.rowName = @"YSFormDatePickerCell";
		model4.necessary = YES;
		model4.title = @"出发日期";
		model4.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		model4.datePickerMode = PGDatePickerModeDate;
		model4.paraKey = @"startTime";
		
		YSFormRowModel *model5 = [[YSFormRowModel alloc] init];
		model5.rowName = @"YSFormDatePickerCell";
		model5.necessary = YES;
		model5.title = @"返程日期";
		model5.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		model5.datePickerMode = PGDatePickerModeDate;
		model5.paraKey = @"endTime";
		
		YSFormRowModel *model6 = [[YSFormRowModel alloc] init];
		model6.rowName = @"YSFormTextFieldCell";
		model6.title = @"身份证号";
		//model6.detailTitle = self.payload[@"idCard"];
		model6.placeholder = @"请输入";
		model6.checkoutType = YSCheckoutID;
		model6.paraKey = @"idCard";
		//新增出差性质
		YSFormRowModel *model7 = [[YSFormRowModel alloc] init];
		model7.rowName = @"YSFormOptionsCell";
		model7.title = @"出差性质";
		model7.optionsReturnType = YSFormOptionsReturnKey;
		model7.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		model7.necessary = YES;
		model7.optionsDataArray = @[
			@{@"ccd_nature_hy": @"会议"},
			@{@"ccd_nature_yx": @"营销"},
			@{@"ccd_nature_xm": @"项目"},
			@{@"ccd_nature_xx": @"学习"},
			@{@"ccd_nature_rs": @"人事"},
			@{@"ccd_nature_fw": @"法务"},
			@{@"ccd_nature_qt": @"其他"}
		];
		model7.paraKey = @"businessNature";
		
		
		YSFormRowModel *model8 = [[YSFormRowModel alloc] init];
		model8.rowName = @"YSFormSwitchCell";
		model8.title = @"是否项目人员";
		model8.paraKey = @"proPerson";
		
		[section0Array addObjectsFromArray:@[model0, model1, model2, model3, model4,model5, model6, model7,model8]];
		[_configArray addObjectsFromArray:@[section0Array]];
	}
	return _configArray;
}

- (NSMutableArray *)tripArray {
	if (!_tripArray) {
		_tripArray = [NSMutableArray array];
	}
	return _tripArray;
}

- (NSMutableDictionary *)payload {
	if (!_payload) {
		_payload = [NSMutableDictionary dictionary];
		[_payload setValue:self.tripListArray forKey:@"businessTripList"];
		
		[_payload setValue:@"" forKey:@"businessPno"];
		[_payload setValue:@"" forKey:@"businessPname"];
		[_payload setValue:@"" forKey:@"remark"];
		[_payload setValue:@"" forKey:@"jobLevelName"];
		[_payload setValue:@"0" forKey:@"areaCompany"];
		[_payload setValue:@"" forKey:@"startTime"];
		[_payload setValue:@"" forKey:@"endTime"];
		[_payload setValue:@"" forKey:@"idCard"];
		[_payload setValue:@"0" forKey:@"proPerson"];
		[_payload setValue:@"" forKey:@"proName"];
		[_payload setValue:@"" forKey:@"proManagerName"];
	}
	return _payload;
}

- (NSMutableArray *)tripListArray {
	if (!_tripListArray) {
		_tripListArray = [NSMutableArray array];
	}
	return _tripListArray;
}

- (NSMutableArray *)buyTicketsArray {
	if (!_buyTicketsArray) {
		_buyTicketsArray = [NSMutableArray array];
	}
	return _buyTicketsArray;
}

- (void)initSubviews {
	[super initSubviews];
	self.title = @"出差申请";
	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, kSCREEN_WIDTH, kSCREEN_HEIGHT - kTopHeight - kBottomHeight) style:UITableViewStyleGrouped];
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	[self.tableView registerClass:[YSFormCommonCell class] forCellReuseIdentifier:cellIdentifier];
	[self.view addSubview:self.tableView];
	UIView *backView = [UIView new];
	backView.backgroundColor = kGrayColor(239);
	[self.view addSubview:backView];
	[backView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.mas_equalTo(0);
		make.bottom.mas_equalTo(-kBottomHeight);
		make.height.mas_equalTo(60*kHeightScale);
	}];
	QMUIButton *addTripButton = [YSUIHelper generateDarkFilledButton];
	[addTripButton setTitle:@"添加行程" forState:UIControlStateNormal];
#pragma mark 添加行程
	YSWeak;
	[[addTripButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		YSStrong;
		/** 检验数据完整性 */
		for (YSFormRowModel *rowModel in strongSelf.configArray[0]) {
			if (rowModel.necessary == YES) {
				if (!rowModel.detailTitle.length) {
					[QMUITips showError:[NSString stringWithFormat:@"请填写%@",rowModel.title] inView:strongSelf.view hideAfterDelay:1];
					return;

				}
			}
		}
		
		YSEMSAddTripViewController *addTripViewController = [[YSEMSAddTripViewController alloc]init];
			addTripViewController.emsArr = strongSelf.configArray;
		addTripViewController.personmModel = strongSelf.personalInformationModel;
			[strongSelf.navigationController pushViewController:addTripViewController animated:YES];
	}];
		
	self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
	[backView addSubview:addTripButton];
	[addTripButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.mas_equalTo(backView.mas_centerX);
		make.bottom.mas_equalTo(backView.mas_bottom).offset(-5*kHeightScale);
		make.size.mas_equalTo(CGSizeMake(300*kWidthScale, 50*kHeightScale));
	}];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectPerson:) name:KNotificationPostSelectedPerson object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTrip:) name:@"AddTripNotification" object:nil];
	[self getUserInfo];
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}
- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
	[super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
	self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"提交" position:QMUINavigationButtonPositionRight target:self action:@selector(submit)];
	
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.configArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSArray *rowArray = self.configArray[section];
	return rowArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	YSFormRowModel *cellModel = self.configArray[indexPath.section][indexPath.row];
	YSFormCommonCell *cell = [[NSClassFromString(cellModel.rowName) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	[cell setCellModel:cellModel];
	YSWeak;
	__weak __typeof(cell) weakCell = cell;
	//，用于返回，选择的值
	[cell.sendValueSubject subscribeNext:^(id x) {
		YSStrong;
		[strongSelf.payload setValue:x forKey:cellModel.paraKey];//记录上传参数
		
		cellModel.detailTitle = x;//有改变model记录下，不用rac也可以在cell里面记录现在放在控制器记录
		
		// 控制时间范围
		
		if ([cellModel.title isEqualToString:@"出发日期"]) {
			
			NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
			[formatter setDateFormat:@"yyyy-MM-dd"];
			//限制返程日期范围
			YSFormRowModel *model5 = strongSelf.configArray[indexPath.section][indexPath.row + 1];//返程日期
			model5.minimumDate = [formatter dateFromString:strongSelf.payload[@"startTime"]];
			model5.maximumDate = [strongSelf getPriousorLaterDateFromDate:[formatter dateFromString:strongSelf.payload[@"startTime"]] withMonth:1];
		}
		// 控制时间范围
		if ([cellModel.title isEqualToString:@"返程日期"]) {
			NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
			[formatter setDateFormat:@"yyyy-MM-dd"];
			YSFormRowModel *model4 = strongSelf.configArray[indexPath.section][indexPath.row - 1];//上一行
			model4.maximumDate = [formatter dateFromString:strongSelf.payload[@"endTime"]];
		}
		
		
		if ([cellModel.title isEqualToString:@"是否项目人员"]&& [x isEqual:@"1"]) {//是否项目人员,并选择了是
			
			cellModel.switchStatus = YES;
			YSFormRowModel *proNameModel = [[YSFormRowModel alloc] init];
			proNameModel.rowName = @"YSFormDetailCell";
			proNameModel.necessary = YES;
			proNameModel.title = @"工程项目名称";
			proNameModel.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			
			
			YSFormRowModel *mangerModel = [[YSFormRowModel alloc] init];
			mangerModel.rowName = @"YSFormDetailCell";
			mangerModel.necessary = YES;
			mangerModel.title = @"项目经理";
			
			//刷新下面两行
			[strongSelf.tableView beginUpdates];
			[strongSelf.configArray[0] addObjectsFromArray:@[proNameModel, mangerModel]];
			[strongSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0], [NSIndexPath indexPathForRow:indexPath.row + 2 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
			[strongSelf.tableView endUpdates];
		}
		
		if ([cellModel.title isEqualToString:@"是否项目人员"] && [x isEqual:@"0"]) {
			cellModel.switchStatus = NO;
			[strongSelf.configArray[0] removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, indexPath.row + 2)]];
			[strongSelf.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0], [NSIndexPath indexPathForRow:indexPath.row + 2 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
		}
	}];
	
	//多选信号订阅
	[cell.sendOptionsSubject subscribeNext:^(NSDictionary *optionDic) {
		YSStrong;
		cellModel.detailTitle = optionDic.allValues.firstObject;
		[strongSelf.payload setValue:optionDic.allKeys.firstObject forKey:cellModel.paraKey];//记录上传参数
		//试着将上传key存在cellModel里？摆脱行数的限制
	}];
	
	
	
	
	//编辑行程  信号订阅
	[cell.sendEditSectionSubject subscribeNext:^(YSFormRowModel *rowModel) {
		YSStrong;
		YSEMSAddTripViewController *EMSAddTripViewController  = [[YSEMSAddTripViewController alloc]init];
		NSIndexPath *indexPath = [strongSelf.tableView indexPathForCell:weakCell];
		EMSAddTripViewController.isEditing = YES;
		EMSAddTripViewController.editingIndexPath = indexPath;
		EMSAddTripViewController.emsArr = strongSelf.configArray;
		EMSAddTripViewController.payload = strongSelf.tripListArray[indexPath.section - 1];
		NSMutableArray *tripArray = [[NSMutableArray alloc]initWithArray:strongSelf.configArray[indexPath.section]];
		[tripArray removeObjectAtIndex:0];
		EMSAddTripViewController.tripInfoArray = tripArray;
		
		
		[strongSelf.navigationController pushViewController:EMSAddTripViewController animated:YES];
	}];
	[cell.sendDeleteSectionSubject subscribeNext:^(YSFormRowModel *rowModel) {
		YSStrong;
		NSIndexPath *indexPath = [strongSelf.tableView indexPathForCell:weakCell];
		[strongSelf.configArray removeObjectAtIndex:indexPath.section];
		[strongSelf.tripListArray removeObjectAtIndex:indexPath.section -1];
		[strongSelf.buyTicketsArray removeObjectAtIndex:indexPath.section -1];
		//删除时要改变行程数字,遍历刷新整个数组
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
		
		for (int i = 0; i < strongSelf.configArray.count; i++) {
			if (i == 0) {//出差信息
			}else{//行程信息,添加行程数字
				YSFormRowModel *model = strongSelf.configArray[i][0];
				model.title = [NSString stringWithFormat:@"行程%@", [formatter stringFromNumber:[NSNumber numberWithInt:i]]];
			}
		}
		[strongSelf.tableView reloadData];
		
		[strongSelf checkNeedIdCard:strongSelf.buyTicketsArray];
		
	}];
	
	return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return section == self.configArray.count - 1 ? 110*kHeightScale : 30.0;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewAutomaticDimension;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	YSFormRowModel *cellModel = self.configArray[indexPath.section][indexPath.row];
	if (indexPath.section == 0) {
		if ([cellModel.title isEqualToString:@"出差人"]) {
			YSContactSelectPersonViewController *contactSelectPersonViewController = [[YSContactSelectPersonViewController alloc]init];
			contactSelectPersonViewController.jumpSourceStr = @"EMS";
			[self.navigationController pushViewController:contactSelectPersonViewController animated:YES];
		}
		
		if ([cellModel.title isEqualToString:@"工程项目名称"]) {
			YSEMSProPageController *vc = [[YSEMSProPageController alloc]init];
			vc.projectInfoBlock = ^(NSDictionary *dic) {
				YSEMSProListModel *proModel = dic.allValues.firstObject;
				[self.payload setValue:proModel.name forKey:@"proName"];
				[self.payload setValue:proModel.proManName forKey:@"proManagerName"];
				[self.payload setValue:proModel.id forKey:@"proId"];
				[self.payload setValue:proModel.proNatureCode forKey:@"proCode"];
				[self.payload setValue:proModel.proManId forKey:@"proManagerId"];
				[self.payload setValue:proModel.proCompId forKey:@"proCompId"];
				
				//修改本行cell的详情值
				cellModel.detailTitle = proModel.name;
				cellModel.proListModel = proModel;
				
				//修改项目经理的值,下一行
				YSFormRowModel *managerCellModel =  self.configArray[indexPath.section][indexPath.row + 1];
				managerCellModel.detailTitle = proModel.proManName;
				
				
				
				[self.tableView beginUpdates];
				[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0], [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
				[self.tableView endUpdates];
			};
			[self.navigationController pushViewController:vc animated:YES];
			
		}
	}
}



#pragma mark - /** 获取默认申请人信息 */
- (void)getUserInfo {
	NSString *url = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getPersonInfo, [YSUtility getUID]];
	[YSNetManager ys_request_GETWithUrlString:url isNeedCache:NO parameters:nil successBlock:^(id response) {
		if ([response[@"code"] isEqual:@1]) {
			_personalInformationModel = [YSPersonalInformationModel yy_modelWithDictionary:response[@"data"]];
			[self.payload setValue:_personalInformationModel.no forKey:@"businessPno"];
			[self.payload setValue:_personalInformationModel.companyName forKey:@"businessPdeptName"];
			[self.payload setObject:_personalInformationModel.name forKey:@"businessPname"];
			
			YSFormRowModel *model0 = _configArray[0][0];
			model0.detailTitle = _personalInformationModel.name;
			NSIndexPath *indexPath0 = [NSIndexPath indexPathForRow:0 inSection:0];
			[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath0] withRowAnimation:UITableViewRowAnimationAutomatic];
			
			YSFormRowModel *model1 = _configArray[0][1];
			model1.detailTitle = _personalInformationModel.companyName;
			NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
			[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath1] withRowAnimation:UITableViewRowAnimationAutomatic];
			//更新职务
			
			//职务不需要从列表选择了，从选择的工号去请求回来
			[YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain,getPostNameByNo,_personalInformationModel.no] isNeedCache:NO parameters:nil successBlock:^(id response) {
				DLog(@"-------%@",response);
				if ([response[@"code"] integerValue]) {
					YSFormRowModel *model3 = _configArray[0][3];
					model3.detailTitle = response[@"data"][@"postName"];
					NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:3 inSection:0];
					[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath3] withRowAnimation:UITableViewRowAnimationAutomatic];
					//配置参数
					[self.payload setValue:response[@"data"][@"postCode"] forKey:@"jobLevelId"];
					[self.payload setValue:response[@"data"][@"postName"] forKey:@"jobLevelName"];
					
				}
			} failureBlock:^(NSError *error) {
				
			} progress:nil];
		}
	} failureBlock:^(NSError *error) {
		DLog(@"error:%@", error);
	} progress:nil];
}
#pragma mark - 选择联系人通知
- (void)selectPerson:(NSNotification *)notification {
	YSContactModel *internalModel = notification.userInfo[@"selectedArray"][0];
	[self.payload setObject:internalModel.name forKey:@"businessPname"];
	[self.payload setObject:internalModel.userId forKey:@"businessPno"];
	//出差人
	YSFormRowModel *model0 = _configArray[0][0];
	model0.detailTitle = internalModel.name;
	NSIndexPath *indexPath0 = [NSIndexPath indexPathForRow:0 inSection:0];
	[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath0] withRowAnimation:UITableViewRowAnimationAutomatic];
	//公司
	YSFormRowModel *model1 = _configArray[0][1];
	model1.detailTitle = internalModel.companyName;
	NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
	[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath1] withRowAnimation:UITableViewRowAnimationAutomatic];
	//更新职务
	//职务不需要从列表选择了，从选择的工号去请求回来
	[YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain,getPostNameByNo,internalModel.userId] isNeedCache:NO parameters:nil successBlock:^(id response) {
		DLog(@"======%@",response);
		if ([response[@"code"] integerValue]) {
			YSFormRowModel *model3 = _configArray[0][3];
			model3.detailTitle = response[@"data"][@"postName"];
			NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:3 inSection:0];
			
			[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath3] withRowAnimation:UITableViewRowAnimationAutomatic];
			//配置参数
			[self.payload setValue:response[@"data"][@"postCode"] forKey:@"jobLevelId"];
			[self.payload setValue:response[@"data"][@"postName"] forKey:@"jobLevelName"];
			
		}
	} failureBlock:^(NSError *error) {
		DLog(@"=======%@",error);
		
	} progress:nil];
}
#pragma mark - 添加行程通知
- (void)addTrip:(NSNotification *)notification {
	
	NSDictionary *trip = notification.userInfo[@"trip"];
	DLog(@"trip========%@", trip);
	
	if ([trip[@"isEditing"] boolValue]) {//编辑 更新区
		NSMutableArray *tripInfoArray = trip[@"rowDataArr"];
		NSIndexPath *indexPath = trip[@"indexPath"];
		
		
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
		NSInteger index = indexPath.section;
		YSFormRowModel *model0 = [[YSFormRowModel alloc] init];
		model0.title = [NSString stringWithFormat:@"行程%@",[formatter stringFromNumber:[NSNumber numberWithInt:index]]];
		model0.rowName = @"YSFormDeleteCell";
		[tripInfoArray insertObject:model0 atIndex:0];
		
		[self.configArray replaceObjectAtIndex:indexPath.section withObject:tripInfoArray];
		
		//跟新上传参数
		[self.tripListArray replaceObjectAtIndex:indexPath.section - 1 withObject:trip[@"payload"]];
		[self.buyTicketsArray replaceObjectAtIndex:indexPath.section - 1 withObject:trip[@"buyTickets"]];
	}else {//添加 插入区
		//行程信息
		NSMutableArray *tripInfoArray = trip[@"rowDataArr"];
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
		NSInteger index = self.configArray.count;//出差单信息 + 行程
		YSFormRowModel *model0 = [[YSFormRowModel alloc] init];
		model0.title = [NSString stringWithFormat:@"行程%@",[formatter stringFromNumber:[NSNumber numberWithInt:index]]];
		model0.rowName = @"YSFormDeleteCell";
		[tripInfoArray insertObject:model0 atIndex:0];
		[self.configArray addObject:tripInfoArray];
		[self.tripListArray addObject:trip[@"payload"]];//数组里一个行程的字典
		[self.buyTicketsArray addObject:trip[@"buyTickets"]];
	}
	
	
	
	
	//遍历将行程的区变为不可编辑
	for (int i = 0; i < self.configArray.count; i++) {
		if (i == 0) {//出差
			
		}else{
			for (YSFormRowModel *model in self.configArray[i]) {
				model.disable = YES;
				model.accessoryType = UITableViewCellAccessoryNone;
				if ([model.title isEqualToString:@"预定酒店"]) {
					model.rowName = @"YSFormDetailCell";
					model.detailTitle = model.switchStatus?@"是":@"否";
				}
				if ([model.title isEqualToString:@"备注"]) {
					model.rowName = @"YSFormDetailCell";
				}
			}
		}
	}
	
	[self.tableView reloadData];
	
	[self checkNeedIdCard:self.buyTicketsArray];//再更新身份证必填xin
}

- (void)checkNeedIdCard:(NSArray *)buyTicketsArray {
	
	self.needIdCard = NO;
	for (NSString *value in buyTicketsArray) {
		
		if ([value integerValue] == 1) {
			self.needIdCard = YES;
		}
	}
	
	for (YSFormRowModel *model in self.configArray[0]) {
		if ([model.title isEqualToString:@"身份证号"]) {
			model.detailTitle = self.payload[@"idCard"];
			model.necessary = self.needIdCard;
			
			[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow: [self.configArray[0] indexOfObject:model] inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
		}
	}
	
}

#pragma mark - 提交数据
- (void)submit {
	
	
	if (_needIdCard) {//选择了交通代买，身份证必要
		if ([self.payload[@"idCard"] isEqual:@""]) {
			[QMUITips showError:@"请填写身份证信息" inView:self.view hideAfterDelay:1];
			return;
		}
	}
	
	if (self.tripListArray.count == 0) {
		[QMUITips showError:@"请添加至少一个行程" inView:self.view hideAfterDelay:1];
		return;
	}
	
	//检测出差安排时间是不是和行程时间吻合
	NSDate *startDate = [NSDate dateWithString:self.payload[@"startTime"] formatString:@"yyyy-MM-dd"];
	NSDate *endDate = [NSDate dateWithString:self.payload[@"endTime"] formatString:@"yyyy-MM-dd"];
	for (int i = 0; i <  [self.payload[@"businessTripList"] count] ; i ++) {
		NSString *dateStr = self.payload[@"businessTripList"][i][@"startTime"];
		NSDate *date = [NSDate dateWithString:dateStr formatString:@"yyyy-MM-dd"];

		if (startDate.timeIntervalSince1970 > date.timeIntervalSince1970 || endDate.timeIntervalSince1970 < date.timeIntervalSince1970) {
			[QMUITips showInfo:@"出差时间和行程时间不符" inView:self.view hideAfterDelay:2];
			return;
		}

	}
	//检测是不是有历史出差重合
	[QMUITips showLoadingInView:self.view];
	[YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@/%@/%@",YSDomain,applyCheckTripApi,self.payload[@"businessPno"],self.payload[@"startTime"],self.payload[@"endTime"]] isNeedCache:NO parameters:nil successBlock:^(id response) {
		DLog(@"----------%@",response);
		[QMUITips hideAllTipsInView:self.view];
		if ([response[@"code"] integerValue] == 1) {
			if ([response[@"data"] count]) {//有重复
				QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"是" style:(QMUIAlertActionStyleDestructive) handler:^(QMUIAlertAction *action) {
					[self summitRequest];//提交
				}];
				QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"否" style:(QMUIAlertActionStyleCancel) handler:^(QMUIAlertAction *action) {
					
				}];
				NSMutableString *alertStr = [[NSMutableString alloc]init];
				for (int i = 0; i < [response[@"data"] count]; i++) {
					if (i == 0) {
						[alertStr appendString:response[@"data"][i]];
					}else{
						[alertStr appendString:[NSString stringWithFormat:@"、%@",response[@"data"][i]]];
					}
				}
				QMUIAlertController *alertVC = [[QMUIAlertController alloc]initWithTitle:nil message:[NSString stringWithFormat:@"您已提交过该时间范围内的出差单(%@),是否仍要提交？",alertStr] preferredStyle:(QMUIAlertControllerStyleAlert)];
				[alertVC addAction:action1];
				[alertVC addAction:action2];
				[alertVC showWithAnimated:YES];
			}else {
				[self summitRequest];//提交
			}
		}
	} failureBlock:^(NSError *error) {
		[QMUITips hideAllTipsInView:self.view];
	} progress:nil];
	
	
}
- (void)summitRequest {
	DLog(@"=======%@",self.payload);
	//提交
	if (_needIdCard) {
		if ([self.payload[@"idCard"] isEqual:@""]) {
			[QMUITips showError:@"请填写完整" inView:self.view hideAfterDelay:1];
			return;
		}
		self.navigationItem.rightBarButtonItem.enabled = NO;
		[QMUITips showLoadingInView:self.view];
		NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, applyTripApi];
		[YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:self.payload successBlock:^(id response) {
			[QMUITips hideAllTipsInView:self.view];
			DLog(@"payload:%@", self.payload);
			DLog(@"申请出差结果:%@", response);
			if ([response[@"code"] intValue] == 1) {
				[QMUITips showInfo:@"该出差申请流程已成功提交！" inView:self.view hideAfterDelay:2];
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					self.navigationItem.rightBarButtonItem.enabled = YES;
					[self.navigationController popViewControllerAnimated:YES];
				});
				
			}else{
				self.navigationItem.rightBarButtonItem.enabled = YES;
			}
		} failureBlock:^(NSError *error) {
			DLog(@"error:%@", error);
			self.navigationItem.rightBarButtonItem.enabled = YES;
		} progress:nil];
	} else {
		[QMUITips showLoadingInView:self.view];
		self.navigationItem.rightBarButtonItem.enabled = NO;
		NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, applyTripApi];
		[YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:self.payload successBlock:^(id response) {
			DLog(@"payload:%@", self.payload);
			DLog(@"申请出差结果:%@", response);
			[QMUITips hideAllTipsInView:self.view];
			self.navigationItem.rightBarButtonItem.enabled = YES;
			if ([response[@"code"] intValue] == 1) {
				[QMUITips showInfo:@"该出差申请流程已成功提交！" inView:self.view hideAfterDelay:1.5];
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					self.navigationItem.rightBarButtonItem.enabled = YES;
					[self.navigationController popViewControllerAnimated:YES];
				});
			}else{
				self.navigationItem.rightBarButtonItem.enabled = YES;
			}
		} failureBlock:^(NSError *error) {
			DLog(@"error:%@", error);
			self.navigationItem.rightBarButtonItem.enabled = YES;
		} progress:nil];
	}
}



-(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month{

    NSDateComponents *comps = [[NSDateComponents alloc] init];

    [comps setMonth:month];

    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];// NSGregorianCalendar

    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];

    return mDate;

}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
