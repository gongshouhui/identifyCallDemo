//
//  YSHRJobsInfoController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2019/1/9.
//  Copyright © 2019年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRJobsInfoController.h"
#import "YSHRPersonalInfoCell.h"
#define InfoCellReuseIdentifier @"YSPersonalInfoCell"
@interface YSHRJobsInfoController ()
@property (nonatomic,strong)NSMutableArray *contactArr;
@property (nonatomic,strong)NSMutableArray *infoArr;
@property (nonatomic,strong)NSMutableArray *addressArr;
@property (nonatomic,strong)NSArray *titleArray;
@end
@implementation YSHRJobsInfoController

#pragma mark - 懒加载
- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"职位详情",@"入职及合同签署",@"职位变动"];
    }
    return _titleArray;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"岗位信息";
    self.view.backgroundColor = kUIColor(229, 229, 229, 1);
    
}
- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSHRPersonalInfoCell class] forCellReuseIdentifier:InfoCellReuseIdentifier];
    [self hideMJRefresh];
    self.tableView.sectionFooterHeight = 0.0;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.backgroundColor = kUIColor(229, 229, 229, 1);
    [self doNetworking];
    
}
- (void)doNetworking{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.contactArr = [NSMutableArray array];
        self.infoArr = [NSMutableArray array];
        self.addressArr = [NSMutableArray array];
        
        [self.contactArr addObject:@{@"所属公司":[YSUtility cancelNullData:self.profileModel.companyName]}];
        [self.contactArr addObject:@{@"所属部门":[YSUtility cancelNullData:self.profileModel.deptName]}];
        [self.contactArr addObject:@{@"所属职位":[YSUtility cancelNullData:self.profileModel.jobStation]}];
        [self.contactArr addObject:@{@"职位等级":[YSUtility cancelNullData:_profileModel.levelId]}];
        
        // 从组织信息里面取出来 self.modelArr
        [self.infoArr addObject:@{@"司龄":[NSString stringWithFormat:@"%@年", [YSUtility cancelNullData:self.profileModel.year]]}];
        [self.infoArr addObject:@{@"入职时间":@""}];//cm
        [self.infoArr addObject:@{@"签署时间":@""}];//=kg
        [self.infoArr addObject:@{@"有效时间":@""}];
        [self.infoArr addObject:@{@"截止时间":@""}];
        
        
        [self.addressArr addObject:@{@"至今":[YSUtility cancelNullData:self.profileModel.companyName]}];
        for (NSDictionary *dic in self.modelArr) {
            [self.addressArr addObject:@{[YSUtility cancelNullData:dic[@"joinsysdate"]]:[YSUtility cancelNullData:dic[@"orgname"]]}];
        }
        
        
        
        [self.dataSourceArray addObject:_contactArr];
        [self.dataSourceArray addObject:_infoArr];
        [self.dataSourceArray addObject:_addressArr];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self ys_reloadDataWithImageName:@"ic_info_bg_personal" text:@"暂无个人信息\n快去后台添加吧"];
        });
    });

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [(NSArray *)(self.dataSourceArray[section]) count];
    
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200*kHeightScale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    YSHRPersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:InfoCellReuseIdentifier forIndexPath:indexPath];
    DLog(@"需要的数据是什么:%@", self.dataSourceArray[indexPath.section][indexPath.row]);
    cell.dic = self.dataSourceArray[indexPath.section][indexPath.row];
    // [cell setOtherByIndexPath:indexPath withArray:self.dataSourceArray[indexPath.section]];//设置圆角 字体
    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *label = [[UILabel alloc]init];
    [view addSubview:label];
    [label sizeToFit];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = kUIColor(25, 31, 37, 1);
    
    label.text = self.titleArray[section];
    label.frame = CGRectMake(15, (38 - 20)/2, kSCREEN_WIDTH, 20);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32*kHeightScale;
}
@end
