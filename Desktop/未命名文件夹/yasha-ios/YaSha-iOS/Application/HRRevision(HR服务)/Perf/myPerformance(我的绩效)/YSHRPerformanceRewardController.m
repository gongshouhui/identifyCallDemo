//
//  YSHRPerformanceRewardController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/1/9.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRPerformanceRewardController.h"
#import "YSHRRewardCell.h"
@interface YSHRPerformanceRewardController ()

@end

@implementation YSHRPerformanceRewardController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"奖励信息";
    [self hideMJRefresh];
    [self ys_reloadData];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSHRRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSHRRewardCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"YSHRRewardCell" owner:self options:nil].firstObject;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
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
