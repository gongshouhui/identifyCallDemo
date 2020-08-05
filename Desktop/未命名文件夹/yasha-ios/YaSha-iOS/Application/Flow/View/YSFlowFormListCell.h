//
//  YSFlowFormListCell.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/27.
//

#import <UIKit/UIKit.h>
#import "YSFlowFormModel.h"
#import "YSFlowAssetsApplyFormModel.h"
#import "YSFlowExpensePexpShareModel.h"
@interface YSFlowFormListCell : UITableViewCell

@property (nonatomic, strong) YSFlowFormListModel *cellModel;

@property (nonatomic, strong) UILabel *lableNameLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIButton *extendButton;
@property (nonatomic,strong) NSDictionary *contentDic;
@property (nonatomic,strong) YSFlowExpenseShareDetailModel *expenseDetailmodel;

/** 设置业务流程表单 */
- (void)setLeftArray:(NSArray *)leftArray indexPath:(NSIndexPath *)indexPath;
- (void)setRightArray:(NSArray *)rightArray indexPath:(NSIndexPath *)indexPath;

/** 设置行程详情表单 */
- (void)setLeftDetailArray:(NSArray *)leftDetailArray indexPath:(NSIndexPath *)indexPath;
- (void)setRightDetailArray:(NSArray *)rightDetailArray indexPath:(NSIndexPath *)indexPath;
/**设置行程详情表单*/
- (void)setBusinessTripDetailWithDictionary:(NSDictionary *)contentDic;
/**设置报销单*/
- (void)setExpenseDetailWithDictionary:(NSDictionary *)contentDic Model:(YSFlowAssetsApplyFormListModel *)model;
/**新业务流程通用cell赋值*/
- (void)setCommonBusinessFlowDetailWithDictionary:(NSDictionary *)contentDic;


@end
