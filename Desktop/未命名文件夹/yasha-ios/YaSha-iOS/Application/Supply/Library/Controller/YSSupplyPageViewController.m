//
//  YSSupplyPageViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/10/19.
//

#import "YSSupplyPageViewController.h"
#import "YSPMSInfoPageSearchView.h"
#import <ZYSideSlipFilterController.h>
#import <ZYSideSlipFilterRegionModel.h>
#import <SideSlipBaseTableViewCell.h>
#import "SideSlipCommonTableViewCell.h"
#import "SideSlipSearchTableViewCell.h"
#import "YSPMSResultsViewController.h"
#import "CommonItemModel.h"
#import "AddressModel.h"
#import "YSSupplyListViewController.h"
#import "YSSupplyBlackListViewController.h"


@interface YSSupplyPageViewController ()<UISearchBarDelegate>
@property (nonatomic,strong) NSArray *subTitles;
@property (nonatomic, strong) NSMutableDictionary *payload;
@property (nonatomic, strong) NSArray *filterArray;
@property (nonatomic, strong) YSPMSInfoPageSearchView *PMSInfoPageSearchView;
@property (nonatomic, strong) ZYSideSlipFilterController *sideSlipFilterController;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) QMUIPopupMenuView *rightPopupMenuView;
@property (nonatomic, strong) NSArray *viewControllerArray;

@end

@implementation YSSupplyPageViewController
- (NSArray *)viewControllerArray {
    if (!_viewControllerArray) {
        YSSupplyListViewController *qualifiedSupplyListViewController = [[YSSupplyListViewController alloc] init];
        qualifiedSupplyListViewController.SupplyType = QualifiedSupplyInfo;
        //    qualifiedSupplyListViewController.button = _rightButton;
        YSSupplyListViewController *allSupplyListViewController = [[YSSupplyListViewController alloc] init];
        allSupplyListViewController.SupplyType = AllSupplyInfo;
       _viewControllerArray = @[qualifiedSupplyListViewController,allSupplyListViewController];
    }
    return _viewControllerArray;
}
- (NSArray *)subTitles {
    if (!_subTitles) {
        _subTitles = @[@"合格供应商", @"全部供应商"];
    }
    return _subTitles;
}

- (instancetype)init {
    if (self = [super init]) {
        self.menuItemWidth = kSCREEN_WIDTH/2 - 15*kWidthScale;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"供应商库";
    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"黑名单" position:QMUINavigationButtonPositionRight target:self action:@selector(jumpSupplyBlackList)];
    _payload = [NSMutableDictionary dictionary];
    _filterArray = @[@"factorymode", @"areamode", @"citymode", @"provicemode", @"countrymode", @"standard", @"unstandard",@"submaterial"];
    [self createSearchView];
}
//设置统计开始进入该模块
- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"供应商管理"];
}

- (void)viewWillDisappear:(BOOL)animated {
      [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"供应商管理"];
}
- (void)createSearchView {
    _PMSInfoPageSearchView = [[YSPMSInfoPageSearchView alloc] init];
    _PMSInfoPageSearchView.searchBar.delegate = self;
    [self.view addSubview:_PMSInfoPageSearchView];
    [_PMSInfoPageSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(40*kHeightScale);
    }];
    YSWeak;
    [[_PMSInfoPageSearchView.filtButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf monitorFiltButton];
    }];
}
#pragma mark - 数据源代理
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    menuView.backgroundColor = [UIColor whiteColor];
    return CGRectMake(0, 40*kHeightScale, kSCREEN_WIDTH, kMenuViewHeight);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 40*kHeightScale+kMenuViewHeight, kSCREEN_WIDTH, kSCREEN_HEIGHT-kMenuViewHeight);
}
#pragma mark - wmpageView 代理方法
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return  self.viewControllerArray.count;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    return self.viewControllerArray[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.subTitles[index];
}


