//
//  YSFlowSupplyCategoryTableViewCell.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/18.
//

#import <UIKit/UIKit.h>

@interface YSFlowSupplyCategoryTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *cententLabel;

- (void)setFlowSupplyCategoryData:(NSArray *)array andIndexPath:(NSIndexPath *)indexPath;

@end
