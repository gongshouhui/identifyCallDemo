//
//  YSSalaryCell.h
//  YaSha-iOS
//
//  Created by 蘑菇加 on 2017/11/24.
//

#import <UIKit/UIKit.h>

@interface YSSalaryCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dic;

- (void)setOtherByIndexPath:(NSIndexPath *)indexPath withArray:(NSArray *)array;


@end
