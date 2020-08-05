//
//  YSPMSUnitTableViewCell.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/8/30.
//
//

#import <UIKit/UIKit.h>
@class YSPMSUnitInfoModel;

@interface YSPMSUnitTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *twoTitleLabel;

- (void)setUnitInfoCellData:(YSPMSUnitInfoModel *)model andUinitInfoArr:(NSArray *)arr andIndexPath:(NSIndexPath *)indexPath;

@end
