//
//  YSSupplyManageViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/10/20.
//

#import "YSSupplyManageViewController.h"
#import "YSSupplyListTableViewCell.h"

@interface YSSupplyManageViewController ()

@end

@implementation YSSupplyManageViewController

- (void)initTableView {
    [super initTableView];
     [self.tableView registerClass:[YSSupplyListTableViewCell class] forCellReuseIdentifier:@"SupplyListCell"];
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
