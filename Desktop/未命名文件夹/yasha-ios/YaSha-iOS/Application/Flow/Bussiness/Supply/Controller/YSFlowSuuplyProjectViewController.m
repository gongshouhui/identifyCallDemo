//
//  YSFlowSuuplyProjectViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/18.
//

#import "YSFlowSuuplyProjectViewController.h"
#import "YSFlowSupplyTableViewCell.h"

@interface YSFlowSuuplyProjectViewController ()

@end

@implementation YSFlowSuuplyProjectViewController

- (void)initTableView {
    [super initTableView];
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    [self.tableView registerClass:[YSFlowSupplyTableViewCell class] forCellReuseIdentifier:@"FlowSuuplyProjectCell"];
    [self doNetworking];
}

- (void)doNetworking {
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.applyInfosArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFlowSupplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FlowSuuplyProjectCell"];
    if (cell == nil) {
        cell = [[YSFlowSupplyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FlowSuuplyProjectCell"];
    }
    [cell setFlowSupplyData:self.applyInfosArray[indexPath.section] andIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  [tableView fd_heightForCellWithIdentifier:@"FlowSuuplyProjectCell" cacheByIndexPath:indexPath configuration:^(YSFlowSupplyTableViewCell *cell) {
        [cell setFlowSupplyData:self.applyInfosArray[indexPath.section] andIndexPath:indexPath];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"代表项目";
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
