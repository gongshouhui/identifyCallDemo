//
//  YSFlowModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/3.
//

#import <Foundation/Foundation.h>

@interface YSFlowModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *processDefinitionKey;
@property (nonatomic, strong) NSString *className;
@property (nonatomic, assign) BOOL isMobile;
@property (nonatomic, assign) BOOL isNewInterface;
@end
