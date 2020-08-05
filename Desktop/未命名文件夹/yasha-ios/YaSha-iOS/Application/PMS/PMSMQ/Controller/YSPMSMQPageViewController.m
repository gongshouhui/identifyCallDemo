//
//  YSPMSMQPageViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/19.
//
//

#import "YSPMSMQPageViewController.h"
#import "YSPMSMQListViewController.h"
#import "YSPMSInfoPageSearchView.h"
#import "YSPMSMQResultsViewController.h"
#import "YSPMSChooseView.h"
#import <ZYSideSlipFilterController.h>
#import <ZYSideSlipFilterRegionModel.h>
#import <SideSlipBaseTableViewCell.h>
#import "SideSlipCommonTableViewCell.h"
#import "SideSlipSearchTableViewCell.h"
#import "YSPMSResultsViewController.h"
#import "ShowAnimationView.h"
#import "YSSelfNVCView.h"
#import "CommonItemModel.h"
#import "AddressModel.h"
#import "YSACLModel.h"


@interface YSPMSMQPageViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *filterArray;
@property (nonatomic, strong) NSMutableDictionary *payload;
@property (nonatomic, strong) NSArray *viewControllerArray;

@property (nonatomic, strong) YSPMSInfoPageSearchView *PMSInfoPageSearchView;
@property (nonatomic, strong) ZYSideSlipFilterController *sideSlipFilterController;
@property (nonatomic, strong) RLMResults *zsResults;
@property (nonatomic,strong) NSArray *subTitles;

@end

@implementation YSPMSMQPageViewController

//设置统计开始进入该模块
- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"幕墙项目信息管理"];
}

- (void)viewWillDisappear:(BOOL)animated {
      [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"幕墙项目信息管理"];
}

- (NSArray *)viewControllerArray {
    if (!_viewControllerArray) {
        YSPMSMQListViewController *autotrophyOneInfoListViewController = [[YSPMSMQListViewController alloc] initWithStyle:UITableViewStyleGrouped];
        autotrophyOneInfoListViewController.PMSMQType = AutotrophyInfoOne;
//        YSPMSMQListViewController *autotrophyTwoInfoListViewController = [[YSPMSMQListViewController alloc] initWithStyle:UITableViewStyleGrouped];
//        autotrophyTwoInfoListViewController.PMSMQType = AutotrophyInfoTwo;
        //     NSArray *viewControllers = @[autotrophyOneInfoListViewController, autotrophyTwoInfoListViewController];
        
        YSPMSMQListViewController *cooperationInfoListViewController = [[YSPMSMQListViewController alloc] initWithStyle:UITableViewStyleGrouped];
        cooperationInfoListViewController.PMSMQType = CheckInfo;
        
        _viewControllerArray = @[autotrophyOneInfoListViewController,cooperationInfoListViewController];
    }
    return _viewControllerArray;
}
- (NSArray *)subTitles {
    if (!_subTitles) {
        _subTitles = @[@"直营", @"考核"];
    }
    return _subTitles;
}

- (instancetype)init {
    if (self = [super init]) {
        self.menuItemWidth = kSCREEN_WIDTH / 3 - 15*kWidthScale;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //    _dataArray = @[@"自营",@"考核"];
    _filterArray = @[@"gddjht", @"gdzjht", @"5", @"10", @"20", @"30", @"40", @"55", @"60",@"10",@"20",@"30"];
    _payload = [NSMutableDictionary dictionary];
    self.title = @"项目信息管理";
    [self createSearchView];
    
}
- (void)createSearchView {
    _PMSInfoPageSearchView = [[YSPMSInfoPageSearchView alloc] init];
    _PMSInfoPageSearchView.searchBar.placeholder = @"请输入项目名称...";
    _PMSInfoPageSearchView.searchBar.delegate = self;
    [self.view addSubview:_PMSInfoPageSearchView];
    [_PMSInfoPageSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(40*kHeightScale);
    }];
    YSWeak;
    [[_PMSInfoPageSearchView.filtButton rac_signalForControlEvents:UIControlEventTouchUpInside
      ] subscribeNext:^(id x) {
         [weakSelf monitorFiltButton];
    }];
//    [self monitorSearchBar];
//    [self monitorFiltButton];
}





