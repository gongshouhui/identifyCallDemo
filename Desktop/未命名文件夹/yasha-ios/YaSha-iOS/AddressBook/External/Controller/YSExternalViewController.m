//
//  YSExternalViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/1/29.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSExternalViewController.h"
#import "YSSonTableViewCell.h"
#import "YSInformationViewController.h"
#import "YSAddPeopleViewController.h"
#import "YSPhoneAddressBookViewController.h"
#import "YSChoosePeopleViewController.h"
#import "ActionSheetPicker.h"
#import "YSExternalModel.h"
#import "YSDataManager.h"
#import "YSSingleton.h"
#import "YSDingDingHeader.h"
#import "YSChooseMorePeopleViewController.h"

@interface YSExternalViewController ()<UINavigationControllerDelegate>{
    UITableView *table;
    NSArray *arr;
    NSMutableArray  *mutableArray;
    YSExternalModel *model;
    YSSingleton *si;
    UIButton *buttonBackground;
    
}

@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) QMUIPopupMenuView *popupMenuView;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation YSExternalViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)initTableView {
    [super initTableView];
    //获得清除缓存文件的大小
    //    [YSNationalWay deleteFileAtPath];
    si = [YSSingleton getData];
    mutableArray = [NSMutableArray arrayWithCapacity:100];
    self.navigationController.navigationBar.translucent = NO;
    
    //self.numberCon == 1   外部通讯录
    //self.numberCon == 2   常用联系人
    switch (self.numberCon) {
        case 1:
            self.title = @"外部通讯录";
            break;
        case 2:
            self.title = @"常用联系人";
            break;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithImage:UIImageMake(@"选项添加")  position:QMUINavigationButtonPositionRight target:self action:@selector(addEvent)];
 
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [si.selectDataArr removeAllObjects];
    [self setupPopMenu];
    [self getServeManager];
    switch (self.numberCon) {
        case 1:
            [TalkingData trackPageBegin:@"外部通讯录"];
            break;
        case 2:
            [TalkingData trackPageBegin:@"常用联系人"];
            break;
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    switch (self.numberCon) {
        case 1:
            [TalkingData trackPageEnd:@"外部通讯录"];
            break;
        case 2:
            [TalkingData trackPageEnd:@"常用联系人"];
            break;
    }
}

- (void)getServeManager {
    NSString * serveStr=[NSString new];
    switch (self.numberCon) {
        case 1:{
            self.title = @"外部通讯录";
            serveStr=outerPersons;
            break;
        }
        case 2:{
            self.title = @"常用联系人";
            serveStr=getCommonPersons;
            break;
        }
    }
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,serveStr] isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"----------%@",response);
        if ([response[@"code"] integerValue] == 1) {
            self.dataSourceArray = [YSDataManager getExternalData:response];
            [self ys_reloadData];
        }
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}

- (void)addEvent {
    switch (self.numberCon) {
        case 1:{
            YSAddPeopleViewController *addPeople = [[YSAddPeopleViewController alloc]init];
            [self.navigationController pushViewController:addPeople animated:YES];
            break;
        }
        case 2:{
            YSChooseMorePeopleViewController *internal = [[YSChooseMorePeopleViewController alloc]init];
            internal.title = @"内部通讯录";
            internal.str = @"首页";
            [[YSDingDingHeader shareHelper].titleList removeAllObjects];
            [[YSDingDingHeader shareHelper].titleList addObject:@"联系人"];
            [self.navigationController pushViewController:internal animated:YES];
            break;
        }
    }
}
- (void)setupPopMenu {
    __weak __typeof(self)weakSelf = self;
    
    self.popupMenuView = [[QMUIPopupMenuView alloc] init];
    self.popupMenuView.automaticallyHidesWhenUserTap = YES;
    self.popupMenuView.maskViewBackgroundColor = UIColorMaskWhite;
    self.popupMenuView.maximumWidth = 180;
    self.popupMenuView.shouldShowItemSeparator = YES;
    self.popupMenuView.separatorInset = UIEdgeInsetsMake(0, self.popupMenuView.padding.left, 0, self.popupMenuView.padding.right);
    self.popupMenuView.items = @[
                                 [QMUIPopupMenuItem itemWithImage:[UIImageMake(@"") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] title:@"内部联系人导入" handler:^{
                                     [weakSelf.popupMenuView hideWithAnimated:YES];
                                     YSChooseMorePeopleViewController *internal = [[YSChooseMorePeopleViewController alloc]init];
                                     internal.title = @"内部通讯录";
                                     internal.type = AddressBook;
                                     internal.str = @"首页";
                                     [[YSDingDingHeader shareHelper].titleList removeAllObjects];
                                     [[YSDingDingHeader shareHelper].titleList addObject:@"联系人"];
                                     [self.navigationController pushViewController:internal animated:YES];
                                 }],
                                 [QMUIPopupMenuItem itemWithImage:[UIImageMake(@"") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] title:@"外部联系人导入" handler:^{
                                     [weakSelf.popupMenuView hideWithAnimated:YES];
                                     YSChoosePeopleViewController *external = [[YSChoosePeopleViewController alloc]init];
                                     [self.navigationController pushViewController:external animated:YES];
                                 }],
                                 [QMUIPopupMenuItem itemWithImage:[UIImageMake(@"") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] title:@"手机联系人导入" handler:^{
                                     [weakSelf.popupMenuView hideWithAnimated:YES];
                                     YSPhoneAddressBookViewController *phone = [[YSPhoneAddressBookViewController alloc]init];
                                     [self.navigationController pushViewController:phone animated:YES];
                                 }]];
}

- (void)viewDidLayoutSubviews {
    [self.popupMenuView layoutWithTargetView:_rightButton];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *inde = @"cell";
    YSSonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inde];
    if (cell == nil) {
        cell = [[YSSonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inde];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    model = self.dataSourceArray[indexPath.row];
    if (model.name.length <= 2) {
        [cell.headImage setTitle:[model.name substringToIndex:model.name.length] forState:UIControlStateNormal];
    }else{
        [cell.headImage setTitle:[model.name substringFromIndex:model.name.length-2]  forState:UIControlStateNormal];
    }
    cell.headImage.backgroundColor = [UIColor colorWithRed:98.0/255.0 green:189.0/255.0 blue:231.0/255.0 alpha:1.0];
    cell.nameLabel.text = model.name;
    cell.nameLabel.textColor = kUIColor(51, 51, 51, 1);
    cell.nameLabel.font = [UIFont systemFontOfSize:15*BIZ];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSInformationViewController *information =  [[YSInformationViewController alloc]init];
    information.number = 2;
    information.str = self.title;
    model = self.dataSourceArray[indexPath.row];
    information.id = model.id;
    information.source = model.source;
    [self.navigationController pushViewController:information animated:YES];
}

- (void)dealloc {
    // 移除当前对象监听的事件
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:@"update"];
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
