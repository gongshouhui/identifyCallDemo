//
//  YSFlowBusinessViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/18.
//

#import "YSFlowBusinessViewController.h"
#import "YSFlowBusinessTableViewCell.h"

@interface YSFlowBusinessViewController ()

@end

@implementation YSFlowBusinessViewController

- (void)initSubviews {
    [super initSubviews];
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    [self.tableView registerClass:[YSFlowBusinessTableViewCell class] forCellReuseIdentifier:@"FlowBusinessCell"];
    [self doNetworking];
}

- (void)doNetworking {
    [QMUITips hideAllTipsInView:self.view];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.applyInfosArray.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFlowBusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FlowSupplyCategoryCell"];
    if (cell == nil) {
        cell = [[YSFlowBusinessTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FlowSupplyCategoryCell"];
    }
    if (indexPath.row > 0) {
         [cell setFlowBusinessData:self.applyInfosArray[indexPath.row-1] andIndexPath:indexPath];
    }
  
    return cell;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"企业经营情况";
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
