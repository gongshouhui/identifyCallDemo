//
//  YSPMSPlanImageListModel.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/10/10.
//

#import <Foundation/Foundation.h>

@interface YSPMSPlanImageListModel : NSObject

@property (nonatomic, strong) NSString *creator;
@property (nonatomic, strong) NSString *percent;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *planInfoProgreeDate;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) NSString *ActualOutput;
@property (nonatomic, strong) NSArray *MqGraphicProgresses;

@end
