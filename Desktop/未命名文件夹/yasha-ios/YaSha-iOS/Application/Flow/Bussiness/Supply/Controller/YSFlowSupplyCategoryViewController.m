//
//  YSFlowSupplyCategoryViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/18.
//

#import "YSFlowSupplyCategoryViewController.h"
#import "YSFlowSupplyCategoryTableViewCell.h"

@interface YSFlowSupplyCategoryViewController ()

@end

@implementation YSFlowSupplyCategoryViewController

- (void)initTableView {
    [super initTableView];
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    [self.tableView registerClass:[YSFlowSupplyCategoryTableViewCell class] forCellReuseIdentifier:@"FlowSupplyCategoryCell"];
    [self doNetworking];
}

- (void)doNetworking {
    [QMUITips hideAllTipsInView:self.view];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.applyInfosArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFlowSupplyCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FlowSupplyCategoryCell"];
    if (cell == nil) {
        cell = [[YSFlowSupplyCategoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FlowSupplyCategoryCell"];
    }
    DLog(@"-------%@",self.applyInfosArray);
    [cell setFlowSupplyCategoryData:self.applyInfosArray[indexPath.section] andIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"FlowSupplyCategoryCell" cacheByIndexPath:indexPath configuration:^(YSFlowSupplyCategoryTableViewCell *cell) {
        cell.cententLabel.textColor =self.applyInfosArray[indexPath.section][3];
    }]-15*kHeightScale;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"供货类别";
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
