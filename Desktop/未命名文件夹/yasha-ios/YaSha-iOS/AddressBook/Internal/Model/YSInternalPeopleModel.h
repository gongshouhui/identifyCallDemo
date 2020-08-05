//
//  YSInternalPeopleModel.h
//  YaSha-iOS
//
//  Created by mHome on 2016/12/19.
//
//

#import <Foundation/Foundation.h>

@interface YSInternalPeopleModel : NSObject

@property (nonatomic,strong) NSString  *id ; //人员id

@property (nonatomic,strong) NSString *name; //人员姓名

@property (nonatomic,strong) NSString *keyword ; //用于搜索的关键字

@property (nonatomic,strong) NSString *sex ;  //性别

@property (nonatomic,strong) NSString *no ; //人员工号

@property (nonatomic,strong) NSString *companyEmail ; //邮箱

@property (nonatomic,strong) NSString *companyId; //所属单位ID

@property (nonatomic,strong) NSString *companyName;//所属单位名称

@property (nonatomic,strong) NSString *deptId;  //所属部门ID

@property (nonatomic,strong) NSString *deptName ;//所属部门名称

@property (nonatomic,strong) NSString *position ; //岗位

@property (nonatomic,strong) NSString *shortPhone; //短号

@property (nonatomic,strong) NSString *levelId ; //所属级别,等级ID

@property (nonatomic,strong) NSString *levelName;//所属级别

@property (nonatomic,strong) NSString *workAddress;//办公地址

@property (nonatomic,strong) NSString *companyMobile;// 单位手机

@property (nonatomic,strong) NSString *selfMobile;//个人手机

@property (nonatomic,strong) NSString *phone;//固话、座机

@property (nonatomic,strong) NSString *headImg;//头像

@property (nonatomic,strong) NSString *headImage;//头像

@property (nonatomic,assign) int addbool;//是否添加

@property (nonatomic,strong) NSString *jobStation;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
