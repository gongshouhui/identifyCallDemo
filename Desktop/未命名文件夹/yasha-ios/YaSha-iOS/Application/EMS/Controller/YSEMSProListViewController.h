//
//  YSEMSProListViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/21.
//

#import "YSCommonListViewController.h"
#import "YSEMSProListModel.h"

typedef enum : NSUInteger {
    YSEMSProTypeZS,
    YSEMSProTypeMQ,
} YSEMSProType;
typedef void(^ProjectInfoBlock)(NSDictionary *dic);
@interface YSEMSProListViewController : YSCommonListViewController

@property (nonatomic, assign) YSEMSProType EMSProType;
@property (nonatomic,strong) ProjectInfoBlock projectInfoBlock;
@end
