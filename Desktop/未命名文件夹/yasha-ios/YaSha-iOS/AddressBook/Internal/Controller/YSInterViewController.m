//
//  YSInterViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/1/29.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSInterViewController.h"
#import "YSSearchViewController.h"
#import "MyScrollView.h"
#import "YSDingDingHeader.h"
#import "YSInternalModel.h"
#import "YSInformationViewController.h"
#import "YSInterTableViewCell.h"

@interface YSInterViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property(strong,nonatomic)UITableView * mTableView;
@property(strong,nonatomic)MyScrollView * mScrollView;
@property(nonatomic,assign)BOOL isBack;

@end

@implementation YSInterViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isBack = false;
    self.navigationController.delegate = self;
    self.navigationController.navigationBar.translucent = YES;
    __weak typeof(self) weakSelf = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
}

#pragma mark - <QMUINavigationControllerDelegate>

- (BOOL)shouldSetStatusBarStyleLight {
    return StatusbarStyleLightInitially;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return StatusbarStyleLightInitially ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
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

- (void)initSubviews {
    [super initSubviews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBack) name:@"back" object:nil];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [leftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"关闭" position:QMUINavigationButtonPositionRight target:self action:@selector(clicked)];
    
   
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, kTopHeight, 375*kWidthScale, 41*kHeightScale)];
    [self.view addSubview:backView];
    QMUIButton *button = [QMUIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10*kWidthScale, 5, 355*kWidthScale, 30*kHeightScale);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    button.backgroundColor = kUIColor(247, 246, 245, 1.0);
    [button setTitle:@"找人" forState:UIControlStateNormal];
    [button setTitleColor:kUIColor(128, 128, 128, 1.0) forState:UIControlStateNormal];
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setBack {
    self.isBack = true;
}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    viewController.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
//    viewController.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
//}
//关闭按钮事件
- (void)clicked {
    [[YSDingDingHeader shareHelper].titleList removeAllObjects];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//搜索事件
- (void)search{
    YSSearchViewController * search = [[YSSearchViewController alloc]init];
    search.searchNumber = 1;
    [self.navigationController pushViewController:search animated:YES];
    
}
//返回上一级
- (void)back{
    self.isBack = true;
    if ([YSDingDingHeader shareHelper].titleList.count > 0) {
        [[YSDingDingHeader shareHelper].titleList removeObjectAtIndex:[YSDingDingHeader shareHelper].titleList.count-1];
    }
    if ([YSDingDingHeader shareHelper].titleList.count == 1) {
        [[YSDingDingHeader shareHelper].titleList removeAllObjects];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kTopHeight+41*kHeightScale, kSCREEN_WIDTH, kSCREEN_HEIGHT-kTopHeight-41*kHeightScale) style:UITableViewStyleGrouped];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        _mTableView.estimatedRowHeight = 0;
        _mTableView.estimatedSectionHeaderHeight = 0;
        _mTableView.estimatedSectionFooterHeight = 0;
    }
    return _mTableView;
}

#pragma mark delegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10*kWidthScale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 60*kWidthScale;
    }
    return 48*kWidthScale;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSInterTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell  = [[YSInterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        [cell.titleImage removeFromSuperview];
        [cell.nameLabel removeFromSuperview];
        [cell.contentView addSubview:self.mScrollView];
        self.mScrollView.titleArr = [YSDingDingHeader shareHelper].titleList;
    }else if (indexPath.section == 1) {
        YSInternalModel *model = self.peopleArray[indexPath.row];
        if (model.headImg.length > 0) {
            [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YSImageDomain, [YSUtility getAvatarUrlString:model.headImg]]] placeholderImage:[UIImage imageNamed:@"头像"]];
        }else{
            cell.titleImage.image = [UIImage imageNamed:@"头像"];
        }
        if (model.text) {
            cell.nameLabel.text = model.text;
        }else{
            cell.nameLabel.text = model.name;
        }
        if (model.position) {
            cell.jobsName.text = model.position;
        }else{
            cell.jobsName.text = model.jobStation;
        }
    }else{
        [cell.titleImage removeFromSuperview];
        [cell.nameLabel removeFromSuperview];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        YSInternalModel *model = self.organizationArray[indexPath.row];
        cell.textLabel.text = model.text;
        cell.textLabel.textColor = kUIColor(51, 51, 51, 1);
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        YSInternalModel *model = self.peopleArray[indexPath.row];
        YSInformationViewController *information = [[YSInformationViewController alloc]init];
        information.number = 3;//显示内部联系人详情
        information.str = @"内部";
        information.id= model.id;
        [self.navigationController pushViewController:information animated:YES];
    }else{
        YSInternalModel *model = self.organizationArray[indexPath.row];
        if (model.children) {
            [self getServeManager:model.id andCompanyId:model.companyId andType:model.type andName:model.text];
        }else{
            [self getPeopleList:model.id andName:model.text];
        }
    }
}
- (UIScrollView *)mScrollView {
    if (!_mScrollView) {
        _mScrollView = [[MyScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60*kHeightScale)];
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
                     if ([obj isKindOfClass:YSInterViewController.class]) {
                         
                         for (int i=0; i<[YSDingDingHeader shareHelper].titleList.count; i++) {
                             DLog(@"--%@,%d",[[YSDingDingHeader shareHelper].titleList objectAtIndex:i],i);
                             if ([title isEqual:[[YSDingDingHeader shareHelper].titleList objectAtIndex:i]]) {
                                 [weakSelf.rt_navigationController popToViewController:weakSelf.rt_navigationController.rt_viewControllers[i] animated:YES];
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
- (void)getServeManager:(NSString *)ids
           andCompanyId:(NSString *)companyId
                andType:(NSString *)type
                andName:(NSString *)name{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:100];
    [dic setObject:type  forKey:@"type"];
    [dic setObject:ids  forKey:@"id"];
    [dic setObject:companyId  forKey:@"companyId"];
    DLog(@"=======%@",dic);
    [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getOrganizationTree] isNeedCache:NO parameters:dic successBlock:^(id response) {
        DLog(@"-------%@",response);
        YSInterViewController *first = [[YSInterViewController alloc]init];
        first.title = name;
        first.dataArr = [YSDataManager getInternallData:response];
        first.peopleArray = [NSMutableArray arrayWithCapacity:100];
        first.organizationArray = [NSMutableArray arrayWithCapacity:100];
        for (int i = 0 ; i < first.dataArr.count ; i++) {
            YSInternalModel *model = first.dataArr[i];
            if ([model.type isEqual:@"3"]) {
                [first.peopleArray addObject:model];
            }else if ([model.type isEqual:@"2"] || [model.type isEqual:@"1"]){
                [first.organizationArray addObject:model];
            }
        }
        [self.navigationController pushViewController:first animated:YES];
    } failureBlock:^(NSError *error) {
        DLog(@"========%@",error);
    } progress:nil];
    
}
//获得人员列表
- (void)getPeopleList:(NSString *)ids andName:(NSString *)name {
    NSMutableDictionary  *diction = [NSMutableDictionary dictionaryWithCapacity:100];
    [diction setObject:[NSString stringWithFormat:@"%@",ids] forKey:@"deptId"];
    [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@/1000/1",YSDomain,getDepartmentMembers] isNeedCache:NO parameters:diction successBlock:^(id response) {
        DLog(@"======%@",response);
        if (![response[@"data"][@"total"] isEqual:@0]) {
            YSInterViewController *first = [[YSInterViewController alloc]init];
            first.title = name;
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
