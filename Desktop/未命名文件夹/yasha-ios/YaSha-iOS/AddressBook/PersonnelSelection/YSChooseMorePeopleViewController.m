//
//  YSChooseMorePeopleViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/8/7.
//
//

#import "YSChooseMorePeopleViewController.h"
#import "YSSingleton.h"
#import "MyScrollView.h"
#import "YSDingDingHeader.h"
#import "YSInternalModel.h"
#import "YSChoosePeopleTableViewCell.h"
#import "YSExternalViewController.h"
#import "YSSearchViewController.h"
#import "YSRepairViewController.h"
#import "YSCalendarGrantViewController.h"
#import "YSMessageViewController.h"
#import "YSFlowHandleViewController.h"
#import "YSCommonFlowLaunchListViewController.h"

@interface YSChooseMorePeopleViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property(strong,nonatomic)UITableView * mTableView;
@property(strong,nonatomic)MyScrollView * mScrollView;
@property(strong,nonatomic)UIImageView  *titleImage;
@property(strong,nonatomic)NSMutableArray *array;
@property(nonatomic,strong) YSSingleton *singleton;
@property(nonatomic,assign)BOOL isADD;
@property(nonatomic,assign)BOOL isBack;

@end

@implementation YSChooseMorePeopleViewController

