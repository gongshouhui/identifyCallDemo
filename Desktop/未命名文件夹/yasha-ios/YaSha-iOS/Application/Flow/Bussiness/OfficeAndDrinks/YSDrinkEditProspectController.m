//
//  YSDrinkEditProspectController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/4/11.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSDrinkEditProspectController.h"
#import "YSFormRowModel.h"
#import "YSFormCommonCell.h"
@interface YSDrinkEditProspectController ()

@end

@implementation YSDrinkEditProspectController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self setUpData];
}
- (void)setUpData {
    if ([self.title isEqualToString:@"预估信息填写"]) {
        YSFormRowModel *model1 = [[YSFormRowModel alloc] init];
        model1.rowName = @"YSFormTextFieldCell";
        model1.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        model1.title = @"预估金额*";
        model1.detailTitle = self.drinkdModel.apply.prospectMoney;
        [self.dataSourceArray addObject:model1];
        
        YSFormRowModel *model2 = [[YSFormRowModel alloc] init];
        model2.rowName = @"YSFormTextFieldCell";
        model2.title = @"采购数量*";
        model2.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        model2.detailTitle = [NSString stringWithFormat:@"%ld",self.drinkdModel.apply.purchaseNumber];
        [self.dataSourceArray addObject:model2];
    }
    
    if ([self.title isEqualToString:@"实际采购信息填写"]) {
        YSFormRowModel *model1 = [[YSFormRowModel alloc] init];
        model1.rowName = @"YSFormTextFieldCell";
        model1.title = @"实际采购金额*";
        model1.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        model1.detailTitle = self.drinkdModel.apply.actualPurchaseMoney;
        [self.dataSourceArray addObject:model1];
        
        YSFormRowModel *model2 = [[YSFormRowModel alloc] init];
        model2.rowName = @"YSFormTextFieldCell";
        model2.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        model2.title = @"实际采购数量*";
        model2.detailTitle = [NSString stringWithFormat:@"%ld",self.drinkdModel.apply.actualPurchaseNumber];
        [self.dataSourceArray addObject:model2];
    }
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)submit {
    if (self.editSuccessBlock) {
        NSString *money = [self.dataSourceArray[0] detailTitle];
       
         NSInteger num = [[self.dataSourceArray[1] detailTitle] integerValue];
        
        self.editSuccessBlock(money,num);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
@end
