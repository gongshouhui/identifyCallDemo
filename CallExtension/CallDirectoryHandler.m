//
//  CallDirectoryHandler.m
//  CallExtension
//
//  Created by 龚守辉 on 2018/5/4.
//  Copyright © 2018年 mianduijifengba. All rights reserved.
//

#import "CallDirectoryHandler.h"
#import <Realm/Realm.h>
#import "YSContactModel.h"
@interface CallDirectoryHandler () <CXCallDirectoryExtensionContextDelegate>
@end

@implementation CallDirectoryHandler

- (void)beginRequestWithExtensionContext:(CXCallDirectoryExtensionContext *)context {
    context.delegate = self;

//    if (context.isIncremental) {
//        [self addOrRemoveIncrementalBlockingPhoneNumbersToContext:context];
//
//        [self addOrRemoveIncrementalIdentificationPhoneNumbersToContext:context];
//    } else {
//        [self addAllBlockingPhoneNumbersToContext:context];
//
//        [self addAllIdentificationPhoneNumbersToContext:context];
//    }
    [self addOrRemoveIncrementalIdentificationPhoneNumbersToContext:context];
    //[self addAllIdentificationPhoneNumbersToContext:context];
    
    [context completeRequestWithCompletionHandler:nil];
}

- (void)addAllBlockingPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
    // Retrieve phone numbers to block from data store. For optimal performance and memory usage when there are many phone numbers,
    // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
    //
    // Numbers must be provided in numerically ascending order.
    CXCallDirectoryPhoneNumber allPhoneNumbers[] = { 861719663180, 8617303762002 };
    NSUInteger count = (sizeof(allPhoneNumbers) / sizeof(CXCallDirectoryPhoneNumber));
    for (NSUInteger index = 0; index < count; index += 1) {
        CXCallDirectoryPhoneNumber phoneNumber = allPhoneNumbers[index];
        [context addBlockingEntryWithNextSequentialPhoneNumber:phoneNumber];
    }
}

- (void)addOrRemoveIncrementalBlockingPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
    // Retrieve any changes to the set of phone numbers to block from data store. For optimal performance and memory usage when there are many phone numbers,
    // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
    CXCallDirectoryPhoneNumber phoneNumbersToAdd[] = { 14085551234 };
    NSUInteger countOfPhoneNumbersToAdd = (sizeof(phoneNumbersToAdd) / sizeof(CXCallDirectoryPhoneNumber));

    for (NSUInteger index = 0; index < countOfPhoneNumbersToAdd; index += 1) {
        CXCallDirectoryPhoneNumber phoneNumber = phoneNumbersToAdd[index];
        [context addBlockingEntryWithNextSequentialPhoneNumber:phoneNumber];
    }

    CXCallDirectoryPhoneNumber phoneNumbersToRemove[] = { 18005555555 };
    NSUInteger countOfPhoneNumbersToRemove = (sizeof(phoneNumbersToRemove) / sizeof(CXCallDirectoryPhoneNumber));
    for (NSUInteger index = 0; index < countOfPhoneNumbersToRemove; index += 1) {
        CXCallDirectoryPhoneNumber phoneNumber = phoneNumbersToRemove[index];
        [context removeBlockingEntryWithPhoneNumber:phoneNumber];
    }

    // Record the most-recently loaded set of blocking entries in data store for the next incremental load...
}

- (void)addAllIdentificationPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
    // Retrieve phone numbers to identify and their identification labels from data store. For optimal performance and memory usage when there are many phone numbers,
    // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
    //
    // Numbers must be provided in numerically ascending order.
    CXCallDirectoryPhoneNumber allPhoneNumbers[] = { 861719663180, 8617303762002 };
    NSArray<NSString *> *labels = @[ @"Telemarketer", @"Local business" ];
    NSUInteger count = (sizeof(allPhoneNumbers) / sizeof(CXCallDirectoryPhoneNumber));
    for (NSUInteger i = 0; i < count; i += 1) {
        CXCallDirectoryPhoneNumber phoneNumber = allPhoneNumbers[i];
        NSString *label = labels[i];
        [context addIdentificationEntryWithNextSequentialPhoneNumber:phoneNumber label:label];
    }
}

- (void)addOrRemoveIncrementalIdentificationPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
    
    //配置数据库
    RLMRealmConfiguration *configuration = [RLMRealmConfiguration defaultConfiguration];
    configuration.fileURL = [[[[NSFileManager defaultManager]
                               containerURLForSecurityApplicationGroupIdentifier:@"group.com.yasha.group"] URLByAppendingPathComponent:@"IDCall"] URLByAppendingPathExtension:@"realm"];
    [RLMRealmConfiguration setDefaultConfiguration:configuration];
    RLMRealm *realm = [RLMRealm defaultRealm];
    
   
    
    [realm beginWriteTransaction];
    RLMResults *results = [[YSContactModel allObjects] sortedResultsUsingKeyPath:@"phone" ascending:YES];
    [realm commitWriteTransaction];
    if (results.count != 0) {
        [context removeAllIdentificationEntries];
        
        NSMutableArray *allPhoneNumbersArray = [NSMutableArray array];
        NSMutableArray *labelsArray = [NSMutableArray array];
        for (YSContactModel *model in results) {
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
