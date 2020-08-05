//
//  YSContactSelectPeopleBottomView.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/9.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSContactSelectPeopleBottomView : UIView

@property (nonatomic, strong) RACSubject *sendSelectAllSubject;
@property (nonatomic, strong) RACSubject *sendConfirmSubject;
@property (nonatomic, strong) QMUIButton *selectedAllButton;
- (void)updateSelectCountWithpDatasourceArray:(NSArray *)datasourceArray andIsRootView:(Boolean) isRootView;

@end
