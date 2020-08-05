//
//  YSPMSMQPlanProgressViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/3/1.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSMQPlanProgressViewController.h"
#import "YSPMAMQPlanProgressViewCell.h"
#import "YSPMSMQPlanProgressListHeaderView.h"
#import "YSPMSPlanImageListModel.h"
#import "YSPMSPlanTimeChooseView.h"

@interface YSPMSMQPlanProgressViewController ()<PGDatePickerDelegate>

@property (nonatomic, strong) YSPMSMQPlanProgressListHeaderView *PMSPlanProgressListHeaderView;
@property (nonatomic, strong) YSPMSPlanTimeChooseView *pickerview;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, strong) NSString *percentStr;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *recordArray;

@end

@implementation YSPMSMQPlanProgressViewController

- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSPMAMQPlanProgressViewCell class] forCellReuseIdentifier:@"PMSPlanProgressCell"];
    self.titleArray = @[@"累计形象进度",@"累计实际产值"];
    [self doNetworking];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加实际形象进度";
    self.dataSourceArray = [NSMutableArray array];
    BOOL zsResults = [YSUtility checkDatabaseSystemSn:Infomanagement andModuleSn:ZSPlanModel andCompanyId:ZScompanyId andPermissionValue:MQPeopleInfoPermissionValue];
    if (zsResults) {
        self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"保存" position:QMUINavigationButtonPositionRight target:self action:@selector(submit)];
    }
}

#pragma mark - 修改提交按钮点击事件
- (void)submit {
    if (self.timeStr.length <= 0) {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate* dt = [NSDate date];
        unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
        NSDateComponents* comp = [gregorian components: unitFlags fromDate:dt];
        
        self.timeStr = [NSString stringWithFormat:@"%ld-%@-%@",comp.year, comp.month > 9 ? [NSString stringWithFormat:@"%ld",comp.month ] :[NSString stringWithFormat:@"0%ld",comp.month ] ,comp.day > 9 ? [NSString stringWithFormat:@"%ld",comp.day ] :[NSString stringWithFormat:@"0%ld",comp.day ] ];
    }
    NSDictionary *payload = @{@"planInfoCode":self.code,
                              @"planInfoId":self.id,
                              @"deadlineDateStr":self.timeStr,
                              };
    [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain, updatePlanGraphicProgressMQ] isNeedCache:NO parameters:payload successBlock:^(id response) {
        DLog(@"========%@",response);
        [QMUITips hideAllToastInView:self.view animated:YES];
        if ([response[@"data"] isEqual:@1]) {
            self.refreshBlock();//返回刷新
            self.pageNumber = 1;
            [self doNetworking];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"--------%@",error);
    } progress:nil];
}

- (void)doNetworking {
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@/%zd",YSDomain, getPlanGraphicProgressListMQ, self.code, self.pageNumber] isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"==========%@",response);
        self.recordArray = response[@"data"][@"MqGraphicProgresses"];
        if (self.pageNumber == 1) {
            [self.dataSourceArray removeAllObjects];
        }
        [self.dataSourceArray addObject:[YSPMSPlanImageListModel yy_modelWithJSON:response[@"data"]]];
        DLog(@"=====%@",self.dataSourceArray);
        
        if (self.dataSourceArray.count > 0) {
            self.tableView.mj_footer.state = self.dataSourceArray.count < 10 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
            [self ys_reloadData];
            [self.tableView.mj_header endRefreshing];
        }
        
    } failureBlock:^(NSError *error) {
        DLog(@"----------%@",error);
    } progress:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else if(section == 1){
        return 0;
    }else {
        return self.recordArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }else if (section == 1) {
        return 118*kHeightScale;
    }else{
        return 30*kHeightScale;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }else{
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        if (section == 1) {
            backView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 118*kHeightScale);
            _PMSPlanProgressListHeaderView = [[YSPMSMQPlanProgressListHeaderView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 118*kHeightScale)];
            [_PMSPlanProgressListHeaderView.button addTarget:self action:@selector(buttonEvent) forControlEvents:UIControlEventTouchUpInside];
        
            [backView addSubview:_PMSPlanProgressListHeaderView];
        }else{
            backView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 48*kHeightScale);
            UILabel *label = [[UILabel alloc]init];
            label.text = @"历史记录";
            label.frame = CGRectMake(20, 0, kSCREEN_WIDTH, 30*kHeightScale);
            label.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [backView addSubview:label];
        }
        return backView;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *inde = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inde];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:inde];
        }
        cell.textLabel.text = self.titleArray[indexPath.row];
        if (self.dataSourceArray.count > 0) {
            YSPMSPlanImageListModel *model = self.dataSourceArray[0];
            if (indexPath.row == 0) {
                cell.detailTextLabel.text =[NSString stringWithFormat:@"%.2f%@",model.progress,@"%"];
            }else{
               cell.detailTextLabel.text = model.ActualOutput;
            }
        }
        return cell;
    }else{
        YSPMAMQPlanProgressViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PMSPlanProgressCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[YSPMAMQPlanProgressViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PMSPlanProgressCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 2) {
              [cell setPlanProgressCellData:self.recordArray[indexPath.row]];
        }
      
        return cell;
    }
}

- (void) buttonEvent {
    PGDatePicker *datePicker = [[PGDatePicker alloc] init];
    datePicker.delegate = self;
    [datePicker showWithShadeBackgroud];
    //    datePicker.minimumDate = self.cellModel.minimumDate;
    //    datePicker.maximumDate = self.cellModel.maximumDate;
    datePicker.datePickerMode = PGDatePickerModeDate;
}
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    [_PMSPlanProgressListHeaderView.button setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
  
    self.timeStr = [NSString stringWithFormat:@"%zd-%@%zd-%@%zd", dateComponents.year,dateComponents.month > 9 ?@"":@"0", dateComponents.month, dateComponents.day > 9 ?@"":@"0",dateComponents.day ];
    DLog(@"========选择的时间%@",_timeStr);
    [_PMSPlanProgressListHeaderView.button setTitle:self.timeStr forState:UIControlStateNormal];
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    DLog(@"释放了");
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
