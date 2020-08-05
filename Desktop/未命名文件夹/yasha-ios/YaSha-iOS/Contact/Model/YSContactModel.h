//
//  YSContactModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/8.
//Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Realm/Realm.h>

@interface YSContactModel : RLMObject

@property NSString *pid;//父id
@property NSString *num;//主键，编号
@property BOOL isOrg;
@property BOOL isSelected;

@property NSString *deptId;// 部门ID
//@property NSString *parentDeptId;
//@property NSString *companyEmail;
@property NSString *id;// ID
//@property NSString *viewSubDeptStaff;
@property NSString *isPublic;// 0 不显示，1/2/3显示
//@property NSString *levelId;
@property NSString *deptName;//部门名称
@property BOOL showContact;// 是否显示联系方式（1：显示；0：不显示[只显示工号部门岗位]）
//@property NSString *interests;
@property NSString *userId;//工号
//@property NSString *parentDeptName;
//@property NSString *selfMobile;
@property NSString *email;// 公司邮箱地址
@property NSString *jobStation;// 职位
//@property NSString *selfEmail;
@property NSString *name;// 名称
@property NSString *mobilePhone;
@property NSString *status;// 状态(0-未到岗，1-已到岗)
@property NSString *companyId;//公司ID
@property NSString *pNum;// 当前树节点父节点编号
//@property NSString *qqNo;
@property NSString *mobile;
@property NSString *shortPhone; //短号
//@property NSString *weiBlog;
//@property NSString *keyword;
@property BOOL sex;
@property NSString *postStatus;// 在岗状态 0 未到岗  1已在岗
//@property NSString *weixinNo;
@property NSString *workAddress;// 工作地址
@property NSString *type;//类型 1.公司(既为公司也为部门) 2.部门
@property NSString *shortWorkPhone;// 座机短号
//@property NSString *companyMobile;
//@property NSString *levelName;
@property NSString *phone;// 座机号码
@property NSString *companyName;//公司名称
@property NSString *headImg;// 头像
//@property NSString *showDept;
@property NSInteger sortNo;// 排序号
@property NSString *delFlag;// 是否删除，0：已删除，1：未删除
@property NSString *updateTime;//修改时间
@property NSString *createTime;//创建时间
@property NSString *synTime;
@property NSString *updator;
@property NSString *creator;
@property NSString *syn;
@property NSString *synStatus;
//1优秀员工 非优秀员工
@property NSString *isExcellentEmployee;



@end
