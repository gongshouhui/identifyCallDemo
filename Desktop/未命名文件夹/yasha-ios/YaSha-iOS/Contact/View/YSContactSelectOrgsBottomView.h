//
//  YSContactSelectOrgsBottomView.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/12.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSContactSelectOrgsBottomView : UIView

@property (nonatomic, strong) RACSubject *sendSelectAllSubject;
@property (nonatomic, strong) RACSubject *sendConfirmSubject;

- (void)updateSelectCountWithpNum:(NSString *)pNum;

@end
