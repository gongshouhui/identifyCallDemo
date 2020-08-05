//
//  YSCalendarEventDetailViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/7.
//

#import "YSCalendarEventDetailViewController.h"
#import "YSCalendarEventDetailCell.h"
#import "YSCalendarEventDetailContentCell.h"
#import "YSCalendarEditEventViewController.h"

@interface YSCalendarEventDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation YSCalendarEventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName,nil]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"calendarEvent_navigationBar"]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.toolbar.barTintColor = [UIColor redColor];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"事项详情";
    _hasAuth ? self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(gotoEdit)] : nil;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    [self addTableView];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)gotoEdit {
    YSCalendarEditEventViewController *calendarEditEventViewController = [[YSCalendarEditEventViewController alloc] initWithStyle:UITableViewStyleGrouped];
    calendarEditEventViewController.model = _model;
    calendarEditEventViewController.isEdit = YES;
    [self.navigationController pushViewController:calendarEditEventViewController animated:YES];
    [calendarEditEventViewController setReturnBlock:^(YSCalendarEventModel *model) {
        _model = model;
        [self.tableView reloadData];
        [QMUITips showSucceed:@"修改成功" inView:self.view hideAfterDelay:1];
    }];
}

- (void)addTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) style:UITableViewStyleGrouped];
    [self.tableView registerClass:[YSCalendarEventDetailCell class] forCellReuseIdentifier:@"CalendarEventDetailCell"];
    [self.tableView registerClass:[YSCalendarEventDetailContentCell class] forCellReuseIdentifier:@"CalendarEventDetailContentCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    _hasAuth ? [self addDeleteButton] : nil;
}

- (void)addDeleteButton {
    _deleteButton = [YSUIHelper generateDarkFilledButton];
    [_deleteButton setTitle:@"删除事项" forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(deleteCalendarSchedule) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_deleteButton];
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-30);
        make.size.mas_equalTo(CGSizeMake(300*kWidthScale, 50*kHeightScale));
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        YSCalendarEventDetailCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CalendarEventDetailCell"];
        cell = [[YSCalendarEventDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CalendarEventDetailCell"];
        [cell setCellModel:_model];
        
        return cell;
    } else {
        YSCalendarEventDetailContentCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CalendarEventDetailContentCell"];
        cell = [[YSCalendarEventDetailContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CalendarEventDetailContentCell"];
        [cell setCellModel:_model];
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 120*kHeightScale : [tableView fd_heightForCellWithIdentifier:@"CalendarEventDetailContentCell" cacheByIndexPath:indexPath configuration:^(YSCalendarEventDetailContentCell *cell) {
        [cell setCellModel:_model];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 185*kHeightScale : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *tableHeaderImageView = [[UIImageView alloc] init];
    tableHeaderImageView.image = [UIImage imageNamed:@"事项-banner"];
    
    return section == 0 ? tableHeaderImageView : nil;
}

- (void)deleteCalendarSchedule {
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction *action) {
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"删除" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
        [QMUITips showLoading:@"删除中..." inView:self.view];
        NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, deleteSchedule];
        NSDictionary *payload = @{
                                  @"id": _model.id
                                  };
        [YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:payload successBlock:^(id response) {
            DLog(@"删除事项:%@", response);
            if ([response[@"code"] intValue] == 1) {
                [QMUITips hideAllToastInView:self.view animated:YES];
                [self.navigationController popViewControllerAnimated:YES];
                self.DeleteBlock(_model);
            }
        } failureBlock:^(NSError *error) {
            DLog(@"error:%@", error);
        } progress:nil];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"确定删除？" message:@"删除后将无法恢复，请慎重考虑" preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
}

@end
