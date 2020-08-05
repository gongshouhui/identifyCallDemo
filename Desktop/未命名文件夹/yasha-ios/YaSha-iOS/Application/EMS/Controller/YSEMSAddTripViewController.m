//
//  YSEMSAddTripViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/20.
//

#import "YSEMSAddTripViewController.h"
#import "YSFormRowModel.h"
#import "YSFormCommonCell.h"
#import "YSAreaPickerView.h"
#import "YSEMSProPageController.h"
#import "YSHRMTDeptTreeViewController.h"
#import "YSRightToLeftTransition.h"
#import "YSEMSProPageController.h"

@interface YSEMSAddTripViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isForeign;
@property (nonatomic, assign) BOOL showProName;
@property (nonatomic, strong) NSMutableDictionary *tripRowDic;


@end

@implementation YSEMSAddTripViewController

static NSString *cellIdentifier = @"FormCommonCell";
- (NSMutableDictionary *)payload {
	if (!_payload) {
		_payload = [NSMutableDictionary dictionary];
	}
	return _payload;
}
- (void)initSubviews {
	[super initSubviews];
	self.title = @"添加行程";
	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) style:UITableViewStyleGrouped];
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	[self.tableView registerClass:[YSFormCommonCell class] forCellReuseIdentifier:cellIdentifier];
	[self.view addSubview:self.tableView];
	
}
-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self prepareDataSource];
}
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
}
- (void)prepareDataSource {
	if (self.tripInfoArray.count) {//有数据，编辑情况
		for (YSFormRowModel *model in self.tripInfoArray) {
			
			model.disable = NO;
			model.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			if ([model.title isEqualToString:@"预定酒店"]) {
				model.rowName = @"YSFormSwitchCell";
				
				model.accessoryType = UITableViewCellAccessoryNone;
			}
			if ([model.title isEqualToString:@"出发日期"]) {//编辑时设置时间范围
				YSFormRowModel *emsStartDateModel = self.emsArr[0][4];
				YSFormRowModel *emsEndDateModel = self.emsArr[0][5];
				//设置时间范围
				model.minimumDate = [YSUtility dateFromString:emsStartDateModel.detailTitle andFormatter:@"yyyy-MM-dd"];
				model.maximumDate = [YSUtility dateFromString:emsEndDateModel.detailTitle andFormatter:@"yyyy-MM-dd"];
			}
			
			
			if ([model.title isEqualToString:@"出行方式"]) {
				NSDictionary *tripModeDic = @{@"ccd_tripmode_fj": @"飞机", @"ccd_tripmode_hc": @"火车", @"ccd_tripmode_qc": @"汽车"};
				NSArray *tripModeArray = nil;
				if (model.detailTitle.length) {//选择过 行程
					tripModeArray = [model.detailTitle componentsSeparatedByString:@","];
				}
				NSMutableSet *indexSets = [[NSMutableSet alloc]init];
				for (int i = 0; i < tripModeArray.count; i ++) {
					NSString *key = tripModeArray[i];
					//
					if ([key isEqualToString:@"飞机"]) {
						[indexSets addObject:@0];
					}else if ([key isEqualToString:@"火车"]){
						[indexSets addObject:@1];
					}else if ([key isEqualToString:@"汽车"]){
						[indexSets addObject:@2];
					}
				}
				model.selectedItemIndexes = indexSets;
			}
			
			if ([model.title isEqualToString:@"交通代买"]) {
				if (model.detailTitle.length) {//选择了交通代买，目前只有飞机票
					NSMutableSet *indexSets = [[NSMutableSet alloc]init];
					[indexSets addObject:@0];
					model.selectedItemIndexes = indexSets;
				}
			}
		}
		
		//备注
		YSFormRowModel *lastModel = [self.tripInfoArray lastObject];
		if ([lastModel.title isEqualToString:@"备注"]) {
			YSFormRowModel *remarkModel = [self.tripInfoArray lastObject];
			remarkModel.rowName = @"YSFormTextViewCell";//回去时将textview换掉
		}
		
		
	}else{//没数据，添加行程情况
		self.tripInfoArray = [NSMutableArray array];
		YSFormRowModel *model0 = [[YSFormRowModel alloc] init];
		model0.rowName = @"YSFormOptionsCell";
		model0.title = @"出差地区";
		model0.detailTitle = @"国内";//没数据默认国内
		model0.necessary = YES;
		model0.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		model0.optionsReturnType = YSFormOptionsReturnKey;
		model0.optionsDataArray = @[@{@"1": @"国内"},
									@{@"2": @"国外"}];
		model0.paraKey = @"businessArea";
		//给了默认值,也要给上传参数赋值,因为目前是需要选择才执行记录操作
		[self.payload setValue:@"1" forKey:@"businessArea"];
		[self.tripInfoArray addObject:model0];
		
		YSFormRowModel *model1 = [[YSFormRowModel alloc] init];
		model1.rowName = @"YSFormAreaPickerCell";
		model1.title = @"出发地";
		model1.necessary = YES;
		model1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		model1.areaPickerType = YSAreaPickerCity;
		model1.paraKey = @"address";
		[self.tripInfoArray addObject:model1];
		
		YSFormRowModel *model2 = [[YSFormRowModel alloc] init];
		model2.rowName = @"YSFormAreaPickerCell";
		model2.title = @"目的地";
		model2.necessary = YES;
		model2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		model2.areaPickerType = YSAreaPickerCity;
		model2.paraKey = @"address";
		[self.tripInfoArray addObject:model2];
		
		//        YSFormRowModel *model3 = [[YSFormRowModel alloc] init];
		//        model3.title = @"国外地址";
		//        model3.rowName = @"YSFormTextFieldCell";
		//model3.paraKey = @"address";
		
		
		YSFormRowModel *model4 = [[YSFormRowModel alloc] init];
		model4.rowName = @"YSFormDatePickerCell";
		model4.title = @"出发日期";
		YSFormRowModel *emsStartDateModel = self.emsArr[0][4];
		YSFormRowModel *emsEndDateModel = self.emsArr[0][5];
		model4.detailTitle = emsStartDateModel.detailTitle;
		model4.necessary = YES;
		model4.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		model4.datePickerMode = PGDatePickerModeDate;
		//设置时间范围
		model4.minimumDate = [YSUtility dateFromString:emsStartDateModel.detailTitle andFormatter:@"yyyy-MM-dd"];
		model4.maximumDate = [YSUtility dateFromString:emsEndDateModel.detailTitle andFormatter:@"yyyy-MM-dd"];
		model4.paraKey = @"startTime";
		//给了默认值,也要给上传参数赋值
		[self.payload setValue:emsStartDateModel.detailTitle forKey:@"startTime"];
		[self.tripInfoArray addObject:model4];
		
		
		YSFormRowModel *model5 = [[YSFormRowModel alloc] init];
		model5.rowName = @"YSFormSwitchCell";
		model5.title = @"预定酒店";
		model5.paraKey = @"bookHotal";
		[self.tripInfoArray addObject:model5];
		
		
		YSFormRowModel *model6 = [[YSFormRowModel alloc] init];
		model6.rowName = @"YSFormMultipleSelectCell";
		model6.title = @"出行方式";
		model6.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		model6.optionsDataArray = @[@{@"ccd_tripmode_fj": @"飞机"},
									@{@"ccd_tripmode_hc": @"火车"},
									@{@"ccd_tripmode_qc": @"汽车"}];
		model6.optionsReturnType = YSFormOptionsReturnKey;
		model6.paraKey = @"tripMode";
		[self.tripInfoArray addObject:model6];
		
		YSFormRowModel *model7 = [[YSFormRowModel alloc] init];
		model7.rowName = @"YSFormMultipleSelectCell";
		model7.title = @"交通代买";
		model7.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		model7.optionsDataArray = @[@{@"ccd_buytickets_fjp": @"飞机票"}];
		model7.optionsReturnType = YSFormOptionsReturnKey;
		model7.paraKey = @"buyTickets";
		[self.tripInfoArray addObject:model7];
		
		
		
		YSFormRowModel *model8 = [[YSFormRowModel alloc] init];
		model8.rowName = @"YSFormOptionsCell";
		model8.title = @"费用所属公司";
		model8.necessary = YES;
		model8.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
		model8.indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
		model8.optionsDataArray = @[@{@"ownCompany_ysjt": @"亚厦集团"},
									@{@"ownCompany_yszs": @"亚厦装饰"},
									@{@"ownCompany_ysmq": @"亚厦幕墙"},
									@{@"ownCompany_ysjd": @"亚厦机电"},
									@{@"ownCompany_mgj": @"蘑菇加"},
									@{@"ownCompany_shlt": @"上海蓝天"},
									@{@"ownCompany_yssjy": @"亚厦设计院"},
									@{@"ownCompany_cyy": @"亚厦产业园"},
									@{@"ownCompany_zcgs": @"资产公司"},
		];
		model8.paraKey = @"ownCompany";
		[self.tripInfoArray addObject:model8];
		
		
		YSFormRowModel *model9 = [[YSFormRowModel alloc] init];
		model9.rowName = @"YSFormOptionsCell";
		model9.title = @"费用分摊";
		model9.necessary = YES;
		model9.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
		model9.optionsDataArray = @[@{@"ccd_triptype_xm": @"项目"},
									@{@"ccd_triptype_bbm": @"本部门"},
									@{@"ccd_triptype_qtbm": @"其它部门"}
		];
		model9.paraKey = @"proType";
		[self.tripInfoArray addObject:model9];
		
		YSFormRowModel *model10 = [[YSFormRowModel alloc] init];
		model10.rowName = @"YSFormTextViewCell";
		model10.title = @"备注";
		model10.placeholder = @"如有特殊情况请备注";
		model10.maximumTextLength = 50;
		model10.paraKey = @"remark";
		[self.tripInfoArray addObject:model10];
		
	}
	[self.tableView reloadData];
}


- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
	[super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
	self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"完成" position:QMUINavigationButtonPositionRight target:self action:@selector(submit)];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.tripInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	YSFormRowModel *cellModel = _tripInfoArray[indexPath.row];
	YSFormCommonCell *cell = [[NSClassFromString(cellModel.rowName) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	[cell setCellModel:cellModel];//选择的值记在model里
	//国内、出发日期，项目类型，出行方式，交通代买，预定酒店，备注，国外地址
	YSWeak;
	[cell.sendFormCellModelSubject subscribeNext:^(YSFormCellModel *model) {
		YSStrong;
		[strongSelf.payload setObject:model.value forKey:cellModel.paraKey];
		if ([cellModel.title isEqualToString:@"出行方式"] || [cellModel.title isEqualToString:@"交通代买"]) {//需要用的是key
			[strongSelf.payload setObject:model.key forKey:cellModel.paraKey];
		}
		
		if ([cellModel.title isEqualToString:@"出差地区"]) {//选择国内还是国外
			if ([model.value isEqualToString:@"2"]) {//国外
				NSMutableArray *deleteArray = [NSMutableArray array];
				for (YSFormRowModel *formRowModel in weakSelf.tripInfoArray) {
					if ([formRowModel.title isEqual:@"出发地"] || [formRowModel.title isEqual:@"目的地"]) {
						[deleteArray addObject:formRowModel];
					}
				}
				[strongSelf.tripInfoArray removeObjectsInArray:[deleteArray copy]];
				
				
				YSFormRowModel *formRowModel = [strongSelf.tripInfoArray objectAtIndex:indexPath.row + 1];//下一行
				if (![formRowModel.title isEqual:@"国外地址"]) {
					YSFormRowModel *model3 = [[YSFormRowModel alloc] init];
					model3.title = @"国外地址";
					model3.placeholder = @"请输入国外地址";
					model3.rowName = @"YSFormTextFieldCell";
					model3.necessary = YES;
					model3.paraKey = @"address";
					
					[strongSelf.tripInfoArray insertObject:model3 atIndex:indexPath.row + 1];
				}
				
				
				
			} else {//选择国内
				NSMutableArray *deleteArray = [NSMutableArray array];
				for (YSFormRowModel *formRowModel in strongSelf.tripInfoArray) {
					if ([formRowModel.title isEqual:@"国外地址"]) {
						[deleteArray addObject:formRowModel];
					}
				}
				[strongSelf.tripInfoArray removeObjectsInArray:[deleteArray copy]];
				YSFormRowModel *formRowModel = [strongSelf.tripInfoArray objectAtIndex:indexPath.row + 1];
				if (![formRowModel.title isEqual:@"出发地"]) {//如果已经选择国内，再次选择时不创建
					
					YSFormRowModel *model1 = [[YSFormRowModel alloc] init];
					model1.title = @"出发地";
					model1.rowName = @"YSFormAreaPickerCell";
					model1.necessary = YES;
					model1.indexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
					model1.areaPickerType = YSAreaPickerCity;
					model1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					
					YSFormRowModel *model2 = [[YSFormRowModel alloc] init];
					model2.title = @"目的地";
					model2.rowName = @"YSFormAreaPickerCell";
					model2.necessary = YES;
					model2.indexPath = [NSIndexPath indexPathForRow:indexPath.row + 2 inSection:0];
					model2.areaPickerType = YSAreaPickerCity;
					model2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					
					[strongSelf.tripInfoArray insertObject:model1 atIndex:indexPath.row + 1];
					[strongSelf.tripInfoArray insertObject:model2 atIndex:indexPath.row + 2];
				}
			}
			[strongSelf.tableView reloadData];
			
			
			/** 处理项目类型 */
		}
	}];
	//d单选
	[cell.sendOptionsSubject subscribeNext:^(NSDictionary *dic) {
		YSStrong;
		cellModel.detailTitle = dic.allValues.firstObject;
		[strongSelf.payload setValue:dic.allKeys.firstObject forKey:cellModel.paraKey];
		
		
		if ([cellModel.title isEqualToString:@"出差地区"]) {//选择国内还是国外
				if ([dic.allKeys.firstObject isEqualToString:@"2"]) {//国外
					NSMutableArray *deleteArray = [NSMutableArray array];
					for (YSFormRowModel *formRowModel in weakSelf.tripInfoArray) {
						if ([formRowModel.title isEqual:@"出发地"] || [formRowModel.title isEqual:@"目的地"]) {
							[deleteArray addObject:formRowModel];
						}
					}
					[strongSelf.tripInfoArray removeObjectsInArray:[deleteArray copy]];
					
					
					YSFormRowModel *formRowModel = [strongSelf.tripInfoArray objectAtIndex:indexPath.row + 1];//下一行
					if (![formRowModel.title isEqual:@"国外地址"]) {
						YSFormRowModel *model3 = [[YSFormRowModel alloc] init];
						model3.title = @"国外地址";
						model3.placeholder = @"请输入国外地址";
						model3.rowName = @"YSFormTextFieldCell";
						model3.necessary = YES;
						//xiugai 20200210
						model3.paraKey = @"address";
						
						[strongSelf.tripInfoArray insertObject:model3 atIndex:indexPath.row + 1];
					}
					
					
					
				} else {//选择国内
					NSMutableArray *deleteArray = [NSMutableArray array];
					for (YSFormRowModel *formRowModel in strongSelf.tripInfoArray) {
						if ([formRowModel.title isEqual:@"国外地址"]) {
							[deleteArray addObject:formRowModel];
						}
					}
					[strongSelf.tripInfoArray removeObjectsInArray:[deleteArray copy]];
					YSFormRowModel *formRowModel = [strongSelf.tripInfoArray objectAtIndex:indexPath.row + 1];
					if (![formRowModel.title isEqual:@"出发地"]) {//如果已经选择国内，再次选择时不创建
						
						YSFormRowModel *model1 = [[YSFormRowModel alloc] init];
						model1.title = @"出发地";
						model1.rowName = @"YSFormAreaPickerCell";
						model1.necessary = YES;
						model1.indexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
						model1.areaPickerType = YSAreaPickerCity;
						model1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
						
						YSFormRowModel *model2 = [[YSFormRowModel alloc] init];
						model2.title = @"目的地";
						model2.rowName = @"YSFormAreaPickerCell";
						model2.necessary = YES;
						model2.indexPath = [NSIndexPath indexPathForRow:indexPath.row + 2 inSection:0];
						model2.areaPickerType = YSAreaPickerCity;
						model2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
						
						[strongSelf.tripInfoArray insertObject:model1 atIndex:indexPath.row + 1];
						[strongSelf.tripInfoArray insertObject:model2 atIndex:indexPath.row + 2];
					}
				}
				[strongSelf.tableView reloadData];
				/** 处理项目类型 */
			}
		
		
		
		if ([cellModel.title isEqualToString:@"费用分摊"]) {//费用分摊分为项目、本部门、其他部门
					if ([dic.allKeys.firstObject isEqual:@"ccd_triptype_xm"]) {//选择项目，删除部门名称
						NSMutableArray *deleteArray = [NSMutableArray array];
						for (YSFormRowModel *formRowModel in strongSelf.tripInfoArray) {//如果有部门名称就删除了
							if ([formRowModel.title isEqual:@"部门名称"]) {
								[deleteArray addObject:formRowModel];
							}
						}
						[strongSelf.tripInfoArray removeObjectsInArray:[deleteArray copy]];
						
						YSFormRowModel *formRowModel = [strongSelf.tripInfoArray objectAtIndex:indexPath.row + 1];//下一行
						if (![formRowModel.title isEqualToString:@"项目名称"]) {//去除重复点击的情况
							YSFormRowModel *proModel = [[YSFormRowModel alloc] init];
							proModel.title = @"项目名称";
							proModel.rowName = @"YSFormDetailCell";
							proModel.necessary = YES;
							proModel.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
							
							YSFormRowModel *natureModel = [[YSFormRowModel alloc] init];
							natureModel.title = @"项目性质";
							natureModel.rowName = @"YSFormDetailCell";
							
							
							YSFormRowModel *manModel = [[YSFormRowModel alloc] init];
							manModel.title = @"项目经理";
							manModel.rowName = @"YSFormDetailCell";
							
							[strongSelf.tripInfoArray insertObject:proModel atIndex:indexPath.row +1];
							[strongSelf.tripInfoArray insertObject:natureModel atIndex:indexPath.row +2];
							[strongSelf.tripInfoArray insertObject:manModel atIndex:indexPath.row +3];
						}
						
					} else if ([dic.allKeys.firstObject isEqual:@"ccd_triptype_qtbm"]) {//选着 其他部门
						NSMutableArray *deleteArray = [NSMutableArray array];
						for (YSFormRowModel *formRowModel in strongSelf.tripInfoArray) {
							if ([formRowModel.title isEqual:@"项目名称"]) {
								[deleteArray addObject:formRowModel];
							}
							if ([formRowModel.title isEqual:@"项目性质"]) {
								[deleteArray addObject:formRowModel];
							}
							if ([formRowModel.title isEqual:@"项目经理"]) {
								[deleteArray addObject:formRowModel];
							}
						}
						[strongSelf.tripInfoArray removeObjectsInArray:[deleteArray copy]];
						
						
						YSFormRowModel *formRowModel = [strongSelf.tripInfoArray objectAtIndex:indexPath.row + 1];//下一行
						
						if (![formRowModel.title isEqualToString:@"部门名称"]) {
							YSFormRowModel *departModel = [[YSFormRowModel alloc] init];
							departModel.title = @"部门名称";
							departModel.rowName = @"YSFormDetailCell";
							departModel.necessary = YES;
							departModel.detailTitle = nil;
							departModel.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
							[weakSelf.tripInfoArray insertObject:departModel atIndex:indexPath.row + 1];
						}else{
							formRowModel.detailTitle = nil;
						}
						
						
					} else {//本部门 ccd_triptype_bbm
						NSMutableArray *deleteArray = [NSMutableArray array];
						for (YSFormRowModel *formRowModel in strongSelf.tripInfoArray) {
							if ([formRowModel.title isEqual:@"项目名称"]) {
								[deleteArray addObject:formRowModel];
							}
							if ([formRowModel.title isEqual:@"项目性质"]) {
								[deleteArray addObject:formRowModel];
							}
							if ([formRowModel.title isEqual:@"项目经理"]) {
								[deleteArray addObject:formRowModel];
							}
						}
						[strongSelf.tripInfoArray removeObjectsInArray:[deleteArray copy]];
						
						
						YSFormRowModel *formRowModel = [strongSelf.tripInfoArray objectAtIndex:indexPath.row + 1];//下一行
						
						if (![formRowModel.title isEqualToString:@"部门名称"]) {
							YSFormRowModel *departModel = [[YSFormRowModel alloc] init];
							departModel.title = @"部门名称";
							departModel.disable = YES;
							departModel.rowName = @"YSFormDetailCell";
							departModel.necessary = YES;
							departModel.detailTitle = strongSelf.personmModel.deptName;
							[weakSelf.tripInfoArray insertObject:departModel atIndex:indexPath.row + 1];
							[strongSelf.payload setValue:strongSelf.personmModel.deptName forKey:@"orgName"];
							[strongSelf.payload setValue:strongSelf.personmModel.deptId forKey:@"orgId"];
							
						}else{
							formRowModel.detailTitle = strongSelf.personmModel.deptName;
						}
						
					}
				
					[strongSelf.tableView reloadData];
				}
		
		
		
		
	}];
	
	//选择地区
	[cell.sendAreaSubject subscribeNext:^(YSAddressModel *addressModel) {
		YSStrong;
		if ([cellModel.title isEqualToString:@"出发地"]) {
			[strongSelf.payload setValue:addressModel.province forKey:@"startProvince"];
			[strongSelf.payload setValue:addressModel.provinceCode forKey:@"startProvinceCode"];
			[strongSelf.payload setValue:addressModel.city forKey:@"startCity"];
			[strongSelf.payload setValue:addressModel.cityCode forKey:@"startCityCode"];
			[strongSelf.payload setValue:addressModel.area forKey:@"startArea"];
			[strongSelf.payload setValue:addressModel.areaCode forKey:@"startAreaCode"];
		}
		if ([cellModel.title isEqualToString:@"目的地"]) {
			[strongSelf.payload setValue:addressModel.province forKey:@"endProvince"];
			[strongSelf.payload setValue:addressModel.provinceCode forKey:@"endProvinceCode"];
			[strongSelf.payload setValue:addressModel.city forKey:@"endCity"];
			[strongSelf.payload setValue:addressModel.cityCode forKey:@"endCityCode"];
			[strongSelf.payload setValue:addressModel.area forKey:@"endArea"];
			[strongSelf.payload setValue:addressModel.areaCode forKey:@"endAreaCode"];
		}
		
		
		
		
	}];
	return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	YSFormRowModel *cellModel = self.tripInfoArray[indexPath.row];
	if ([cellModel.title isEqualToString:@"部门名称"]) {
		YSFormRowModel *expenseModel  = self.tripInfoArray[indexPath.row - 1];//上一行
		if ([expenseModel.detailTitle isEqualToString:@"本部门"]) {//不需要选择
			return;
		}
		YSHRMTDeptTreeViewController *deptVC = [YSHRMTDeptTreeViewController new];
		deptVC.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.4];
		// 自定义的模态动画
		deptVC.modalPresentationStyle = UIModalPresentationCustom;
		deptVC.transitioningDelegate = [YSRightToLeftTransition sharedYSTransition];
		YSWeak;
		deptVC.choseDeptTreeBlock = ^(YSDeptTreePointModel * _Nonnull model) {
			//更新部门数据
			cellModel.detailTitle = model.point_name;
			[weakSelf.payload setValue:model.point_name forKey:@"orgId"];
			[weakSelf.payload setValue:model.point_name forKey:@"orgName"];
			[weakSelf.tableView beginUpdates];
			[weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
			[self.tableView endUpdates];
			
		};
		[self presentViewController:deptVC animated:YES completion:nil];
	}
	
		if ([cellModel.title isEqualToString:@"项目名称"]) {
			YSEMSProPageController *vc = [[YSEMSProPageController alloc]init];
			vc.projectInfoBlock = ^(NSDictionary *dic) {
				YSEMSProListModel *proModel = dic.allValues.firstObject;
				[self.payload setValue:proModel.name forKey:@"proName"];
				[self.payload setValue:proModel.proManName forKey:@"proManagerName"];
				[self.payload setValue:proModel.id forKey:@"proId"];
				[self.payload setValue:proModel.proNatureCode forKey:@"proCode"];
				[self.payload setValue:proModel.proNature forKey:@"proNature"];
				[self.payload setValue:proModel.proManId forKey:@"proManagerId"];
				[self.payload setValue:proModel.proCompId forKey:@"proCompId"];
				
				//修改本行cell的详情值
				cellModel.detailTitle = proModel.name;
				
				//修改项目性质的值,下一行
				YSFormRowModel *natureCellModel =  self.tripInfoArray[indexPath.row + 1];
				natureCellModel.detailTitle = proModel.proNature;
				//修改项目经理的值,下一行
				YSFormRowModel *managerCellModel =  self.tripInfoArray[indexPath.row + 2];
				managerCellModel.detailTitle = proModel.proManName;
				
				
			};
		[self.navigationController pushViewController:vc animated:YES];
		}
	
}

- (void)submit {
	NSLog(@"%@",self.payload);
	//校验数据完整性
	/** 校验数据完整 */
	for (YSFormRowModel *rowModel in self.tripInfoArray) {
		if (rowModel.necessary == YES) {
			if (!rowModel.detailTitle.length) {
				[QMUITips showError:[NSString stringWithFormat:@"请填写%@",rowModel.title] inView:self.view hideAfterDelay:1];
				return;

			}
		}
	}
	
	//通知传过去的内容
	NSMutableDictionary *trip = [NSMutableDictionary dictionary];
	[trip setValue:self.payload forKey:@"payload"];
	[trip setValue:@(self.isEditing) forKey:@"isEditing"];
	[trip setValue:self.editingIndexPath forKey:@"indexPath"];
	[trip setValue:self.tripInfoArray forKey:@"rowDataArr"];
	if ([self.payload[@"buyTickets"] isEqualToString:@"ccd_buytickets_fjp"]) {//买了飞机票
		[trip setValue:@(true) forKey:@"buyTickets"];
	}else{
		[trip setValue:@(false) forKey:@"buyTickets"];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"AddTripNotification" object:nil userInfo:@{@"trip":trip}];
	[self.navigationController popViewControllerAnimated:YES];
	
}

- (void)dealloc {
	DLog(@"释放了");
}

@end
