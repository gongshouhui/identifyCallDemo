//
//  YSFlowValSoftWareEditController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/4/26.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowValSoftWareEditController.h"
#import "YSFormRowModel.h"
#import "YSFormCommonCell.h"
#import "YSFlowBackGroundCell.h"
#import "YSFlowEmptyCell.h"
@interface YSFlowValSoftWareEditController ()
/**表单填写参考信息*/
@property (nonatomic,strong) NSMutableArray *infoArray;
@property (nonatomic,strong) NSDictionary *submitData;
@end

@implementation YSFlowValSoftWareEditController
- (NSMutableArray *)infoArray {
	if (!_infoArray) {
		_infoArray = [NSMutableArray array];
	}
	return _infoArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"软件明细";
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    submit.backgroundColor = [UIColor colorWithHexString:@"#2A8ADB"];
    [self.view addSubview:submit];
    [submit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-kBottomHeight-30);
        make.height.mas_equalTo(50);
    }];
    YSWeak;
    [[submit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf submit];
    }];
}
- (void)setEditType:(ValuationEditType)editType {
	_editType = editType;
	if (self.editType == ValuationEditPersonSYDepartNode || self.editType == ValuationEditPersonSJDepartNode) {
		YSFormRowModel *model1 = [[YSFormRowModel alloc] init];
		model1.title = @"受理方式*";
		if ([self.softwareModel.handleType isEqualToString:@"CG"]) {
			model1.detailTitle = @"采购";
		}
		if ([self.softwareModel.handleType isEqualToString:@"DB"]) {
			model1.detailTitle = @"调拨";
		}
		
		model1.rowName = @"YSFormOptionsCell";
		model1.optionsDataArray = @[@{@"CG": @"采购"},
									@{@"DB": @"调拨"}];
		model1.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
		[self.dataSourceArray addObject:model1];
	}else if (self.editType == ValuationEditPersonSYITNode || self.editType == ValuationEditDutyCGITNode){
		YSFormRowModel *model1 = [[YSFormRowModel alloc] init];
		model1.rowName = @"YSFormTextFieldCell";
		model1.keyboardType = UIKeyboardTypeDefault;
		model1.title = @"锁号*";
		model1.detailTitle = self.softwareModel.lockNumber;
		[self.dataSourceArray addObject:model1];
		
		YSFormRowModel *model2 = [[YSFormRowModel alloc] init];
		model2.rowName = @"YSFormTextFieldCell";
		model2.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
		model2.title = @"采购金额*";
		if (self.softwareModel.purchMoney > 0) {
			model2.detailTitle = [NSString stringWithFormat:@"%.2f",self.softwareModel.purchMoney];
		}
		
		[self.dataSourceArray addObject:model2];
	}else if (self.editType == ValuationEditPersonSJITNode || self.editType == ValuationEditDutySJITNode){
		YSFormRowModel *model2 = [[YSFormRowModel alloc] init];
		model2.rowName = @"YSFormTextFieldCell";
		model2.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
		model2.title = @"采购金额*";
		if (self.softwareModel.purchMoney > 0) {
			model2.detailTitle = [NSString stringWithFormat:@"%.2f",self.softwareModel.purchMoney];
		}
		[self.dataSourceArray addObject:model2];
	}
	[self.tableView reloadData];
}
-(void)setUpData {
	
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
            YSFormRowModel *model = self.dataSourceArray[indexPath.row];
            YSFormCommonCell *cell = [[NSClassFromString(model.rowName) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            [cell setCellModel:model];//当cell编辑的时候，数据记录在model里了
            return cell;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
    
}
- (void)submit {
	
	if (self.editType == ValuationEditPersonSYDepartNode || self.editType == ValuationEditPersonSJDepartNode) {
		YSFormRowModel *formModel = self.dataSourceArray[0];//就一个编辑选项
		if (!formModel.detailTitle.length) {
			[QMUITips showInfo:@"请选择处理方式" inView:self.view hideAfterDelay:1.5];
			return;
		}
		
		self.softwareModel.handleType = [formModel.detailTitle isEqualToString:@"采购"] ? @"CG":@"DB";
		
//		NSString *jsonStr = [self getJsonString:@[@{@"id":self.softwareModel.id,
//													@"handleType":self.softwareModel.handleType,
//													}]];
//		self.submitData = @{@"id":self.formId,
//							@"datas":jsonStr,
//							};
		[self submitNetData];
	}else if (self.editType == ValuationEditPersonSYITNode || self.editType == ValuationEditDutyCGITNode){
		YSFormRowModel *formModel1 = self.dataSourceArray[0];//锁号
		if (!formModel1.detailTitle.length) {
			[QMUITips showInfo:@"请选择锁号" inView:self.view hideAfterDelay:1.5];
			return;
		}
		self.softwareModel.lockNumber = formModel1.detailTitle;
		
		YSFormRowModel *formModel2 = self.dataSourceArray[1];//
		if (!formModel2.detailTitle.length) {
			[QMUITips showInfo:@"请输入采购金额" inView:self.view hideAfterDelay:1.5];
			return;
		}
		self.softwareModel.purchMoney = [formModel2.detailTitle floatValue];
		
//		NSString *jsonStr = [self getJsonString:@[@{@"id":self.softwareModel.id,
//													@"handleType":self.softwareModel.handleType,
//													@"purchMoney":@(self.softwareModel.purchMoney),
//													@"lockNumber":self.softwareModel.lockNumber
//													}]];
//		self.submitData = @{@"id":self.formId,
//							@"datas":jsonStr,
//							};
		[self submitNetData];
	}else if (self.editType == ValuationEditPersonSJITNode || self.editType == ValuationEditDutySJITNode){
		YSFormRowModel *formModel = self.dataSourceArray[0];//就一个编辑选项
		if (!formModel.detailTitle.length) {
			[QMUITips showInfo:@"请输入采购金额" inView:self.view hideAfterDelay:1.5];
			return;
		}
		self.softwareModel.purchMoney = [formModel.detailTitle floatValue];
//		NSString *jsonStr = [self getJsonString:@[@{@"id":self.softwareModel.id,
//													@"handleType":self.softwareModel.handleType,
//													@"purchMoney":@(self.softwareModel.purchMoney),
//													}]];
//		self.submitData = @{@"id":self.formId,
//							@"datas":jsonStr,
//							};
		[self submitNetData];
	}	
}
- (void)submitNetData {
	
			
	if (self.editValuationSuccessBlock) {
		self.editValuationSuccessBlock(self.softwareModel.handleType, self.softwareModel.purchMoney, self.softwareModel.lockNumber);
	}
	
	[self.navigationController popViewControllerAnimated:YES];
}

@end
