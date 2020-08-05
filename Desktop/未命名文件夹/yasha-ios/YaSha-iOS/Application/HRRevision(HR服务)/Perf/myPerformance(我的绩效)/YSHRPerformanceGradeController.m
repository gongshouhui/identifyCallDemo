//
//  YSHRPerformanceGradeController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/1/9.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRPerformanceGradeController.h"
#import "YSHRPerformGradeCell.h"
#import "YSHRPerformModel.h"

@interface YSHRPerformanceGradeController ()
@property (nonatomic,strong)  YSHRPerformModel *perModel;
@end

@implementation YSHRPerformanceGradeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绩效结果";
    [self doNetworking];
    // Do any additional setup after loading the view.
}

- (void)initTableView {
    [super initTableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (void)doNetworking {
    [super doNetworking];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%ld",YSDomain,getPersonYearPerformance,self.pageNumber] isNeedCache:NO parameters:nil successBlock:^(id response) {
        if ([response[@"code"] intValue] == 1) {
            self.pageNumber == 1 ? [self.dataSourceArray removeAllObjects] : nil;
            [self.dataSourceArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[YSHRPerformModel class] json:response[@"data"]]];
            self.tableView.mj_footer.state = self.dataSourceArray.count < [response[@"total"] intValue] ?MJRefreshStateIdle :MJRefreshStateNoMoreData ;
            [self ys_reloadData];
            [self.tableView.mj_header endRefreshing];
        }
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSHRPerformGradeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSHRPerformGradeCell"];
    if (cell == nil) {
        cell = [[YSHRPerformGradeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSHRPerformGradeCell"];
    }
    [cell setCellDataWithModel:self.dataSourceArray[indexPath.row] indexPath:indexPath];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

@end
