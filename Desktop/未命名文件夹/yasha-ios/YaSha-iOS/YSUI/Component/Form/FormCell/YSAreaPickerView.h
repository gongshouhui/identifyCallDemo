//
//  YSAreaPickerView.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/16.
//

#import <UIKit/UIKit.h>

/** 使用方法
 YSAreaPickerView *areaPickerView = [[YSAreaPickerView alloc] init];
 [areaPickerView.sendAddressSubject subscribeNext:^(YSAreaModel *areaModel) {
    DLog(@"选择的地址:%@%@%@", areaModel.province, areaModel.city, areaModel.area);
 }];
 */

typedef enum : NSUInteger {
    YSAreaPickerProvince,
    YSAreaPickerCity,
    YSAreaPickerArea,
} YSAreaPickerType;

@interface YSAreaPickerView : UIView

@property (nonatomic, assign) YSAreaPickerType areaPickerType;
@property (nonatomic, strong) RACSubject *sendAddressSubject;
@property (nonatomic, strong) RACSubject *sendCancelSubject;

@end

@interface YSProvinceModel : NSObject

//@property (nonatomic, strong) NSString *province;
//@property (nonatomic, strong) NSString *provinceCode;
//@property (nonatomic, strong) NSString *city;
//@property (nonatomic, strong) NSString *cityCode;
//@property (nonatomic, strong) NSString *area;
//@property (nonatomic, strong) NSString *areaCode;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSArray *cities;

@end

@interface YSCityModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSArray *areas;

@end

@interface YSAreaModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;

@end

@interface YSAddressModel : NSObject

@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *provinceCode;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *areaCode;

@end
