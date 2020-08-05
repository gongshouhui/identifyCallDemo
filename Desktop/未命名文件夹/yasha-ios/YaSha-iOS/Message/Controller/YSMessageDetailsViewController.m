//
//  YSMessageDetailsViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/6/22.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSMessageDetailsViewController.h"
#import "YSMessageDetailsTableViewCell.h"
#import "YSMessageContentTableViewCell.h"

@interface YSMessageDetailsViewController ()

@end

@implementation YSMessageDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息详情";
    [self doNetworking];
}

- (void)initTableView {
    [super initTableView];
    [self hideMJRefresh];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerClass:[YSMessageDetailsTableViewCell class] forCellReuseIdentifier:@"MessageDetailsCell"];
    [self doNetworking];
}

- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, updateReadingStatus,self.cellModel.id];
    [YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"======%@",response);
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 25;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        YSMessageDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageDetailsCell"];
        if (cell == nil) {
            cell = [[YSMessageDetailsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageDetailsCell"];
        }
        cell.titleLabel.text = self.cellModel.title;
        return cell;
    }else {
        static NSString *inde = @"cell";
        YSMessageContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inde];
        if (cell == nil) {
            cell = [[YSMessageContentTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:inde];
        }
        [cell setMessageContent:self.cellModel andIndexPath:indexPath];
        return cell;
    }
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