- (void)viewWillAppear:(BOOL)animated{
    
    self.chooseView.numLabel.text = [NSString stringWithFormat:@"共选择%lu人",(unsigned long)self.singleton.selectDataArr.count];
    __weak typeof(self) weakSelf = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer{
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBack) name:@"back" object:nil];
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
    
    if ([self.str isEqual:@"首页"]) {
        self.peopleArray = [NSMutableArray arrayWithCapacity:100];
        self.organizationArray = [NSMutableArray arrayWithCapacity:100];
        [self networkingData];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [[YSDingDingHeader shareHelper].titleList addObject:self.title];
    [self.view addSubview:self.mTableView];
    
    self.chooseView = [[YSChoosePeopleView alloc]init];
    self.chooseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.chooseView];
    [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_bottom).offset(-(40*kHeightScale+ kBottomHeight));
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, 40*kHeightScale));
    }];
    [self.chooseView.chooseButton addTarget:self action:@selector(Choose:) forControlEvents:UIControlEventTouchUpInside];
    [self.chooseView.allChooseButton addTarget:self action:@selector(allChoose:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationController.delegate = self;
    
}
//#pragma UINavigationControllerDelegate  设置导航栏左，右侧文字颜色
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    viewController.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
//    viewController.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
//}

//通知是否是滑动返回
- (void)setBack {
    
    self.isBack = YES;
}

//导航栏右侧关闭按钮事件处理
- (void)clicked {
    [[YSDingDingHeader shareHelper].titleList removeAllObjects];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//导航栏返回按钮事件处理
- (void)backToLastView{
    self.isBack = YES;
    [[YSDingDingHeader shareHelper].titleList removeObjectAtIndex:[YSDingDingHeader shareHelper].titleList.count-1];
    if ([YSDingDingHeader shareHelper].titleList.count == 1) {
        [[YSDingDingHeader shareHelper].titleList removeAllObjects];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//全选按钮事件处理
- (void)allChoose:(UIButton *)btn{
    for (YSInternalModel *model in self.peopleArray) {
        
        if ([self.singleton.selectDataArr containsObject:model]) {
            
            [self.singleton.selectDataArr removeObject:model];
        }
    }
    if (btn.selected) {
        [btn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
        btn.selected = NO;
        [self.singleton.selectDataArr removeAllObjects];
    }else{
        [btn setImage:[UIImage imageNamed:@"选择1"] forState:UIControlStateNormal];
        btn.selected = YES;
        for (int row=0; row<self.peopleArray.count; row++) {
            YSInternalModel *model = self.peopleArray[row];
            [self.singleton.selectDataArr addObject:model];
        }
    }
    self.chooseView.numLabel.text = [NSString stringWithFormat:@"共选择%lu人",(unsigned long)self.singleton.selectDataArr.count];
    [_mTableView reloadData];
}

//确定按钮的事件处理
- (void)Choose:(UIButton *)button {
    switch (_type) {
        case AddressBook:
        {
            NSDictionary *dic = @{};
            NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:100];
            for (YSInternalModel *model in self.singleton.selectDataArr) {
                [array addObject:model.id];
            }
            [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain,addInnerPersonToCommonPerson,[array componentsJoinedByString:@","]] isNeedCache:NO parameters:dic successBlock:^(id response) {
                if ([response[@"data"] integerValue] == 0) {
                    [QMUITips showInfo:response[@"mag"] inView:self.view hideAfterDelay:1];
                }else{
                    [self.singleton.selectDataArr removeAllObjects];
                    for (UIViewController *VC in self.rt_navigationController.rt_viewControllers) {
                        if ([VC isKindOfClass:[YSExternalViewController class]]) {
                            [self.navigationController popToViewController:VC animated:YES];
                        }
                    }
                }
            } failureBlock:^(NSError *error) {
                DLog(@"=======%@",error);
            } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                
            }];
            break;
        }
        case MeetingRoom:
        {
            for (UIViewController *viewControlle in self.rt_navigationController.rt_viewControllers) {
                if ([viewControlle isKindOfClass:[YSExternalViewController class]]) {
                    [self.rt_navigationController popToViewController:viewControlle animated:YES complete:nil];
                }
            }
            break;
        }
        case CreateGroup:
        {
            for (UIViewController *viewController in self.rt_navigationController.rt_viewControllers) {
                if ([viewController isKindOfClass:[YSMessageViewController class]]) {
                    [self.rt_navigationController popToViewController:viewController animated:YES complete:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"createGroupWithPeople" object:nil];
                }
            }
            break;
        }
        case AddGroup:
        {
            //do noting
            break;
        }
        case FlowSelectPeople:
        {
            for (UIViewController *viewController in self.rt_navigationController.rt_viewControllers) {
                if ([viewController isKindOfClass:[YSFlowHandleViewController class]]) {
                    [self.rt_navigationController popToViewController:viewController animated:YES complete:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"flowSelectPeople" object:nil];
                }
            }
            break;
        }
        case LaunchFlowSelectPeople:
        {
            for (UIViewController *viewController in self.rt_navigationController.rt_viewControllers) {
                if ([viewController isKindOfClass:[YSCommonFlowLaunchListViewController class]]) {
                    [self.rt_navigationController popToViewController:viewController animated:YES complete:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"launchFlowSelectPeople" object:nil];
                }
            }
        }
    }
}

//搜索按钮事件处理
- (void)search{
    YSSearchViewController *search = [[YSSearchViewController alloc]init];
    search.searchNumber = 2;
    search.titleStr = self.str;
    search.index = _type;
    [self.navigationController pushViewController:search animated:YES];
}
//获得组织树顶级数据
- (void)networkingData{
    
    NSDictionary *dic = @{};
    [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getOrganizationTree] isNeedCache:NO parameters:dic successBlock:^(id response) {
        DLog(@"=======%@",response);
        self.dataArr = [YSDataManager getInternallData:response];
        
        for (int i = 0 ; i < self.dataArr.count ; i++) {
            YSInternalModel *model = self.dataArr[i];
            if ([model.type isEqual:@"3"]) { //筛选出人员信息
                [self.peopleArray addObject:model];
            }else if ([model.type isEqual:@"2"] || [model.type isEqual:@"1"]){  //筛选出组织信息
                [self.organizationArray addObject:model];
            }
        }
        [self.mTableView reloadData];
    } failureBlock:^(NSError *error) {
        DLog(@"-------%@",error);
    } progress:nil];
}

//懒加载Tableview
- (UITableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 41*BIZ, kSCREEN_WIDTH, kSCREEN_HEIGHT-kBottomHeight-40*kHeightScale-kTopHeight-41*kHeightScale) style:UITableViewStyleGrouped];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        _mTableView.estimatedSectionHeaderHeight = 0;
        _mTableView.estimatedSectionFooterHeight = 0;
    }
    return _mTableView;
}

