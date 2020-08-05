//
//  YSHRMSSubSctionHeaderAllView.h
//  YaSha-iOS
//
//  Created by GZl on 2019/4/9.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSHRMSSubSctionHeaderAllView : UIView

// type:1(5个标题) 2(4个标题) 3(5个标题,只是迟到早退) 4(3个标题,只是加班)
- (instancetype)initWithFrame:(CGRect)frame withViewType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
