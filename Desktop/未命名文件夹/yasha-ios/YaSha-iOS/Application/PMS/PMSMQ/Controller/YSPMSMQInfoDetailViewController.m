//
//  YSPMSMQInfoDetailViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/13.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSMQInfoDetailViewController.h"
#import "YSPMSInfoDetailHeaderCell.h"
#import "YSContentTextCell.h"
#import "YSExpenseShareHeaderView.h"

@interface YSPMSMQInfoDetailViewController ()<YSExpenseShareHeaderViewDelegate>

@property (nonatomic, strong) NSMutableArray *contentDataArray;
@property (nonatomic, strong) NSString *projectName;
//当前控制器记录展开收起
@property (nonatomic,strong) NSMutableArray *isOpenArray;

@end

@implementation YSPMSMQInfoDetailViewController
- (NSMutableArray *)isOpenArray {
    if (!_isOpenArray) {
        _isOpenArray = [NSMutableArray array];
    }
    return _isOpenArray;
}
- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"项目信息详情";
}

- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSPMSInfoDetailHeaderCell class] forCellReuseIdentifier:@"InfoDetailCell"];
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self handleData];
}

- (void)handleData {
    NSMutableArray *proGeneralArr = [NSMutableArray array];
   
    [proGeneralArr addObject:@{@"合同形式":_infoModel.contFormName?_infoModel.contFormName:@"-"}];
    [proGeneralArr addObject:@{@"是否公建":_infoModel.isPublic == 10?@"是":@"否"}];
    [proGeneralArr addObject:@{@"质量目标":_infoModel.qtarget?_infoModel.qtarget:@"-"}];
    [proGeneralArr addObject:@{@"合同开工": [YSUtility timestampSwitchTime:_infoModel.planStart andFormatter:@"yyyy-MM-dd"]}];
    [proGeneralArr addObject:@{@"合同竣工":[YSUtility timestampSwitchTime:_infoModel.planEnd andFormatter:@"yyyy-MM-dd"]}];
    [proGeneralArr addObject:@{@"保修期限（年）":_infoModel.repairStr?_infoModel.repairStr:@"-"}];
    [proGeneralArr addObject:@{@"保险时间":_infoModel.proInsDate?_infoModel.proInsDate:@""}];
    [proGeneralArr addObject:@{@"甲方单位":_infoModel.firstUnit?_infoModel.firstUnit:@""}];
    
    [self.dataSourceArray addObject:proGeneralArr];
    [self.dataSourceArray addObject:@[@{@"施工范围":_infoModel.conScope.length?_infoModel.conScope:@"暂无信息"}]];
    [self.dataSourceArray addObject:@[@{@"合同分段工期描述":_infoModel.sectionDurationDescription.length?_infoModel.sectionDurationDescription:@"暂无信息"}]];
    [self.dataSourceArray addObject:@[@{@"合同奖励条款":_infoModel.awardClause.length?_infoModel.awardClause:@"暂无信息"}]];
    [self.dataSourceArray addObject:@[@{@"合同处罚条款":_infoModel.penaltyClause.length?_infoModel.penaltyClause:@"暂无信息"}]];
    [self.dataSourceArray addObject:@[@{@"合同付款条款":_infoModel.contractPaymentTerms.length?_infoModel.contractPaymentTerms:@"暂无信息"}]];
   
    for (int i = 0; i < self.dataSourceArray.count; i++) {//当前控制器记录展开收起
        if (i == 0) {
            [self.isOpenArray addObject:@"open"];
        }else{
            [self.isOpenArray addObject:@"close"];
        }
    }
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.isOpenArray[section] isEqualToString:@"open"]) {
       return [self.dataSourceArray[section] count];
    }else{
        return 0;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        YSPMSInfoDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSPMSInfoDetailHeaderCell"];
        if (!cell) {
            cell = [[YSPMSInfoDetailHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSPMSInfoDetailHeaderCell"];
        }
        cell.dic = self.dataSourceArray[indexPath.section][indexPath.row];
        return cell;
    }else{
        YSContentTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSContentTextCell"];
        if (!cell) {
            cell = [[YSContentTextCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSContentTextCell"];
        }
        NSDictionary *dic = self.dataSourceArray[indexPath.section][0];
        cell.label.text = [dic allValues].firstObject;
        return cell;
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 80*kHeightScale;
    }else{
        return 44;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
 
        if (section == 0) {
            UIView *view = [[UIView alloc]init];
            UILabel *projectLabel = [[UILabel alloc]init];
            projectLabel.textAlignment = NSTextAlignmentCenter;
            projectLabel.font = [UIFont systemFontOfSize:17];
            projectLabel.textColor = kUIColor(51, 51, 51, 1.0);
            projectLabel.numberOfLines = 0;
            projectLabel.adjustsFontSizeToFitWidth = YES;
            projectLabel.text = self.infoModel.name;
            [view addSubview:projectLabel];
            [projectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH-80*kWidthScale, 80*kHeightScale));
            }];
            return view;
        }else{
            NSDictionary *dic = self.dataSourceArray[section][0];
            YSExpenseShareHeaderView *view = [[YSExpenseShareHeaderView alloc]init];
            view.lineView.hidden = YES;
            view.titleLb.textColor = kGrayColor(153);
            view.titleLb.text = [dic allKeys].firstObject;
            view.delegate = self;
            view.tag = 500 + section;
            if ([self.isOpenArray[section] isEqualToString:@"close"]) {
                view.arrowBtn.selected = NO;
            }else{
               view.arrowBtn.selected = YES;
            }
            
            return view;
        }
}


- (void)expandButtonDidClick:(YSExpenseShareHeaderView *)headerView {
    NSInteger index = headerView.tag - 500;
    if ([self.isOpenArray[index] isEqualToString:@"close"]) {
        self.isOpenArray[index] = @"open";
    }else{
        self.isOpenArray[index] = @"close";
    }
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:index];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
  
}
@end