- (void) jumpSupplyBlackList {
    //跳转到黑名单界面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidePMSKeyboard" object:nil];
    YSSupplyBlackListViewController *SupplyBlackListViewController = [[YSSupplyBlackListViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:SupplyBlackListViewController animated:YES];
}

///** 监控搜索框 */
//- (void)monitorSearchBar {
//    [_PMSInfoPageSearchView.searchSubject subscribeNext:^(NSString *searchString) {
//        DLog(@"searchString:%@", searchString);
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"searchSupply" object:nil userInfo:@{@"keyWord": searchString}];
//    }];
//}

/** 监控筛选按钮 */
- (void)monitorFiltButton {
//    [_PMSInfoPageSearchView.filtSubject subscribeNext:^(UIButton *filtButton) {
    YSWeak;
        if (!_sideSlipFilterController) {
            _sideSlipFilterController = [[ZYSideSlipFilterController alloc] initWithSponsor:self resetBlock:^(NSArray *dataList) {
                for (ZYSideSlipFilterRegionModel *model in dataList) {
                    // selectedStatus
                    for (CommonItemModel *itemModel in model.itemList) {
                        [itemModel setSelected:NO];
                        if (itemModel.addressType == 1) {
                            itemModel.itemName = @"省";
                        } else if (itemModel.addressType == 2) {
                            itemModel.itemName = @"市";
                        } else if (itemModel.addressType == 3) {
                            itemModel.itemName = @"区";
                        } 
                    }
                    model.selectedItemList = nil;
                }
                [weakSelf.payload removeAllObjects];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"resetSupplyPayload" object:nil];
            } commitBlock:^(NSArray *dataList) {
                [_payload removeAllObjects];
                for (ZYSideSlipFilterRegionModel *model in dataList) {
                    for (CommonItemModel *commonItemModel in model.selectedItemList) {
                        if (commonItemModel.addressType == 1) {
                            if ([dataList indexOfObject:model] == 1) {
                                [weakSelf.payload setObject:commonItemModel.itemName.length > 1 ?commonItemModel.itemName : @"" forKey:@"addressProvince"];
                            }else{
                                [weakSelf.payload setObject:commonItemModel.itemName.length > 1 ?commonItemModel.itemName : @"" forKey:@"regionProvince"];
                            }
                            
                        } else if (commonItemModel.addressType == 2) {
                            if ([dataList indexOfObject:model] == 1) {
                                [weakSelf.payload setObject:commonItemModel.itemName.length > 1 ?commonItemModel.itemName : @"" forKey:@"addressCity"];
                            }else{
                                [weakSelf.payload setObject:commonItemModel.itemName.length > 1 ?commonItemModel.itemName : @"" forKey:@"regionCity"];
                            }
                        } else if (commonItemModel.addressType == 3) {
                            if ([dataList indexOfObject:model] == 1) {
                                [weakSelf.payload setObject:commonItemModel.itemName.length > 1 ?commonItemModel.itemName : @"" forKey:@"addressArea"];
                            }else{
                                [weakSelf.payload setObject:commonItemModel.itemName.length > 1 ?commonItemModel.itemName : @"" forKey:@"regionArea"];
                            }
                        } else {
                            switch ([dataList indexOfObject:model]) {
                                case 0:
                                {
                                    NSString *str = weakSelf.payload[@"saleModel"];
                                        NSInteger index = [commonItemModel.itemId integerValue];
                                        NSString *filterString = weakSelf.filterArray[index];
                                        if (str == nil) {
                                            str = [NSString stringWithFormat:@"%@",filterString];
                                        }else{
                                            str = [NSString stringWithFormat:@"%@,%@",str,filterString];
                                        }
                                    
                                    [weakSelf.payload setObject:str forKey:@"saleModel"];
                                    break;
                                }
                                case 3:
                                {
                                    NSString *str = weakSelf.payload[@"category"];
                                        NSInteger index = [commonItemModel.itemId integerValue];
                                        NSString *filterString = weakSelf.filterArray[index];
                                        if (str == nil) {
                                            str = [NSString stringWithFormat:@"%@",filterString];
                                        }else{
                                            str = [NSString stringWithFormat:@"%@,%@",str,filterString];
                                        }
                                   
                                    [weakSelf.payload setObject:str forKey:@"category"];
                                    break;
                                }
                            }
                        }
                    }
                }
                [weakSelf.sideSlipFilterController dismiss];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"filterSupply" object:nil userInfo:weakSelf.payload];
            }];
            _sideSlipFilterController.animationDuration = .3f;
            _sideSlipFilterController.sideSlipLeading = 0.15*kSCREEN_WIDTH;
            _sideSlipFilterController.dataList = [self packageDataList];
            [_sideSlipFilterController.navigationController setNavigationBarHidden:NO];
            
        }
        [_PMSInfoPageSearchView.searchBar resignFirstResponder];
        [_sideSlipFilterController show];
