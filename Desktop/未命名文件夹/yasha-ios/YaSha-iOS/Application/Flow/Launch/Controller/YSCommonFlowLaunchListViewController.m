//
//  YSCommonFlowLaunchListViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/12.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonFlowLaunchListViewController.h"
#import "YSFormRowModel.h"
#import "YSContactModel.h"
#import "YSFormCommonCell.h"
#import "YSFlowLaunchFormListModel.h"
#import "YSFlowLaunchFormHeaderView.h"
#import "YSChooseMorePeopleViewController.h"
#import "YSInternalPeopleModel.h"
#import "YSInternalModel.h"
#import "YSDingDingHeader.h"
#import "YSFlowPageController.h"
#import "YSFlowListViewController.h"
#import "YSContactSelectPersonViewController.h"
#import "YSSelfHelpViewController.h"

@interface YSCommonFlowLaunchListViewController ()
/**提交参数*/
@property (nonatomic, strong) NSMutableDictionary *payload;
@property (nonatomic, strong) NSArray *imageDataArray;
@property (nonatomic, strong) YSFlowLaunchFormListModel *flowLaunchFormListModel;
@property (nonatomic, strong) YSFlowLaunchFormHeaderView *headerView;
@property (nonatomic, strong) UIView *footerView;
/**表单原始数据*/
@property (nonatomic, strong) NSArray *midArray;
@property (nonatomic, strong) NSString *startTimeStr;
/**表单key做key,表单选择的图片数组做value*/
@property (nonatomic,strong) NSMutableDictionary *imageDataDic;
@end

@implementation YSCommonFlowLaunchListViewController

static NSString *cellIdentifier = @"FormCommonCell";
- (NSMutableDictionary *)imageDataDic {
	if (!_imageDataDic) {
		_imageDataDic = [NSMutableDictionary dictionary];
	}
	return _imageDataDic;
}
- (NSMutableDictionary *)payload {
	if (!_payload) {
		_payload = [NSMutableDictionary dictionary];
	}
	return _payload;
}

- (NSArray *)midArray {
	if (!_midArray) {
		_midArray = @[];
	}
	return _midArray;
}

- (YSFlowLaunchFormHeaderView *)headerView {
	if (!_headerView) {
		_headerView = [[YSFlowLaunchFormHeaderView alloc] init];
	}
	return _headerView;
}

- (UIView *)footerView {
	if (!_footerView) {
		_footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 80*kHeightScale)];
		QMUIButton *submitButton = [YSUIHelper generateDarkFilledButton];
		YSWeak;
		[[submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
			[weakSelf submit];
		}];
		[submitButton setTitle:@"提交" forState:UIControlStateNormal];
		[_footerView addSubview:submitButton];
		[submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
			make.size.mas_equalTo(CGSizeMake(300*kWidthScale, 50*kHeightScale));
			make.center.mas_equalTo(_footerView);
		}];
	}
	return _footerView;
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
	[super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
	self.title = _cellModel.modelName;
}

- (void)initTableView {
	[super initTableView];
	[self hideMJRefresh];
	self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
	[self.tableView registerClass:[YSFormCommonCell class] forCellReuseIdentifier:cellIdentifier];
	//选择人员的通知
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectPerson:) name:KNotificationPostSelectedPerson object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectPeople:) name:@"launchFlowSelectPeople" object:nil];
	[self doNetworking];
}

- (void)doNetworking {
	[super doNetworking];
	YSWeak;
	NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getFormDesInfoApi, _cellModel.modelKey];
	DLog(@"===========%@",urlString);
	[YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
		DLog(@"获取自定义表单数据:%@", response);
		dispatch_async(dispatch_get_global_queue(0, 0), ^{
			self.dataSource = [self getFlowList:response];
			self.midArray = self.dataSource;
			self.flowLaunchFormListModel = [YSFlowLaunchFormListModel yy_modelWithJSON:response[@"data"]];
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.headerView setHeaderModel:self.flowLaunchFormListModel];
				self.tableView.tableHeaderView = self.headerView;
				self.tableView.tableFooterView = self.footerView;
				[self ys_reloadData];
			});
		});
	} failureBlock:^(NSError *error) {
		DLog(@"error:%@", error);
	} progress:nil];
}


