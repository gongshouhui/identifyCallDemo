//
//  YSPMSMQFinishingViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/4/2.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSMQFinishingViewController.h"

@interface YSPMSMQFinishingViewController ()

@end

@implementation YSPMSMQFinishingViewController

- (void)initTableView {
    [super initTableView];
    [self doNetworking];
}

- (void)doNetworking {
    [QMUITips hideAllToastInView:self.view animated:YES];
    [self ys_reloadData];
    [self showEmptyViewWithImage:UIImageMake(@"ic_pg_empty_end") text:@"收尾计划系统研发中..." detailText:@"" buttonTitle:@"" buttonAction:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
