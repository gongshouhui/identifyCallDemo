//
//  YSFlowRecordListCell.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/30.
//

#import <UIKit/UIKit.h>
#import "YSFlowRecordListModel.h"
#import "YSTagButton.h"
@protocol YSFlowRecordListCellDelegate <NSObject>
- (void)recordListCellCallButtonDidClick:(NSString *)userid;
@end
@interface YSFlowRecordListCell : UITableViewCell
@property (nonatomic, strong) QMUIButton *avatarButton;
@property (nonatomic,strong) UIButton *callButton;
@property (nonatomic, strong) YSTagButton *typeNameLabel;
@property (nonatomic, strong) YSFlowRecordListModel *cellModel;
@property (nonatomic,weak) id<YSFlowRecordListCellDelegate> delegate;
- (void)setRecordListCellModel:(YSFlowRecordListModel *)cellModel andIndexPath:(NSIndexPath *)indexPath;

@end
