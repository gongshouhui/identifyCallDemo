//
//  YSFlowHRInfoViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/4/12.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowHRInfoViewController.h"

@interface YSFlowHRInfoViewController ()
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *contentArray;

@end

@implementation YSFlowHRInfoViewController

- (void)initTableView {
    [super initTableView];
    [self hideMJRefresh];
    [QMUITips hideAllToastInView:self.view animated:YES];
     self.contentArray = [NSMutableArray array];
    [self dealWith];
    if (![self.typeStr isEqualToString:@"点工"]) {
        _titleArray = @[@"姓名",@"班组",@"工种",@"入职时间",@"性别",@"年龄",@"技工类型",@"日薪"];
    }else{
        _titleArray = @[@"姓名",@"身份证",@"日期",@"白天工时",@"加班工时"];
    }
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"InfoTableViewCell"];
   
    
}
- (void)dealWith {
    for (NSDictionary *dic in self.infoArray) {
        if (![self.typeStr isEqualToString:@"点工"]) {
            NSArray *mutableArray = @[dic[@"memberName"],dic[@"teamsName"],dic[@"workType"],[YSUtility timestampSwitchTime:dic[@"entryDate"] andFormatter:@"yyyy-MM-dd"],dic[@"sex"],dic[@"age"],dic[@"workGrade"],dic[@"dailyWage"]];
            [self.contentArray addObject:mutableArray];
        }else{
            NSArray *mutableArray = @[dic[@"memberName"],dic[@"idCode"],[YSUtility timestampSwitchTime:dic[@"workDate"] andFormatter:@"yyyy-MM-dd"],dic[@"workDayHours"],dic[@"workOuttimeHours"]];
            [self.contentArray addObject:mutableArray];
        }
       
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.infoArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contentArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30*kHeightScale;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30*kHeightScale)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kSCREEN_WIDTH, 30*kHeightScale)];
    titleLabel.text = [NSString stringWithFormat:@"人员%@",[YSUtility digitalTransformation:(int)section+1]];
    [view addSubview:titleLabel];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *inde = @"InfoTableViewCell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:inde];
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.textLabel.textColor = kGrayColor(51);
    if (self.contentArray.count > 0) {
        cell.detailTextLabel.text =[NSString stringWithFormat:@"%@",self.contentArray[indexPath.section][indexPath.row]] ;
    }
    
    return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"人员详情";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
