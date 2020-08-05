//
//  YSCalendarGrantViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/2.
//

#import "YSCalendarGrantViewController.h"
#import "YSCalendarGrantCell.h"
#import "YSCalendarGrantPeopleModel.h"
#import "YSContactSelectPersonViewController.h"
#import "YSDingDingHeader.h"
#import "YSInternalPeopleModel.h"

@interface YSCalendarGrantViewController ()<UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>

@end

@implementation YSCalendarGrantViewController

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"授权管理";
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UIImageMake(@"选项添加") style:UIBarButtonItemStyleDone target:self action:@selector(addGrant)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
}
- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSCalendarGrantCell class] forCellReuseIdentifier:@"CalendarGrantCell"];
    [self doNetworking];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnPeople:) name:@"returnPeopleInfo" object:nil];
}

- (void)returnPeople:(NSNotification *)notifacation {
    YSInternalPeopleModel *internalPeopleModel = [notifacation object];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, saveScheduleGrant];
    NSDictionary *payload = @{
                              @"grantedPersonNo": internalPeopleModel.no,
                              @"grantedPersonName": internalPeopleModel.name,
                              @"grantType": @"0",
                              };
    [YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:payload successBlock:^(id response) {
        DLog(@"新增授权:%@", response);
        if ([response[@"code"] intValue] == 1) {
            [self doNetworking];
            [QMUITips showSucceed:@"成功新增授权" inView:self.view hideAfterDelay:1];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/1", YSDomain, getScheduleGrant];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"获取授权用户:%@", response);
        [self.dataSourceArray removeAllObjects];
        [self.dataSourceArray addObjectsFromArray:[YSDataManager getCalendarGrantPeopleData:response]];
        [self.tableView cyl_reloadData];
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

- (void)addGrant {
//    YSChoosePeopleVC *choosePeopleViewController = [[YSChoosePeopleVC alloc] init];
//    choosePeopleViewController.str = @"单选";
//    choosePeopleViewController.sourceStr = @"日程";
//    choosePeopleViewController.isFirst = @"YES";
//    choosePeopleViewController.title = @"内部通讯录";
//    [[YSDingDingHeader shareHelper].titleList removeAllObjects];
//    [[YSDingDingHeader shareHelper].titleList addObject:@"联系人"];
//    [self.navigationController pushViewController:choosePeopleViewController animated:YES];
    YSContactSelectPersonViewController *contactSelectPersonViewController = [[YSContactSelectPersonViewController alloc]init];
    contactSelectPersonViewController.jumpSourceStr = @"日程";
    [self.navigationController pushViewController:contactSelectPersonViewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSCalendarGrantCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CalendarGrantCell"];
    cell = [[YSCalendarGrantCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CalendarGrantCell"];
    YSCalendarGrantPeopleModel *cellModel = self.dataSourceArray[indexPath.row];
    [cell setCellModel:cellModel];
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    return cell;
}

- (NSArray *)rightButtons {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"删除"];
    
    return rightUtilityButtons;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30*kHeightScale;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    QMUIButton *button = [[QMUIButton alloc] init];
    [button setTitleColor:UIColorGray forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:10];
    [button setTitle:@"向左滑动删除授权" forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setImage:[UIImage imageNamed:@"alert"] forState:UIControlStateNormal];
    button.imagePosition = QMUIButtonImagePositionLeft;
    button.spacingBetweenImageAndTitle = 5;
    [footerView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(footerView.mas_centerY);
        make.left.mas_equalTo(footerView.mas_left).offset(15);
        make.right.mas_equalTo(footerView.mas_right).offset(-15);
        make.height.mas_equalTo(20*kHeightScale);
    }];
    return footerView;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction *action) {
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"查阅" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
        [self saveCalendarGrant:indexPath grantType:0];
    }];
    QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"修改" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
        [self saveCalendarGrant:indexPath grantType:1];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"" message:@"修改权限" preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    [alertController showWithAnimated:YES];
}

#pragma mark - SWTableViewCellDelegate

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    YSCalendarGrantPeopleModel *cellModel = self.dataSourceArray[indexPath.row];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, deleteScheduleGrant];
    NSDictionary *payload = @{
                              @"id": cellModel.id
                              };
    [YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:payload successBlock:^(id response) {
        DLog(@"删除授权:%@", response);
        if ([response[@"code"] intValue] == 1) {
            [self.dataSourceArray removeObjectAtIndex:indexPath.row];
            [self.tableView cyl_reloadData];
            [QMUITips showSucceed:@"成功删除授权" inView:self.view hideAfterDelay:1];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

- (void)saveCalendarGrant:(NSIndexPath *)indexPath grantType:(int)grantType {
    YSCalendarGrantPeopleModel *cellModel = self.dataSourceArray[indexPath.row];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, saveScheduleGrant];
    NSDictionary *payload = @{
                              @"grantedPersonNo": cellModel.grantedPersonNo,
                              @"grantedPersonName": cellModel.grantedPersonName,
                              @"grantType": [NSString stringWithFormat:@"%zd", grantType],
                              @"id": cellModel.id
                              };
    [YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:payload successBlock:^(id response) {
        DLog(@"修改授权:%@", response);
        if ([response[@"code"] intValue] == 1) {
            cellModel.grantType = grantType;
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [QMUITips showSucceed:@"成功修改权限" inView:self.view hideAfterDelay:1];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

- (UIView *)makePlaceHolderView {
    return [YSUtility NoDataView:@"暂无授权"];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
