//
//  YSInternalModel.h
//  YaSha-iOS
//
//  Created by mHome on 2016/12/16.
//
//

#import <Foundation/Foundation.h>

@interface YSInternalModel : NSObject

@property (nonatomic, strong) NSString *id;     //id
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *name;   //公司部门或人员姓名
@property (nonatomic, strong) NSString *type;   //类型3.人员2.组织
@property (nonatomic, strong) NSArray *children;
@property (nonatomic, strong) NSString *companyId;  //公司id
@property (nonatomic, strong) NSString *headImg;    //头像 (人员)
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *no;
@property (nonatomic, strong) NSString *position;   //职位(人员)
@property (nonatomic, strong) NSString *jobStation;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
