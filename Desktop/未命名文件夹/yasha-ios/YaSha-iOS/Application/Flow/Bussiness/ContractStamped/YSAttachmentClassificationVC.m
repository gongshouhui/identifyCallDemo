//
//  YSAttachmentClassificationVC.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2019/2/21.
//  Copyright © 2019年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSAttachmentClassificationVC.h"
#import "YSNewsAttachmentCell.h"
#import "YSNewsAttachmentViewController.h"

@interface YSAttachmentClassificationVC ()

@end
static NSString *cellIdentifierFile = @"FlowRecordFileListCell";
@implementation YSAttachmentClassificationVC
- (void)initTableView {
    [super initTableView];
    [self hideMJRefresh];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附件";
    self.view.backgroundColor = [UIColor whiteColor];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataSourceArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YSNewsAttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierFile];
    if (!cell) {
        cell = [[YSNewsAttachmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierFile];
    }
    YSNewsAttachmentModel *cellModel = self.dataSourceArray[indexPath.section][indexPath.row];
    [cell setCellModel:cellModel];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30*kHeightScale;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    NSArray *array = @[@"公共附件",@"与供应商合同附件",@"全品/蘑菇加合同附件"];
    UILabel *label = [[UILabel alloc]init];
    label.frame =CGRectMake(16, 5, kSCREEN_WIDTH, 20*kHeightScale);
    label.text = array[section];
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50*kHeightScale + 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSNewsAttachmentModel *attachmentModel = self.dataSourceArray[indexPath.section][indexPath.row];
    YSNewsAttachmentViewController *newsAttachmentViewController = [[YSNewsAttachmentViewController alloc] init];
    newsAttachmentViewController.attachmentModel = attachmentModel;
    [self.navigationController pushViewController:newsAttachmentViewController animated:YES];
    
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