- (NSArray *)getFlowList:(id)response {
	// 控件控制,根据type获取本行cell类型的字典
	NSDictionary *rowNameDic = @{@"separator": @"YSFormSeparatorCell",
								 @"text": @"YSFormTextFieldCell",
								 // 文本输入，申请人工号 TextFiled
								 @"textarea": @"YSFormTextViewCell",
								 // 事由说明，TextView
								 @"number": @"YSFormTextFieldCell",
								 // 文本输入，申请天数 TextFiled
								 @"datetime": @"YSFormDatePickerCell",// 时间选择 UIDatePiker
								 @"radiogroup": @"YSFormOptionsCell",
								 // 开始时间段，AlertSheet
								 @"checkboxgroup": @"YSFormMultipleSelectCell",
								 @"combo": @"YSFormOptionsCell",
								 //职级 AlertSheet
								 @"combocheck": @"YSFormMultipleSelectCell",
								 @"address": @"YSFormAreaPickerCell",
								 @"upload": @"YSFormImagePickerCell",//上传证明材料
								 @"subform": @"YSFormDetailCell",
								 @"user": @"YSFormJumpCell",//申请人员
								 @"usermsg": @"YSFormJumpCell",//申请人员
								 @"usergroup": @"YSFormJumpCell",//人员多选
								 @"dept": @"YSFormDetailCell",
								 @"company": @"YSFormDetailCell",
								 @"deptgroup": @"YSFormMultipleSelectCell",
								 @"companygroup": @"YSFormDetailCell"};
	NSMutableArray *mutableArray = [NSMutableArray array];
	[self.payload setValue:response[@"data"][@"formInfo"][@"id"] forKey:@"form_id"];
	
	for (NSDictionary *dic in response[@"data"][@"items"]) {
		if (!([dic[@"fieldIsshow"] integerValue] == 1)) {//fieldIsshow 1显示，0不显示
			continue;//为0时跳过本次循环
		}
		
		YSFormRowModel *model = [[YSFormRowModel alloc] init];
		model.type = dic[@"type"];
		model.rowName = [rowNameDic valueForKey:dic[@"type"]];
		if ([model.rowName isEqual:@"YSFormOptionsCell"] || [model.rowName isEqual:@"YSFormMultipleSelectCell"] || [model.rowName isEqual:@"YSFormDatePickerCell"] || [model.rowName isEqual:@"YSFormAreaPickerCell"] || [model.rowName isEqual:@"YSFormJumpCell"] || [model.rowName isEqual:@"YSFormImagePickerCell"]) {
			model.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		// 控件 Key
		model.key = dic[@"fieldName"];
		//后台要求，返回的不可编辑的字段，有值，也要再传给后台
		if ([model.rowName isEqualToString:@"YSFormTextFieldCell"] && ![YSUtility judgeIsEmpty:dic[@"fieldDefaultValue"]]) {
			[self.payload setValue:dic[@"fieldDefaultValue"] forKey:model.key];
		}
		
		//控件ID
		model.fieldId = dic[@"fieldId"];
		// 控件左 title 显示
		model.title = dic[@"labelName"];
		//关联控件
		model.itemLinkeds = dic[@"itemLinkeds"];
		//        // 配置控件的 indexPath
		//        model.indexPath = [NSIndexPath indexPathForRow:[response[@"data"][@"items"] indexOfObject:dic] inSection:0];
        //判断是否可以编辑 1可以编辑 0不可以编辑
        model.editable = [dic[@"editable"] integerValue];
		// 是否必填
		model.necessary = ![dic[@"fieldIsnull"] intValue];
		// 是否必填
		model.backgroundColor = ![dic[@"fieldIsnull"] intValue];
		//fieldEnable 这个判断显示隐藏
		// UITextField 小数点后位数
		if ([model.rowName isEqual:@"YSFormTextFieldCell"] && ![dic[@"fieldDecimalLength"] isEqual:@""]) {
			model.countLimited = [dic[@"fieldDecimalLength"] integerValue];
		}
		// TextView 最大输入字符数
		if ([model.rowName isEqual:@"YSFormTextViewCell"]) {
			model.placeholder = dic[@"labelName"];
			model.maximumTextLength = 100;
		}
		// 数字键盘控制
		if ([dic[@"fieldName"] isEqual:@"uid"] || [dic[@"fieldName"] isEqual:@"phone_number"] || [dic[@"type"] isEqual:@"number"]) {
			model.keyboardType = UIKeyboardTypeDecimalPad;
		}
		// 手机号码检验
		if ([dic[@"fieldName"] isEqual:@"phone_number"]) {
			model.checkoutType = YSCheckoutPhoneNumber;
		}
		// 时间选择器控制时间格式
		NSDictionary *timeFormatDic = @{@"yyyy": @"0",
										@"yyyy-MM": @"1",
										@"yyyy-MM-dd": @"2",
										@"yyyy-MM-dd HH:mm": @"3",
										@"yyyy-MM-dd HH:mm:ss": @"4",
										@"HH:mm": @"5",
										@"HH:mm:ss": @"6",
										@"": @"7"
										};
		model.datePickerMode = [[timeFormatDic valueForKey:dic[@"fieldFormat"]] integerValue];
		// 单选数据源控制
		model.optionsDataArray = [YSDataManager getFlowLaunchOptionsData:dic[@"dicItems"]];
		// 控件默认值
		if ([model.rowName isEqual:@"YSFormOptionsCell"] || [model.rowName isEqual:@"YSFormMultipleSelectCell"]) {
			// 非空才有默认值
			if (![dic[@"fieldDefaultValue"] isEqual:@""]) {
				// 根据 ename 取出 cname
				NSMutableString *mutableString = [NSMutableString string];
				for (NSDictionary *optionsDic in model.optionsDataArray) {
					NSArray *array = [dic[@"fieldDefaultValue"] componentsSeparatedByString:@","];
					for (int i = 0; i < array.count; i ++) {
						NSString *value = [optionsDic valueForKey:array[i]];
						if (value) {
							[mutableString appendString:[NSString stringWithFormat:i == 0 ? @"%@" : @",%@", value]];
						}
					}
				}
				model.detailTitle = mutableString;
			}
		} else {
			model.detailTitle = dic[@"fieldDefaultValue"];
		}
		// 人员选择器
		if ([model.type isEqual:@"usermsg"] || [model.type isEqual:@"user"] ) {
			//取消编辑状态，不进行跳转
			model.disable = YES;
		} else if ([model.type isEqual:@"usergroup"]) {
			YSChooseMorePeopleViewController *chooseMorePeopleViewController = [[YSChooseMorePeopleViewController alloc] init];
			chooseMorePeopleViewController.title = @"通讯录";
			chooseMorePeopleViewController.str = @"首页";
			chooseMorePeopleViewController.indexPath = model.indexPath;
			chooseMorePeopleViewController.type = LaunchFlowSelectPeople;
			[[YSDingDingHeader shareHelper].titleList removeAllObjects];
			[[YSDingDingHeader shareHelper].titleList addObject:@"联系人"];
			model.jumpViewController = chooseMorePeopleViewController;
		}
		[mutableArray addObject:model];
	}
	for (int i = 0; i < mutableArray.count; i++) {
		YSFormRowModel *model = mutableArray[i];
		model.indexPath =   // 配置控件的 indexPath
		model.indexPath = [NSIndexPath indexPathForRow:i inSection:0];
	}
	return [mutableArray copy];
}
#pragma mark - 选择单个人员的回调通知
- (void)selectPerson:(NSNotification *)notification {
	YSContactModel *internalModel = notification.userInfo[@"selectedArray"][0];
	NSIndexPath *indexPath = notification.userInfo[@"selectIndexPath"];
	YSFormRowModel *model = self.dataSource[indexPath.row];
	model.detailTitle = internalModel.name;
	for (YSFormRowModel *model in self.dataSource) {
		if ([model.key isEqual:@"no"]) {
			YSFormRowModel *model1 = self.dataSource[model.indexPath.row];
			model1.detailTitle = internalModel.userId;
			[self.payload setValue:internalModel.userId forKey:model.key];
			[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:model.indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
		}
	}
	[self.payload setValue:internalModel.userId forKey:model.key];
	[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark - 选择多个人员的回调通知
- (void)selectPeople:(NSNotification *)notification {
	NSMutableString *nameMutableString = [NSMutableString string];
	NSMutableString *userIdMutableString = [NSMutableString string];
	NSIndexPath *indexPath;
	for (int i = 0; i < [YSSingleton getData].selectDataArr.count; i ++) {
		YSInternalModel *model = [YSSingleton getData].selectDataArr[i];
		indexPath = model.indexPath;
		[nameMutableString appendString:[NSString stringWithFormat:i == [YSSingleton getData].selectDataArr.count-1 ? @"%@" : @"%@,", [model.name isEqual:@""] ? model.text : model.name]];
		[userIdMutableString appendString:[NSString stringWithFormat:i == [YSSingleton getData].selectDataArr.count-1 ? @"%@" : @"%@,", model.no]];
	}
	YSFormRowModel *model = self.dataSource[indexPath.row];
	model.detailTitle = [nameMutableString copy];
	[self.payload setValue:[userIdMutableString copy] forKey:model.key];
	[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataSource.count;
}
#pragma mark - cell代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	YSWeak;
	YSFormRowModel *cellModel = weakSelf.dataSource[indexPath.row];
	/** 暂不开启复用 */
	YSFormCommonCell *cell = [[NSClassFromString(cellModel.rowName) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	[cell setCellModel:cellModel];
	if (cellModel.backgroundColor) {
		cell.contentView.layer.backgroundColor = [UIColor colorWithHexString:@"FFFFE9"].CGColor;
	}else{
		cell.contentView.layer.backgroundColor = [UIColor whiteColor].CGColor;
	}
	
	[cell.sendValueSubject subscribeNext:^(id x) {
		YSStrong;
		[strongSelf.payload setValue:x forKey:cellModel.key];
	}];
	
	[cell.sendOptionsSubject subscribeNext:^(NSDictionary *dic) {//顺序变动会引起indexPath变动，接下来需要优化
		YSStrong;
		NSString *subKey = [dic allKeys].firstObject;
		/*1 - 事假 2 - 病假 3 - 婚假 4 - 产假 5 - 哺乳假 6 - 丧假
		 7 - 工伤假 8 - 陪产假 9 - 调休*/
		if (cellModel.itemLinkeds.count) {//单选并且有关联控件的才进行删减操作
			//删除行
			//例如:我选择value == 1 即[dic allKeys].firstObject == 1的时候，这时候在关联控件itemLinkeds数组中可能存在三个value==1的项，然后将这些项的ishide值保存起来，即value==1影响的有三个他所关联的控件的显示和隐藏
			for (NSDictionary *linkDic in cellModel.itemLinkeds) {
				if ([linkDic[@"value"]  isEqualToString:subKey]  && [cellModel.fieldId isEqualToString:linkDic[@"fromFieldId"]]) {
					for (YSFormRowModel *model in weakSelf.midArray) {
						if ([model.fieldId isEqualToString:linkDic[@"toFieldId"]]) {
							//控件是否隐藏
							model.isHidde =  [linkDic[@"isHide"] boolValue];
							model.necessary = [linkDic[@"isNull"] boolValue];
						}
					}
				}
			}
			//这里直接将显示隐藏的转态保存到最初的数据源里，因为可能存在多个不同fieldid的控件有关联控件，这样操作不同的才可以将其他的状态保存下来，注意实现深拷贝的
			//过渡数据源
			NSMutableArray *tableViewDataSource  = [strongSelf.midArray mutableCopy];
			for (YSFormRowModel *cellModel in strongSelf.midArray) {
				if (cellModel.isHidde == YES) {
					[tableViewDataSource removeObject:cellModel];
					//同时将保存的请求参数删除
					[strongSelf.payload removeObjectForKey:cellModel.key];
				}
			}
			strongSelf.dataSource = [tableViewDataSource copy];
		}
		[strongSelf.tableView reloadData];
		[strongSelf.payload setValue:[dic allKeys][0] forKey:cellModel.key];
	}];
	[cell.sendImageDataSubject subscribeNext:^(NSArray *imageDataArray) {
		YSStrong;
		cellModel.image = imageDataArray[0];
		[strongSelf.imageDataDic setValue:imageDataArray forKey:cellModel.key];
		//       /****** strongSelf.imageDataArray = imageDataArray;*/ //待确认
		//        for (YSFormRowModel *model in strongSelf.midArray){
		//            if([model.type isEqual:@"upload"]){
		//                model.image = imageDataArray[0];
		//                //[strongSelf.payload setValue:imageDataArray forKey:model.key];
		//				[strongSelf.imageDataDic setValue:imageDataArray forKey:model.key];
		//            }
		//        }
	}];
	return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	if (self.remark) {
		UIView *view = [[UIView alloc] init];
		view.frame = CGRectZero;
		view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
		
		UILabel *remarkLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 100)];
		remarkLb.font = [UIFont systemFontOfSize:10];
		remarkLb.textColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
		remarkLb.numberOfLines = 0;
		remarkLb.text = self.remark;
		[view addSubview:remarkLb];
		[remarkLb mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.top.mas_equalTo(10);
			make.right.bottom.mas_equalTo(-10);
		}];
		return view;
		
	}
	return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if (self.remark) {
		CGRect rect = [self.remark boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 30, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil];
		return rect.size.height + 20;
	}
	return 0.0;
}
#pragma mark - cell点击处理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	YSFormRowModel *cellModel = self.dataSource[indexPath.row];
	if ([cellModel.type isEqual:@"user"]||[cellModel.type isEqual:@"usermsg"]){
		YSContactSelectPersonViewController *selectPerson = [[YSContactSelectPersonViewController alloc]init];
		selectPerson.indexPath = indexPath;
		selectPerson.jumpSourceStr = @"flowLaunch";
		[self.rt_navigationController pushViewController:selectPerson animated:YES];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	YSFormRowModel *cellModel = self.dataSource[indexPath.row];
	if ([cellModel.rowName isEqual:@"YSFormTextViewCell"]) {
		return 100*kHeightScale;
	} else {
		return indexPath.row == 0 ? 30 *kHeightScale : [tableView fd_heightForCellWithIdentifier:cellIdentifier configuration:^(YSFormCommonCell *cell) {
			cell = [[NSClassFromString(cellModel.rowName) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
			[cell setCellModel:cellModel];
		}];
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self.tableView selectRowAtIndexPath:nil animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)tableViewTouchInSide {
	[self.view endEditing:YES];
}

- (void)submit {
	
	// 校验数据
	BOOL isEmpty = NO;
	NSString *emptyKeyString;
	for (YSFormRowModel *model  in self.dataSource) {
		if(model.necessary){
			NSString *value = [self.payload valueForKey:model.key];
			while (!value || [value isEqual:@""] || [value isEqual:NULL] || [value isEqual:[NSNull null]]) {
				DLog(@"%@为空", model.key);
				emptyKeyString = model.key;
				isEmpty = YES;
				break;
			}
		}
	}
	// 必填数据不完整时提示用户输入相关数据
	if (isEmpty) {
		for (YSFormRowModel *model in self.dataSource) {
			while (model.key == emptyKeyString) {
				[QMUITips showError:[NSString stringWithFormat:@"请填写%@", model.title] inView:self.view hideAfterDelay:0.5];
				break;
			}
		}
	} else {
		[self submitData];
	}
}
- (void)submitData{
	/**
	 有附件时先上传图片，再提交表单*/
	NSMutableArray *imageDataArray = [NSMutableArray array];
	
	for (NSString *key in self.imageDataDic.allKeys) {
		[imageDataArray addObjectsFromArray:self.imageDataDic[key]];
	}
	[QMUITips showLoading:@"流程提交中..." inView:self.view];
	if (imageDataArray.count > 0) {
		
		dispatch_queue_t queue = dispatch_queue_create("queue.group",  DISPATCH_QUEUE_CONCURRENT); 
		dispatch_group_t groupGCD = dispatch_group_create(); //一个线程组
		for (NSString *key in self.imageDataDic.allKeys) {
			// 进入group
			   dispatch_group_enter(groupGCD);
				NSString *imageUrlString = [NSString stringWithFormat:@"%@%@", YSDomain, uploadAnnexApi];
				[YSNetManager ys_uploadImageWithUrlString:imageUrlString parameters:nil imageArray:self.imageDataDic[key] file:@"files" successBlock:^(id response) {
					NSString *fileValue = response[@"data"];
					[self.payload setValue:fileValue forKey:key];
					// 离开group
					dispatch_group_leave(groupGCD);
				} failurBlock:^(NSError *error) {
					
				} upLoadProgress:nil];
			
		}
		
		dispatch_group_notify(groupGCD, queue, ^{  //线程组的监听通知
			
			NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, addFormDesApi];
			/**
			 1.保存草稿；
			 2.发起流程。
			 */
			[self.payload setValue:@"2" forKey:@"status"];
			DLog(@"=======%@",self.payload);
			[YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:self.payload successBlock:^(id response) {
				DLog(@"payload:%@", self.payload);
				DLog(@"自定义表单提交结果:%@", response);
				[QMUITips showInfo:@"提交成功" inView:self.view hideAfterDelay:1.5];
				// 提交成功后跳转到流程中心已发界面并通知监听者刷新流程数据
				if ([response[@"code"] intValue] == 1) {
					[QMUITips hideAllTipsInView:self.view];
					for (YSFlowPageController *flowPageController in self.rt_navigationController.rt_viewControllers) {
						if ([flowPageController isKindOfClass:[YSFlowPageController class]]) {
							[self.rt_navigationController popToViewController:flowPageController animated:YES complete:^(BOOL finished) {
								[[NSNotificationCenter defaultCenter] postNotificationName:@"PostUpdateFlowTodo" object:nil];
								[flowPageController setSelectIndex:2];
								
							}];
						}
					}
					
					if ([self.source isEqualToString:@"HR"]) {
						[QMUITips showInfo:@"提交成功" inView:self.view hideAfterDelay:2];
						dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
							[self.navigationController popViewControllerAnimated:YES];
						});
						
					}
					
					
				} else {
					[QMUITips hideAllTipsInView:self.view];
					[QMUITips showError:@"流程提交失败" inView:self.view hideAfterDelay:1];
				}
			} failureBlock:^(NSError *error) {
				DLog(@"error:%@", error);
				[QMUITips hideAllTipsInView:self.view];
				[QMUITips showError:@"接口异常，请联系信息部处理" inView:self.view hideAfterDelay:1];
			} progress:nil];
			
		});
		
		
		
	}else{
		NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, addFormDesApi];
		/**
		 1.保存草稿；
		 2.发起流程。
		 */
		[self.payload setValue:@"2" forKey:@"status"];
		DLog(@"====11111111===%@",self.payload);
		[YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:self.payload successBlock:^(id response) {
			DLog(@"payload:%@", self.payload);
			DLog(@"自定义表单提交结果:%@", response);
			// 提交成功后跳转到流程中心已发界面并通知监听者刷新流程数据
			if ([response[@"code"] intValue] == 1) {
				[QMUITips hideAllTipsInView:self.view];
				for (YSFlowPageController *flowPageController in self.rt_navigationController.rt_viewControllers) {
					if ([flowPageController isKindOfClass:[YSFlowPageController class]]) {
						[self.rt_navigationController popToViewController:flowPageController animated:YES complete:^(BOOL finished) {
							
							[[NSNotificationCenter defaultCenter] postNotificationName:@"PostUpdateFlowTodo" object:nil];
							[flowPageController setSelectIndex:2];
						}];
						break;
					}
					
				}
				
				if ([self.source isEqualToString:@"HR"]) {
					[QMUITips showInfo:@"提交成功" inView:self.view hideAfterDelay:2];
					dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
						[self.navigationController popViewControllerAnimated:YES];
					});
				}
				
				
			} else {
				[QMUITips hideAllTipsInView:self.view];
				[QMUITips showError:@"流程提交失败" inView:self.view hideAfterDelay:1];
			}
		} failureBlock:^(NSError *error) {
			DLog(@"error:%@", error);
			[QMUITips hideAllTipsInView:self.view];
			[QMUITips showError:@"接口异常，请联系信息部处理" inView:self.view hideAfterDelay:1];
		} progress:nil];
	}
}
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
//比如选择是否项目人员：
/** {
 formCode = GFRS0022;
 formId = 8a8a94aa5f9b2c64015fb2ea0ba90283;
 fromFieldId = "_field_1527681121831";
 id = 8a8a94aa66ebbe750166ed1e1536002b;
 isHide = "<null>";
 isNull = 1;//影响是否必填
 toFieldId = "_field_1527681121898";//影响哪个控件
 value = 1;
 },
 {
 formCode = GFRS0022;
 formId = 8a8a94aa5f9b2c64015fb2ea0ba90283;
 fromFieldId = "_field_1527681121831";
 id = 8a8a94aa66ebbe750166ed1e153b002c;
 isHide = "<null>";
 isNull = 1;
 toFieldId = "_field_1527681121965";
 value = 1;
 },
 {
 formCode = GFRS0022;
 formId = 8a8a94aa5f9b2c64015fb2ea0ba90283;
 fromFieldId = "_field_1527681121831";
 id = 8a8a94aa66ebbe750166ed1e153b002d;
 isHide = 1;
 isNull = "<null>";
 toFieldId = "_field_1539166261949";
 value = 1;
 },
 {
 formCode = GFRS0022;
 formId = 8a8a94aa5f9b2c64015fb2ea0ba90283;
 fromFieldId = "_field_1527681121831";
 id = 8a8a94aa66ebbe750166ed1e153b002e;
 isHide = "<null>";
 isNull = 1;
 toFieldId = "_field_1527681121898";
 value = 2;
 },
 {
 formCode = GFRS0022;
 formId = 8a8a94aa5f9b2c64015fb2ea0ba90283;
 fromFieldId = "_field_1527681121831";
 id = 8a8a94aa66ebbe750166ed1e153b002f;
 isHide = "<null>";
 isNull = 1;
 toFieldId = "_field_1527681121965";
 value = 2;
 },。。。。。
 这个cell对应的是有关联控件的，上面就是他的选择不同的值所对应的关联控件，数据固定不变，我选择value == 1 即[dic allKeys].firstObject == 1的时候，这时候在关联控件itemLinkeds数组中存在三个value==1的项，value==1影响的有三个他所关联的控件的显示和隐藏（_field_1527681121898，_field_1527681121965，_field_1539166261949），保存这些
 */
