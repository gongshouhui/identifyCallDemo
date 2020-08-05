//
//  YSPMSPeopleInfoViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/1/29.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSPeopleInfoViewController.h"
#import "YSPMSPeopleInfoCell.h"
#import "YSPMSPeopleInfoModel.h"
#import "YSPMSInfoHeaderView.h"

@interface YSPMSPeopleInfoViewController ()
@property (nonatomic, assign) BOOL exitBool;

@end

@implementation YSPMSPeopleInfoViewController

- (void)initTableView {
    [super initTableView];
    self.title = @"人员信息";
    self.exitBool = [YSUtility checkDatabaseSystemSn:Infomanagement andModuleSn:ZSModuleIdentification andCompanyId:ZScompanyId andPermissionValue:MQPeopleInfoPermissionValue];
    [self.tableView registerClass:[YSPMSPeopleInfoCell class] forCellReuseIdentifier:@"peopleInfoCell"];

    [self doNetworking];
}

- (void)doNetworking {
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@/%zd", YSDomain, getPersonsListApp, self.projectId, self.pageNumber] isNeedCache:NO parameters:nil successBlock:^(id response) {
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
        DLog(@"=======%@",error);
    } progress:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPMSPeopleInfoModel *model = self.dataSourceArray[indexPath.section];
    
    return model.leaveDate.length > 0 ? 123*kHeightScale : 97*kHeightScale;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPMSPeopleInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[YSPMSPeopleInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"peopleInfoCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.phoneButton addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
    if (self.exitBool) {
        
        [cell.exitButton addTarget:self action:@selector(handelExit:) forControlEvents:UIControlEventTouchUpInside];
        cell.exitButton.tag = indexPath.section;
    }else{
        [cell.exitButton removeFromSuperview];
    }
    YSPMSPeopleInfoModel *model = self.dataSourceArray[indexPath.section];
    [cell setZSPeopleInfoCell:model];
    return cell;
}

- (void)handelExit:(UIButton *)btn {
    QMUIDialogSelectionViewController *dialogSelection = [[QMUIDialogSelectionViewController alloc]init];
    dialogSelection.title = @"是否退场";
    [dialogSelection addCancelButtonWithText:@"取消" block:nil];
    [dialogSelection addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *dialogViewController) {
        YSPMSPeopleInfoModel *model = self.dataSourceArray[btn.tag];
        [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain,updatePersonExit,model.id] isNeedCache:NO parameters:nil successBlock:^(id response) {
            DLog(@"------%@",response);
            if ([response[@"data"] isEqual:@1]) {
                [self doNetworking];
            }
        } failureBlock:^(NSError *error) {
            DLog(@"======%@",error);
        } progress:nil];
        [dialogViewController hideWithAnimated:YES completion:^(BOOL finished) {
        }];
    }];
    [dialogSelection show];
}
- (void)callPhone:(UIButton *)btn {
    
    NSString *versionPhone = [[UIDevice currentDevice] systemVersion];
    if ([versionPhone compare:@"10.2"options:NSNumericSearch] ==NSOrderedDescending || [versionPhone compare:@"10.2"options:NSNumericSearch] ==NSOrderedSame) {
        /// 大于等于10.0系统使用此openURL方法
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", btn.titleLabel.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{}completionHandler:nil];
    }else{
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", btn.titleLabel.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
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
