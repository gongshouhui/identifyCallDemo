//
//  YSContactTableViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/8.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSContactTableViewController.h"
#import "YSContactModel.h"
#import "YSFormRowModel.h"
#import "YSFormCommonCell.h"
#import "YSExternalViewController.h"
#import "YSContactAddressBookViewController.h"
#import "YSContactInnerViewController.h"
#import "YSIdentPhoneViewController.h"
@interface YSContactTableViewController ()
@end

static NSString *cellIdentifier = @"FormCommonCell";

@implementation YSContactTableViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
}
- (void)initTableView {
    [super initTableView];
     self.title = @"通讯录";
    [self.tableView registerClass:[YSFormCommonCell class] forCellReuseIdentifier:cellIdentifier];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatasource];
}
- (void)initDatasource {
    YSFormRowModel *model0 = [[YSFormRowModel alloc] init];
    model0.rowName = @"YSFormDetailCell";
    model0.imageName = @"内部icon";
    model0.title = @"内部通讯录";
    model0.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    YSFormRowModel *model1 = [[YSFormRowModel alloc] init];
    model1.rowName = @"YSFormDetailCell";
    model1.imageName = @"外部icon";
    model1.title = @"外部通讯录";
    model1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    YSFormRowModel *model2 = [[YSFormRowModel alloc] init];
    model2.rowName = @"YSFormDetailCell";
    model2.imageName = @"手机icon";
    model2.title = @"手机通讯录";
    model2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    YSFormRowModel *model3 = [[YSFormRowModel alloc] init];
    model3.rowName = @"YSFormDetailCell";
    model3.imageName = @"常用icon";
    model3.title = @"常用联系人";
    model3.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    YSFormRowModel *model4 = [[YSFormRowModel alloc] init];
    model4.rowName = @"YSFormDetailCell";
    model4.imageName = @"号码识别";
    model4.title = @"号码识别";
    model4.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.dataSource = @[model0, model1, model2, model3, model4];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFormRowModel *cellModel = self.dataSource[indexPath.row];
    YSFormCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[NSClassFromString(cellModel.rowName) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    [cell setCellModel:cellModel];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            YSContactInnerViewController *contactInner = [[YSContactInnerViewController alloc]init];
            [self.navigationController pushViewController:contactInner animated:YES];
            break;
        }
        case 1:
        {
            YSExternalViewController *external = [[YSExternalViewController alloc]init];
            external.numberCon = 1;
            [self.navigationController pushViewController:external animated:YES];
            break;
        }
        case 2:
        {
            YSContactAddressBookViewController *external = [[YSContactAddressBookViewController alloc]init];
            [YSUtility checkAddressBookEnableStatus:^(BOOL enable) {
                [self.navigationController pushViewController:external animated:YES];
               
            }];
             break;
        }
        case 3:
        {
            YSExternalViewController *external = [[YSExternalViewController alloc]init];
            external.string = @"联系人";
            external.numberCon = 2;
            [self.navigationController pushViewController:external animated:YES];
        }
            break;
            case 4:
        {
            YSIdentPhoneViewController *identPhoneVC = [[YSIdentPhoneViewController alloc]init];
             [self.navigationController pushViewController:identPhoneVC animated:YES];
        }
            break;
        default:
            break;
    }
}
- (void)dealloc {
    DLog(@"通讯录释放");
}
@end
