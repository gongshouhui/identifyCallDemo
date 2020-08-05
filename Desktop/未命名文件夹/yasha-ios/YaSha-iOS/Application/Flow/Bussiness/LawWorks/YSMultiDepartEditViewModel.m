//
//  YSMultiDepartEditViewModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/18.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSMultiDepartEditViewModel.h"
#import "YSLawDepartModel.h"
#import "YSFlowLawSuitEditDepartController.h"
@implementation YSMultiDepartEditViewModel
- (NSMutableArray *)viewDataArr {
    if (!_viewDataArr) {
        _viewDataArr = [NSMutableArray array];
    }
    return _viewDataArr;
}
- (void)setDepartArray:(NSMutableArray *)departArray {
    _departArray = departArray;
    [self.viewDataArr removeAllObjects];
    for (YSLawDepartModel *departModel in departArray) {
        NSMutableArray *infoArray = [NSMutableArray array];
        [infoArray addObject:@{@"title":departModel.deptName,@"special":@(BussinessFlowCellEdit)}];
        

        [infoArray addObject:@{@"title":@"法务部接收资料情况",@"content":departModel.lawsuitData}];
        [infoArray addObject:@{@"special":@(BussinessFlowCellEmpty)}];
        [infoArray addObject:@{@"title":@"接收人",@"special":@(BussinessFlowCellBG),@"content":departModel.receiverName}];
        [infoArray addObject:@{@"title":@"应收资料" ,@"special":@(BussinessFlowCellBG),@"content":departModel.receiveData}];
        [infoArray addObject:@{@"title":@"类型" ,@"special":@(BussinessFlowCellBG),@"content":departModel.type}];
        [infoArray addObject:@{@"title":@"提供日期",@"special":@(BussinessFlowCellBG),@"content":[YSUtility timestampSwitchTime:departModel.submitDate andFormatter:@"yyyy-MM-dd hh:mm"]}];
        [infoArray addObject:@{@"title":@"拟提供日期",@"special":@(BussinessFlowCellBG),@"content":[YSUtility timestampSwitchTime:departModel.planSubmitDate andFormatter:@"yyyy-MM-dd hh:mm"]}];
        [infoArray addObject:@{@"title":@"经办人" ,@"special":@(BussinessFlowCellBG),@"content":departModel.operator}];
        [infoArray addObject:@{@"title":@"经办人联系方式" ,@"special":@(BussinessFlowCellBG),@"content":departModel.operatorPhone}];
        [infoArray addObject:@{@"title":@"备注",@"special":@(BussinessFlowCellBG) ,@"content":departModel.remark}];
        [infoArray addObject:@{@"special":@(BussinessFlowCellEmpty)}];
        [self.viewDataArr addObject:infoArray];
    }
}
- (void)turnOtherViewControllerWith:(UIViewController *)viewController andIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *cellDic = self.viewDataArr[indexPath.section][indexPath.row];
    if ([cellDic[@"special"] integerValue] == BussinessFlowCellEdit) {
        YSLawDepartModel *departModel = self.departArray[indexPath.section];
        YSFlowLawSuitEditDepartController * vc = [[YSFlowLawSuitEditDepartController alloc]init];
        vc.departModel = departModel;
        vc.bussinessKey = self.bussinessKey;
        vc.editBlock = ^{
            [self setDepartArray:self.departArray];//重新刷新viewmodel
        };
        [viewController.navigationController pushViewController:vc animated:YES];
    }
    
}
@end
