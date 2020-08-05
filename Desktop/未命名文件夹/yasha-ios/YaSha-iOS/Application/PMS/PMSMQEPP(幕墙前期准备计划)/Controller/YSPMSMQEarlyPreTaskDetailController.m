//
//  YSPMSMQEarlyPreTaskDetailController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/11/1.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSMQEarlyPreTaskDetailController.h"
#import "YSPMSMQEarlyTaskModel.h"
#import "YSMQScheduleCell.h"
#import "YSMQTaskHandleDetailCell.h"
#import "YSMQTaskDetailCell.h"
@interface YSPMSMQEarlyPreTaskDetailController()
@property (nonatomic,strong) YSPMSMQEarlyTaskModel *taskModel;
@end
@implementation YSPMSMQEarlyPreTaskDetailController
- (void)initTableView {
    [super initTableView];
    [self hideMJRefresh];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务详情";
    [self doNetworking];
}
- (void)doNetworking {
    [super doNetworking];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain,getPlanPreapreDeatil,self.code] isNeedCache:NO parameters:nil successBlock:^(id response) {
        [QMUITips hideAllTipsInView:self.view];
        if ([response[@"code"] integerValue] == 1) {
            self.taskModel = [YSPMSMQEarlyTaskModel yy_modelWithDictionary:response[@"data"]];
            [self.tableView reloadData];
        }
      
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}

#pragma mark - tableViewDelete方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.taskModel.planPrepareStageList.count + 1;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                YSMQScheduleCell *cell = [[NSBundle mainBundle] loadNibNamed:@"YSMQScheduleCell" owner:self options:nil].firstObject;
                [cell setCellData:self.taskModel];
                return cell;
            }
                break;
                
            default:
            {
                YSMQTaskDetailCell *cell = [[NSBundle mainBundle] loadNibNamed:@"YSMQTaskDetailCell" owner:self options:nil].firstObject;
                [cell setCellDataWithModel:self.taskModel];
                return cell;
            }
                break;
        }
    }else{
        
        YSMQTaskHandleDetailCell *cell = [[YSMQTaskHandleDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell setCellDataWithModel:self.taskModel.planPrepareStageList[indexPath.section -1]];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }else{
        return 10;
    }
}
@end
