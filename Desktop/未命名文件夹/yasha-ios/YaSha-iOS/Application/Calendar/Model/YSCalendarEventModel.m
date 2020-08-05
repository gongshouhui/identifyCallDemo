//
//  YSCalendarEventModel.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/7/25.
//
//

#import "YSCalendarEventModel.h"

@implementation YSCalendarEventModel

+ (YSCalendarEventModel *)initWithEmpty {
    return [[self alloc] initWithEmpty];
}

- (YSCalendarEventModel *)initWithEmpty {
    self.id = @"";
    self.start = @"";
    self.end = @"";
    self.title = @"";
    self.address = @"";
    self.content = @"";
    
    return self;
}

@end
