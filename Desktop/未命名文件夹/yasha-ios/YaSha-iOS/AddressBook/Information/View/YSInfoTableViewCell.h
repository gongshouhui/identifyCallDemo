//
//  YSInfoTableViewCell.h
//  YaSha-iOS
//
//  Created by mHome on 2017/3/10.
//
//

#import <UIKit/UIKit.h>
#import "YSInternalPeopleModel.h"

@interface YSInfoTableViewCell : UITableViewCell

@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *conterLabel;

-(void)setInfoTableViewCellData:(YSInternalPeopleModel *)cellModel andAtIndexPath:(NSIndexPath *)indexPath ;

@end
