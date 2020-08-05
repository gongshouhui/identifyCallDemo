//
//  YSPMSMQPeopleInfoViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/1/29.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSMQPeopleInfoViewController.h"
#import "YSPMSPeopleInfoCell.h"
#import "YSPMSPeopleInfoModel.h"
#import "YSPMSInfoHeaderView.h"

@interface YSPMSMQPeopleInfoViewController ()<PGDatePickerDelegate>


@property (nonatomic, strong) NSMutableArray *handelArray;
@property (nonatomic, strong) YSPMSInfoHeaderView *infoHeaderView;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *btnName;

@end

@implementation YSPMSMQPeopleInfoViewController

- (void)initTableView {
    [super initTableView];
   
    [self hideMJRefresh];
    [self.tableView registerClass:[YSPMSPeopleInfoCell class] forCellReuseIdentifier:@"YSPMSPeopleInfoCell"];
    _handelArray = [NSMutableArray array];
    [self doNetworking];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.type == 0 ? @"项目人员":@"人员信息";
    
}
- (void)doNetworking {
    [super doNetworking];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@/%zd/%zd", YSDomain, getPersonsListAppMQ, self.projectId, self.type,self.pageNumber] isNeedCache:NO parameters:nil successBlock:^(id response) {
         [QMUITips hideAllToastInView:self.view animated:YES];
        DLog(@"-------%@",response);
        NSArray *arr = [YSDataManager getPMSPeopleInfoData:response];
        if (self.pageNumber == 1) {
            [self.dataSourceArray removeAllObjects];
        }
        if (arr.count != 0) {
            [self.dataSourceArray addObjectsFromArray:arr];
        }
        self.tableView.mj_footer.state = arr.count < 15?MJRefreshStateNoMoreData : MJRefreshStateIdle;
        [self ys_reloadData];
        [self.tableView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
         [QMUITips hideAllToastInView:self.view animated:YES];
    } progress:nil];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPMSPeopleInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSPMSPeopleInfoCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.phoneButton addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
    [cell.exitButton addTarget:self action:@selector(handelExit:) forControlEvents:UIControlEventTouchUpInside];
    cell.exitButton.tag = indexPath.section;
    
    
    YSPMSPeopleInfoModel *model = self.dataSourceArray[indexPath.section];
    [cell setPeopleInfoCell:model personType:self.type];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [tableView fd_heightForCellWithIdentifier:@"YSPMSPeopleInfoCell" cacheByKey:indexPath configuration:^(id cell) {
//        YSPMSPeopleInfoModel *model = self.dataSourceArray[indexPath.section];
//        [cell setPeopleInfoCell:model];
//    }];
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 52*kHeightScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kSCREEN_WIDTH, 42*kHeightScale)];
    backView.backgroundColor = [UIColor whiteColor];
    
    self.infoHeaderView = [[YSPMSInfoHeaderView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [backView addSubview:self.infoHeaderView];
    YSPMSPeopleInfoModel *model = self.dataSourceArray[section];
    self.infoHeaderView.positionLabel.text = model.typeStr;
    return backView;
}

- (void)handelExit:(UIButton *)btn {
    PGDatePicker *datePicker = [[PGDatePicker alloc] init];
    datePicker.delegate = self;
    [datePicker showWithShadeBackgroud];
//    datePicker.minimumDate = self.cellModel.minimumDate;
//    datePicker.maximumDate = self.cellModel.maximumDate;
    datePicker.datePickerMode = PGDatePickerModeDate;
    YSPMSPeopleInfoModel *model = self.dataSourceArray[btn.tag];
    self.id = model.id;
    self.btnName = btn.titleLabel.text;
}
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
   
    NSString *timeStr = [NSString stringWithFormat:@"%zd-%@%zd-%@%zd", dateComponents.year,dateComponents.month > 9 ?@"":@"0", dateComponents.month, dateComponents.day > 9 ?@"":@"0",dateComponents.day ];
    DLog(@"========选择的时间%@",timeStr);
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@/%@/%@",YSDomain,updatePersonExitMQ,self.id, timeStr, [self.btnName isEqual:@"进场"] ? @"1":@"2" ] isNeedCache:NO parameters:nil successBlock:^(id response) {
            DLog(@"------%@",response);
            if ([response[@"data"] isEqual:@1]) {
                [self doNetworking];
            }
        } failureBlock:^(NSError *error) {
            DLog(@"======%@",error);
        } progress:nil];
}
- (void)callPhone:(UIButton *)btn {
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", btn.titleLabel.text];
    NSString *versionPhone = [[UIDevice currentDevice] systemVersion];
    if ([versionPhone compare:@"10.2"options:NSNumericSearch] ==NSOrderedDescending || [versionPhone compare:@"10.2"options:NSNumericSearch] ==NSOrderedSame) {
        /// 大于等于10.0系统使用此openURL方法
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{}completionHandler:nil];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
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
