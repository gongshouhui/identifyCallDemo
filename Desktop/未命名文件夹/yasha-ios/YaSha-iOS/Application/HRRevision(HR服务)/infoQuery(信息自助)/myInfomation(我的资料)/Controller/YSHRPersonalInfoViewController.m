//
//  YSHRPersonalInfoViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/12/13.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRPersonalInfoViewController.h"
#import "YSHRPersonalInfoCell.h"
#define InfoCellReuseIdentifier @"YSPersonalInfoCell"
@interface YSHRPersonalInfoViewController ()
@property (nonatomic,strong)NSMutableArray *contactArr;
@property (nonatomic,strong)NSMutableArray *infoArr;
@property (nonatomic,strong)NSMutableArray *addressArr;
@property (nonatomic,strong)NSArray *titleArray;
@end

@interface YSHRPersonalInfoViewController ()

@end

@implementation YSHRPersonalInfoViewController

#pragma mark - 懒加载
- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"联系方式",@"个人信息",@"地址"];
    }
    return _titleArray;
}

#pragma mark - 生命周期

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"基本信息";
    self.view.backgroundColor = kUIColor(229, 229, 229, 1);
    
}
- (void)initTableView{
    [super initTableView];
    [self.tableView registerClass:[YSHRPersonalInfoCell class] forCellReuseIdentifier:InfoCellReuseIdentifier];
    [self hideMJRefresh];
    self.tableView.sectionFooterHeight = 0.0;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.backgroundColor = kUIColor(229, 229, 229, 1);
    //self.tableView.estimatedRowHeight = 100;
    [self doNetworking];
    
}
- (void)doNetworking{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (_profileModel) {
            self.contactArr = [NSMutableArray array];
            self.infoArr = [NSMutableArray array];
            self.addressArr = [NSMutableArray array];
        
            [self.contactArr addObject:@{@"手机号码": _profileModel.workphone}];
            [self.contactArr addObject:@{@"手机短号": _profileModel.worklongphone}];
            [self.contactArr addObject:@{@"办公电话":_profileModel.officephone}];
            [self.contactArr addObject:@{@"家庭电话":_profileModel.homephone}];
            [self.contactArr addObject:@{@"QQ":_profileModel.qq}];
            [self.contactArr addObject:@{@"邮件":_profileModel.secretemail}];
            
            [self.infoArr addObject:@{@"身高":_profileModel.height}];//cm
            [self.infoArr addObject:@{@"体重":_profileModel.weight}];//=kg
            [self.infoArr addObject:@{@"民族":_profileModel.nationality}];
            [self.infoArr addObject:@{@"婚姻状况":_profileModel.marital}];
            [self.infoArr addObject:@{@"政治面貌":_profileModel.polity}];
            [self.infoArr addObject:@{@"出生日期":_profileModel.birthdate}];
            [self.infoArr addObject:@{@"参加工作日期":_profileModel.joinworkdate}];
            
            [self.addressArr addObject:@{@"户口性质":_profileModel.characterrpr}];
            [self.addressArr addObject:@{@"户口驻地":_profileModel.permanreside}];
            [self.addressArr addObject:@{@"身份证登记地":_profileModel.idcardaddr}];
            [self.addressArr addObject:@{@"籍贯":_profileModel.nativeplace}];
            [self.addressArr addObject:@{@"可书面送达地址":_profileModel.sendaddr}];
            [self.addressArr addObject:@{@"家庭住址":_profileModel.addr}];
            [self.addressArr addObject:@{@"现居住地址":_profileModel.nowaddr}];
            
            [self.dataSourceArray addObject:_contactArr];
            [self.dataSourceArray addObject:_infoArr];
            [self.dataSourceArray addObject:_addressArr];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self ys_reloadDataWithImageName:@"ic_info_bg_personal" text:@"暂无个人信息\n快去后台添加吧"];
        });
    });
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [(NSArray *)(self.dataSourceArray[section]) count];
    
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200*kHeightScale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    YSHRPersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:InfoCellReuseIdentifier forIndexPath:indexPath];
    cell.dic = self.dataSourceArray[indexPath.section][indexPath.row];
    // [cell setOtherByIndexPath:indexPath withArray:self.dataSourceArray[indexPath.section]];//设置圆角 字体
    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *label = [[UILabel alloc]init];
    [view addSubview:label];
    [label sizeToFit];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = kUIColor(25, 31, 37, 1);
    
    label.text = self.titleArray[section];
    label.frame = CGRectMake(15, (38 - 20)/2, kSCREEN_WIDTH, 20);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32*kHeightScale;
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
