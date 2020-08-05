//
//  YSInterTableViewCell.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/8/3.
//
//

#import <UIKit/UIKit.h>
#import "YSInternalModel.h"

@interface YSInterTableViewCell : UITableViewCell

@property(nonatomic, strong) UIImageView *titleImage;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *jobsName;

- (void)setAdderssBookCell:(YSInternalModel *)cellModel;
@end
