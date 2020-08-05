//
//  YSAssetsSearchCell.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/24.
//
//

#import <UIKit/UIKit.h>

@interface YSAssetsSearchCell : UITableViewCell

@property (nonatomic, strong) UITextField *textField;
- (void)setCellWithIndexPath:(NSIndexPath *)indexPath config:(NSDictionary *)config;

@end
