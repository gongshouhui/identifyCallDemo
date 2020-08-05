//
//  YSFlowListCell.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/25.
//

#import <UIKit/UIKit.h>
#import "YSFlowListViewController.h"
#import "YSFlowListModel.h"

@interface YSFlowListCell : UITableViewCell
@property (nonatomic, strong) YSFlowListModel *cellModel;
- (void)setCellModel:(YSFlowListModel *)cellModel withFlowType:(YSFlowType)flowType;
- (void)setAssociatedFlowCell:(YSFlowListModel *)cellModel;

@end
