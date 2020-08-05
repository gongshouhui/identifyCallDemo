//
//  YSOpinionEditController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2020/1/6.
//  Copyright © 2020 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSOpinionEditController.h"
#import "YSFormRowModel.h"
#import "YSHROptionEditCell.h"
#import "YSFormCommonCell.h"
#import "YSOpinionModel.h"
@interface YSOpinionEditController ()
@property (nonatomic,strong) NSMutableArray *configArray;
@property (nonatomic,strong) YSFormCommonCell *totalCell;
@property (nonatomic,strong) NSMutableArray *sectionOneArr;
@property (nonatomic,strong) NSMutableArray *sectionTwoArr;
@property (nonatomic,strong) NSMutableArray *sectionThreeArr;
@end

@implementation YSOpinionEditController
- (NSMutableArray *)configArray {
	if (!_configArray) {
		_configArray = [NSMutableArray array];
		_sectionOneArr = [NSMutableArray array];
		YSFormRowModel *model0 = [[YSFormRowModel alloc] init];
		model0.rowName = @"YSFormOptionsCell";
		model0.necessary = YES;
		model0.title = @"转正方式";//点击cell跳转选人
		model0.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		model0.optionsDataArray = @[@{@"1": @"正常转正"},
									@{@"0":@"延迟转正"},
									@{@"4":@"不予转正"}];
		model0.paraKey = @"regularType";
		
		
		
		
		
		
		
		
		[_sectionOneArr addObject:model0];
		
		
		_sectionTwoArr =  [NSMutableArray array];
		
		YSOpinionModel *model3 = [[YSOpinionModel alloc] init];
		model3.title = @"工作能力（30分）*";
		model3.rowName = @"YSHROptionEditCell";
		
		YSOpinionModel *model4 = [[YSOpinionModel alloc] init];
		model4.title = @"工作绩效（30分）*";
		model4.rowName = @"YSHROptionEditCell";
		
		YSOpinionModel *model5 = [[YSOpinionModel alloc] init];
		model5.title = @"工作态度（20分）*";
		model5.rowName = @"YSHROptionEditCell";
		
		YSOpinionModel *model6 = [[YSOpinionModel alloc] init];
		model6.title = @"工作总结（20分）*";
		model6.rowName = @"YSHROptionEditCell";
		
		[_sectionTwoArr addObject:model3];
		[_sectionTwoArr addObject:model4];
		[_sectionTwoArr addObject:model5];
		[_sectionTwoArr addObject:model6];
		
		_sectionThreeArr =  [NSMutableArray array];
		YSFormRowModel *model7 = [[YSFormRowModel alloc] init];
		model7.rowName = @"YSFormDetailCell";
		model7.title = @"评估总分合计";//点击cell跳转选人
		
		[_sectionThreeArr addObject:model7];
		
		
		[_configArray addObject:_sectionOneArr];
		[_configArray addObject:_sectionTwoArr];
		[_configArray addObject:_sectionThreeArr];
		
		
	}
	return _configArray;
}
- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"评估人意见";
	UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
	[submit setTitle:@"保存" forState:UIControlStateNormal];
	submit.backgroundColor = [UIColor colorWithHexString:@"#2A8ADB"];
	[self.view addSubview:submit];
	[submit mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(15);
		make.right.mas_equalTo(-15);
		make.bottom.mas_equalTo(-kBottomHeight);
		make.height.mas_equalTo(50);
	}];
	YSWeak;
	[[submit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		[weakSelf submit];
	}];
	
}
///底部有按钮的时候 使用
- (void)layoutTableView {
	self.tableView.frame = CGRectMake(0, kTopHeight, kSCREEN_WIDTH, kSCREEN_HEIGHT-kTopHeight-kBottomHeight-50*kHeightScale);
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
	if (indexPath.section == 0 || indexPath.section == 2) {
		YSFormRowModel *cellModel = self.configArray[indexPath.section][indexPath.row];
		YSFormCommonCell *cell = [[NSClassFromString(cellModel.rowName) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
		if (indexPath.section == 2) {
			self.totalCell = cell;//保存指针
		}
		[cell setCellModel:cellModel];
		YSWeak;
		__weak __typeof(cell) weakCell = cell;
		
		//多选信号订阅
		[cell.sendOptionsSubject subscribeNext:^(NSDictionary *optionDic) {
			YSStrong;
			//保存值
			cellModel.detailTitle = optionDic.allValues.firstObject;
			cellModel.key = optionDic.allKeys.firstObject;
			
			if ([cellModel.detailTitle isEqualToString:@"正常转正"]) {
				NSMutableArray *newArr = [NSMutableArray array];
				[newArr addObject:cellModel];
				
				YSFormRowModel *model2 = [[YSFormRowModel alloc] init];
				model2.rowName = @"YSFormDetailCell";
				model2.necessary = YES;
				model2.title = @"拟转正时间";//点击cell跳转选人
				model2.detailTitle = [strongSelf getDateStringWitHEntry:[strongSelf.initiationTime doubleValue] month:0 day:1];
				model2.paraKey = @"quasiExpectedDate";
				[newArr addObject:model2];
				[strongSelf.configArray replaceObjectAtIndex:0 withObject:newArr];
				[strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationNone)];
			}
			
			
			if ([cellModel.detailTitle isEqualToString:@"延迟转正"]) {//延迟转正
				NSMutableArray *newArr = [NSMutableArray array];
				[newArr addObject:cellModel];
				
				YSFormRowModel *model1 = [[YSFormRowModel alloc] init];
				model1.rowName = @"YSFormOptionsCell";
				model1.necessary = YES;
				model1.title = @"延缓期限";
				model1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				model1.optionsDataArray = @[@{@"1": @"1个月"},
											@{@"2": @"2个月"},@{@"0":@"3个月"}];
				model1.paraKey = @"deferralPeriod";
				[newArr addObject:model1];
				
				YSFormRowModel *model2 = [[YSFormRowModel alloc] init];
				model2.rowName = @"YSFormDetailCell";
				model2.necessary = YES;
				model2.title = @"拟转正时间";//点击cell跳转选人
				model2.paraKey = @"quasiExpectedDate";
				[newArr addObject:model2];
				
				[strongSelf.configArray replaceObjectAtIndex:0 withObject:newArr];
				[strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationNone)];
				
				
			}
			
			
			if ([cellModel.detailTitle isEqualToString:@"不予转正"] ) {
				NSMutableArray *newArr = [NSMutableArray array];
				[newArr addObject:cellModel];
					[strongSelf.configArray replaceObjectAtIndex:0 withObject:newArr];
				[strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationNone)];
			}
			
			if ([cellModel.title containsString:@"延缓期限"]) {//选择y延缓期限
				YSFormRowModel *nextModel = strongSelf.configArray[indexPath.section][indexPath.row + 1];
				nextModel.detailTitle = [strongSelf getDateStringWitHEntry:[strongSelf.initiationTime doubleValue] month:[cellModel.detailTitle intValue]  day:1];
				[strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationNone)];
				
			}
			
			
		}];
		[cell.sendValueSubject subscribeNext:^(id x) {//选择的时间
			
			cellModel.detailTitle = x;
		}];
		
		return cell;
	}else{//section = 1
		YSOpinionModel *cellModel = self.configArray[indexPath.section][indexPath.row];
		YSFormRowModel *totalScoreModel = self.configArray[2][0];//获取最后一行
		YSHROptionEditCell *cell = [[YSHROptionEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
		cell.selectionStyle =UITableViewCellSelectionStyleNone;
		cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, SCREEN_WIDTH);
		YSWeak;
		[cell setOpinionBlock:^(NSString * _Nonnull score, NSString * _Nonnull opinion) {
			cellModel.score = score;
			cellModel.opinion = opinion;
			NSInteger totalScore = 0;
			for (YSOpinionModel *opinionModel in weakSelf.configArray[1]) {
				totalScore += [opinionModel.score integerValue];
			}
			totalScoreModel.detailTitle = [NSString stringWithFormat:@"%ld",totalScore];
			weakSelf.totalCell.detailTextLabel.text = totalScoreModel.detailTitle;
		}];
		[cell setOpinionModel:cellModel];
		return cell;
	}
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
	return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if (section == 1) {
		return 0.01;
	}else{
		return UITableViewAutomaticDimension;
	}
	
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	if (section == 0) {
		UIView *view = [UIView new];
		UILabel *label = [[UILabel alloc]initWithFont:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithHexString:@"#999999"]];
		label.text = @"请确认已和员工本人完成转正面谈，且员工接受该转正结果。一旦提交，转正结果不可更改。";
		label.numberOfLines = 0;
		[view addSubview:label];
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.mas_equalTo(15);
			make.right.mas_equalTo(-15);
			make.top.mas_equalTo(10);
			make.bottom.mas_equalTo(-10);
		}];
		return view;
	}else if (section == 2){
		UIView *view = [UIView new];
		UILabel *label = [[UILabel alloc]initWithFont:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithHexString:@"#999999"]];
		label.text = @"上述评估得分在70分以下，视为员工不能够胜任该岗位。若员工对评分及结果有异议，请员工在流程结束后三个工作日内向人力资源部进行反馈， 逾期不反馈，将视为认可此次评分及结果。";
		label.numberOfLines = 0;
		[view addSubview:label];
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.mas_equalTo(15);
			make.right.mas_equalTo(-15);
			make.top.mas_equalTo(10);
			make.bottom.mas_equalTo(-10);
		}];
		return view;
		
	}else{
		
		return nil;
	}
}

