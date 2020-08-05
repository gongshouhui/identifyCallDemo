//
//  YSCalendarGrantPeopleModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/2.
//

#import <Foundation/Foundation.h>

@interface YSCalendarGrantPeopleModel : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, assign) int grantType;
@property (nonatomic, strong) NSString *grantPersonName;
@property (nonatomic, strong) NSString *grantedPersonName;
@property (nonatomic, strong) NSString *grantPersonNo;
@property (nonatomic, strong) NSString *grantedPersonNo;


@end