//懒加载ScrollView
- (UIScrollView *)mScrollView {
    if (!_mScrollView) {
        _mScrollView = [[MyScrollView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 60*kHeightScale)];
        _mScrollView.backgroundColor = [UIColor whiteColor];
        _mScrollView.delegate = self;
        _mScrollView.showsHorizontalScrollIndicator = NO;
        _mScrollView.showsVerticalScrollIndicator = NO;
        __weak typeof(self) weakSelf = self;
        [_mScrollView setBtnClick:^(NSString * title, NSInteger tag) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"back" object:nil];
            if (tag==1) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                [[YSDingDingHeader shareHelper].titleList removeAllObjects];
            }else{
                [[YSDingDingHeader shareHelper].titleList removeObjectsInRange:NSMakeRange(tag, [YSDingDingHeader shareHelper].titleList.count-tag)];
                [weakSelf.rt_navigationController.rt_viewControllers
                 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx,
                                              BOOL *stop) {
                     if ([obj isKindOfClass:YSChooseMorePeopleViewController.class]) {
                         
                         for (int i=0; i<[YSDingDingHeader shareHelper].titleList.count; i++) {
                             if ([title isEqual:[[YSDingDingHeader shareHelper].titleList objectAtIndex:i]]) {
                                 [weakSelf.rt_navigationController
                                      popToViewController:weakSelf.rt_navigationController.rt_viewControllers[i+1]
                                      animated:YES];
                                 return ;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if (section == 1){
        return self.peopleArray.count;
    }else{
        return self.organizationArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10*kHeightScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 60*kHeightScale;
    }else{
        return 50*kHeightScale;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YSChoosePeopleTableViewCell *cell  = [[YSChoosePeopleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        [cell.chooseImage removeFromSuperview];
        [cell.titleLabel removeFromSuperview];
        [cell.contentView addSubview:self.mScrollView];
        self.mScrollView.titleArr = [YSDingDingHeader shareHelper].titleList;
    }
    else if (indexPath.section == 1) {
        YSInternalModel *model = self.peopleArray[indexPath.row];
        for (int i = 0; i< self.singleton.selectDataArr.count; i++) {
            YSInternalModel *chooseModel = self.singleton.selectDataArr[i];
            if ([model.id  isEqual:chooseModel.id]) {
                cell.chooseImage.image = [UIImage imageNamed:@"选择1"];
            }
        }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        YSInternalModel *model = self.peopleArray[indexPath.row];
        model.indexPath = _indexPath;
        for (int i = 0; i< self.singleton.selectDataArr.count; i++) {
            YSInternalModel *chooseModel = self.singleton.selectDataArr[i];
            if ([model.id  isEqual:chooseModel.id]) {
                [self.singleton.selectDataArr removeObjectAtIndex:i];
                _isADD = YES;
            }
        }
        if (_isADD == NO) {
            [self.singleton.selectDataArr addObject:model];
        }else{
            _isADD = NO;
        }
        self.chooseView.numLabel.text = [NSString stringWithFormat:@"共选择%lu人",(unsigned long)self.singleton.selectDataArr.count];
        [_mTableView reloadData];
    }else{
        YSInternalModel *model = self.organizationArray[indexPath.row];
        model.indexPath = _indexPath;
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
        YSChooseMorePeopleViewController *first = [[YSChooseMorePeopleViewController alloc]init];
        first.title = name;
        first.type = _type;
        first.dataArr = [YSDataManager getInternallData:response];
        first.peopleArray = [NSMutableArray arrayWithCapacity:100];
        first.dataArr = [YSDataManager getInternallData:response];
        first.organizationArray = [NSMutableArray arrayWithCapacity:100];
        for (int i = 0 ; i < first.dataArr.count ; i++) {
            YSInternalModel *model = first.dataArr[i];
            if ([model.type isEqual:@"3"]) { //筛选出人员信息
                [first.peopleArray addObject:model];
            }else if ([model.type isEqual:@"2"] || [model.type isEqual:@"1"]){  //筛选出组织信息
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
- (void)getPeopleList:(NSString *)ids
              andName:(NSString *)name {
    NSMutableDictionary  *diction = [NSMutableDictionary dictionaryWithCapacity:100];
    [diction setObject:[NSString stringWithFormat:@"%@",ids] forKey:@"deptId"];
    [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@/1000/1",YSDomain,getDepartmentMembers] isNeedCache:NO parameters:diction successBlock:^(id response) {
        DLog(@"======%@",response);
        if (![response[@"data"][@"total"] isEqual:@0]) {
            
            YSChooseMorePeopleViewController *first = [[YSChooseMorePeopleViewController alloc]init];
            first.title = name;
            first.type = _type;
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
        DLog(@"----------%@",error);
    } progress:nil];
}

- (void)dealloc {
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
