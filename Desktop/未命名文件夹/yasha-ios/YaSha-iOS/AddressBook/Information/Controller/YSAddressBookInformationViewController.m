//
//  YSAddressBookInformationViewController.m
//  YaSha-iOS
//
//  Created by mHome on 2016/12/13.
//
//

#import "YSAddressBookInformationViewController.h"
#import "YSModifyViewController.h"
#import "YSAddPeopleViewController.h"
#import "YSSddressBookViewController.h"


@interface YSAddressBookInformationViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
{
    UIButton *optionsButton;
    NSArray *arr;
    NSArray *array;
    UITableView *table;
}

@end

@implementation YSAddressBookInformationViewController

//- (void)viewWillAppear:(BOOL)animated {
//    
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    
//}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kUIColor(247, 247, 247, 1);
    self.title = @"个人信息";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.delegate = self;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName,nil];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏背景"]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.selfNavigation = [[YSSelfNVCView alloc]init];
//    self.selfNavigation.titleLabel.text = @"个人信息";
//    self.selfNavigation.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"导航栏背景"]];
//    [self.view addSubview:self.selfNavigation];
//    [self.selfNavigation mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.mas_equalTo(self.view);
//        make.size.mas_equalTo(CGSizeMake(375*kWidthScale, 64*kHeightScale));
//    }];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回（white）"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    arr = @[@"手机号码", @"来源"];
    [self addButton];
    [self table];
}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    viewController.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
//    viewController.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
//}

//返回按钮事间
- (void)back {
    if (self.nameStr != nil){
        for (UIViewController *VC in self.rt_navigationController.rt_viewControllers) {
            if ([VC isKindOfClass:[YSSddressBookViewController class]]) {
                [self.navigationController popToViewController:VC animated:YES];
            }
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//创建UI界面
- (void)table {
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 550*kHeightScale) style:UITableViewStyleGrouped];
    table.backgroundColor = kUIColor(247, 247, 247, 1);
    table.delegate = self;
    table.dataSource = self;
    table.bounces = NO;
    table.rowHeight = 48*kHeightScale;
    table.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:table];
}

//添加常用联系人按钮
- (void)addButton {
    UIButton *btn = [UIButton  buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"添加常用联系人" forState:UIControlStateNormal];
    btn.backgroundColor = kThemeColor;
    [btn addTarget:self action:@selector(addContent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, 50*kHeightScale));
    }];
}

//添加常用联系人按钮的事件监听
- (void)addContent {
    YSAddPeopleViewController *addPeople = [[YSAddPeopleViewController alloc]init];
    addPeople.addStr = @"通讯录";
    if (self.nameStr != nil) {
        addPeople.addName = self.nameStr;
        addPeople.Phone = self.telStr;
    }else{
        addPeople.addName = [YSSingleton getData].name;
        addPeople.Phone = [YSSingleton getData].phone;
    }
    [self.navigationController pushViewController:addPeople animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *inde = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inde];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inde];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentRight;
    label.frame = CGRects(180, 14, 180, 19);
    [cell addSubview:label];
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = kUIColor(247, 240, 247, 1);
    line.frame = CGRects(10, 47, 355, 1);
    [cell addSubview:line];
    
    cell.textLabel.text = arr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    switch (indexPath.row) {
        case 0:{
            if(self.telStr != nil){
                label.text = self.telStr;
            }else{
                label.text = [YSSingleton getData].phone ;
            }
            label.textColor = kUIColor(42, 138, 229, 1.0);
            break;
        }
        case 1:{
            label.text = @"手机通讯录";
              break;
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 183*kHeightScale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIImageView *view = [[UIImageView alloc]init];
        view.frame = CGRects(0, 0, 375, 183);
        view.image = YSThemeManagerShare.currentTheme.themeContactBackgroundImage;
        
        UIImageView *img = [[UIImageView alloc]init];
        img.image = [UIImage imageNamed:@"头像"];
        [view addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view.mas_top).offset(15);
            make.left.mas_equalTo(view.mas_left).offset(150*kWidthScale);
            make.size.mas_equalTo(CGSizeMake(74*kWidthScale, 74*kHeightScale));
        }];
        
        UILabel *label = [[UILabel alloc]init];
        label.text = [YSSingleton getData].name ;
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.textColor = [UIColor whiteColor];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(img.mas_bottom).offset(18);
            make.left.mas_equalTo(view.mas_left).offset(137*kWidthScale);
            make.size.mas_equalTo(CGSizeMake(100*kWidthScale, 20*kHeightScale));
        }];
        return view;
    }
    return 0;
}

//设置状态栏字体颜色
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
