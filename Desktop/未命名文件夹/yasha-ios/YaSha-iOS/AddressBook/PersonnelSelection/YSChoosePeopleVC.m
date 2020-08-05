//
//  YSChoosePeopleVC.m
//  YaSha-iOS
//
//  Created by mHome on 2017/4/17.
//
//

#import "YSChoosePeopleVC.h"
#import "YSSingleton.h"
#import "MyScrollView.h"
#import "YSDingDingHeader.h"
#import "YSInternalModel.h"
#import "YSChoosePeopleTableViewCell.h"
#import "YSExternalViewController.h"
#import "YSSearchViewController.h"
#import "YSRepairViewController.h"
#import "YSCalendarGrantViewController.h"
#import "YSFlowHandleViewController.h"
#import "YSEMSApplyTripViewController.h"
#import "YSCommonFlowLaunchListViewController.h"

@interface YSChoosePeopleVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property(strong,nonatomic)UITableView * mTableView; //显示数据的tableview
@property(strong,nonatomic)MyScrollView * mScrollView;//显示通讯录头部导航栏
@property(strong,nonatomic)UIImageView  *titleImage;
@property(strong,nonatomic)NSMutableArray *array;
@property(nonatomic,strong)YSSingleton *singleton;
@property(nonatomic,assign)BOOL isADD; //判断是否选着该人员
@property(nonatomic,assign)BOOL isBack;//判断?导航栏返回:滑动手势返回

@end

@implementation YSChoosePeopleVC

- (void)viewWillAppear:(BOOL)animated{
    
    __weak typeof(self) weakSelf = self;
 self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    
}
#pragma mark - UIGestureRecognizerDelegate  重写滑动手势代理事件
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    //判断是否为rootViewController
    if (self.navigationController && self.rt_navigationController.rt_viewControllers.count == 1) {
        return NO;
    }else{
        if ([YSDingDingHeader shareHelper].titleList.count > 1) {
            [[YSDingDingHeader shareHelper].titleList removeObjectAtIndex:[YSDingDingHeader shareHelper].titleList.count-1];
        }
        if ([YSDingDingHeader shareHelper].titleList.count == 1) {
            [[YSDingDingHeader shareHelper].titleList removeAllObjects];
        }
        return YES;
    }
}

- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBack) name:@"clickBtnBack" object:nil];
    self.navigationController.navigationBar.translucent = NO;
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [leftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backToLastView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(clicked)];
    
    [super viewDidLoad];
    self.singleton = [YSSingleton getData];
    self.isADD = NO;
    self.array = [NSMutableArray arrayWithCapacity:100];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375*BIZ, 41*BIZ)];
    [self.view addSubview:backView];
    QMUIButton *button = [QMUIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10*BIZ, 5, 355*BIZ, 30*BIZ);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    button.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:246.0/255.0 blue:245.0/255 alpha:1.0];
    [button setTitle:@"找人" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setImage:[UIImage imageNamed:@"放大镜"] forState:UIControlStateNormal];
    button.imagePosition = QMUIButtonImagePositionLeft;
    button.spacingBetweenImageAndTitle = 4;
    [button addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:button];
    
    if ([self.isFirst isEqualToString:@"YES"]) {
        self.peopleArray = [NSMutableArray arrayWithCapacity:100];
        self.organizationArray = [NSMutableArray arrayWithCapacity:100];
        [self networkingData];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [[YSDingDingHeader shareHelper].titleList addObject:self.title];
    [self.view addSubview:self.mTableView];
    
    self.navigationController.delegate = self;
}

#pragma UINavigationControllerDelegate  设置导航栏左，右侧文字颜色
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    viewController.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
//    viewController.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
//}

- (void)setBack {
    self.isBack = YES;
}

