//
//  YSCalendarEventModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/7/25.
//
//

#import <Foundation/Foundation.h>

@interface YSCalendarEventModel : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *start;
@property (nonatomic, strong) NSString *end;
@property (nonatomic, assign) int week;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *content;

+ (YSCalendarEventModel *)initWithEmpty;

@end
