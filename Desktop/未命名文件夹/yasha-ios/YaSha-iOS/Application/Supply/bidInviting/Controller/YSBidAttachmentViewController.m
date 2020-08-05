//
//  YSBidAttachmentViewController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/8/16.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSBidAttachmentViewController.h"
#import "YSNewsAttachmentViewController.h"
#import "YSNewsAttachmentCell.h"
#import "YSNewsAttachmentViewController.h"
#import "YSNewsAttachmentModel.h"
#import "YSFlowFormSectionHeaderView.h"

@interface YSBidAttachmentViewController ()

@end

@implementation YSBidAttachmentViewController
- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc]init];
    }
    return _titleArray;
}
- (void)initTableView {
    [super initTableView];
    [self hideMJRefresh];
    [self.tableView registerClass:[YSNewsAttachmentCell class] forCellReuseIdentifier:@"FlowAttachmentCell"];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附件";
    [self doNetworking];
}


- (void)doNetworking {
    
    [QMUITips hideAllToastInView:self.view animated:YES];
    [self ys_reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataSourceArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60*kHeightScale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSNewsAttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FlowAttachmentCell"];
    if (cell == nil) {
        cell = [[YSNewsAttachmentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FlowAttachmentCell"];
    }
 
    cell.cellModel = self.dataSourceArray[indexPath.section][indexPath.row];
  
    
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    YSNewsAttachmentModel *model = self.dataSourceArray[indexPath.section][indexPath.row];
    YSNewsAttachmentViewController *NewsAttachmentViewController = [[YSNewsAttachmentViewController alloc]init];
    NewsAttachmentViewController.attachmentModel = model;
    [self.navigationController pushViewController:NewsAttachmentViewController animated:YES];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YSFlowFormSectionHeaderView *headerView = [[YSFlowFormSectionHeaderView alloc]init];
    headerView.titleLabel.text = self.titleArray[section];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
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
