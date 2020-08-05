//
//  YSSupplyMaterialPriceViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/14.
//

#import "YSSupplyMaterialPriceViewController.h"
#import "YSSupplyMaterialPriceCell.h"
#import "YSPMSInfoHeaderView.h"
#import "YSMaterialPriceHeaderView.h"

@interface YSSupplyMaterialPriceViewController ()<YSMaterialPriceHeaderViewDelegate,CYLTableViewPlaceHolderDelegate>

@property (nonatomic, strong) NSMutableArray *isOpenArr;
@property (nonatomic, strong) NSIndexPath *selectedIndex;
@property (nonatomic, strong) YSPMSInfoHeaderView *infoHeaderView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation YSSupplyMaterialPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.sectionFooterHeight = 0;

    [self.tableView registerClass:[YSSupplyMaterialPriceCell class] forCellReuseIdentifier:@"SupplyMaterialPriceCell"];
    _isOpenArr = [NSMutableArray array];
    for (int i =0; i< 100; i++) {
        
        [_isOpenArr addObject:@"0"];
    }
   
    [self doNetworking];
}

- (void)doNetworking{
    
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain,getMaterialFixDetailApp,self.materialID] isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"------%@",response);
        if ([response[@"code"] integerValue] == 1) {
            self.dataArray = response[@"data"];
            if (self.dataArray.count > 0) {
                [self.tableView reloadData];
            }else {
                [self.tableView cyl_reloadData];
            }
        }else{
            [QMUITips showError:response[@"msg"] inView:self.view];
        }
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([_isOpenArr[section] isEqualToString:@"1"]) {
        return 1;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 52*kHeightScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 210*kHeightScale;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *view  = [[UIView alloc]initWithFrame:CGRectMake(0, 5*kHeightScale, kSCREEN_WIDTH, 42*kHeightScale)];
//    view.backgroundColor = [UIColor whiteColor];
//    self.infoHeaderView = [[YSPMSInfoHeaderView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    [view addSubview:self.infoHeaderView];
//    NSArray *headlineArray = @[@"河北省 石家庄市",@"江苏省 南京市",@"江苏省 南京市"];
//    self.infoHeaderView.positionLabel.text = headlineArray[section];
//    self.infoHeaderView.positionLabel.textColor = [UIColor blackColor];
//
//    //添加点击手势
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topgesture:)];
//    [view addGestureRecognizer:tap];
//
//  view.tag = section;
//    return view;
 YSMaterialPriceHeaderView *headerView =[[YSMaterialPriceHeaderView alloc]initWithReuseIdentifier:@"YSMaterialPriceHeaderView"];
   
    headerView.delegate = self;
    headerView.tag = section;
    [headerView setAdderssShow:self.dataArray[section]];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSSupplyMaterialPriceCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[YSSupplyMaterialPriceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SupplyMaterialPriceCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setLineChart:self.dataArray[indexPath.section][@"data"]];

    return cell;
}

-(void)topgesture:(UITapGestureRecognizer*)tap
{
    NSInteger index = tap.view.tag;
    if ([_isOpenArr[index] isEqualToString:@"1"]) {
        [_isOpenArr replaceObjectAtIndex:index withObject:@"0"];
    }else {
        [_isOpenArr replaceObjectAtIndex:index withObject:@"1"];
    }
    [self.tableView reloadData];
}


#pragma mark - YSMaterialPriceHeaderViewDelegate
- (void)materialPriceHeaderViewDidClickWith:(YSMaterialPriceHeaderView *)view{
    NSInteger index = view.tag;
    
    if ([_isOpenArr[index] isEqualToString:@"1"]) {
        
        [_isOpenArr replaceObjectAtIndex:index withObject:@"0"];
        
    }else{
        [_isOpenArr replaceObjectAtIndex:index withObject:@"1"];
        
    }
    
    [self.tableView reloadData];
}


#pragma mark - CYLTableViewPlaceHolderDelegate

- (BOOL)enableScrollWhenPlaceHolderViewShowing {
    return YES;
}

- (UIView *)makePlaceHolderView {
    return [YSUtility NoDataView:@"无数据"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
