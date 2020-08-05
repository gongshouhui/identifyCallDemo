//
//  YSContentDetailController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2020/1/8.
//  Copyright © 2020 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSContentDetailController.h"
#import "YSFlowFormListCell.h"
@interface YSContentDetailController ()
@property (nonatomic,strong) NSDictionary *contentdic;
@end

@implementation YSContentDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"详情";
	self.contentdic = @{@"special":@(BussinessFlowCellText),@"content":self.content};
	[self.tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	YSFlowFormListCell *cell = [[YSFlowFormListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	[cell setCommonBusinessFlowDetailWithDictionary:self.contentdic];
	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 300;
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
