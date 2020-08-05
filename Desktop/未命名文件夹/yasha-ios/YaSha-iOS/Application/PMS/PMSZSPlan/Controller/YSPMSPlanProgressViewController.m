//
//  YSPMSPlanProgressViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/10/16.
//

#import "YSPMSPlanProgressViewController.h"
#import "YSPMAPlanProgressViewCell.h"
#import "YSPMSPlanProgressListHeaderView.h"
#import "YSPMSPlanImageListModel.h"
#import "YSPMSPlanTimeChooseView.h"

@interface YSPMSPlanProgressViewController ()


@property (nonatomic, strong) YSPMSPlanProgressListHeaderView *PMSPlanProgressListHeaderView;
@property (nonatomic, strong) YSPMSPlanTimeChooseView *pickerview;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, strong) NSString *percentStr;

@end

@implementation YSPMSPlanProgressViewController

- (void)initTableView {
    [super initTableView];
     [self.tableView registerClass:[YSPMAPlanProgressViewCell class] forCellReuseIdentifier:@"PMSPlanProgressCell"];
    [self doNetworking];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"形象进度表";
     BOOL zsResults = [YSUtility checkDatabaseSystemSn:Infomanagement andModuleSn:ZSPlanModel andCompanyId:ZScompanyId andPermissionValue:MQPeopleInfoPermissionValue];
    if (zsResults) {
        self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"筛选" position:QMUINavigationButtonPositionRight target:self action:@selector(submit)];
    }
    
}

#pragma mark - 修改提交按钮点击事件
- (void)submit {
    [_PMSPlanProgressListHeaderView.textFiled resignFirstResponder];
    if (self.timeStr.length <= 0) {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate* dt = [NSDate date];
        unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
        NSDateComponents* comp = [gregorian components: unitFlags fromDate:dt];
        self.timeStr = [NSString stringWithFormat:@"%ld-%ld",comp.year, comp.month];
    }
    NSDictionary *payload = @{@"planInfoCode":self.code,
                              @"planInfoId":self.id,
                              @"planInfoProgreeDateStr":self.timeStr,
                              @"percent":self.percentStr
                              };
    [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain, updatePlanGraphicProgress] isNeedCache:NO parameters:payload successBlock:^(id response) {
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
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@/%zd",YSDomain, getPlanGraphicProgressList, self.code, self.pageNumber] isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"==========%@",response);
        if (self.pageNumber == 1) {
            [self.dataSourceArray removeAllObjects];
        }
        for (NSDictionary *dic in response[@"data"]) {
            [self.dataSourceArray addObject:[YSPMSPlanImageListModel yy_modelWithJSON:dic]];
        }
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
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section == 0 ? 0 : self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 118*kHeightScale : 30*kHeightScale;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    backView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 48*kHeightScale);
    if (section == 0) {
        _PMSPlanProgressListHeaderView = [[YSPMSPlanProgressListHeaderView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 118*kHeightScale)];
        [_PMSPlanProgressListHeaderView.button addTarget:self action:@selector(buttonEvent) forControlEvents:UIControlEventTouchUpInside];
        [_PMSPlanProgressListHeaderView.textFiled addTarget:self action:@selector(writeEvent:) forControlEvents:UIControlEventEditingChanged];
        [backView addSubview:_PMSPlanProgressListHeaderView];
    }else{
        UILabel *label = [[UILabel alloc]init];
        label.text = @"历史记录";
        label.frame = CGRectMake(20, 0, kSCREEN_WIDTH, 30*kHeightScale);
        label.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [backView addSubview:label];
    }
    return backView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPMAPlanProgressViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PMSPlanProgressCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[YSPMAPlanProgressViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PMSPlanProgressCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setPlanProgressCellData:self.dataSourceArray[indexPath.row]];
    return cell;
}

- (void) buttonEvent {
    _pickerview =[[YSPMSPlanTimeChooseView alloc] initWithFrame:CGRects(0, 450, 375, 230)];
    _pickerview.backgroundColor = [UIColor whiteColor];
    //    pickerview.timeLabel.text = [self.model.sdate substringToIndex:10];
    _pickerview.delegate=self;
    //    pickerview.tag = indexPath.row;
    [self.view addSubview:_pickerview];
}

- (void)hisPickerView:(YSPMSPlanTimeChooseView *)alertView {
    
    DLog(@"------%@",alertView.Taketime);
    
    [_PMSPlanProgressListHeaderView.button setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
    if (alertView.Taketime.length > 0) {
        [_PMSPlanProgressListHeaderView.button setTitle:alertView.Taketime forState:UIControlStateNormal];
        self.timeStr = alertView.Taketime;
    }else{
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate* dt = [NSDate date];
        unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
        NSDateComponents* comp = [gregorian components: unitFlags fromDate:dt];
        self.timeStr = [NSString stringWithFormat:@"%ld-%ld",comp.year, comp.month];
        [_PMSPlanProgressListHeaderView.button setTitle:self.timeStr forState:UIControlStateNormal];
    }
    _PMSPlanProgressListHeaderView.button.imagePosition = QMUIButtonImagePositionRight;
    _PMSPlanProgressListHeaderView.button.spacingBetweenImageAndTitle = 8;
    [_pickerview removeFromSuperview];
}

- (void) writeEvent:(UITextField *)textFiled {
    self.percentStr = textFiled.text;
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
