//
//  YSPublicQuery.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/22.
//

#import "YSPublicQuery.h"

@implementation YSJobLevelModel

@end

@implementation YSPublicQuery

+ (void)getJobLevelListDataCompletion:(void (^)(NSArray *))completion {
    NSMutableArray *mutableArray = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *urlString = [NSString stringWithFormat:@"%@%@/1", YSDomain, getDicInfoApi];
        [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
           
          
                if ([response[@"code"] intValue] == 1) {
                    for (NSDictionary *dic in response[@"data"]) {
                        YSJobLevelModel *model = [YSJobLevelModel yy_modelWithJSON:dic];
                        [mutableArray addObject:@{model.code: model.text}];
                    }
                }
                completion([mutableArray copy]);
        } failureBlock:^(NSError *error) {
           
        } progress:nil];
    });
    completion([mutableArray copy]);
}

@end
