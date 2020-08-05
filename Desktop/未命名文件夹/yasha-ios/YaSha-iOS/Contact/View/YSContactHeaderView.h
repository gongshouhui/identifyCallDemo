//
//  YSContactHeaderView.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/12/12.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol YSContactHeaderViewDelegate <NSObject>

- (void)contactHeaderViewDepartmentButton:(UIButton *)departmentButton;

@end
@interface YSContactHeaderView : UIView
@property (nonatomic,strong) NSArray *headerArray;
@property (nonatomic,assign) id <YSContactHeaderViewDelegate> delegate;
/**等待人数查出后回到主线程显示*/
- (void)setlastDepartMentButtonWithTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
