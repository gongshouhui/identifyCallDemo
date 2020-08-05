//
//  YSAttendanceWFooterView.h
//  YaSha-iOS
//
//  Created by GZl on 2019/12/13.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ImageSelectBtnBlock)(NSArray *imgArray);

@interface YSAttendanceWFooterView : UITableViewHeaderFooterView

@property (nonatomic, strong) UITextView *markTV;
@property (nonatomic, strong) UILabel *markLab;
@property (nonatomic, copy) ImageSelectBtnBlock selectedImageBlock;
@property (nonatomic, copy) NSString *totlaNum;//总字数
@property (nonatomic, strong) UILabel *numberLab;


@end

NS_ASSUME_NONNULL_END
