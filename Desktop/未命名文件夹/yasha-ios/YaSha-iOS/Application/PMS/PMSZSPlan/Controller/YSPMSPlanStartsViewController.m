//
//  YSPMSPlanStartsViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/10/16.
//

#import "YSPMSPlanStartsViewController.h"
#import "YSPMSPlanStartsViewCell.h"
#import "YSPMSPlanDetailsViewController.h"
#import "YSPMSPlanAddPhotoViewController.h"
#import "YSPMSPlanListModel.h"
#import "QMUIPopupMenuView.h"
#import <QMUIKit.h>
typedef NS_ENUM(NSUInteger, YSTaskType) {
    YSTaskTypeAll = 1,   //全部
    YSTaskTypeMine = 2   //我的
    
};
@interface YSPMSPlanStartsViewController ()<SWTableViewCellDelegate,UISearchBarDelegate,UISearchControllerDelegate>

@property (nonatomic, strong) NSMutableDictionary *payload;
@property(nonatomic,assign)YSTaskType taskType;
@property(nonatomic,strong)QMUIPopupMenuView *rightPopupMenuView;
@end

@implementation YSPMSPlanStartsViewController

- (QMUIPopupMenuView *)rightPopupMenuView
{
    if (!_rightPopupMenuView) {
        
        _rightPopupMenuView = [[QMUIPopupMenuView alloc] init];
        _rightPopupMenuView.automaticallyHidesWhenUserTap = YES;
        _rightPopupMenuView.maskViewBackgroundColor = UIColorMaskWhite;
        _rightPopupMenuView.maximumWidth = 120*kWidthScale;
        _rightPopupMenuView.shouldShowItemSeparator = YES;
        _rightPopupMenuView.separatorInset = UIEdgeInsetsMake(0, _rightPopupMenuView.padding.left, 0, _rightPopupMenuView.padding.right);
        YSWeak;
        _rightPopupMenuView.items = @[
                                      [QMUIPopupMenuItem itemWithImage:nil title:@"我的" handler:^{
                                          weakSelf.pageNumber = 1;
                                          weakSelf.taskType = YSTaskTypeMine;
                                          [weakSelf doNetworking];
                                          [weakSelf.rightPopupMenuView hideWithAnimated:YES];
                                      }],
                                      [QMUIPopupMenuItem itemWithImage:nil title:@"全部" handler:^{
                                          weakSelf.pageNumber = 1;
                                          weakSelf.taskType = YSTaskTypeAll;
                                          [weakSelf doNetworking];
                                          [weakSelf.rightPopupMenuView hideWithAnimated:YES];
                                      }]
                                      ];
        
        _rightPopupMenuView.didHideBlock = ^(BOOL hidesByUserTap) {
            
        };
    }
    return _rightPopupMenuView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleName;
    self.taskType = YSTaskTypeAll; //默认是全部
    
    //导航栏按钮
    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"筛选" position:QMUINavigationButtonPositionRight target:self action:@selector(rightBarButtonAction:event:)];
}

- (void)viewDidAppear:(BOOL)animated {
    self.pageNumber = 1;
    [self doNetworking];
}

- (void)initTableView {
    [super initTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YSPMSPlanStartsViewCell class] forCellReuseIdentifier:@"PlanStartsCell"];
    [self ys_shouldShowSearchBar];
    [self doNetworking];
}

