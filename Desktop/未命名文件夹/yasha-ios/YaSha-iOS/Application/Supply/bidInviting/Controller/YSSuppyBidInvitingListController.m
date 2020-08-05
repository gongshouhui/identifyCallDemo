//
//  YSSuppyBidInvitingListController.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/1/2.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSSuppyBidInvitingListController.h"
#import <ZYSideSlipFilterController.h>
#import <ZYSideSlipFilterRegionModel.h>
#import <SideSlipBaseTableViewCell.h>
#import "SideSlipCommonTableViewCell.h"
#import "SideSlipSearchTableViewCell.h"
#import "CommonItemModel.h"
#import "AddressModel.h"
#import "YSSuppyBidInvitingCell.h"
#import "YSSupplyBidInvitingDetailController.h"
#import "YSSupplyBidDetailModel.h"
@interface YSSuppyBidInvitingListController ()<UISearchBarDelegate>
@property (nonatomic, strong) ZYSideSlipFilterController *sideSlipFilterController;
@property (nonatomic,strong) NSArray *filterArray;
@property (nonatomic,strong) NSMutableDictionary *playLoad;
@property (nonatomic,strong) NSString *bidNum;
@property (nonatomic,strong) NSString *bidMtrl;/**招标材料*/
/**项目编号*/
@property (nonatomic,strong) NSString *proCode;
@property (nonatomic,strong) NSString *status;/**审核状态*/

@end

@implementation YSSuppyBidInvitingListController

//设置统计开始进入该模块
- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"招标管理"];
}

- (void)viewWillDisappear:(BOOL)animated {
      [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"招标管理"];
}
- (NSMutableDictionary *)playLoad {
    if (!_playLoad) {
        _playLoad = [NSMutableDictionary dictionary];
    }
    return _playLoad;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"招标管理";
    //_filterArray = @[@"输入中", @"已提交", @"审核中",@"已审核"];
    _filterArray = @[@"10", @"20", @"30",@"40"];
    // Do any additional setup after loading the view.
}

- (void)initSubviews {
    [super initSubviews];
    [self ys_shouldShowSearchBaraAndScreening];//初始化搜索框
    self.searchField.placeholder = @"请输入项目名称";
    self.searchBar.delegate = self;
    [self doNetworking];
    
}

