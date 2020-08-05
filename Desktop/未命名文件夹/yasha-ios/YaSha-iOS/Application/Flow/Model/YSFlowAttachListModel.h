//
//  YSFlowAttachListModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/30.
//

#import <Foundation/Foundation.h>

@interface YSFlowAttachListModel : NSObject

@end

@interface YSFlowAttachPSListModel : NSObject

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *creator;
@property (nonatomic, strong) NSString *procFormId;
@property (nonatomic, strong) NSArray *mobileFileVos;

@end

@interface YSFlowAttachFlowListModel : NSObject

@end