//关闭按钮事件监听
- (void)clicked {
    [[YSDingDingHeader shareHelper].titleList removeAllObjects];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)backToLastView {
    self.isBack = YES;
    [[YSDingDingHeader shareHelper].titleList removeObjectAtIndex:[YSDingDingHeader shareHelper].titleList.count-1];
    if ([YSDingDingHeader shareHelper].titleList.count == 1) {
        [[YSDingDingHeader shareHelper].titleList removeAllObjects];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//搜索事件的监听
- (void)search {
    YSSearchViewController *search = [[YSSearchViewController alloc]init];
    search.searchNumber = 3;
    search.titleStr = @"单选";
    search.indexPath = self.indexPath;
    [self.navigationController pushViewController:search animated:YES];
    
}

//获得组织树顶级数据
- (void)networkingData {
    
    NSDictionary *dic = @{};
    [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getOrganizationTree] isNeedCache:NO parameters:dic successBlock:^(id response) {
        DLog(@"=======%@",response);
        self.dataArr = [YSDataManager getInternallData:response];
        for (int i = 0 ; i < self.dataArr.count ; i++) {
            YSInternalModel *model = self.dataArr[i];
            if ([model.type isEqual:@"3"]) {
                [self.peopleArray addObject:model];
            }else if ([model.type isEqual:@"2"] || [model.type isEqual:@"1"]){
                [self.organizationArray addObject:model];
            }
        }
        [self.mTableView reloadData];
    } failureBlock:^(NSError *error) {
        DLog(@"-------%@",error);
    } progress:nil];
}

//懒加载TableView
- (UITableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 41*kHeightScale, kSCREEN_WIDTH, kSCREEN_HEIGHT-kBottomHeight-kTopHeight-41*kHeightScale) style:UITableViewStyleGrouped];
        _mTableView.delegate = self;
        _mTableView.sectionHeaderHeight = 0.01;
        _mTableView.dataSource = self;
        _mTableView.estimatedSectionHeaderHeight = 0;
        _mTableView.estimatedSectionFooterHeight = 0;
    }
    return _mTableView;
}
//懒加载ScrollView
- (UIScrollView *)mScrollView{
    if (!_mScrollView) {
        _mScrollView = [[MyScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60*kHeightScale)];
        _mScrollView.backgroundColor = [UIColor whiteColor];
        _mScrollView.delegate = self;
        _mScrollView.showsHorizontalScrollIndicator = NO;
        _mScrollView.showsVerticalScrollIndicator = NO;
        __weak typeof(self) weakSelf = self;
        [_mScrollView setBtnClick:^(NSString * title, NSInteger tag) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"clickBtnBack" object:nil];
            if (tag==1) {
                if ([weakSelf.sourceStr isEqual:@"ITSM"]) {
                    [weakSelf.navigationController
                     popToViewController:weakSelf.rt_navigationController.rt_viewControllers[1] animated:YES];
                }else if([weakSelf.sourceStr isEqual:@"日程"]){
                   [weakSelf.navigationController
                 popToViewController:weakSelf.rt_navigationController.rt_viewControllers[2] animated:YES];
                } else if ([weakSelf.sourceStr isEqual:@"流程"]) {
                    for (UIViewController *viewController in weakSelf.rt_navigationController.rt_viewControllers) {
                        if ([viewController isKindOfClass:[YSFlowHandleViewController class]]) {
                            [weakSelf.rt_navigationController popToViewController:viewController animated:YES complete:nil];
                        }
                    }
                } else if ([weakSelf.sourceStr isEqual:@"出差申请"]) {
                    for (UIViewController *viewController in weakSelf.rt_navigationController.rt_viewControllers) {
                        if ([viewController isKindOfClass:[YSEMSApplyTripViewController class]]) {
                            [weakSelf.rt_navigationController popToViewController:viewController animated:YES complete:nil];
                        }
                    }
                } else if ([weakSelf.sourceStr isEqual:@"表单发起"]) {
                    for (UIViewController *viewController in weakSelf.rt_navigationController.rt_viewControllers) {
                        if ([viewController isKindOfClass:[YSCommonFlowLaunchListViewController class]]) {
                            [weakSelf.rt_navigationController popToViewController:viewController animated:YES complete:nil];
                        }
                    }
                }
                [[YSDingDingHeader shareHelper].titleList removeAllObjects];
            }else{

                [[YSDingDingHeader shareHelper].titleList removeObjectsInRange:NSMakeRange(tag, [YSDingDingHeader shareHelper].titleList.count-tag)];
                [weakSelf.rt_navigationController.rt_viewControllers
                 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx,
                                              BOOL *stop) {
                     if ([obj isKindOfClass:YSChoosePeopleVC.class]) {
                         for (int i=0; i<[YSDingDingHeader shareHelper].titleList.count; i++) {
                             if ([title isEqualToString:[[YSDingDingHeader shareHelper].titleList objectAtIndex:i]]) {
                                 
                                 if ([weakSelf.sourceStr isEqual:@"ITSM"]) {
                                     [weakSelf.rt_navigationController popToViewController:weakSelf.rt_navigationController.rt_viewControllers[i+1] animated:YES];
                                 }else if([weakSelf.sourceStr isEqual:@"日程"]){
                                     [weakSelf.rt_navigationController popToViewController:weakSelf.rt_navigationController.rt_viewControllers[i+2] animated:YES];
                                 } else if ([weakSelf.sourceStr isEqual:@"流程"]) {
                                     for (UIViewController *viewController in weakSelf.rt_navigationController.rt_viewControllers) {
                                         if ([viewController isKindOfClass:[YSFlowHandleViewController class]]) {
                                             [weakSelf.rt_navigationController popToViewController:viewController animated:YES complete:nil];
                                         }
                                     }
                                 } else if ([weakSelf.sourceStr isEqual:@"表单发起"]) {
                                     [weakSelf.rt_navigationController popToViewController:weakSelf.rt_navigationController.rt_viewControllers[i+3] animated:YES];
//                                     for (UIViewController *viewController in weakSelf.rt_navigationController.rt_viewControllers) {
////                                         if ([viewController isKindOfClass:[YSCommonFlowLaunchListViewController class]]) {
//                                             [weakSelf.rt_navigationController popToViewController:weakSelf.rt_navigationController.rt_viewControllers[i] animated:YES complete:nil];
////                                         }
//                                     }
                                 }
                             }
                         }
                     }
                 }];

            weakSelf.mScrollView.titleArr = [YSDingDingHeader shareHelper].titleList;
            }
        }];
    }
    return _mScrollView;
}

