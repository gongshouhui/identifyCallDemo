//
//  YSHRMDRewardViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/9.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRMDRewardViewController.h"
#import "YSHRMDPLevelHeaderView.h"
#import "YSHRMSSubAllTableViewCell.h"
#import "YSNetManagerCache.h"

@interface YSHRMDRewardViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation YSHRMDRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"sreenDeptHRLevel" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
//        [self.paramDic setObject:[x.userInfo objectForKey:@"deptIds"] forKey:@"queryDeptIds"];
        self.deptNameStr = [x.userInfo objectForKey:@"deptName"];
        YSHRMDPLevelHeaderView *headerView = [self.view viewWithTag:1556];
        headerView.titLab.text = [x.userInfo objectForKey:@"deptName"];
//        [self getTeamPerfTotalNetwork];
//        [self refreshDeptTeamPerforDataWith:(RefreshStateTypeHeader)];
    }];
    UIView *hiddenView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kSCREEN_WIDTH, CGRectGetHeight(self.view.frame)))];
    hiddenView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:hiddenView];
    UIImageView *hiddenImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hrDeptRewardVCImg"]];
    [hiddenView addSubview:hiddenImg];
    [hiddenImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(200*kHeightScale); make.size.mas_equalTo(CGSizeMake(374.0/2.0*kWidthScale, 391.0/2.0*kHeightScale));
    }];
}
- (void)layoutTableView {
    [super layoutTableView];
    self.tableView.frame = CGRectMake(0, 104*kHeightScale, kSCREEN_WIDTH, kSCREEN_HEIGHT-kBottomHeight-kTopHeight-104*kHeightScale);
}
- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSHRMSSubAllTableViewCell class] forCellReuseIdentifier:@"levelreward"];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 16*kWidthScale, 0, 16*kWidthScale);
}

- (void)loadSubViews {
    NSDictionary *dataDic = [YSNetManagerCache ys_httpCacheWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getDeptTree] parameters:nil];
    
    if (0 != [[dataDic objectForKey:@"data"] count] && !self.deptNameStr) {
        NSDictionary *deptTreeDic = [dataDic objectForKey:@"data"][0];
        self.deptNameStr = [deptTreeDic objectForKey:@"name"];
//        [self.paramDic setObject:@"" forKey:@"queryDeptIds"];
    }
    YSHRMDPLevelHeaderView *headerView = [[YSHRMDPLevelHeaderView alloc] initWithFrame:(CGRectMake(0, 0, kSCREEN_WIDTH, 104*kHeightScale)) withType:2];
    headerView.tag = 4124;
    headerView.titLab.text = self.deptNameStr;

    [self.view addSubview:headerView];
}


#pragma mark--tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48*kHeightScale;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSHRMSSubAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"levelreward" forIndexPath:indexPath];
    // 更改布局
    return cell;
}

#pragma mark--setter&&getter
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
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
