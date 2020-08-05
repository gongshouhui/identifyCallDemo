//
//  YSRejectHandleHelper.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/8/27.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSRejectHandleHelper.h"
#import "YSRejectCell.h"
#import "YSRejectModel.h"
#import "YSRejectPickerView.h"

@interface YSRejectHandleHelper()<YSRejectCellDelegate>
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSString *taskID;
@property (nonatomic,strong) NSArray *nodeArray;
@end
@implementation YSRejectHandleHelper
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
        YSRejectModel *model = [[YSRejectModel alloc]init];
        model.title = @"驳回至提交者";
        model.rejectType = RejectTypeSource;
        model.isSelected = YES;//默认选中第一个
        //暂时去掉了驳回上一个节点
//        YSRejectModel *model2 = [[YSRejectModel alloc]init];
//        model2.title = @"驳回至上一审批节点";
//         model2.rejectType = RejectTypeLastNode;
        YSRejectModel *model3 = [[YSRejectModel alloc]init];
        model3.rejectType = RejectTypeSelectedNode;
        model3.title = @"驳回至指定节点";
        [_dataArray addObject:model];
        //[_dataArray addObject:model2];
        [_dataArray addObject:model3];
    }
    return _dataArray;
}
- (instancetype)initWithTaskID:(NSString *)taskID {
    if (self = [super init]) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _taskID = taskID;
        self.selectedModel = self.dataArray.firstObject;//默认选中第一个
        [self getApprovalNode];
    }
    return self;
}

#pragma mark - 获取审批节点
- (void)getApprovalNode {
    [QMUITips showLoadingInView:self.tableView];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain,getBackNodes,self.taskID] isNeedCache:NO parameters:nil successBlock:^(id response) {
        [QMUITips hideAllTipsInView:self.tableView];
        if ([response[@"code"] integerValue] == 1) {
            self.nodeArray = [NSArray yy_modelArrayWithClass:[YSRejectNodeModel class] json:response[@"data"]];
        }
    } failureBlock:^(NSError *error) {
      [QMUITips hideAllTipsInView:self.tableView];
    } progress:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSRejectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSRejectCell"];
    if (cell == nil) {
        cell = [[YSRejectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSRejectCell"];
    }
    if (indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.rejectModel = self.dataArray[indexPath.row];
   
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithHexString:@"#999999"];
    label.text = @"驳回类型";
    label.frame = CGRectMake(15, 5, 200, 20);
    [view addSubview:label];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            self.selectedModel = nil;
            NSInteger index = indexPath.row;
            YSRejectModel *currentSelectedModel = self.dataArray[index];
            currentSelectedModel.isSelected = !currentSelectedModel.isSelected;
            if (currentSelectedModel.isSelected) {
                self.selectedModel = currentSelectedModel;
            }else{
                currentSelectedModel.name = nil;
                currentSelectedModel.nodeModel = nil;
            }
            //整体设置驳回类型
            for (int i = 0; i < self.dataArray.count; i++) {
                YSRejectModel *model = self.dataArray[i];
                if (i == index) {//当前点击行（上面已经做处理）
                    
                }else{//其他行
                    model.isSelected = NO;
                    model.name = nil;
                    model.nodeModel = nil;
                }
            }
            [self.tableView reloadData];
            break;
        }
//        case 1:
//        {
//            self.selectedModel = nil;
//            NSInteger index = indexPath.row;
//            YSRejectModel *currentSelectedModel = self.dataArray[index];
//            currentSelectedModel.isSelected = !currentSelectedModel.isSelected;
//            if (currentSelectedModel.isSelected) {
//                self.selectedModel = currentSelectedModel;
//            }else{
//                currentSelectedModel.name = nil;
//                currentSelectedModel.nodeModel = nil;
//            }
//            //整体设置驳回类型
//            for (int i = 0; i < self.dataArray.count; i++) {
//                YSRejectModel *model = self.dataArray[i];
//                if (i == index) {//当前点击行（上面已经做处理）
//                    
//                }else{//其他行
//                    model.isSelected = NO;
//                    model.name = nil;
//                    model.nodeModel = nil;
//                }
//            }
//            [self.tableView reloadData];
//        }
//            break;
        case 1:
        {
            if (!self.nodeArray.count) {
                [QMUITips showInfo:@"暂无流程审批节点" inView:self.tableView hideAfterDelay:1.5];
                return;
            }
            YSRejectPickerView *pickView = [[YSRejectPickerView alloc]init];
            pickView.dataArray = self.nodeArray;
            YSWeak;
            [pickView showPickerViewOnWindowAnimated:YES selectComplete:^(YSRejectNodeModel *model) {
                YSRejectModel *rejectModel = weakSelf.dataArray[indexPath.row];
                rejectModel.name = model.userName;
                rejectModel.nodeModel = model;
                rejectModel.isSelected = YES;
                
                //设置驳回类型
                for (YSRejectModel *model in self.dataArray) {
                    if (model == rejectModel) {//不做处理
                        
                    }else{//另外的设置为未选中
                        model.isSelected = NO;
                        //                    model.name = nil;
                        //                    model.nodeModel = nil;
                    }
                }
                self.selectedModel = rejectModel;
                
                [weakSelf.tableView reloadData];
            }];
        }
            break;
            
        default:
            break;
    }
   
}

//- (void)rejectCellSelectedButtonDidClick:(YSRejectCell *)cell {
//    self.selectedModel = nil;
//    NSInteger index = [self.tableView indexPathForCell:cell].row;
//    YSRejectModel *currentSelectedModel = self.dataArray[index];
//    currentSelectedModel.isSelected = !currentSelectedModel.isSelected;
//    if (currentSelectedModel.isSelected) {
//        self.selectedModel = currentSelectedModel;
//    }else{
//        currentSelectedModel.name = nil;
//        currentSelectedModel.nodeModel = nil;
//    }
//    //整体设置驳回类型
//    for (int i = 0; i < self.dataArray.count; i++) {
//        YSRejectModel *model = self.dataArray[i];
//        if (i == index) {//当前点击行（上面已经做处理）
//            
//        }else{//其他行
//            model.isSelected = NO;
//            model.name = nil;
//            model.nodeModel = nil;
//        }
//    }
//    [self.tableView reloadData];
//}
@end
