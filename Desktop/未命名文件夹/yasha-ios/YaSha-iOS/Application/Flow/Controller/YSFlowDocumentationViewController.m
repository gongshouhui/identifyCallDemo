//
//  YSFlowDocumentationViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/9/11.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowDocumentationViewController.h"
#import "YSNewsAttachmentCell.h"
#import "YSNewsAttachmentViewController.h"
#import "YSNewsAttachmentModel.h"
@interface YSFlowDocumentationViewController ()

@end

static NSString *cellIdentifierFile = @"FlowRecordFileListCell";

@implementation YSFlowDocumentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关联文档";
    self.view.backgroundColor = [UIColor whiteColor];
    
}
- (void)initTableView {
    [super initTableView];
    [self hideMJRefresh];
	[self.dataSourceArray addObjectsFromArray:self.attachArray];
	[self ys_reloadData];
//    if (self.dataSourceArray.count > 0) {
//        [self.dataSourceArray addObjectsFromArray:_attachArray];
//        [self ys_reloadData];
//    }else {
//        [self.dataSourceArray addObjectsFromArray:_attachArray];
//        NSLog(@"------%@",self.dataSourceArray);
//        [self doNetworking];
//    }
}

//- (void)doNetworking {
//    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getAttachmentApi, self.businessKey];
//    DLog(@"文档:%@", urlString);
//    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
//        DLog(@"获取关联文档:%@", response);
//        [self.dataSourceArray addObjectsFromArray:[YSDataManager getFlowAttachFileListData:response]];
//        [self ys_reloadData];
//    } failureBlock:^(NSError *error) {
//        DLog(@"error:%@", error);
//    } progress:nil];
//}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YSNewsAttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierFile];
    if (!cell) {
        cell = [[YSNewsAttachmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierFile];
    }
    YSNewsAttachmentModel *cellModel = self.dataSourceArray[indexPath.row];
    [cell setCellModel:cellModel];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50*kHeightScale + 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSNewsAttachmentModel *attachmentModel = self.dataSourceArray[indexPath.row];
    YSNewsAttachmentViewController *newsAttachmentViewController = [[YSNewsAttachmentViewController alloc] init];
    newsAttachmentViewController.attachmentModel = attachmentModel;
    [self.navigationController pushViewController:newsAttachmentViewController animated:YES];
   
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
