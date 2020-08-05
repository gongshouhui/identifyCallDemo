//
//  YSMessageInfoModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/12/11.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface YSMessageInfoDetailModel : NSObject
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *createTime;
//消息类型(1流程知会，2流程消息，3系统提醒，4系统待办，没有该参数为全部)
@property (nonatomic,assign) NSInteger noticeType;
@property (nonatomic,strong) NSString *title;
@property (nonatomic, strong) NSString *sendTime;
@property (nonatomic,assign) NSInteger noReadNumber;
@end

@interface YSMessageInfoModel : NSObject
@property (nonatomic,strong) YSMessageInfoDetailModel *data;
@property (nonatomic,assign) NSInteger total;
@end




NS_ASSUME_NONNULL_END
