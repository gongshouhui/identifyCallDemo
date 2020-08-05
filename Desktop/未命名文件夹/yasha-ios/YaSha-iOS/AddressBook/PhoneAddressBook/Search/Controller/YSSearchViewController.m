//
//  YSSearchViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/1/29.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

/*
 self.searchNumber == 1        内部通讯录搜索
 self.searchNumber == 2        多选功能搜索
 self.searchNumber == 3        单选功能搜索
 self.searchNumber == 4        手机通讯录搜索
 
 
 */

#import "YSSearchViewController.h"
#import "YSSearch.h"
#import "YSPhoneAddressBookModel.h"
#import "YSPhoneAddressBookTableViewCell.h"
#import "YSInformationViewController.h"
#import "YSInterTableViewCell.h"
#import "YSAddressBookInformationViewController.h"
#import "YSInternalPeopleModel.h"
#import "YSChoosePeopleTableViewCell.h"
#import "YSExternalViewController.h"
#import "YSRepairViewController.h"
#import "YSCalendarGrantViewController.h"
#import "YSMessageViewController.h"
#import "YSFlowHandleViewController.h"
#import "YSEMSApplyTripViewController.h"
#import "YSCommonFlowLaunchListViewController.h"

@interface YSSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataArr;
    UITableView *table;
    NSString *keyword;
    NSMutableArray *phoneData;
    NSInteger pageNumber ;
    NSInteger pageSize ;
}
@property(nonatomic,strong)YSSingleton *singleton;
@property(nonatomic,assign)BOOL isADD;
@property (nonatomic, strong) UISearchBar *customSearchBar;

@end

@implementation YSSearchViewController

