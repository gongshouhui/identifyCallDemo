//
//  YSSingleton.m
//  YaSha-iOS
//
//  Created by mHome on 2016/12/2.
//
//

#import "YSSingleton.h"

@implementation YSSingleton

static YSSingleton *instance;

+(YSSingleton *)getData {
    @synchronized (self) {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    }
    return instance;
}

-(id)init {
    if (self = [super init]) {
        self.selectDataArr = [[NSMutableArray alloc] init];
        self.name = [[NSString alloc] init];
        self.phone = [[NSString alloc] init];
        self.selected = [[NSString alloc] init];
        self.fileArray = [[NSMutableArray alloc] init];
        self.cacheBool = [[NSString alloc] init];
        self.isReset = NO;

    }
    return self;
    
}
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized (self) {
        if (instance == nil) {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}

@end
