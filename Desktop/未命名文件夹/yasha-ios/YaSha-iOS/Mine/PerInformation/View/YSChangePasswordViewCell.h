//
//  YSChangePasswordViewCell.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 17/3/6.
//
//

#import <UIKit/UIKit.h>

@interface YSChangePasswordViewCell : UITableViewCell

@property (nonatomic, strong) QMUITextField *textField;

- (void)setStyle:(NSUInteger)row;

@end