- (void)viewWillAppear:(BOOL)animated{
    self.chooseView.numLabel.text = [NSString stringWithFormat:@"共选择%lu人",(unsigned long)self.singleton.selectDataArr.count];
}
- (void)initSubviews {
    [super initSubviews];
    self.singleton = [YSSingleton getData];
    phoneData = [NSMutableArray array];
    dataArr = [NSMutableArray array];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(40, 20, 300, 40)];
    view.backgroundColor = [UIColor  whiteColor];
    CGRect mainViewBounds = self.navigationController.view.bounds;
    _customSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(CGRectGetWidth(mainViewBounds)/2-((CGRectGetWidth(mainViewBounds)-100)/2), CGRectGetMinY(mainViewBounds)+22, CGRectGetWidth(mainViewBounds)-60, 20)];
    _customSearchBar.delegate = self;
    if (self.searchNumber == 4) {
        _customSearchBar.placeholder = @"姓名/手机";
    }else{
        _customSearchBar.placeholder = @"公司/部门/姓名";
    }
    [_customSearchBar becomeFirstResponder];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_customSearchBar];
    [self table];
    if ( self.searchNumber == 2 ) {
        self.chooseView = [[YSChoosePeopleView alloc]init];
        self.chooseView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.chooseView];
        [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_bottom).offset(-(40*kHeightScale+ kBottomHeight));
            make.size.mas_equalTo(CGSizeMake(375*kWidthScale, 40*kWidthScale));
        }];
        [self.chooseView.chooseButton addTarget:self action:@selector(Choose:) forControlEvents:UIControlEventTouchUpInside];
        [self.chooseView.allChooseButton addTarget:self action:@selector(allChoose:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void) allChoose:(UIButton *)btn {
    for (YSInternalModel *model in dataArr) {
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
        for (int row=0; row<dataArr.count; row++) {
            YSInternalModel *model = dataArr[row];
            [self.singleton.selectDataArr addObject:model];
        }
    }
    self.chooseView.numLabel.text = [NSString stringWithFormat:@"共选择%lu人",(unsigned long)self.singleton.selectDataArr.count];
    [table reloadData];
}
- (void)Choose:(UIButton *)sender{
    switch (self.index) {
        case 0:
        {
            NSDictionary *dic = @{};
            NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:100];
            for (YSInternalModel *model in self.singleton.selectDataArr) {
                [array addObject:model.id];
            }
            [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain,addInnerPersonToCommonPerson,[array componentsJoinedByString:@","]] isNeedCache:NO parameters:dic successBlock:^(id response) {
                [QMUITips hideAllTipsInView:self.view];
                if ([response[@"data"] integerValue] == 1) {
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
        case 1:
        {
            for (UIViewController *viewControlle in self.rt_navigationController.rt_viewControllers) {
                if ([viewControlle isKindOfClass:[YSExternalViewController class]]) {
                    [self.rt_navigationController popToViewController:viewControlle animated:YES complete:nil];
                }
            }
            break;
        }
        case 2:
        {
            for (UIViewController *viewController in self.rt_navigationController.rt_viewControllers) {
                if ([viewController isKindOfClass:[YSMessageViewController class]]) {
                    [self.rt_navigationController popToViewController:viewController animated:YES complete:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"createGroupWithPeople" object:nil];
                }
            }
            break;
        }
        case 3:
        {
            //donoting
            break;
        }
        case 4:
        {
            for (UIViewController *viewController in self.rt_navigationController.rt_viewControllers) {
                if ([viewController isKindOfClass:[YSFlowHandleViewController class]]) {
                    [self.rt_navigationController popToViewController:viewController animated:YES complete:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"flowSelectPeople" object:nil];
                }
            }
            break;
        }
    }

}

//搜索按钮点击的回调
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
    if (self.searchNumber != 4){
        pageNumber = 1;
        keyword = searchBar.text;
        [self doNetworking];
    }else{
        for (int i = 0; i < self.data.count; i++) {
            YSPhoneAddressBookModel *model = self.data[i];
            if ([model.name containsString:searchBar.text] || [model.tel containsString:searchBar.text]) {
                [phoneData addObject:model];
            }
        }
        dataArr = phoneData;
        [table reloadData];
    }
}

//取消按钮点击的回调
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
}

- (void)table {
    
    if (self.searchNumber == 2) {
        table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 375*BIZ,kSCREEN_HEIGHT-40*kHeightScale-41*kHeightScale) style:UITableViewStyleGrouped];
        
    }else{
        
        table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 375*BIZ,kSCREEN_HEIGHT) style:UITableViewStyleGrouped];
    }
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 48*BIZ;
    [self.view addSubview:table];
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return   dataArr.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50*BIZ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.searchNumber) {
        case 1:
        {
            YSInternalPeopleModel *model = dataArr[indexPath.row];
            static NSString *inde = @"cell";
            YSInterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inde];
            if (cell == nil) {
                cell = [[YSInterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inde];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (model.headImg.length > 0) {
                [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YSImageDomain, [YSUtility getAvatarUrlString:model.headImg]]] placeholderImage:[UIImage imageNamed:@"头像"]];
            }else{
                cell.titleImage.image = [UIImage imageNamed:@"头像"];
            }
            cell.nameLabel.text = model.name;
            cell.jobsName.text = model.jobStation;
            cell.nameLabel.textColor = kUIColor(51, 51, 51, 1);
            return cell;
        }
            break;
        case 4:
        {
            static NSString *inde = @"cell";
            YSPhoneAddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inde];
            if (cell == nil) {
                cell = [[YSPhoneAddressBookTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inde];
            }
            cell.selectionStyle =  UITableViewCellSelectionStyleNone;
            YSPhoneAddressBookModel *model = [[YSPhoneAddressBookModel alloc]init];
            model = dataArr [indexPath.row];
            cell.headLabel.text = [model.name substringToIndex:1];
            cell.namelabel.text = model.name;
            cell.telLabel.text = model.tel;
            return cell;
            
        }
            break;
        case 3: case 2:
        {
            
            YSChoosePeopleTableViewCell *cell  = [[YSChoosePeopleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            YSInternalPeopleModel *model = dataArr[indexPath.row];
            if ([self.titleStr isEqualToString:@"单选"]) {
                [cell.chooseImage removeFromSuperview];
                [cell.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell.contentView.mas_left).offset(15);
                    make.top.mas_equalTo(cell.contentView.mas_top).offset(10);
                    make.size.mas_equalTo(CGSizeMake(150*kWidthScale, 28*kWidthScale));
                }];
                
            }else{
                for (int i = 0; i< self.singleton.selectDataArr.count; i++) {
                    YSInternalModel *chooseModel = self.singleton.selectDataArr[i];
                    if ([model.id isEqual:chooseModel.id]) {
                        cell.chooseImage.image = [UIImage imageNamed:@"选择1"];
                    }
                }
            }
            cell.titleLabel.text = model.name;
            cell.jobsName.text = model.jobStation;
            return cell;
        }
            break;
        default:
            break;
    }
    return 0;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"点击事件");
    if (self.searchNumber == 1) {
        YSInternalPeopleModel *model = dataArr[indexPath.row];
        YSInformationViewController *information = [[YSInformationViewController alloc]init];
        information.id = model.id;
        information.number = 3;//显示内部联系人详情
        information.str = @"内部";
        [self.navigationController pushViewController:information animated:YES];
    }else if (self.searchNumber == 4){
        YSPhoneAddressBookTableViewCell  *cell = (YSPhoneAddressBookTableViewCell *) [table cellForRowAtIndexPath:indexPath];
        YSAddressBookInformationViewController *information = [[YSAddressBookInformationViewController alloc]init];
        information.telStr =cell.telLabel.text;
        information.nameStr = cell.namelabel.text;
        [self.navigationController pushViewController:information animated:YES];
    }else{
        
        YSInternalPeopleModel *model = dataArr[indexPath.row];
        if ([self.titleStr isEqual:@"单选"]) {
            NSString *url = [NSString stringWithFormat:@"%@%@/%@",YSDomain,getInnerPersons,model.id];
            [YSNetManager ys_request_GETWithUrlString:url isNeedCache:NO parameters:nil successBlock:^(id response) {
                DLog(@"------%@",response);
                NSArray *arr1 = [YSDataManager getInternPeopleMemberData:response];
                YSInternalPeopleModel *internalModel = arr1[0];
                internalModel.indexPath = self.indexPath;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"returnPeopleInfo" object:internalModel];
                
                for (UIViewController *controller in self.rt_navigationController.rt_viewControllers) {
                    if ([controller isKindOfClass:[YSRepairViewController class]] || [controller isKindOfClass:[YSCalendarGrantViewController class]] || [controller isKindOfClass:[YSFlowHandleViewController class]] || [controller isKindOfClass:[YSEMSApplyTripViewController class]]||[controller isKindOfClass:[YSCommonFlowLaunchListViewController class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
                    }
                }
            } failureBlock:^(NSError *error) {
                
            } progress:nil];
            
        }else{
            for (int i = 0; i< self.singleton.selectDataArr.count; i++) {
                if ([model isEqual:self.singleton.selectDataArr[i]]) {
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
            [table reloadData];
        }
    }
}
-(void)doNetworking{
    
    [dataArr removeAllObjects];
    NSString *urlAddress ;
    
    NSMutableDictionary  *diction = [NSMutableDictionary dictionaryWithCapacity:100];
    [diction setObject:keyword forKey:@"keyword"];
    urlAddress = getDepartmentMembers;
    [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@/2000/%@",YSDomain,urlAddress, [NSString stringWithFormat:@"%ld",(long)pageNumber]] isNeedCache:NO parameters:diction successBlock:^(id response) {
        NSArray *arr = [YSDataManager getInternallMemberData:response];
        if (arr.count>0) {
            [dataArr addObjectsFromArray:arr];
            [table reloadData];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有搜到相关人员"preferredStyle: UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
            }]];
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"=======%@",error);
    } progress:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_customSearchBar resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