//    }];
}

/** 设置ZYSideSlipFilterController的数据源 */
- (NSArray *)packageDataList {
    NSMutableArray *dataArray = [NSMutableArray array];
    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"销售模式" index:0 selectionType:BrandTableViewCellSelectionTypeMultiple]];
    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"供货/发票/生产地址" index:1 selectionType:BrandTableViewCellSelectionTypeAddress]];
    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"供货区域" index:2 selectionType:BrandTableViewCellSelectionTypeAddress]];
    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"供应商类型" index:3 selectionType:BrandTableViewCellSelectionTypeMultiple]];

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
            model.itemList = @[[self createItemModelWithTitle:@"工厂直销" itemId:@"0" selected:NO],
                               [self createItemModelWithTitle:@"区域代理" itemId:@"1" selected:NO],
                               [self createItemModelWithTitle:@"市级代理" itemId:@"2" selected:NO],
                               [self createItemModelWithTitle:@"省级代理" itemId:@"3" selected:NO],
                               [self createItemModelWithTitle:@"全国代理" itemId:@"4" selected:NO]
                               ];
            break;
        }
        case 1:
        {
            model.itemList = @[[self createItemModelWithTitle:@"省" itemId:@"" selected:NO],
                               [self createItemModelWithTitle:@"市" itemId:@"" selected:NO],
                               [self createItemModelWithTitle:@"区" itemId:@"" selected:NO]
                               ];
            break;
        }
        case 2:
        {
            model.itemList = @[[self createItemModelWithTitle:@"省" itemId:@"" selected:NO],
                               [self createItemModelWithTitle:@"市" itemId:@"" selected:NO],
                               [self createItemModelWithTitle:@"区" itemId:@"" selected:NO]
                               ];
            break;
        }
        case 3:
        {
            model.itemList = @[[self createItemModelWithTitle:@"标准品" itemId:@"5" selected:NO],
                               [self createItemModelWithTitle:@"非标准品" itemId:@"6" selected:NO],
                               [self createItemModelWithTitle:@"辅材类" itemId:@"7" selected:NO]
                               
                               ];
            break;
        }
    }
    return model;
}

- (ZYSideSlipFilterRegionModel *)yearFilterRegionModelWithKeyword:(NSString *)keyword index:(NSInteger)index selectionType:(CommonTableViewCellSelectionType)selectionType {
    ZYSideSlipFilterRegionModel *model = [[ZYSideSlipFilterRegionModel alloc] init];
    model.containerCellClass = @"SideSlipServiceTableViewCell";
    model.regionTitle = @"所属年份";
    model.customDict = @{REGION_SELECTION_TYPE:@(selectionType)};
    model.itemList = @[[self createItemModelWithTitle:@"年份" itemId:@"" selected:NO]];
    model.customDict = @{ADDRESS_LIST:[self generateYearDataList]};
    return model;
}

- (ZYSideSlipFilterRegionModel *)searchFilterRegionModel {
    ZYSideSlipFilterRegionModel *model = [[ZYSideSlipFilterRegionModel alloc] init];
    model.containerCellClass = @"SideSlipSearchTableViewCell";
    model.regionTitle = @"所属部门";
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

- (NSArray *)generateYearDataList {
    return @[[self createAddressModelWithAddress:[NSString stringWithFormat:@"%@", @" "] addressId:@"0000"]];
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
#pragma mark - searchBar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
   [[NSNotificationCenter defaultCenter] postNotificationName:@"searchSupply" object:nil userInfo:@{@"keyWord":searchText}];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
