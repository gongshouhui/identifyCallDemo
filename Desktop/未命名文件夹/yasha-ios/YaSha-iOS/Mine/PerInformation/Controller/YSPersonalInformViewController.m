//
//  YSPersonalInformViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/7.
//

#import "YSPersonalInformViewController.h"
#import "YSPersonalInformationModel.h"
#import "YSContactModel.h"

@interface YSPersonalInformViewController ()<QMUISearchControllerDelegate>

@property (nonatomic, strong) YSPersonalInformationModel *personalInformationModel;

@end

@implementation YSPersonalInformViewController

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"个人信息";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideMJRefresh];
    [self doNetworking];
}

- (void)doNetworking {
    [super doNetworking];
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getPersonInfo, [YSUtility getUID]];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        if ([response[@"code"] isEqual:@1]) {
            _personalInformationModel = [YSPersonalInformationModel yy_modelWithDictionary:response[@"data"]];
           
            self.dataSource = @[@"姓名", @"工号",@"单位",@"部门", @"岗位",@"职级",@"个人手机", @"单位手机", @"短号", @"办公电话", @"企业邮箱", @"办公地点"];
            self.detailTextDataSource = [NSArray arrayWithObjects:
                                         _personalInformationModel.name,
                                         _personalInformationModel.no,
                                         _personalInformationModel.companyName,
                                         _personalInformationModel.deptName,
                                         _personalInformationModel.jobStation,
                                         _personalInformationModel.positionName,
                                         _personalInformationModel.mobile,
                                         _personalInformationModel.companyMobile,
                                         _personalInformationModel.shortPhone,
                                         _personalInformationModel.phone,
                                         _personalInformationModel.email,
                                         _personalInformationModel.workAddress,
                                         nil];
            [self ys_reloadData];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
        [self ys_showNetworkError];
    } progress:nil];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.detailTextDataSource objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

@end
