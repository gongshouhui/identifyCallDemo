//
//  YSPMSPlanAddPhotoTableViewCell.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/10/17.
//

#import <UIKit/UIKit.h>

@interface YSPMSPlanAddPhotoTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *inputTextFiled;

- (void)setAddPhotoCellData:(NSString *)cumulativeCount andProportion:(NSString *)proportion andIndexPath:(NSIndexPath *)indexPath;
- (void)setMQAddPhotoCellData:(NSArray *)dataArray andIndexPath:(NSIndexPath *)indexPath ;

@end
