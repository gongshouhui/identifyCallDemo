//
//  YSYearSalaryDetailController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2020/1/3.
//  Copyright © 2020 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSYearSalaryDetailController.h"
#import "YSSalaryCell.h"
#import "YSSalaryHeaderView.h"
#import "YSSalaryRemarkCell.h"
#import "YSImageTitleButton.h"
@interface YSYearSalaryDetailController ()
@property (nonatomic,strong)NSMutableArray *infoArr;
@property (nonatomic,strong)NSMutableArray *payArr;
@property (nonatomic,strong)NSMutableArray *welfareArr;
@property (nonatomic,strong)NSMutableArray *takeoutArr;
@property (nonatomic,strong)NSMutableArray *remarkArr;
@property (nonatomic,strong) NSMutableArray *deductArr;
@property (nonatomic,strong)NSArray *titleArray;
@property (nonatomic,strong) UIView *footerView;
@end

@implementation YSYearSalaryDetailController

#pragma mark - 懒加载
- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"基本信息",@"2019年税前年薪 (元)",@"年终奖发放 (元)",@"备注"];
    }
    return _titleArray;
}
- (UIView *)footerView {
	if (!_footerView) {
		_footerView = [[UIView alloc]init];
		UILabel *label = [[UILabel alloc]initWithFont:[UIFont systemFontOfSize:13] textColor:[UIColor colorWithHexString:@"#999999"]];
		label.text = @"个税：根据年终奖税率表得出。";
		[_footerView addSubview:label];
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.mas_equalTo(15);
			make.top.mas_equalTo(15);
		}];
	}
	return _footerView;
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
     self.title = @"年终奖明细";
}

- (void)initTableView {
    [super initTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kUIColor(229, 229, 229, 1);
    [self.tableView registerClass:[YSSalaryRemarkCell class] forCellReuseIdentifier:@"YSSalaryRemarkCell"];
	self.tableView.tableFooterView = self.footerView;
    [self doNetworking];
    
}
- (void)doNetworking{
    self.infoArr = [NSMutableArray array];
    self.payArr = [NSMutableArray array];
    self.welfareArr = [NSMutableArray array];
    self.remarkArr = [NSMutableArray array];
	
    [self.infoArr addObject:@{@"工号":self.salaryModel.icode}];
    [self.infoArr addObject:@{@"姓名":self.salaryModel.iname}];
    [self.infoArr addObject:@{@"工资发放部门":self.salaryModel.deptName}];
   

    [self.payArr addObject:@{@"固薪":self.salaryModel.fixedSalary}];
    [self.payArr addObject:@{@"个人绩效":self.salaryModel.personalEffectiveness}];
    [self.payArr addObject:@{@"考核后浮薪":self.salaryModel.noteFloatingSalary}];
    [self.payArr addObject:@{@"考核后年薪":self.salaryModel.noteYearlySalary}];
    

    [self.welfareArr addObject:@{@"税前应发":self.salaryModel.beforeTaxSalary}];
    [self.welfareArr addObject:@{@"个税":self.salaryModel.incomeTax}];
    [self.welfareArr addObject:@{@"实发":self.salaryModel.actualSalary}];
   
	//备注
    [self.remarkArr addObject:@{@"remark":self.salaryModel.remark}];
	
	
    
    [self.dataSourceArray addObject:_infoArr];
    [self.dataSourceArray addObject:_payArr];
    [self.dataSourceArray addObject:_welfareArr];
    [self.dataSourceArray addObject:_remarkArr];
    
    [self.tableView reloadData];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [(NSArray *)(self.dataSourceArray[section]) count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == self.dataSourceArray.count - 1) {
         return [tableView fd_heightForCellWithIdentifier:@"YSSalaryRemarkCell" cacheByIndexPath:indexPath configuration:^(YSSalaryRemarkCell *cell) {

        cell.remarkLb.text = self.dataSourceArray[indexPath.section][indexPath.row][@"remark"];

        }];
    }else{
        return 40*kHeightScale;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == self.dataSourceArray.count - 1) {
        YSSalaryRemarkCell *cell = [[YSSalaryRemarkCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"YSSalaryRemarkCell"];
        cell.dic = self.dataSourceArray[indexPath.section][indexPath.row];
        return cell;
    }else{
       
        YSSalaryCell *cell = [[YSSalaryCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"YSSalaryCell"];
        cell.dic = self.dataSourceArray[indexPath.section][indexPath.row];
        [cell setOtherByIndexPath:indexPath withArray:self.dataSourceArray[indexPath.section]];//设置圆角 字体
        return cell;
    }
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = kUIColor(229, 229, 229, 1);
    UILabel *label = [[UILabel alloc]init];
    [view addSubview:label];
    [label sizeToFit];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = kUIColor(102, 102, 102, 1);
    
    label.text = self.titleArray[section];
    label.frame = CGRectMake(15, (38 - 20)/2, kSCREEN_WIDTH, 20);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 38;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