#pragma mark delegate dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10*kHeightScale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }else if (section == 1){
        return self.peopleArray.count;
    }else{
        return self.organizationArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 60*BIZ;
    }
    return 50*BIZ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSChoosePeopleTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell  = [[YSChoosePeopleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section==0) {
        [cell.chooseImage removeFromSuperview];
        [cell.titleLabel removeFromSuperview];
        [cell.contentView addSubview:self.mScrollView];
        self.mScrollView.titleArr = [YSDingDingHeader shareHelper].titleList;
    }
    else if (indexPath.section == 1) {
        YSInternalModel *model = self.peopleArray[indexPath.row];
        [cell.chooseImage removeFromSuperview];
        [cell.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.contentView.mas_left).offset(15);
            make.top.mas_equalTo(cell.contentView.mas_top).offset(10);
            make.size.mas_equalTo(CGSizeMake(150*kWidthScale, 28*kWidthScale));
        }];
        if (model.text) {
            cell.titleLabel.text = model.text;
        }else{
            cell.titleLabel.text = model.name;
        }
        if (model.position) {
            cell.jobsName.text = model.position;
        }else{
            cell.jobsName.text = model.jobStation;
        }
        
        cell.titleLabel.textColor = kUIColor(51, 51, 51, 1);
        cell.titleLabel.font = [UIFont systemFontOfSize:15];
    }else{
        [cell.chooseImage removeFromSuperview];
        [cell.titleLabel removeFromSuperview];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        YSInternalModel *model = self.organizationArray[indexPath.row];
        cell.textLabel.text = model.text;
        cell.textLabel.textColor =kUIColor(51, 51, 51, 1);
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        YSInternalModel *model = self.peopleArray[indexPath.row];
        NSString *url = [NSString stringWithFormat:@"%@%@/%@",YSDomain,getInnerPersons,model.id];
        [YSNetManager ys_request_GETWithUrlString:url isNeedCache:NO parameters:nil successBlock:^(id response) {
            DLog(@"------%@",response);
            NSArray *arr1 = [YSDataManager getInternPeopleMemberData:response];
            YSInternalPeopleModel *internalModel = arr1[0];
            internalModel.indexPath = _indexPath;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"returnPeopleInfo" object:internalModel];
            DLog(@"-------%@",self.rt_navigationController.rt_viewControllers);
            for (UIViewController *controller in self.rt_navigationController.rt_viewControllers) {
                if ([controller isKindOfClass:[YSRepairViewController class]] || [controller isKindOfClass:[YSCalendarGrantViewController class]] || [controller isKindOfClass:[YSFlowHandleViewController class]] || [controller isKindOfClass:[YSEMSApplyTripViewController class]] || [controller isKindOfClass:[YSCommonFlowLaunchListViewController class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                }
                
            }
        } failureBlock:^(NSError *error) {
            
        } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
            
        }];
        
    }else{
        YSInternalModel *model = self.organizationArray[indexPath.row];
        if (model.children) {
            [self getServeManager:model.id andCompanyId:model.companyId andType:model.type andName:model.text];
        }else{
            [self getPeopleList:model.id andName:model.text];
        }
    }
    
}

