//
//  YSCalendarEditEventCell.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/7.
//

#import <UIKit/UIKit.h>

@interface YSCalendarEditEventCell : UITableViewCell

@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UITextField *detailTextField;
@property (nonatomic, strong) UISwitch *allDaySwitch;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) QMUITextView *textView;

- (void)setStyle:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath;

@end
