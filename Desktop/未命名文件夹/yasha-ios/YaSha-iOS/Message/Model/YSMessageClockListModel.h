//
//  YSMessageClockListModel.h
//  YaSha-iOS
//
//  Created by GZl on 2019/12/27.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSMessageClockListModel : NSObject
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *sendTime;//推送时间
@property (nonatomic, copy) NSString *id;
@property (nonatomic, assign) BOOL isPositi;//在打卡记录页面判断 


@end

NS_ASSUME_NONNULL_END