#pragma mark - 提交按钮
- (void)submit{
	for (YSFormRowModel *model in self.configArray[0]) {
		if (!model.detailTitle.length) {
			[QMUITips showError:[NSString stringWithFormat:@"请填写%@",model.title] inView:self.view hideAfterDelay:2];
			return;
		}
	}
	for (YSOpinionModel *model in self.configArray[1]) {
		if (!model.opinion.length || !model.score.length) {
			[QMUITips showError:[NSString stringWithFormat:@"请填写或打分%@",model.title] inView:self.view hideAfterDelay:2];
			return;
		}
		if (!model.opinion.length ) {
			[QMUITips showError:[NSString stringWithFormat:@"%@描述不能为空",model.title] inView:self.view hideAfterDelay:2];
			return;
		}
		if ([model.title containsString:@"能力"] || [model.title containsString:@"绩效"]) {
			if ([model.score intValue] > 30) {
				[QMUITips showError:[NSString stringWithFormat:@"%@评分不能大于30分",model.title] inView:self.view hideAfterDelay:2];
				return;
			}
		}
		
		if ([model.title containsString:@"态度"] || [model.title containsString:@"总结"]) {
			if ([model.score intValue] > 20) {
				[QMUITips showError:[NSString stringWithFormat:@"%@评分不能大于20分",model.title] inView:self.view hideAfterDelay:2];
				return;
			}
		}
		
		
		
	}
	
	YSFormRowModel *totalScoreModel = self.configArray[2][0];
	if ([totalScoreModel.detailTitle intValue] < 70 && [[self.configArray[0][0] detailTitle] isEqualToString:@"正常转正"]) {
		[QMUITips showError:@"评分总分低于70分不能正常转正" inView:self.view hideAfterDelay:2];
		return;
	}
	
	
	//参数

	NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
	for (YSFormRowModel *model in self.configArray[0]) {
		if ([model.title containsString:@"拟转正"]) {
			[paraDic setValue:model.detailTitle forKey:model.paraKey];
		}else{
			[paraDic setValue:model.key forKey:model.paraKey];
		}
	}
	
	
	[paraDic setValue:[self.configArray[1][0] opinion] forKey:@"workAbility"];
	[paraDic setValue:[self.configArray[1][0] score] forKey:@"gradeAbility"];
	[paraDic setValue:[self.configArray[1][1] opinion] forKey:@"workPerformance"];
	[paraDic setValue:[self.configArray[1][1] score] forKey:@"gradePerformance"];
	[paraDic setValue:[self.configArray[1][2] opinion] forKey:@"workAttitude"];
	[paraDic setValue:[self.configArray[1][2] score] forKey:@"gradeAttitude"];
	[paraDic setValue:[self.configArray[1][3] opinion] forKey:@"workSummary"];
	[paraDic setValue:[self.configArray[1][3] score] forKey:@"gradeSummary"];
	
	
	[paraDic setValue:[self.configArray[2][0] detailTitle] forKey:@"gradeTotal"];
	[paraDic setValue:[YSUtility getDeptId] forKey:@"deptId"];
	
	[paraDic setValue:self.applicantEmployeeCode forKey:@"applicantEmployeeCode"];
	[paraDic setValue:@"3" forKey:@"state"];
	
	//
	NSMutableDictionary *submitDic = [NSMutableDictionary dictionary];
	[submitDic setValue:paraDic forKey:@"recruitFormals"];
	[submitDic setValue:@{@"bizId":self.bussinessId} forKey:@"initiator"];
	[QMUITips showLoadingInView:self.view];
	[YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,@"flowCenter/personnelAllot/saveZZsp"] isNeedCache:NO parameters:submitDic successBlock:^(id response) {
		[QMUITips hideAllTipsInView:self.view];
		if ([response[@"code"] integerValue] == 1) {
			[QMUITips showInfo:@"保存成功" inView:self.view hideAfterDelay:1.5];
			self.editControllerBlock(@"保存成功");
			[self.navigationController popViewControllerAnimated:YES];
		}
		
	} failureBlock:^(NSError *error) {
		[QMUITips hideAllTipsInView:self.view];
	} progress:nil];
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//	[self.view endEditing:YES];
//}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (NSString *)getDateStringWitHEntry:(NSTimeInterval)time month:(NSInteger)month day:(NSInteger)day {
	
	
	NSDate *date = [[[NSDate dateWithTimeIntervalSince1970:time/1000] dateByAddingMonths:month] dateByAddingDays:1];
	NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	return [formatter stringFromDate:date];
	
}
- (void)dealloc
{
	DLog(@"edit释放了");
}
@end
