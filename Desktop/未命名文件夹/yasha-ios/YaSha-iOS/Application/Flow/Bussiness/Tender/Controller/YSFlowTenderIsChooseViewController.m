//
//  YSFlowTenderIsChooseViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/23.
//

#import "YSFlowTenderIsChooseViewController.h"
#import "YSFlowTenderTableViewCell.h"
#import "YSFlowTenderHeaderView.h"
#import "YSFlowTenderIsChooseModel.h"

@interface YSFlowTenderIsChooseViewController ()

@property (nonatomic, strong) YSFlowTenderHeaderView *flowTenderHeaderView;
@property (nonatomic, strong) NSMutableArray *isOpenArr;
@property (nonatomic, strong) NSMutableArray *headerArray;

@end

@implementation YSFlowTenderIsChooseViewController

- (void)initTableView {
    [super initTableView];
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    self.headerArray = [NSMutableArray array];
    [self.tableView registerClass:[YSFlowTenderTableViewCell class] forCellReuseIdentifier:@"FlowTenderCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self doNetworking];
   
}
- (void)doNetworking {
    NSDictionary *dic = @{@"tenderBidId":self.id,@"isBid":[NSString stringWithFormat:@"%zd",self.flowTenderType]
                          };
    DLog(@"=======%@",dic);
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%zd",YSDomain, getTenderBidFranOpenAjaxApi, self.pageNumber ] isNeedCache:NO parameters:dic successBlock:^(id response) {
        DLog(@"标价详情:%@", response);
        self.pageNumber == 1 ? [self.dataSourceArray removeAllObjects]:nil;
        if (![response[@"data"] isEqual:[NSNull null]]) {
//            for (NSDictionary *dic in response[@"data"]) {
//                [self.dataSourceArray addObject:[YSFlowTenderIsChooseModel yy_modelWithJSON:dic]];
//            }
            self.dataSourceArray = response[@"data"];
        }
        self.tableView.mj_footer.state = self.dataSourceArray.count < 15 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
        _isOpenArr = [NSMutableArray array];
        for (int i =0; i< self.dataSourceArray.count; i++) {
            
            [_isOpenArr addObject:@"0"];
        }
        [self ys_reloadData];
        [self.tableView.mj_header endRefreshing];
        
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([_isOpenArr[section] isEqualToString:@"1"])
    {
        return 1;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70*kHeightScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"FlowTenderCell" cacheByIndexPath:indexPath configuration:^(YSFlowTenderTableViewCell *cell) {
        [cell setFlowTenderData:self.dataSourceArray[indexPath.section]];
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10*kHeightScale, kSCREEN_WIDTH, 42*kHeightScale)];
    backView.backgroundColor = [UIColor whiteColor];
    self.flowTenderHeaderView = [[YSFlowTenderHeaderView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.flowTenderHeaderView.unitLabel removeFromSuperview];
    [backView addSubview:self.flowTenderHeaderView];
    [self.flowTenderHeaderView setFlowTenderHeaderData:self.dataSourceArray[section] andIsspread:_isOpenArr[section]];
    
    //添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topgesture:)];
    [backView addGestureRecognizer:tap];
    backView.tag = section;
    
    return backView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFlowTenderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FlowTenderCell"];
    if (cell == nil) {
        cell = [[YSFlowTenderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FlowTenderCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, kSCREEN_WIDTH, 0, 0);
    [cell setFlowTenderData:self.dataSourceArray[indexPath.section] ];
    return cell;
}

-(void)topgesture:(UITapGestureRecognizer*)tap
{
    
    NSInteger index = tap.view.tag;
    
    if ([_isOpenArr[index] isEqualToString:@"1"]) {
        
        [_isOpenArr replaceObjectAtIndex:index withObject:@"0"];
        
    }else{
        [_isOpenArr replaceObjectAtIndex:index withObject:@"1"];
        
    }
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:index];
    
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
