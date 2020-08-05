//
//  YSUICommonDefines.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/4.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#ifndef YSUICommonDefines_h
#define YSUICommonDefines_h
//皮肤包标识符
#define YSSkinSign @"YSSkinSign"
#define YSUserDefaults [NSUserDefaults standardUserDefaults]
#define YSDocumentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

// 新增的亚厦控股没有id 用死值;遇到控股的id 转换成 @""或者是集团的id(部门选择树处使用)
//#define KYSCompanyFalseID @"12345678910ASDFGHJKL"//亚厦控股
//#define KYSCompanyTrueID @"1001K310000000027A0J"//亚厦集团

/**
 屏幕适配参数宏
 */

// 屏幕大小、宽、高
#define kSCREEN_BOUNDS [UIScreen mainScreen].bounds
#define kSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define BIZ (kSCREEN_WIDTH/375.0)
#define CGRects(x,y,w,h) CGRectMake(x*BIZ,y*BIZ,w*BIZ,h*BIZ)
#define Multiply(_size) _size*BIZ

// 判断 iPhone X xr,xsmax 
#define IS_IPHONEX (([[UIScreen mainScreen] bounds].size.height - 812.0) >= 0 ? YES : NO)
// 以6/6s为准宽度缩小系数
#define kWidthScale [UIScreen mainScreen].bounds.size.width / 375.0
// 高度缩小系数，适配iPhone X
#define kHeightScale [UIScreen mainScreen].bounds.size.height / ((IS_IPHONEX) ? 812.0 : 667.0)
// Tabbar默认高度
#define kTabBarHeight ((IS_IPHONEX) ? 83.0 : 49.0)
// 状态栏默认高度
#define kStatusBarHeight ((IS_IPHONEX) ? 44.0 : 20.0)
// 导航栏默认高度
#define kNavigationBarHeight 44.0
// 状态栏加导航栏高度
#define kTopHeight (kStatusBarHeight + kNavigationBarHeight)
// WMPageMenu高度
#define kMenuViewHeight 44.0
// 底部高度
#define kBottomHeight ((IS_IPHONEX) ? 34.0 : 0.0)

// 文件大小限定
#define KfileSize 35.0// 单位默认是 MB

/**
 常用颜色
 */
#define kThemeColor YSThemeManagerShare.currentTheme.themeTintColor
#define kBlueColor [UIColor colorWithRed:0.16 green:0.58 blue:0.88 alpha:1.00]
#define kUIColor(_red, _green, _blue, _alpha) [UIColor colorWithRed:_red / 255.0f green:_green / 255.0f blue:_blue / 255.0f alpha:_alpha]
#define kGrayColor(_color) [UIColor colorWithRed:_color / 255.0f green:_color / 255.0f blue:_color / 255.0f alpha:1]

/**
 功能权限
 */

#define ZScompanyId  @"0001K310000000000ABV"  //装饰公司ID
#define MQcompanyId  @"0001K310000000000F91"  //幕墙公司ID
#define CRMSystem    @"crm"      //营销报备评估权限
#define Infomanagement  @"pms"                //装饰项目管理
#define MQInfomanagement @"mqpms"             //装饰项目管理
#define SupplySystem  @"srm"                  //供应链系统
#define ZSInfoManagementModel @"project_info" //装饰信息Model
#define ZSPlanManagementModel @"plan_manager" //装饰进度Model
#define MQPlanManagementModel @"mq_plan_info" //幕墙进度Model
#define  ZSModuleIdentification @"base_info" //装饰信息
#define MQModuleIdentification @"new_base_info"//幕墙信息
#define SupplyModel @"fran_info"              //供应链-供应商库Model
#define MaterialModel @"mtrl_info"            //供应链-材料管理Model
#define TenderModel  @"tender_bid"            //供应链-招标管理Model
#define ZSPlanModel @"zs_plan_info"           //装饰计划Model
#define ZSAllPriCompanyModel @"pro_permission" //装饰全公司权限Model
#define ZSStatusModel @"base_info"             //装饰信息单据控制Model
#define PermissionQueryValue @"1"              //查询权限
#define MQPeopleInfoPermissionValue @"2"        //幕墙人员信息退场权限
#define ZSAllPriCompanyPermissionValue @"9"      //装饰全公司权限permissionValue
#define ZSStatusPermissionValue  @"29"           //装饰信息单据控制permissionValue
#define MQPeopleExitPermissionValue  @"46"      //幕墙人员退场控制权限
#define MQPeopleEnterPermissionValue @"45"      //幕墙人员进场控制权限

//模块权限
#define EMSAuthority @"综合费用平台"      //EMS权限
#if YASHA_DEBUG == 1
#define EAMAuthority @"EAM测试"      //固定资产权限
#else
#define EAMAuthority @"资产管理"      //固定资产权限
#endif

/**
 QMUI 常用宏，详见 QMUICommonDefines.h
 */
// 定义图片：UIImageMake
// 定义字体大小：UIFontMake
// 定义颜色：UIColorMake

/**
 通知宏
 */

// 选人结果（单选）的Notification
#define KNotificationPostSelectedPerson @"KNotificationPostSelectedPerson"
#define KNotificationPostSelectedOrg @"KNotificationPostSelectedOrg"

// 选人结果（多选）的Notification
#define KNotificationPostSelectedPeolple @"KNotificationPostSelectedPeolple"
#define KNotificationPostSelectedMoreOrgs @"KNotificationPostSelectedMoreOrgs"

#endif /* YSUICommonDefines_h */
