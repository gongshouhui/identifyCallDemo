//
//  YSYSPMSMQEarilyPrePlanPresent.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/10/18.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class YSPMSMQEarilyPrePlanPresent;
@protocol YSPMSMQEarilyPrePlanPresentDelegate <NSObject>
- (void)earilyPrePlanPresent:(YSPMSMQEarilyPrePlanPresent *)present didGetData:(id)result;
@end

@interface YSPMSMQEarilyPrePlanPresent : NSObject
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) NSMutableArray *startDelayArray;
@property (nonatomic,strong) NSMutableArray *endDelayArray;
@property (nonatomic,weak) id<YSPMSMQEarilyPrePlanPresentDelegate> view;
- (void)getListDataWithProjectCode:(NSString *)code Complete:(void(^)(id result,NSString *error)) completeBlock failure:(void(^)(NSError *error)) failureBlock;
@end

NS_ASSUME_NONNULL_END
