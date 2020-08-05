//
//  YSAttendanceRecordGZLNViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/12/18.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSAttendanceRecordGZLNViewController.h"
#import "YSAttendanceRecordWHeaderView.h"
#import "YSAttendanceRecordGWTableViewCell.h"
#import "YSComplaintAttendanceGWViewController.h"
#import "YSComplaintListModel.h"

@interface YSAttendanceRecordGZLNViewController ()<PGDatePickerDelegate>
@property (nonatomic, strong) YSAttendanceRecordWHeaderView *headerView;//有日历的时候 把这个类删除
@property (nonatomic, copy) NSString *timeStr;
@property (nonatomic, assign) BOOL isPositi;//用来防止多次跳转指定行


@end

@implementation YSAttendanceRecordGZLNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"考勤记录";
    [self.view addSubview:self.headerView];
    NSString *timeStr = [NSString stringWithFormat:@"%ld-%ld",(long)[[[NSDate date] dateByAddingHours:0] year],(long)[[[NSDate date] dateByAddingHours:0] month]];
    self.timeStr = timeStr;
    [self doNetworking];
    self.tableView.mj_footer = nil;
    //申诉完成 刷新页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshListData) name:@"complaintVCUpdateFlowData" object:nil];
}
- (void)layoutTableView {
    self.tableView.frame = CGRectMake(0, kTopHeight+44*kHeightScale, kSCREEN_WIDTH, kSCREEN_HEIGHT-kTopHeight-44*kHeightScale);
}
- (void)initTableView {
    [super initTableView];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#FCFCFC"];
    [self.tableView registerClass:[YSAttendanceRecordGWTableViewCell class] forCellReuseIdentifier:@"RecordCell"];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, (68*kWidthScale), 0, 0);
    
}

- (void)doNetworking {
    [QMUITips showLoadingInView:self.view];
    [self.view bringSubviewToFront:self.navView];
    //判断是否是 打卡记录 跳转进来的 然后在置空
    NSIndexPath *scrollIndexPath = nil;
    if (self.clockModel && !self.isPositi) {
        //防止下次在进入此判断
        self.isPositi = YES;
        
        double startTime = [self.clockModel.sendTime doubleValue]-24*60*60*1000;

        self.timeStr = [YSUtility timestampSwitchTime:[NSString stringWithFormat:@"%.0f", startTime] andFormatter:@"yyyy-MM"];
         
        NSInteger indexRow = [[YSUtility timestampSwitchTime:[NSString stringWithFormat:@"%.0f", startTime] andFormatter:@"d"] integerValue];
        scrollIndexPath = [NSIndexPath indexPathForRow:indexRow inSection:0];
        self.headerView.timeChoseLab.text = self.timeStr;
    }
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@%@/%@", YSDomain, getAtdsMonthForMobile, [YSUtility getUID], self.timeStr] isNeedCache:NO parameters:nil successBlock:^(id response) {
        [QMUITips hideAllToastInView:self.view animated:NO];
        DLog(@"考勤记录列表数据:%@", response);
        if (1==[[response objectForKey:@"code"] integerValue]) {
            self.dataSourceArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSComplaintListModel class] json:[response objectForKey:@"data"]]];
            [self.dataSourceArray sortUsingComparator:^NSComparisonResult(YSComplaintListModel  *obj1, YSComplaintListModel  *obj2)
            {
                //此处的规则含义为：若前一元素比后一元素小，则返回降序（即后一元素在前，为从大到小排列）
                if ([obj1.day integerValue] < [obj2.day integerValue])
                {
                    return NSOrderedDescending;
                }
                else
                {
                    return NSOrderedAscending;
                }
            }];
            [self.tableView reloadData];

            if (self.dataSourceArray.count > 0) {
                
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            
            if (scrollIndexPath) {
                [self scrollToSpecifiedLocationWith:scrollIndexPath];
            }

        }
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:NO];
    } progress:nil];
}

- (void)refershTeamDataWithType:(RefreshStateType)type {
    if (type == RefreshStateTypeHeader) {
        self.pageNumber = 1;
    }else {
        self.pageNumber++;
    }
    self.refreshType = type;
    [self doNetworking];
}

- (void)choseDateBtnAction {
    PGDatePicker *datePicker = [[PGDatePicker alloc] init];
    datePicker.delegate = self;
    datePicker.datePickerMode = PGDatePickerModeYearAndMonth;
    [datePicker showWithShadeBackgroud];
}

// 滚动到指定的cell
- (void)scrollToSpecifiedLocationWith:(NSIndexPath*)scrollIndexPath {
    if (self.dataSourceArray.count >= scrollIndexPath.row) {
        //周夸月的时候 只适用于 跳周末
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSourceArray.count-scrollIndexPath.row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else {
        DLog(@"数组个数不对:%@--%ld", scrollIndexPath,self.dataSourceArray.count);
    }
}
#pragma mark--tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSComplaintListModel *model = self.dataSourceArray[indexPath.row];
    YSAttendanceRecordGWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.complaintModel = model;
    /*
    @weakify(self);
    [[[cell.complaintBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        @strongify(self);
        if ([model.applyType isEqualToString:@"wss"]) {
            //在处理流程为 未申诉的时候 才能申诉
            YSComplaintAttendanceGWViewController *compliteVC = [YSComplaintAttendanceGWViewController new];
            compliteVC.detailGWModel = model;
            [self.navigationController pushViewController:compliteVC animated:YES];
        }
        
    }];*/
    return cell;
}
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSComplaintAttendanceGWViewController *compliteVC = [YSComplaintAttendanceGWViewController new];
    
    [self.navigationController pushViewController:compliteVC animated:YES];
}
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YSComplaintListModel *model = self.dataSourceArray[indexPath.row];
    if (![model.resultType isEqualToString:@"ZC"]) {
        return 126*kHeightScale;
    }else {
        return 84*kHeightScale;
    }
    
}
/*
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 126*kHeightScale;
}*/

#pragma mark--刷新数据
- (void)refreshListData {
    [self refershTeamDataWithType:(RefreshStateTypeHeader)];
}


#pragma mark--PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    if (datePicker.datePickerMode==PGDatePickerModeYearAndMonth) {
        self.timeStr = [NSString stringWithFormat:@"%zd-%02zd", dateComponents.year, dateComponents.month];
        self.headerView.timeChoseLab.text = self.timeStr;
        [self refershTeamDataWithType:(RefreshStateTypeHeader)];
    }
    
}

#pragma mark--setter&&getter
- (YSAttendanceRecordWHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[YSAttendanceRecordWHeaderView alloc] initWithFrame:(CGRectMake(0, kTopHeight, kSCREEN_WIDTH, 44*kHeightScale))];
        _headerView.backgroundColor = [UIColor colorWithHexString:@"#FCFCFC"];
        _headerView.layer.shadowColor = kUIColor(0, 0, 0, 0.1).CGColor;
        _headerView.layer.shadowOffset = CGSizeMake(0,2);
        _headerView.layer.shadowOpacity = 1;
        _headerView.layer.shadowRadius = 4;
        [_headerView.choseBtn addTarget:self action:@selector(choseDateBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _headerView;
}

-(void)dealloc {
    DLog(@"删除了..");
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
