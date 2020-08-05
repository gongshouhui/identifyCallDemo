//
//  YSPublicQuery.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/22.
//

#import <Foundation/Foundation.h>

@interface YSJobLevelModel : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *code;

@end

@interface YSPublicQuery : NSObject

+ (void)getJobLevelListDataCompletion:(void (^)(NSArray *jobLevelList))completion;

@end
