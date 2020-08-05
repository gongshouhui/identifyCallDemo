//
//  YSValuationSoftwareDetailController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/4/26.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSValuationSoftwareDetailController.h"
#import "YSFlowEditCell.h"
#import "YSFlowBackGroundCell.h"
#import "YSFlowEmptyCell.h"
#import "YSFlowFormListCell.h"
#import "FBKVOController.h"
@interface YSValuationSoftwareDetailController ()
@property (nonatomic,strong) YSValuationSoftwareDetailViewModel *viewModel;
@property (nonatomic,strong) FBKVOController *KVOController;
@end

@implementation YSValuationSoftwareDetailController
- (instancetype)initWithViewModel:(YSValuationSoftwareDetailViewModel *)viewModel {
	if (self = [super init]) {
		self.viewModel = viewModel;
	}
	return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
	//self.title = @"软件升级详情";
	FBKVOController *KVOController = [FBKVOController controllerWithObserver:self];
	self.KVOController = KVOController;
	YSWeak;
	[self.KVOController observe:self.viewModel keyPaths:@[@"handType",@"purchMoney",@"lockNumber"] options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
		[weakSelf.tableView reloadData];
	}];
    // Do any additional setup after loading the view.
}
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.viewModel turnBack];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return self.viewModel.viewDataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.viewModel.viewDataArr[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary *dataDic = self.viewModel.viewDataArr[indexPath.section][indexPath.row];
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
		YSFlowEmptyCell *cell = [[YSFlowEmptyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
		cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kSCREEN_WIDTH);
		return cell;
		
	}else{
		YSFlowFormListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSFlowFormListCell"]; //出列可重用的cell
		
		if (cell == nil) {
			cell = [[YSFlowFormListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSFlowFormListCell"];
		}
		[cell setCommonBusinessFlowDetailWithDictionary:dataDic];
		return cell;
	}
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 30*kHeightScale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return UITableViewAutomaticDimension;
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.viewModel turnOtherViewControllerWith:self andIndexPath:indexPath];
}

@end
