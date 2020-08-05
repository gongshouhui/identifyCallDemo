//
//  YSEMSMyTripListViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/14.
//

#import "YSCommonListViewController.h"

typedef enum : NSUInteger {
    YSEMSMyTripTypeTodo,
    YSEMSMyTripTypeDone,
    YSEMSMyTripTypeAll,
} YSEMSMyTripType;

@interface YSEMSMyTripListViewController : YSCommonListViewController

@property (nonatomic, assign) YSEMSMyTripType EMSMyTripType;

@end