- (void)getServeManager:(NSString *)ids
           andCompanyId:(NSString *)companyId
                andType:(NSString *)type
                andName:(NSString *)name{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:100];
    [dic setObject:type  forKey:@"type"];
    [dic setObject:ids  forKey:@"id"];
    [dic setObject:companyId  forKey:@"companyId"];
    [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getOrganizationTree] isNeedCache:NO parameters:dic successBlock:^(id response) {
        
        DLog(@"-------%@",response);
        YSChoosePeopleVC *first = [[YSChoosePeopleVC alloc]init];
        first.indexPath = _indexPath;
        first.title = name;
        first.sourceStr = self.sourceStr;
        first.dataArr = [YSDataManager getInternallData:response];
        first.peopleArray = [NSMutableArray arrayWithCapacity:100];
        first.dataArr = [YSDataManager getInternallData:response];
        first.organizationArray = [NSMutableArray arrayWithCapacity:100];
        for (int i = 0 ; i < first.dataArr.count ; i++) {
            YSInternalModel *model = first.dataArr[i];
            if ([model.type isEqual:@"3"]) { //人员信息
                [first.peopleArray addObject:model];
            }else if ([model.type isEqual:@"2"] || [model.type isEqual:@"1"]){  //组织信息
                [first.organizationArray addObject:model];
            }
        }
        [self.navigationController pushViewController:first animated:YES];
    } failureBlock:^(NSError *error) {
        DLog(@"----------%@",error);
        
    } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

//获得人员列表
- (void)getPeopleList:(NSString *)ids andName:(NSString *)name {
    NSMutableDictionary  *diction = [NSMutableDictionary dictionaryWithCapacity:100];
    [diction setObject:[NSString stringWithFormat:@"%@",ids] forKey:@"deptId"];
    [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@/1000/1",YSDomain,getDepartmentMembers] isNeedCache:NO parameters:diction successBlock:^(id response) {
        DLog(@"======%@",response);
        if (![response[@"data"][@"total"] isEqual:@0]) {
            
            YSChoosePeopleVC *first = [[ YSChoosePeopleVC alloc]init];
            first.indexPath = _indexPath;
            first.title = name;
            first.sourceStr = self.sourceStr;
            first.dataArr = [YSDataManager getInternallistData:response];
            first.peopleArray = [NSMutableArray arrayWithCapacity:100];
            first.organizationArray = [NSMutableArray arrayWithCapacity:100];
            for (int i = 0 ; i < first.dataArr.count ; i++) {
                YSInternalModel *model = first.dataArr[i];
                [first.peopleArray addObject:model];
            }
            [self.navigationController pushViewController:first animated:YES];
        }else{
            
            [QMUITips showInfo:@"暂无人员信息" inView:self.view hideAfterDelay:1];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"=======%@",error);
    } progress:nil];
}

-(void)dealloc{
    if (!self.isBack) {
        if ([YSDingDingHeader shareHelper].titleList.count > 1) {
            [[YSDingDingHeader shareHelper].titleList removeObjectAtIndex:[YSDingDingHeader shareHelper].titleList.count-1];
        }
        if ([YSDingDingHeader shareHelper].titleList.count == 1) {
            [[YSDingDingHeader shareHelper].titleList removeAllObjects];
        }
    }
}

@end