- (void)doNetworking {
//    [super doNetworking];
    [QMUITips showLoadingInView:self.view];
//    [self.playLoad setValue:self.bidNum forKey:@"code"];
//    [self.playLoad setValue:self.proCode forKey:@"proCode"];
//    [self.playLoad setValue:self.bidMtrl forKey:@"bidMtrl"];
//    [self.playLoad setValue:self.status forKey:@"auditStatusStr"];
    [self.playLoad setValue:self.keyWord forKey:@"proName"];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%zd",YSDomain,getBidManagerListDataAPI,self.pageNumber] isNeedCache:NO parameters:self.playLoad successBlock:^(id response) {
        DLog(@"---------%@",response);
        [QMUITips hideAllTipsInView:self.view];
        if ([response[@"code"] integerValue] == 1) {
            if (self.pageNumber == 1) {
                [self.dataSourceArray removeAllObjects];
            }
            NSArray *dataArr = [NSArray yy_modelArrayWithClass:[YSSupplyBidDetailModel class] json:response[@"data"]];
            [self.dataSourceArray addObjectsFromArray:dataArr];
            self.tableView.mj_footer.state = dataArr.count < 15 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
            [self ys_reloadData];
        }
        [self.tableView.mj_header endRefreshing];
        
    } failureBlock:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    } progress:nil];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableViewDataSource,tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSSuppyBidInvitingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSSuppyBidInvitingCell"];
    if (cell == nil) {
        cell = [[YSSuppyBidInvitingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSSuppyBidInvitingCell"];
    }
    cell.model = self.dataSourceArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YSSupplyBidDetailModel *model =self.dataSourceArray[indexPath.row];
    YSSupplyBidInvitingDetailController *vc = [[YSSupplyBidInvitingDetailController alloc]init];
    vc.type = model.flowType;
    vc.bidID = [self.dataSourceArray[indexPath.row] id];
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

#pragma mark - /** 监控筛选按钮 */
- (void)monitorFiltButton {
    YSWeak;
    if (!_sideSlipFilterController) {
    _sideSlipFilterController = [[ZYSideSlipFilterController alloc]initWithSponsor:self resetBlock:^(NSArray *dataList) {
        for (ZYSideSlipFilterRegionModel *model in dataList) {
            // selectedStatus
            for (CommonItemModel *itemModel in model.itemList) {
                [itemModel setSelected:NO];
            }
            model.selectedItemList = nil;
        }
        //重置刷新
        [weakSelf.playLoad removeAllObjects];
        [weakSelf doNetworking];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"resetPMSPayload" object:nil];
        
        
    } commitBlock:^(NSArray *dataList) {
        [_playLoad removeAllObjects];
        for (ZYSideSlipFilterRegionModel *model in dataList) {
            for (CommonItemModel *commonItemModel in model.selectedItemList) {
                switch ([dataList indexOfObject:model]) {
                    case 0://招标编号
                    {
                        if (commonItemModel.itemName) {

                            [weakSelf.playLoad setObject:commonItemModel.itemName forKey:@"mtrlOne"];
                        }
                        break;
                    }
                    case 1://项目编号
                    {
                        if (commonItemModel.itemName) {
                            [weakSelf.playLoad setObject:commonItemModel.itemName forKey:@"mtrlTwo"];

                        }
                        break;
                    }
                    case 2://招标材料
                    {
                        if (commonItemModel.itemName) {
                            [weakSelf.playLoad setObject:commonItemModel.itemName forKey:@"mtrlThree"];
                        }
                        break;
                    }
                    case 3://审核状态
                    {
                            NSString *str = weakSelf.playLoad[@"auditStatusStr"];
                            NSInteger index = [commonItemModel.itemId integerValue];
                            NSString *filterString = weakSelf.filterArray[index];
                            if (str == nil) {
                                str = [NSString stringWithFormat:@"%@",filterString];
                            }else{
                                str = [NSString stringWithFormat:@"%@,%@",str,filterString];
                            }
                      
                        [weakSelf.playLoad setObject:str forKey:@"auditStatusStr"];
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
- (NSArray *)packageDataList {
    NSMutableArray *dataArray = [NSMutableArray array];
    
    [dataArray addObject:[self searchFilterRegionModelWithTitle:@"招标编号"]];
     [dataArray addObject:[self searchFilterRegionModelWithTitle:@"项目编号"]];
    [dataArray addObject:[self searchFilterRegionModelWithTitle:@"招标材料"]];
    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"审核状态" selectionType:BrandTableViewCellSelectionTypeMultiple]];
    return [dataArray mutableCopy];
}
//搜索框
- (ZYSideSlipFilterRegionModel *)searchFilterRegionModelWithTitle:(NSString *)title {
    ZYSideSlipFilterRegionModel *model = [[ZYSideSlipFilterRegionModel alloc] init];
    model.containerCellClass = @"SideSlipSearchTableViewCell";
    model.regionTitle = title;
    return model;
}
//区域选择
- (ZYSideSlipFilterRegionModel *)commonFilterRegionModelWithKeyword:(NSString *)keyword selectionType:(CommonTableViewCellSelectionType)selectionType {
    ZYSideSlipFilterRegionModel *model = [[ZYSideSlipFilterRegionModel alloc] init];
    model.containerCellClass = @"SideSlipCommonTableViewCell";
    model.regionTitle = keyword;
    model.customDict = @{REGION_SELECTION_TYPE:@(selectionType)};
    model.itemList = @[
                       [self createItemModelWithTitle:@"输入中" itemId:@"0" selected:NO],
                       [self createItemModelWithTitle:@"已提交" itemId:@"1" selected:NO],
                        [self createItemModelWithTitle:@"审核中" itemId:@"2" selected:NO],
                        [self createItemModelWithTitle:@"已审核" itemId:@"3" selected:NO],
                       ];
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}
- (void)dealloc {
    DLog(@"释放");
}
@end
