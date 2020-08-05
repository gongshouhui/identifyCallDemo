//
//  YSPersonalInformationModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/6/1.
//
//

#import <Foundation/Foundation.h>

@interface YSPersonalInformationModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic,strong) NSString *deptId;

/**
 工号
 */
@property (nonatomic, strong) NSString *no;
@property (nonatomic, strong) NSString *companyName;

/**
 部门名称
 */
@property (nonatomic, strong) NSString *deptName;
/**
 职位
 */
@property (nonatomic, strong) NSString *jobStation;
@property (nonatomic, strong) NSArray *psnorgs;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *companyMobile;
@property (nonatomic, strong) NSString *shortPhone;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *workAddress;

@property (nonatomic, strong) NSString *headImg;
@property (nonatomic, strong) NSString *gender;
/**职级*/
@property (nonatomic,strong) NSString *positionName;
@property (nonatomic,strong) NSString *levelId;
@property (nonatomic, strong) NSString *year;
/**是否优秀员工
 *1优秀员工
 *2非优秀员工
 */
@property (nonatomic, strong) NSString *isExcellentEmployee;

@end
