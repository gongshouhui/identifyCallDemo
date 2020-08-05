//
//  YSFlowFormListViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/4.
//

#import "YSFlowFormListViewController.h"
#import "YSFlowFormModel.h"
#import "YSFlowSubFormListViewController.h"
#import "YSFlowMapViewController.h"

@interface YSFlowFormListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) YSFlowFormModel *flowFormModel;

@end

@implementation YSFlowFormListViewController

- (void)initSubviews {
    [super initSubviews];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    [self monitorAction];
}

- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/%@", YSDomain, getUserDefineDetailApi, self.cellModel.processDefinitionKey, self.cellModel.businessKey];
    DLog(@"--------%@",urlString);
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        if ([response[@"code"] intValue] == 1) {
            self.flowFormModel = [YSFlowFormModel yy_modelWithJSON:response[@"data"]];
            [self.flowFormHeaderView setHeaderModel:self.flowFormModel.baseInfo];
            [self.tableView setTableHeaderView:self.flowFormHeaderView];//taberViewHeader 内部采用自上而下的约束，他不像普通view在填充数据时自适应了高度，tableView表头比较特殊，需要在赋值后重新设置一次表头，tableView才能获取到正确的表头高度
            self.attachArray = [YSDataManager getFlowFormAttachFileListData:response];
            self.dataSource = self.flowFormModel.dataInfo;
            for (int i = 0 ; i < self.dataSource.count; i++) {
                YSFlowFormListModel *model = self.dataSource[i];
                if ([model.fieldType isEqual:@"subform"]) {
                    if (model.values.count > 0) {
                        [self.dataSourceArray addObject:model];
                    }
                }else if([model.fieldType isEqual:@"usermsg"]){
                    if (model.values.count > 0) {
                        if (model.value.length > 0) {
                            [self.dataSourceArray addObject:model];
                        }
                        for (int i = 0; i < model.values.count; i++) {
                            YSFlowFormListModel *model1 = model.values[i];
                            [self.dataSourceArray addObject:model1];
                        }
                    }
                }else if([model.fieldType isEqual:@"projectmsg"]){
                    if (model.values.count > 0) {
                        if (model.value.length > 0) {
                            [self.dataSourceArray addObject:model];
                        }
                        for (int i = 0; i < model.values.count; i++) {
                            YSFlowFormListModel *model1 = model.values[i];
                          
                                 [self.dataSourceArray addObject:model1];
                           
                        }
                    }
                }else {
                    [self.dataSourceArray addObject:model];
                }
            }
            [self.tableView reloadData];
        } 
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFlowFormListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[YSFlowFormListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    YSFlowFormListModel *cellModel = self.dataSourceArray[indexPath.row];
    [cell setCellModel:cellModel];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFlowFormListModel *cellModel = self.dataSourceArray[indexPath.row];
    if ([cellModel.fieldType isEqual:@"separator"]) {
        return 30*kHeightScale;
    } else {
        return [tableView fd_heightForCellWithIdentifier:cellIdentifier configuration:^(YSFlowFormListCell *cell) {
            YSFlowFormListModel *cellModel = self.dataSourceArray[indexPath.row];
            [cell setCellModel:cellModel];
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 子表单跳转到新页面显示
    YSFlowFormListModel *cellModel = self.dataSourceArray[indexPath.row];
    if ([cellModel.fieldType isEqual:@"subform"]) {
        YSFlowSubFormListViewController *flowSubFormListViewController = [[YSFlowSubFormListViewController alloc] init];
        flowSubFormListViewController.dataSource = cellModel.values;
        flowSubFormListViewController.titleString = cellModel.lableName;
        [self.navigationController pushViewController:flowSubFormListViewController animated:YES];
        // url跳转
    } else if ([cellModel.fieldType isEqual:@"url"]) {
        YSFlowMapViewController *flowMapViewController = [[YSFlowMapViewController alloc] init];
        flowMapViewController.title = cellModel.lableName;
        flowMapViewController.urlString = cellModel.value;
        [self.navigationController pushViewController:flowMapViewController animated:YES];
    }
}
- (void)dealloc {
   
}
@end
