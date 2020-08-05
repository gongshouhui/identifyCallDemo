//
//  YSFlowDrinksEditController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/4/9.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowDrinksEditController.h"
#import "YSFormRowModel.h"
#import "YSFormCommonCell.h"
@interface YSFlowDrinksEditController ()

@end

@implementation YSFlowDrinksEditController

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
    YSFormRowModel *model1 = [[YSFormRowModel alloc] init];
    model1.title = @"受理方式*";
    if ([self.drinkdModel.apply.acceptMode isEqualToString:@"CG"]) {
        model1.detailTitle = @"采购";
    }
    if ([self.drinkdModel.apply.acceptMode isEqualToString:@"LY"]) {
         model1.detailTitle = @"领用";
    }
    
    model1.rowName = @"YSFormOptionsCell";
    model1.optionsDataArray = @[@{@"CG": @"采购"},
                                @{@"LY": @"领用"}];
    model1.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    [self.dataSourceArray addObject:model1];
    
    if ([self.drinkdModel.apply.acceptMode isEqualToString:@"LY"]) {
        YSFormRowModel *model2 = [[YSFormRowModel alloc] init];
        model2.rowName = @"YSFormTextFieldCell";
        model2.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        model2.title = @"领用金额*";
        model2.detailTitle = self.drinkdModel.apply.receiveMoney;
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
    YSWeak;
    [cell.sendOptionsSubject subscribeNext:^(NSDictionary *dic) {
        YSStrong;
        if ([[dic allValues].firstObject isEqualToString:@"领用"]) {
            if (strongSelf.dataSourceArray.count < 2) {
                YSFormRowModel *model2 = [[YSFormRowModel alloc] init];
                model2.rowName = @"YSFormTextFieldCell";
                model2.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                model2.title = @"领用金额*";
                [strongSelf.dataSourceArray addObject:model2];
                [strongSelf.tableView reloadData];
                
            }
        }else{
            if (strongSelf.dataSourceArray.count > 1) {
                YSFormRowModel *model = strongSelf.dataSourceArray[0];
                [strongSelf.dataSourceArray removeAllObjects];
                [strongSelf.dataSourceArray addObject:model];
                [strongSelf.tableView reloadData];
            }
        }
    }];
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
        NSString *acceptMode = [self.dataSourceArray[0] detailTitle];
        if ([acceptMode isEqualToString:@"采购"]) {
            acceptMode = @"CG";
        }else {//领用
            acceptMode = @"LY";
        }
        NSString *receiveMoney = nil;
        if (self.dataSourceArray.count > 1) {
            receiveMoney = [self.dataSourceArray[1] detailTitle];
        }
        self.editSuccessBlock(acceptMode,receiveMoney);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


@end