///** 监控搜索框 */
//- (void)monitorSearchBar {
//    [_PMSInfoPageSearchView.searchSubject subscribeNext:^(NSString *searchString) {
//        DLog(@"searchString:%@", searchString);
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"searchPMS" object:nil userInfo:@{@"name": searchString}];
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
                        //                        itemModel.itemId = @"";
                        [itemModel setSelected:NO];
                        if (itemModel.addressType == 1) {
                            itemModel.itemName = @"省";
                        } else if (itemModel.addressType == 2) {
                            itemModel.itemName = @"市";
                        } else if (itemModel.addressType == 3) {
                            itemModel.itemName = @"区";
                        }else if([dataList indexOfObject:model] == 1){
                            itemModel.itemName = @"年份";
                        }
                    }
                    model.selectedItemList = nil;
                }
                [weakSelf.payload removeAllObjects];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"resetPMSPayload" object:nil];
            } commitBlock:^(NSArray *dataList) {
                for (ZYSideSlipFilterRegionModel *model in dataList) {
                    for (CommonItemModel *commonItemModel in model.selectedItemList) {
                        if (commonItemModel.addressType == 1) {
                            [weakSelf.payload setObject:commonItemModel.itemId forKey:@"provinceCode"];
                        } else if (commonItemModel.addressType == 2) {
                            [weakSelf.payload setObject:commonItemModel.itemId forKey:@"cityCode"];
                        } else if (commonItemModel.addressType == 3) {
                            [weakSelf.payload setObject:commonItemModel.itemId forKey:@"areaCode"];
                        } else {
                            NSInteger index = [commonItemModel.itemId integerValue];
                            NSString *filterString = weakSelf.filterArray[index];
                            if (weakSelf.zsResults.count > 0) {
                                switch ([dataList indexOfObject:model]) {
                                    case 0:
                                    {
                                        if (filterString) {
                                            [weakSelf.payload setObject:filterString forKey:@"contForm"];
                                        }
                                        break;
                                    }
                                    case 1:
                                    {
                                        if (filterString) {
                                            [weakSelf.payload setObject:commonItemModel.itemName forKey:@"belongTimeStr"];
                                        }
                                        break;
                                    }
                                    case 2:
                                    {
                                        NSString *str = weakSelf.payload[@"auditStatusStr"];
                    
                                            NSInteger index = [commonItemModel.itemId integerValue];
                                            NSString *filterString = weakSelf.filterArray[index];
                                            if (str == nil) {
                                                str = [NSString stringWithFormat:@"%@",filterString];
                                            }else{
                                                str = [NSString stringWithFormat:@"%@,%@",str,filterString];
                                            }
                                        [weakSelf.payload setObject:str forKey:@"auditStatusStr"];
                                        break;
                                    }
                                    case 3:
                                    {
                                        if (filterString) {
                                            [weakSelf.payload setObject:filterString forKey:@"proStatus"];
                                        }
                                        break;
                                    }
                                    case 4:
                                    {
                                        if (commonItemModel.itemName) {
                                            [weakSelf.payload setObject:commonItemModel.itemName forKey:@"baseInfoDept"];
                                        }
                                        break;
                                    }
                                        
                                    default:
                                        break;
                                }
                        }
                    }
                }
            }
                //DLog(@"---------%@",_payload);
                [weakSelf.sideSlipFilterController dismiss];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"filterPMS" object:nil userInfo:weakSelf.payload];
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
    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"合同形式" index:0 selectionType:BrandTableViewCellSelectionTypeSingle]];
    [dataArray addObject:[self yearFilterRegionModelWithKeyword:@"所属年份" index:1 selectionType:BrandTableViewCellSelectionTypeSingle]];
    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"单据状态" index:2 selectionType:BrandTableViewCellSelectionTypeMultiple]];
    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"项目状态" index:3 selectionType:BrandTableViewCellSelectionTypeSingle]];
    [dataArray addObject:[self searchFilterRegionModel]];
    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"工程地址" index:5 selectionType:BrandTableViewCellSelectionTypeAddress]];
//    if (_zsResults.count <= 0) {
//        [dataArray removeObjectAtIndex:2];
//    }
    
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
            model.itemList = @[[self createItemModelWithTitle:@"固定单价" itemId:@"0" selected:NO],
                               [self createItemModelWithTitle:@"固定总价" itemId:@"1" selected:NO]
                               ];
            break;
        }
        case 2:
        {
            model.itemList = @[[self createItemModelWithTitle:@"输入中" itemId:@"9" selected:NO],
                               [self createItemModelWithTitle:@"待审核" itemId:@"10" selected:NO],
                               [self createItemModelWithTitle:@"已审核" itemId:@"11" selected:NO]
                               ];
            break;
        }
        case 3:
        {
            model.itemList = @[[self createItemModelWithTitle:@"未开工" itemId:@"2" selected:NO],
                               [self createItemModelWithTitle:@"在建" itemId:@"3" selected:NO],
                               [self createItemModelWithTitle:@"停工" itemId:@"4" selected:NO],
                               [self createItemModelWithTitle:@"退场" itemId:@"5" selected:NO],
                               [self createItemModelWithTitle:@"完工" itemId:@"6" selected:NO],
                               [self createItemModelWithTitle:@"送审" itemId:@"7" selected:NO],
                               [self createItemModelWithTitle:@"审定" itemId:@"8" selected:NO]
                               ];
            break;
        }
        case 5:
        {
            model.itemList = @[[self createItemModelWithTitle:@"省" itemId:@"" selected:NO],
                               [self createItemModelWithTitle:@"市" itemId:@"" selected:NO],
                               [self createItemModelWithTitle:@"区" itemId:@"" selected:NO]
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
#pragma mark - wmpageView 代理方法
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.viewControllerArray.count;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    return self.viewControllerArray[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.subTitles[index];
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    menuView.backgroundColor = [UIColor whiteColor];
    return CGRectMake(0, 40*kHeightScale, kSCREEN_WIDTH, 40*kHeightScale);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 80*kHeightScale, kSCREEN_WIDTH, kSCREEN_HEIGHT-80*kHeightScale);
}
#pragma mark - searchBar 代理方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchPMS" object:nil userInfo:@{@"name": searchText}];
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
