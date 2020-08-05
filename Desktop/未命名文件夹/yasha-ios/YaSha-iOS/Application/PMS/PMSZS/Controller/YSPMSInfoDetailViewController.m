//
//  YSPMSInfoDetailViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/13.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSInfoDetailViewController.h"
#import "YSPMSInfoDetailViewController.h"
#import "YSPMSInfoDetailHeaderCell.h"

@interface YSPMSInfoDetailViewController ()


@property (nonatomic, strong) NSMutableArray *contentDataArray;
@property (nonatomic, strong) NSString *projectName;

@end

@implementation YSPMSInfoDetailViewController

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"项目信息详情";
}

- (void)initTableView {
    [super initTableView];
    self.contentDataArray = [NSMutableArray array];
    [self.tableView registerClass:[YSPMSInfoDetailHeaderCell class] forCellReuseIdentifier:@"InfoDetailCell"];

    [self.dataSourceArray addObjectsFromArray:@[@"投标类型",
                                                @"合同形式",
                                                @"施工面积（㎡）",
                                                @"施工范围",
                                                @"质量目标",
                                                @"技术标准",
                                                @"计划开工",
                                                @"计划竣工",
                                                @"保修期限 （年）",
                                                @"合同号",
                                                @"保险时间",
                                                @"考核价 (万元)",
                                                @"考核费率（%）",
                                                @"中标交底",
                                                @"项目交底"
                                                ]];
    if ([self.dataDiction[@"isConSign"] isEqual:@0]) {
        [self.dataSourceArray addObject:@"合同签订说明"];
        [self.dataSourceArray removeObject:@"合同号"];
    }
    if ([self.dataDiction[@"isWinBid"] isEqual:@0]) {
        [self.dataSourceArray addObject:@"中标交底说明"];
        [self.dataSourceArray removeObject:@"中标交底"];
    }
    if ([self.dataDiction[@"isProBid"] isEqual:@0]) {
        [self.dataSourceArray addObject:@"项目交底说明"];
        [self.dataSourceArray removeObject:@"项目交底"];
    }
    if ([self.dataDiction[@"examSign"] isEqual:@0]) {
        [self.dataSourceArray addObject:@"考核签订说明"];
        [self.dataSourceArray removeObject:@"考核价 (万元)"];
        [self.dataSourceArray removeObject:@"考核费率（%）"];
    }
    if ([self.dataDiction[@"isProIns"] isEqual:@0]) {
        [self.dataSourceArray addObject:@"项目保险说明"];
        [self.dataSourceArray removeObject:@"保险时间"];
    }
    [self.dataSourceArray addObject:@"合同重要条款"];

    [self handleData:self.dataDiction];
}

- (void)handleData:(NSDictionary *)response {
    DLog(@"-----%@",response);
    [self.contentDataArray addObjectsFromArray:@[response[@"bidTypeName"],
                                                 response[@"contFormName"],
                                                 [YSUtility cancelNullData:response[@"conArea"]],
                                                 response[@"conScope"],
                                                 response[@"qtarget"],
                                                 response[@"tecStand"],
                                                 [YSUtility timestampSwitchTime:response[@"planStart"] andFormatter:@"yyyy-MM-dd"],
                                                 [YSUtility timestampSwitchTime:response[@"planEnd"] andFormatter:@"yyyy-MM-dd"],
                                                 [YSUtility cancelNullData:response[@"repairStr"]],
                                                 
                                                 [self.dataDiction[@"isConSign"] isEqual:@1] ? response[@"conCode"] : @"合同号",
                                                 [self.dataDiction[@"isProIns"] isEqual:@1] ? [YSUtility timestampSwitchTime:response[@"proInsDate"] andFormatter:@"yyyy-MM-dd"] :@"保修时间",
                                                 [self.dataDiction[@"examSign"] isEqual:@1] ? [YSUtility cancelNullData:response[@"assePrice"]] :@"考核价",
                                                 [self.dataDiction[@"examSign"] isEqual:@1] ? [YSUtility cancelNullData:response[@"asseRate"]] :@"考核费率",
                                                 
                                                 [self.dataDiction[@"isWinBid"] isEqual:@1] ? @"已完成":@"已完成1",
                                                 [self.dataDiction[@"isProBid"] isEqual:@1] ? @"已完成":@"已完成2",
                                                 ]];
    DLog(@"========%@",self.contentDataArray);
    if ([self.dataDiction[@"isConSign"] isEqual:@0]) {
        [self.contentDataArray addObject:response[@"conSignRemark"]];
        [self.contentDataArray removeObject:@"合同号"];
    }
    if ([self.dataDiction[@"examSign"] isEqual:@0]) {
        [self.contentDataArray addObject:response[@"examSignRemark"]];
        [self.contentDataArray removeObject:@"考核价"];
        [self.contentDataArray removeObject:@"考核费率"];
        
    }
    if ([self.dataDiction[@"isProIns"] isEqual:@0]) {
        [self.contentDataArray addObject:response[@"proInsRemark"]];
        [self.contentDataArray removeObject:@"保修时间"];
    }
    if ([self.dataDiction[@"isWinBid"] isEqual:@0]) {
        [self.contentDataArray addObject:response[@"winBidRemark"]];
        [self.contentDataArray removeObject:@"已完成1"];
    }
    if ([self.dataDiction[@"isProBid"] isEqual:@0]) {
        [self.contentDataArray addObject:response[@"proBidRemark"]];
        [self.contentDataArray removeObject:@"已完成2"];
    }
    [self.contentDataArray addObject:response[@"conImpClause"]];
    [self.tableView cyl_reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentDataArray.count + 1 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 80*kHeightScale;
    }else{
        return [tableView fd_heightForCellWithIdentifier:@"InfoDetailCell" cacheByIndexPath:indexPath configuration:^(YSPMSInfoDetailHeaderCell *cell) {
            if ([self.contentDataArray[indexPath.row-1] length]>0) {
                cell.contentLabel.font = [UIFont systemFontOfSize:15];
                cell.contentLabel.text = self.contentDataArray[indexPath.row-1];
            }else{
                cell.contentLabel.text = @"设置";
            }
        }] + 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPMSInfoDetailHeaderCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[YSPMSInfoDetailHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InfoDetailCell"];
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, kSCREEN_WIDTH, 0, 0);
    if (indexPath.row == 0) {
        UILabel *projectLabel = [[UILabel alloc]init];
        projectLabel.textAlignment = NSTextAlignmentCenter;
        projectLabel.font = [UIFont systemFontOfSize:17];
        projectLabel.adjustsFontSizeToFitWidth = YES;
        projectLabel.textColor = kUIColor(51, 51, 51, 1.0);
        projectLabel.numberOfLines = 0;
        projectLabel.text = self.dataDiction[@"name"];
        [cell addSubview:projectLabel];
        [projectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(cell.mas_centerX);
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH-80*kWidthScale, 80*kWidthScale));
        }];
        
    }else{
        cell.titleLabel.text = self.dataSourceArray[indexPath.row-1];
        cell.contentLabel.text = self.contentDataArray[indexPath.row-1];
        
    }
    
    return cell;
}
- (UIView *)makePlaceHolderView {
    return [YSUtility NoDataView:@"无数据"];
}

@end