- (void)doNetworking {
    
    NSDictionary *payload = @{@"planInfoCode":self.code,
                              @"keyWord":self.keyWord,
                              };
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@/%zd/%zd",YSDomain, getPlanTaskList, self.type,self.taskType, self.pageNumber] isNeedCache:NO parameters:payload successBlock:^(id response) {
        DLog(@"==========%@",response);
        if (self.pageNumber == 1) {
            [self.dataSourceArray removeAllObjects];
        }
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (NSDictionary *dic  in response[@"data"]) {
            [mutableArray addObject:dic];
            [self.dataSourceArray addObject:[YSPMSPlanListModel yy_modelWithJSON:dic]];
        }
        self.tableView.mj_footer.state = mutableArray.count < 15 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
        [self ys_reloadData];
        [self.tableView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        DLog(@"----------%@",error);
    } progress:nil];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 172;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPMSPlanStartsViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PlanStartsCell" forIndexPath:indexPath];
    //YSPMSPlanStartsViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PlanStartsCell"];
    if (cell == nil) {
        cell = [[YSPMSPlanStartsViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PlanStartsCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YSPMSPlanListModel *model = self.dataSourceArray[indexPath.row];
    if (([self.proManagerId isEqual:[YSUtility getUID]] || [model.personLiableCode isEqual:[YSUtility getUID]]) && ![model.taskStatus isEqual:@"30"]) {
        cell.rightUtilityButtons = [self rightButtons:model.taskStatus andControlPoints:model.taskCategory];
        cell.delegate = self;
    }
    cell.tag = indexPath.row;
    [cell setPlanStartsCellData:self.dataSourceArray[indexPath.row]];
    return cell;
}

- (NSArray *)rightButtons:(NSString *)stateStr andControlPoints:(NSString *)points {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    if ([self.titleName isEqual:@"控制点任务"] || [self.titleName isEqual:@"延期控制点任务"]) {
        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"完工"];
    }else{
        if ([points isEqual:@"gjkzd"]) {
            [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"完工"];
        }else if ([stateStr isEqual:@"10"]) {
            [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"开工"];
        }else{
            [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"跟踪"];
        }
    }
    
    return rightUtilityButtons;
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPMSPlanDetailsViewController *PMSPlanDetailsViewController = [[YSPMSPlanDetailsViewController alloc]initWithStyle:UITableViewStyleGrouped];
    YSPMSPlanListModel *model = self.dataSourceArray[indexPath.row];
    PMSPlanDetailsViewController.code = model.code;
    [self.navigationController pushViewController:PMSPlanDetailsViewController animated:YES];
}

#pragma mark - SWTableViewCellDelegate

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    YSPMSPlanListModel *model = self.dataSourceArray[cell.tag];
    
    YSPMSPlanAddPhotoViewController *PMSPlanAddPhotoViewController = [[YSPMSPlanAddPhotoViewController alloc]init];
    PMSPlanAddPhotoViewController.refreshPlanStart = ^{
        if (self.refreshPlanInfoBlock) {//修改提交时刷新
            self.refreshPlanInfoBlock();
        }
    };
    PMSPlanAddPhotoViewController.model = model;
    DLog(@"========%@",model.taskCategory);
    if ([model.taskCategory isEqual:@"gjkzd"]) {
        PMSPlanAddPhotoViewController.type = @"1";
        PMSPlanAddPhotoViewController.taskStatus = @"30";
        PMSPlanAddPhotoViewController.planType = YSPMSPlanTypeStarts;
        [self.navigationController pushViewController:PMSPlanAddPhotoViewController animated:YES];
    }else{
        DLog(@"========%@",model.taskStatus);
        if ([model.taskStatus isEqual:@"10"]) {
            PMSPlanAddPhotoViewController.planType = YSPMSPlanTypeStarts;
            PMSPlanAddPhotoViewController.type = @"1";
            PMSPlanAddPhotoViewController.taskStatus = @"20";
            [self.navigationController pushViewController:PMSPlanAddPhotoViewController animated:YES];
        }else{
            QMUIDialogSelectionViewController *dialogSelection = [[QMUIDialogSelectionViewController alloc]init];
            dialogSelection.title = @"请选择跟踪进度或完工!";
            [dialogSelection addCancelButtonWithText:@"跟踪" block:^(QMUIDialogViewController *dialogViewController) {
                
                PMSPlanAddPhotoViewController.planType = YSPMSPlanTypeTracking;
                PMSPlanAddPhotoViewController.status = @"1";
                [self.navigationController pushViewController:PMSPlanAddPhotoViewController animated:YES];
            }];
            [dialogSelection addSubmitButtonWithText:@"完工" block:^(QMUIDialogViewController *dialogViewController) {
                [dialogSelection hide];
                if ([model.taskCategory isEqual:@"gjkzd"]) {
                    PMSPlanAddPhotoViewController.planType = YSPMSPlanTypeStarts ;
                    PMSPlanAddPhotoViewController.type = @"1";
                    PMSPlanAddPhotoViewController.taskStatus = @"30";
                    
                }else{
                    PMSPlanAddPhotoViewController.planType = YSPMSPlanTypeTracking;
                    PMSPlanAddPhotoViewController.status = @"2";
                }
                [self.navigationController pushViewController:PMSPlanAddPhotoViewController animated:YES];
            }];
            [dialogSelection show];
        }
    }
    
    
    
    
}
#pragma mark - rightBarButtonAction
- (void)rightBarButtonAction:(UIBarButtonItem *)sender event:(UIEvent *) event {
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:touch.window]; //返回触摸点在视图中的当前坐标
    CGRect rect = [touch.view convertRect:touch.view.frame toView:touch.window];
    [self.rightPopupMenuView layoutWithTargetRectInScreenCoordinate:rect];
    [self.rightPopupMenuView showWithAnimated:YES];
    
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
