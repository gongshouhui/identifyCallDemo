//
//  YSSystemMessageView.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/6/6.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSSystemMessageView : UIView

@property (nonatomic, strong) RACSubject *jumpSubject;

- (void)setSystemMessageData:(NSDictionary *)dic andTotalNum:(NSString *)total;
- (void)setReadSystemMessageData:(NSString *)str andTotalNum:(NSString *)total;

@end
