//
//  YSUtility.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2016/11/17.
//  Copyright © 2016年 方鹏俊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YSFlowModel.h"

typedef enum : NSUInteger {
    YSOpenUrlCall,
    YSOpenUrlSendMsg,
} YSOpenUrlType;

@interface YSUtility : NSObject

/** 获取登录状态 */
+ (BOOL)isLogin;
/** 登录成功，保存用户信息 */
+ (void)loginSuccess:(id)response;
/** 退出登录，清除用户数据 */
+ (void)logout;
/** 登录成功时获取融云Token */
+ (NSString *)getRongCloudToken:(id)response;
/** 获取统一jwtstr请求头 */
+ (NSDictionary *)getHTTPHeaderFieldDictionary;
/** 设置角标 */
+ (void)setApplicationIconBadgeNumber;

/** 获取融云Token */
+ (NSString *)getRongCloudToken;
/** 获取姓名 */
+ (NSString *)getName;
/** 获取工号 */
+ (NSString *)getUID;
/** 获取手机号 */
+ (NSString *)getMobile;
/**获取部门ID*/
+ (NSString *)getDeptId;
/** 获取APP名 */
+ (NSString *)getAPPName;
/** 获取版本号 */
+ (NSString *)getAPPVersion;
/** 获取版本号 */
+ (NSString *)getCurrentVersion;
/** 获得手机版本号 */
+ (NSString *)getplatform;
/** 获取当前ios系统版本*/
+ (CGFloat)getSystemVersion;


/** 校验手机号 */
+ (BOOL)isPhomeNumber:(NSString *)phoneNumber;
/** 检验邮箱 */
+ (BOOL)isEmail:(NSString *)email;
/** 检验身份证号 */
+ (BOOL)isIDCode:(NSString *)IDCode;

/** 获取时间戳 */
+ (NSString *)getCurrentTimestamp;
/** 转换时间戳 */
+ (NSString *)formatTimestamp:(NSString *)time Length:(NSUInteger)length;
/** 时间戳转时间 */
+ (NSDate *)dateWithString:(NSString *)dataString;
/** 时间戳转时间 */
+ (NSString *)timestampSwitchTime:(NSString *)timestamp andFormatter:(NSString *)format;
/** nsdate 转字符串 */
+ (NSString *)stringWithDate:(NSDate *)date andFormatter:(NSString *)format;
/** 字符串 转 nsdate*/
+ (NSDate *)dateFromString:(NSString *)string andFormatter:(NSString *)format;

+ (NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;
/** 获取时间 */
+ (NSDate *)getDate:(NSString *)timestamp;

/// 计算两个时间之间的间隔
/// @param beginTimeStr 开始的时间间隔
/// @param endTimeStr 结束的时间间隔
+ (NSArray*)getTimeIntervalWithFirstTime:(NSString*)beginTimeStr withEndTime:(NSString*)endTimeStr withFormatter:(NSString*)formatterStr;

/** 获取文件大小 fileSize以KB为初始单位*/
+ (NSString *)getFileSize:(CGFloat)fileSize;




/** 获取业务类流程的类 */
+ (YSFlowModel *)getFlowModelWithProcessDefinitionKey:(NSString *)processDefinitionKey;



// 无数据页面
+ (UIView *)NoDataView:(NSString *)imageName;

// 无消息页面
+ (UIView *)NoMessageView:(NSString *)imageName;


+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font size:(CGSize)size;//自适应高度

/** 设置 UILabel 行间距 */
+ (NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace;

+ (NSString*)encryptString:(NSString*)string;

/** 色值转图片 */
+ (UIImage *)generateImageWithColor:(UIColor *)color;

//字符串替换
+ (NSString *)removeSpaceAndNewline:(NSString *)str;

+ (NSString *)getAvatarUrlString:(NSString *)headImg;

/** 保存权限时间戳 */
+ (BOOL)saveTimeStamp:(id)response;

/** 保存通讯录时间戳 */
+ (BOOL)saveContactsTimestamp:(id)response;
/** 获取通讯录时间戳 */
+ (NSString *)getContactsTimestamp;
+ (void)deleteFileWithName:(NSString *)name;

//获得IP地址
+ (NSString *)getIPAddress;

//正则表达式替换字符
+ (NSString *)replaceStr:(NSString *)phoneStr;

/** 检查字典中是否有空value，用于检查提交数据时填写是否完整 */
+ (BOOL)containEmpty:(NSDictionary *)payload;

/** 控制小数点后几位 */
+ (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string limited:(NSInteger)limited;

/** 拨打电话、短信 */
+ (void)openUrlWithType:(YSOpenUrlType)type urlString:(NSString *)urlString;

/** 检查访问通讯录权限 */
+ (void)checkAddressBookEnableStatus:(void (^)(BOOL))completion;
/** 检查相机权限 */
+ (BOOL)checkCameraAuth;
/** 检查电话识别权限 */
+ (void)checkCallDirectoryEnabledStatus:(void (^)(NSInteger phoneStatus))completion;
/** 获取当前控制器 */
+ (UIViewController *)getCurrentViewController;
/** 跳转到人员详情 */
+ (void)pushToContactDetailViewControllerWithuserId:(NSString *)userId;

+ (NSString *)cancelNullData:(NSString *)data;

/** 权限控制 */
+ (BOOL)checkDatabaseSystemSn:(NSString *)systemSn andModuleSn:(NSString *)moduleSn andCompanyId:(NSString *)companyId andPermissionValue:(NSString *)permissionValue;
/** 权限控制 */
+ (BOOL)checkAuthoritySystemSn:(NSString *)systemSn andModuleSn:(NSArray *)moduleArray andCompanyId:(NSString *)companyId andPermissionValue:(NSString *)permissionValue;
/** 小写阿拉伯数字转为“一、二” */
+ (NSString *)digitalTransformation:(int)num;
/** 返回千分位 */
+ (NSString *)positiveFormat:(NSString *)text;
/** 返回千分位 */
+ (NSString *)thousandsFormat:(CGFloat)number;
/**返回带行间距的富文本*/
+(NSMutableAttributedString *)setUpLineSpaceWith:(NSString *)string lineSpace:(CGFloat)size;
//判断字符串是否为空
+(NSString *)judgeData:(NSString *)str;
/**
 判断字符串是否为空
 
 @param emptyStr 字符串
 @return  字符串为空返回YES,反之NO
 */
+ (BOOL)judgeIsEmpty:(NSString*)emptyStr;

/**
 计算字符串的宽度

 @param string 所要计算的字符串
 @param fontSize 字号大小
 @param heigh 高度
 @return 返回字符串的宽度
 */
+ (CGFloat)calculateRowWidthWithStr:(NSString *)string fontSize:(NSInteger)fontSize controlHeight:(CGFloat)heigh;
//判断是否
+ (NSString *)judgeWhetherOrNot:(id)data;
//判断是否通过
+ (NSString *)judgeWhetherOrPass:(id)data;
/**从字符串中获取纯数字123456789*/
+(NSString *)decimalFromString:(NSString *)commonString;
+(void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal;
/**换APP图标,如果名字传空就用默认主图标*/
+(void)setAppIconWithName:(NSString *)iconName;

/**字典转json*/
-(NSString*)convertToJsonData:(NSDictionary*)dict;


@end
