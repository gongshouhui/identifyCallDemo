//
//  CallDirectoryHandler.m
//  YaSha-Call
//
//  Created by 龚守辉 on 2017/11/21.
//

#import "CallDirectoryHandler.h"
#import <Realm.h>
#import "YSIdentPhoneModel.h"

@interface CallDirectoryHandler () <CXCallDirectoryExtensionContextDelegate>
@end

@implementation CallDirectoryHandler

- (void)beginRequestWithExtensionContext:(CXCallDirectoryExtensionContext *)context {
    context.delegate = self;
    if (context.incremental) {
        [self addOrRemoveIncrementalIdentificationPhoneNumbersToContext:context];
    }else{
        
    }
    
    
    [context completeRequestWithCompletionHandler:nil];
}

- (void)addOrRemoveIncrementalIdentificationPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
    
    RLMRealmConfiguration *configuration = [RLMRealmConfiguration defaultConfiguration];
#if YASHA_DEBUG == 1
    configuration.fileURL = [[[[NSFileManager defaultManager]
                               containerURLForSecurityApplicationGroupIdentifier:@"group.com.yasha.group"] URLByAppendingPathComponent:@"test"] URLByAppendingPathExtension:@"realm"];
#else
    configuration.fileURL = [[[[NSFileManager defaultManager]
                               containerURLForSecurityApplicationGroupIdentifier:@"group.com.yasha.group"] URLByAppendingPathComponent:@"default"] URLByAppendingPathExtension:@"realm"];
#endif
    
    [RLMRealmConfiguration setDefaultConfiguration:configuration];
    
    // 数据迁移
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    // 设置新的架构版本。必须大于之前所使用的版本
    // （如果之前从未设置过架构版本，那么当前的架构版本为 0）
    config.schemaVersion = 10;
    
    
    // 设置模块，如果 Realm 的架构版本低于上面所定义的版本，
    // 那么这段代码就会自动调用
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        // 我们目前还未执行过迁移，因此 oldSchemaVersion == 0
        if (oldSchemaVersion < 10) {
            // 没有什么要做的！
            // Realm 会自行检测新增和被移除的属性
            // 然后会自动更新磁盘上的架构
        }
    };
    
    // 通知 Realm 为默认的 Realm 数据库使用这个新的配置对象
    [RLMRealmConfiguration setDefaultConfiguration:config];
    
    // 现在我们已经通知了 Realm 如何处理架构变化，
    // 打开文件将会自动执行迁移
    [RLMRealm defaultRealm];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults *results = [[YSIdentPhoneModel allObjects] sortedResultsUsingKeyPath:@"phone" ascending:YES];
    [realm commitWriteTransaction];
    if (results.count != 0) {
        [context removeAllIdentificationEntries];
        
        NSMutableArray *allPhoneNumbersArray = [NSMutableArray array];
        NSMutableArray *labelsArray = [NSMutableArray array];
        for (YSIdentPhoneModel *model in results) {
            [allPhoneNumbersArray addObject:[NSString stringWithFormat:@"%zd",model.phone ]];
            [labelsArray addObject:model.name];
        }
	
        for (NSUInteger i = 0; i < allPhoneNumbersArray.count; i ++) {
            CXCallDirectoryPhoneNumber phoneNumber = [allPhoneNumbersArray[i] longLongValue];
            NSString *label = labelsArray[i];
            [context addIdentificationEntryWithNextSequentialPhoneNumber:phoneNumber label:label];
        }
    }
}

#pragma mark - CXCallDirectoryExtensionContextDelegate

- (void)requestFailedForExtensionContext:(CXCallDirectoryExtensionContext *)extensionContext withError:(NSError *)error {
    // An error occurred while adding blocking or identification entries, check the NSError for details.
    // For Call Directory error codes, see the CXErrorCodeCallDirectoryManagerError enum in <CallKit/CXError.h>.
    //
    // This may be used to store the error details in a location accessible by the extension's containing app, so that the
    // app may be notified about errors which occured while loading data even if the request to load data was initiated by
    // the user in Settings instead of via the app itself.
    
    
    
}

@end
