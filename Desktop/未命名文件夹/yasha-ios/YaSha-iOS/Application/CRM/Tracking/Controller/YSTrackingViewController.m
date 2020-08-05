//
//  YSTrackingViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/12/22.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSTrackingViewController.h"
#import <ZYSideSlipFilterController.h>
#import <ZYSideSlipFilterRegionModel.h>
#import <SideSlipBaseTableViewCell.h>
#import "SideSlipCommonTableViewCell.h"
#import "SideSlipSearchTableViewCell.h"
#import "YSReportedTableViewCell.h"
#import "CommonItemModel.h"
#import "AddressModel.h"
#import "YSTrackingPageViewController.h"

@interface YSTrackingViewController()<UISearchBarDelegate>
@property (nonatomic, strong) ZYSideSlipFilterController *sideSlipFilterController;
@property (nonatomic, strong) NSMutableDictionary *payload;
@property (nonatomic, strong) NSMutableArray *sourceArray;
@property (nonatomic, strong) NSArray *filterArray;

@end
@implementation YSTrackingViewController
- (NSMutableArray *)sourceArray {
    if (!_sourceArray) {
        _sourceArray = [NSMutableArray array];
    }
    return _sourceArray;
}
- (NSMutableDictionary *)payload {
    if (!_payload) {
        _payload = [NSMutableDictionary dictionary];
    }
    return _payload;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"项目跟踪";
}
- (void)initTableView {
    [super initTableView];
    //接口文档的枚举列表，前面4位是项目阶段，后面的是单据状态
    self.filterArray = @[@"20", @"30", @"40", @"50", @"10", @"20", @"30", @"60", @"50"];
    [self ys_shouldShowSearchBaraAndScreening];
    [self doNetworking];
}
- (void)doNetworking {
	
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%zd", YSDomain, getPageProTrackApi, self.pageNumber];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:self.payload successBlock:^(id response) {
        DLog(@"获取项目列表:%@",response);
        if (self.pageNumber==1) {
            [self.dataSourceArray removeAllObjects];
        }
        [self.sourceArray addObjectsFromArray:[YSDataManager getReporedlistData:response]];
        [self.dataSourceArray addObjectsFromArray:[YSDataManager getTrackinglistData:response]];
        self.tableView.mj_footer.state = [YSDataManager getTrackinglistData:response].count < 15 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
       
        
        [self ys_reloadData];
        [self.tableView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84*kHeightScale;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSReportedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[YSReportedTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    YSReporetModel *model = self.dataSourceArray[indexPath.row];
    [cell setReporedData:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSTrackingPageViewController *trackingInfoViewController = [[YSTrackingPageViewController alloc]init];
    YSReporetModel *model = self.sourceArray[indexPath.row];
    trackingInfoViewController.id  = model.id;;
    [self.navigationController pushViewController:trackingInfoViewController animated:YES];
}
#pragma mark 搜索右侧按钮点击事件
/** 监控筛选按钮 */
- (void)monitorFiltButton {
    DLog(@"可以获取到筛选条件");
    YSWeak;
    if (!_sideSlipFilterController) {
        _sideSlipFilterController = [[ZYSideSlipFilterController alloc] initWithSponsor:self resetBlock:^(NSArray *dataList) {
            for (ZYSideSlipFilterRegionModel *model in dataList) {
                for (CommonItemModel *itemModel in model.itemList) {
                    [itemModel setSelected:NO];
                }
                model.selectedItemList = nil;
            }
            [weakSelf.payload removeAllObjects];
            [weakSelf doNetworking];
        } commitBlock:^(NSArray *dataList) {
            for (ZYSideSlipFilterRegionModel *model in dataList) {
                for (CommonItemModel *commonItemModel in model.selectedItemList) {
                   NSString *filterString = weakSelf.filterArray[[commonItemModel.itemId integerValue]];
                    switch ([dataList indexOfObject:model]) {
                        case 0:
                        {
                            if (filterString) {
                                [weakSelf.payload setObject:filterString forKey:@"bizStatusStr"];
                            }
                            break;
                        }
                        case 1:
                        {
                            if (filterString) {
                                [weakSelf.payload setObject:filterString forKey:@"flowStatusStr"];
                            }
                            break;
                        }
                    }
                }
            }
            [weakSelf.sideSlipFilterController dismiss];
            [weakSelf.tableView.mj_header beginRefreshing];
            [weakSelf doNetworking];
        }];
        _sideSlipFilterController.animationDuration = .3f;
        _sideSlipFilterController.sideSlipLeading = 0.15*kSCREEN_WIDTH;
        _sideSlipFilterController.dataList = [self packageDataList];
        [_sideSlipFilterController.navigationController setNavigationBarHidden:NO];
        
    }
    [_sideSlipFilterController show];
}
/** 设置ZYSideSlipFilterController的数据源 */
- (NSArray *)packageDataList {
    NSMutableArray *dataArray = [NSMutableArray array];
    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"项目阶段" index:0 selectionType:BrandTableViewCellSelectionTypeSingle]];
//    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"单据状态" index:1 selectionType:BrandTableViewCellSelectionTypeSingle]];
    
    return [dataArray mutableCopy];
}

- (ZYSideSlipFilterRegionModel *)commonFilterRegionModelWithKeyword:(NSString *)keyword index:(NSInteger)index selectionType:(CommonTableViewCellSelectionType)selectionType {
    ZYSideSlipFilterRegionModel *model = [[ZYSideSlipFilterRegionModel alloc] init];
    model.containerCellClass = @"SideSlipCommonTableViewCell";
    model.regionTitle = keyword;
    model.customDict = @{REGION_SELECTION_TYPE:@(selectionType)};
    switch (index) {
        case 0:
        {
            model.itemList = @[[self createItemModelWithTitle:@"评估阶段" itemId:@"0" selected:NO],
                               [self createItemModelWithTitle:@"报名资审" itemId:@"1" selected:NO],[self createItemModelWithTitle:@"投标阶段" itemId:@"2" selected:NO],
                               [self createItemModelWithTitle:@"结束阶段" itemId:@"3" selected:NO]
                               ];
            break;
        }
//        case 1:
//        {
//            model.itemList = @[[self createItemModelWithTitle:@"未提交" itemId:@"4" selected:NO],
//                               [self createItemModelWithTitle:@"审批中" itemId:@"5" selected:NO],
//                               [self createItemModelWithTitle:@"输入中" itemId:@"6" selected:NO],
//                               [self createItemModelWithTitle:@"已审批" itemId:@"7" selected:NO],
//                               [self createItemModelWithTitle:@"终止" itemId:@"8" selected:NO]
//                               ];
//            break;
//        }
    }
    return model;
}

- (ZYSideSlipFilterRegionModel *)searchFilterRegionModel:(NSString *)title {
    ZYSideSlipFilterRegionModel *model = [[ZYSideSlipFilterRegionModel alloc] init];
    model.containerCellClass = @"SideSlipSearchTableViewCell";
    model.regionTitle = title;
    return model;
}

- (CommonItemModel *)createItemModelWithTitle:(NSString *)itemTitle itemId:(NSString *)itemId selected:(BOOL)selected {
    CommonItemModel *model = [[CommonItemModel alloc] init];
    model.addressType = 4;
    model.itemId = itemId;
    model.itemName = itemTitle;
    model.selected = selected;
    return model;
}

#pragma mark - searchBar 代理方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.payload setObject:searchText forKey:@"projectName"];
    [self doNetworking];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
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
