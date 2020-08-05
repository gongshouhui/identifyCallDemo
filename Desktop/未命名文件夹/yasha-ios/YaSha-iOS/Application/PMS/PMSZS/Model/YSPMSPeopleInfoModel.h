//
//  YSPMSPeopleInfoModel.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/6.
//
//

#import <Foundation/Foundation.h>

@interface YSPMSPeopleInfoModel : NSObject

@property(nonatomic,strong)NSString *image;//头像

@property(nonatomic,strong)NSString *name;//姓名

@property(nonatomic,strong)NSString *mobile;//手机号

@property(nonatomic,strong)NSString *code; //工号

@property(nonatomic,strong)NSString *enterDate;//进入时间

@property(nonatomic,strong)NSString *leaveDate;//退场时间

@property(nonatomic,strong)NSString *typeStr;//人员类型

@property(nonatomic,strong)NSString *id;//人员id

@property(nonatomic,strong)NSString *personId;//人员id

@property(nonatomic,strong)NSString *status;//进场状态 "status": 10 待进场； "status": 20在场场； "status": 30 退场
/**项目兼职*/
@property (nonatomic,strong) NSString *partTimeStr;
/**岗位名称*/
@property (nonatomic,strong) NSString *jobStation;


@end
