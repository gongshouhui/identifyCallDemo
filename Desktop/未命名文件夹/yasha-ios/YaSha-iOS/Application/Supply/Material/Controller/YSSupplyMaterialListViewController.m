//
//  YSSupplyMaterialListViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/9.
//

#import "YSSupplyMaterialListViewController.h"
#import "YSSupplyMaterialListCell.h"
#import "YSSupplyMaterialInfoPageViewController.h"
#import <ZYSideSlipFilterController.h>
#import <ZYSideSlipFilterRegionModel.h>
#import <SideSlipBaseTableViewCell.h>
#import "SideSlipCommonTableViewCell.h"
#import "SideSlipSearchTableViewCell.h"
#import "CommonItemModel.h"
#import "AddressModel.h"
#import "YSMaterialInfoModel.h"


@interface YSSupplyMaterialListViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) ZYSideSlipFilterController *sideSlipFilterController;
@property (nonatomic, strong) NSMutableDictionary *payload;
@property (nonatomic, strong) NSArray *filterArray;
@end

@implementation YSSupplyMaterialListViewController

//设置统计开始进入该模块
- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"材料管理"];
}

- (void)viewWillDisappear:(BOOL)animated {
      [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"材料管理"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"材料信息";
    _filterArray = @[@"装饰材料", @"幕墙材料", @"标准品", @"非标准品", @"辅材辅料", @(10), @(20)];
    _payload = [NSMutableDictionary dictionary];
}

- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSSupplyMaterialListCell class] forCellReuseIdentifier:@"MaterialListCell"];
    [self ys_shouldShowSearchBaraAndScreening];
    self.searchBar.delegate = self;
    [self doNetworking];
}

- (void)doNetworking {
    [QMUITips showLoadingInView:self.view];
    [_payload setValue:self.keyWord forKey:@"name"];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%zd",YSDomain,getMaterialInfoListApp,self.pageNumber] isNeedCache:NO parameters:_payload successBlock:^(id response) {
        DLog(@"======%@",response);
        [QMUITips hideAllTipsInView:self.view];
        if ([response[@"code"] integerValue] == 1) {
            if (self.pageNumber == 1) {
                [self.dataSourceArray removeAllObjects];
            }
            NSArray *dataArray = [[NSArray yy_modelArrayWithClass:[YSMaterialInfoModel class] json:response[@"data"]] copy];
            if (dataArray.count) {
                [self.dataSourceArray addObjectsFromArray:dataArray];
            }
            self.tableView.mj_footer.state = dataArray.count < 15 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
            [self ys_reloadData];
            [self.tableView.mj_header endRefreshing];
        }else{
            [QMUITips showInfo:@"获取失败" inView:self.view];
            [self.tableView.mj_header endRefreshing];
        }
       
    } failureBlock:^(NSError *error) {
         [self.tableView.mj_header endRefreshing];
    } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
    
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 97*kHeightScale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSSupplyMaterialListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[YSSupplyMaterialListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MaterialListCell"];
    }
    cell.model = self.dataSourceArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSSupplyMaterialInfoPageViewController *SupplyMaterialInfoPageViewController = [[YSSupplyMaterialInfoPageViewController alloc]init];
    YSMaterialInfoModel *model = self.dataSourceArray[indexPath.row];
    SupplyMaterialInfoPageViewController.materialID = model.id;
    SupplyMaterialInfoPageViewController.title = model.name;
    [self.navigationController pushViewController:SupplyMaterialInfoPageViewController animated:YES];
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
            [_payload removeAllObjects];
            for (ZYSideSlipFilterRegionModel *model in dataList) {
                for (CommonItemModel *commonItemModel in model.selectedItemList) {
                    NSInteger index = [commonItemModel.itemId integerValue];
                    NSString *filterString = weakSelf.filterArray[index];
                        switch ([dataList indexOfObject:model]) {
                            case 0:
                            {
                                if (filterString) {
                                    [weakSelf.payload setObject:filterString forKey:@"mtrlOne"];
                                }
                                break;
                            }
                            case 1:
                            {
                                if (filterString) {
                                    [weakSelf.payload setObject:filterString forKey:@"mtrlTwo"];
                                }
                                break;
                            }
                            case 2:
                            {
                                if (commonItemModel.itemName) {
                                    [weakSelf.payload setObject:commonItemModel.itemName forKey:@"mtrlThree"];
                                }
                                break;
                            }
                            case 3:
                            {
                                if (commonItemModel.itemName) {
                                    [weakSelf.payload setObject:commonItemModel.itemName forKey:@"mtrlFour"];
                                }
                                break;
                            }
                            case 4:
                            {
                                if (commonItemModel.itemName) {
                                    [weakSelf.payload setObject:commonItemModel.itemName forKey:@"brand"];
                                }
                                break;
                            }
                            case 5:
                            {
                                if (filterString) {
                                    [weakSelf.payload setObject:filterString forKey:@"status"];
                                }
                                break;
                            }
                        }
                    }
               
            }
           
            [weakSelf.sideSlipFilterController dismiss];
            [weakSelf.tableView.mj_header beginRefreshing];
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
    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"材料一级分类" index:0 selectionType:BrandTableViewCellSelectionTypeSingle]];
    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"材料二级分类" index:1 selectionType:BrandTableViewCellSelectionTypeSingle]];
    [dataArray addObject:[self searchFilterRegionModel:@"材料三级分类"]];
    [dataArray addObject:[self searchFilterRegionModel:@"材料四级分类"]];
    [dataArray addObject:[self searchFilterRegionModel:@"品牌名称"]];
    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"状态" index:5 selectionType:BrandTableViewCellSelectionTypeSingle]];
    
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
            model.itemList = @[[self createItemModelWithTitle:@"装饰材料" itemId:@"0" selected:NO],
                               [self createItemModelWithTitle:@"幕墙材料" itemId:@"1" selected:NO]
                               ];
            break;
        }
        case 1:
        {
            model.itemList = @[[self createItemModelWithTitle:@"标准品" itemId:@"2" selected:NO],
                               [self createItemModelWithTitle:@"非标准品" itemId:@"3" selected:NO],
                               [self createItemModelWithTitle:@"辅材辅料" itemId:@"4" selected:NO]
                               ];
            break;
        }
        case 5:
        {
            model.itemList = @[[self createItemModelWithTitle:@"启用" itemId:@"5" selected:NO],
                               [self createItemModelWithTitle:@"禁用" itemId:@"6" selected:NO]
                               ];
            break;
        }
       
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

- (NSArray *)generateAddressDataList {
    return @[[self createAddressModelWithAddress:@"" addressId:@""]];
}

- (AddressModel *)createAddressModelWithAddress:(NSString *)address addressId:(NSString *)addressId {
    AddressModel *model = [[AddressModel alloc] init];
    model.addressString = address;
    model.addressId = addressId;
    return model;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    DLog(@"释放");
}

@end
