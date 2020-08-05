//
//  YSSingleton.h
//  YaSha-iOS
//
//  Created by mHome on 2016/12/2.
//
//

#import <Foundation/Foundation.h>

@interface YSSingleton : NSObject

@property (nonatomic, strong) NSMutableArray *selectDataArr;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *selected;
@property (nonatomic, strong) NSMutableArray *fileArray;
@property (nonatomic, strong) NSString  *cacheBool;
@property (nonatomic, assign) BOOL isReset;

+ (YSSingleton *)getData;

@end
