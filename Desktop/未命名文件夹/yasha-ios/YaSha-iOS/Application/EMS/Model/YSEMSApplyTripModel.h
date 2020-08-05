//
//  YSEMSApplyTripModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/9.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    YSFormRowTypeText,
    YSFormRowTypeTextField,
    YSFormRowTypeOptions,
    YSFormRowTypeSwitch,
} YSFormRowType;

@interface YSEMSApplyTripModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL necessary;
@property (nonatomic, assign) YSFormRowType type;
@property (nonatomic, assign) BOOL arrow;
@property (nonatomic, strong) NSString *value;

@end
