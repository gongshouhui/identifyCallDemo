//
//  YSUtility.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2016/11/17.
//  Copyright © 2016年 方鹏俊. All rights reserved.
//

#import "YSUtility.h"
#import <JWT.h>
#import <sys/utsname.h>
#import <CommonCrypto/CommonCryptor.h>
#import <GTMBase64.h>
#import "YSPersonalInformationModel.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
#import <Contacts/Contacts.h>
#import <PPGetAddressBook.h>
#import "YSACLModel.h"
#import "CallDirectoryHandler.h"
#import "YSContactDetailViewController.h"
//#import "QYSDK.h"
//密钥
#define gkey          @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCtRmin4ylEzJlTN9ZEYSCi6crpyznFvo5uzBZ5zSkOLFXsPq44MCArmQgUqQw8/pr2JJgf1gr41d7yoBaWzFz18Mq53//i3nbZP0k/rHxZdwDxV8oqBCt77pMrJKQ+fky5yn87ed6JgkEAHWDs20D2KqA+Fl4MhF6375VUn9i4SQIDAQAB"
//偏移量
#define gIv @"01234567"

@implementation YSUtility

+ (BOOL)isLogin {
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
}

+ (void)loginSuccess:(id)response {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:response[@"jwtstr"] forKey:@"jwt"];//
	[userDefaults setObject:response[@"uid"] forKey:@"uid"];//工号
	[userDefaults setObject:response[@"name"] forKey:@"name"];
	[userDefaults setObject:[self getRongCloudToken:response[@"jwtstr"]] forKey:@"RongCloudToken"];
	[userDefaults setBool:YES forKey:@"isLogin"];
	[userDefaults synchronize];
}

+ (void)logout {
	//   ong
	//退出七鱼用户信息
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
		
		NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, addLog];
		NSDictionary *payload = @{
			@"deviceId": @" ",  //极光推送ID清空
			@"platform": @"1",
			@"loginIp": [YSUtility getIPAddress]
		};
		[YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:payload successBlock:^(id response) {
			DLog(@"登录日志:%@", response);
		} failureBlock:^(NSError *error) {
			DLog(@"error:%@", error);
		} progress:nil];
		
	}
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *dictionary = [userDefaults dictionaryRepresentation];
	for(NSString *key in [dictionary allKeys]){
		if ([key isEqualToString:YSSkinSign]) {//下载皮肤标识不必移除
			continue;
		}
		[userDefaults removeObjectForKey:key];
		[userDefaults synchronize];
	}
	[YSDataManager deleteACLDB];
	
	
	//    NSURL *url = [[[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.yasha.group"] URLByAppendingPathComponent:@"default"] URLByAppendingPathExtension:@"realm"];
	//    [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
	//[[NSFileManager defaultManager] removeItemAtPath:@"/private/var/mobile/Containers/Shared/AppGroup/A5885021-3C94-47DD-B590-9BE148FF3CBB/default.realm" error:nil];
}

+ (NSString *)getRongCloudToken:(id)response {
	NSString *secret = @"gufanyuanyingbikongjinweijiandaimayanqianliu";
	NSString *algorithmName = @"HS512";
	JWTBuilder *builder = [JWTBuilder decodeMessage:response].algorithmName(algorithmName).options(@(1));
	NSData *secretData = [[NSData alloc] initWithBase64EncodedString:secret options:0];
	NSString *secretString = secret;
	builder.secretData(secretData);
	NSDictionary *decoded = builder.decode;
	NSData *jsonData = [decoded[@"payload"][@"sub"] dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error = nil;
	NSDictionary *payloadDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
	return payloadDic[@"rongCloudToken"];
}


+ (NSDictionary *)getHTTPHeaderFieldDictionary {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *jwt = [userDefaults objectForKey:@"jwt"];
	if (!jwt) {
		return nil;
	}
	NSMutableDictionary *payload = [NSMutableDictionary dictionary];
	[payload setValue:[userDefaults objectForKey:@"jwt"] forKey:@"jwt"];
	[payload setValue:[NSString stringWithFormat:@"%@-%@", [YSUtility getplatform],[UIDevice currentDevice].systemVersion] forKey:@"device"];
	[payload setValue:[YSUtility getIPAddress] forKey:@"ip"];
	[payload setValue:[YSUtility getCurrentVersion] forKey:@"version"];
	
	NSError *error = nil;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payload options:NSJSONWritingPrettyPrinted error:&error];
	NSString *dataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	NSString *enString = [YSUtility encryptString:dataString];
	return @{
		@"X-Content": enString
	};
}

+ (void)setApplicationIconBadgeNumber {
	NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, getCornerMarkApi];
	[YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
		NSInteger applicationBadgeValue = [[NSString stringWithFormat:@"%@", response[@"data"][@"total"]] integerValue];
		[[UIApplication sharedApplication] setApplicationIconBadgeNumber:applicationBadgeValue];
	} failureBlock:^(NSError *error) {
		DLog(@"error:%@", error);
	} progress:nil];
}

#pragma mark - 获取 NSUserDefaults 中的数据

+ (NSString *)getRongCloudToken {
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"rongCloudToken"];
}

+ (NSString *)getName {
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
}

+ (NSString *)getUID {
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
}

+ (NSString *)getMobile {
	
	RLMResults *results = [YSContactModel objectsWhere:[NSString stringWithFormat:@"userId = '%@'", [self getUID]]];
	if (results.count > 0) {
		YSContactModel *contactModel = results[0];
		return contactModel.mobile;
	}else{
		return nil;
	}
	
}
+ (NSString *)getDeptId {
	RLMResults *results = [YSContactModel objectsWhere:[NSString stringWithFormat:@"userId = '%@'", [self getUID]]];
	if (results.count > 0) {
		YSContactModel *contactModel = results[0];
		return contactModel.deptId;
	}else{
		return nil;
	}
}
+ (NSString *)getAPPName {
	return [NSString stringWithFormat:@"%@", [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"]];
}

+ (NSString *)getAPPVersion {
	return [NSString stringWithFormat:@"%@", [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]];
}

+ (NSString *)getCurrentVersion {
	return [NSString stringWithFormat:@"%@", [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"]];
}

/**
 *  取设备型号标识符，e.g. iPhone8,1
 *
 *  @return 设备型号标识符
 */

+ (NSString *)getplatform {
	
	struct utsname systemInfo;
	uname(&systemInfo);
	NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
	if ([platform isEqualToString:@"x86_64"])     return @"Simulator";
	if ([platform isEqualToString:@"i386"])       return @"Simulator";
	if ([platform isEqualToString:@"iPhone1,1"])  return @"iPhone";
	if ([platform isEqualToString:@"iPhone1,2"])  return @"iPhone 3G";
	if ([platform isEqualToString:@"iPhone2,1"])  return @"iPhone 3GS";
	if ([platform isEqualToString:@"iPhone3,1"])  return @"iPhone 4";
	if ([platform isEqualToString:@"iPhone3,2"])  return @"iPhone 4";
	if ([platform isEqualToString:@"iPhone3,3"])  return @"iPhone 4";
	if ([platform isEqualToString:@"iPhone4,1"])  return @"iPhone 4S";
	if ([platform isEqualToString:@"iPhone5,1"])  return @"iPhone 5";
	if ([platform isEqualToString:@"iPhone5,2"])  return @"iPhone 5c";
	if ([platform isEqualToString:@"iPhone5,3"])  return @"iPhone 5c";
	if ([platform isEqualToString:@"iPhone5,4"])  return @"iPhone 5c";
	if ([platform isEqualToString:@"iPhone6,1"])  return @"iPhone 5s";
	if ([platform isEqualToString:@"iPhone6,2"])  return @"iPhone 5s";
	if ([platform isEqualToString:@"iPhone7,1"])  return @"iPhone 6 Plus";
	if ([platform isEqualToString:@"iPhone7,2"])  return @"iPhone 6";
	if ([platform isEqualToString:@"iPhone8,1"])  return @"iPhone 6s";
	if ([platform isEqualToString:@"iPhone8,2"])  return @"iPhone 6s Plus";
	if ([platform isEqualToString:@"iPhone8,4"])  return @"iPhone SE";
	if ([platform isEqualToString:@"iPhone9,1"])  return @"iPhone 7";
	if ([platform isEqualToString:@"iPhone9,3"])  return @"iPhone 7";
	if ([platform isEqualToString:@"iPhone9,2"])  return @"iPhone 7 Plus";
	if ([platform isEqualToString:@"iPhone9,4"])  return @"iPhone 7 Plus";
	if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
	if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
	if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
	if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
	if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
	if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
	
	return platform;
}
/** 获取当前ios系统版本*/
+ (CGFloat)getSystemVersion {
    
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

#pragma mark - 正则检验

+ (BOOL)isPhomeNumber:(NSString *)phoneNumber {
	NSString *MOBILE = @"^(13[0-9]|14[579]|15[0-3,5-9]|17[0135678]|18[0-9])\\d{8}$";
	NSPredicate *regexmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
	return [regexmobile evaluateWithObject:phoneNumber];
}

+ (BOOL)isEmail:(NSString *)email {
	NSString *EMAIL = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *regexemail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", EMAIL];
	return [regexemail evaluateWithObject:email];
}

+ (BOOL)isIDCode:(NSString *)IDCode {
	NSString *IDCODE = IDCode.length == 15 ? @"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$" : @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$";
	NSPredicate *regexIDCode = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", IDCODE];
	return [regexIDCode evaluateWithObject:IDCode];
}

#pragma mark - 时间处理

+ (NSString *)getCurrentTimestamp {
	NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
	NSTimeInterval timeInterval = [date timeIntervalSince1970];
	NSString *timeString = [NSString stringWithFormat:@"%0.f", timeInterval];
	return timeString;
}

+ (NSString *)formatTimestamp:(NSString *)time Length:(NSUInteger)length {
	if (time == nil || [time isEqual:@""] || !time || [time isEqual:[NSNull null]]) {
		return @"";
	} else if ([time isKindOfClass:[NSString class]] && [time containsString:@"-"]) {
		return time;
	} else {
		double timestamp = [time doubleValue];
		NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000 + 8 * 60 * 60];
		NSString *timeFormat = [NSString stringWithFormat:@"%@", date];
		return [timeFormat substringToIndex:length];
	}
}

+ (NSString *)timestampSwitchTime:(NSString *)timestamp andFormatter:(NSString *)format {
	NSLog(@"------%@",timestamp);
	if ([timestamp isEqual:[NSNull null]] || timestamp == nil) {
		return @"";
	}else{
		NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
		[objDateformat setDateFormat:format];
		//		//设置时区
		//		NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
		//		NSTimeZone *defaultZone = [NSTimeZone defaultTimeZone];
		//		NSLog(@"%@", NSTimeZone.knownTimeZoneNames);
		//		[objDateformat setTimeZone:timeZone];
		NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue] / 1000.0];
		return [objDateformat stringFromDate: date];
	}
}
/** nsdate 转字符串 */
+ (NSString *)stringWithDate:(NSDate *)date andFormatter:(NSString *)format {
	NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
	formatter.dateFormat = format;
	return [formatter stringFromDate:date];
}

// 时间间隔
+ (NSArray*)getTimeIntervalWithFirstTime:(NSString*)beginTimeStr withEndTime:(NSString*)endTimeStr withFormatter:(NSString*)formatterStr {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatterStr];
    NSDate *beginTimeDate = [dateFormatter dateFromString:beginTimeStr];
    NSDate *endTimeDate = [dateFormatter dateFromString:endTimeStr];
    //计算时间间隔（单位是秒）
    NSTimeInterval time = [endTimeDate timeIntervalSinceDate:beginTimeDate];

    //计算天数、时、分、秒
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
    int minutes = ((int)time)%(3600*24)%3600/60;
    int seconds = ((int)time)%(3600*24)%3600%60;
    NSArray *timeArray = @[@(days), @(hours), @(minutes), @(seconds)];
    return timeArray;
}


+ (NSString *)cancelNullData:(id)data {
	if ([data isEqual:[NSNull null]] || data == nil) {
		return @"";
	}else {
		return [NSString stringWithFormat:@"%@",data];
	}
}

+ (NSString *)judgeWhetherOrNot:(id)data {
	if ([data isEqual:[NSNull null]] || data == nil) {
		return @" ";
	}else {
		if ([[NSString stringWithFormat:@"%@",data] isEqualToString:@"0"]) {
			return @"否";
		}else {
			return @"是";
		}
	}
}
+ (NSString *)judgeWhetherOrPass:(id)data {
	if ([data isEqual:[NSNull null]] || data == nil) {
		return @" ";
	}else {
		if ([[NSString stringWithFormat:@"%@",data] isEqualToString:@"0"]) {
			return @"不通过";
		}else {
			return @"通过";
		}
	}
}
+ (NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	
	[formatter setDateStyle:NSDateFormatterMediumStyle];
	
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	
	[formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
	NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
	[formatter setTimeZone:timeZone];
	NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
	//时间转时间戳的方法:
	NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
	
	return timeSp;
}

+ (NSString *)getDate:(NSString *)timestamp {
	double timeInterval = [timestamp doubleValue];
	NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:timeInterval/1000];
	NSString *dateString = [NSString stringWithFormat:@"%@", date];
	return [dateString substringToIndex:10];
}

+ (NSString *)getFileSize:(CGFloat)fileSize {
	if (fileSize < 1024) {
		return [NSString stringWithFormat:@"%.2lfKB", fileSize];
	} else if (fileSize < 1024*1024) {
		return [NSString stringWithFormat:@"%.2lfMB", fileSize/1024.00];
	} else if (fileSize < 1024*1024*1024) {
		return [NSString stringWithFormat:@"%.2lfGB", fileSize/1024.00/1024.00];
	} else {
		return @"未知大小";
	}
}



+ (BOOL)isFileExistAtPath:(NSString*)fileFullPath {
	BOOL isExist = NO;
	isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
	return isExist;
}




+ (UIView *)NoDataView:(NSString *)imageName {
	UIView *noDataview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-64)];
	noDataview.userInteractionEnabled = YES;
	UILabel *label = [[UILabel alloc] init];
	label.backgroundColor = [UIColor colorWithRed:0.82 green:0.82 blue:0.83 alpha:1.00];
	[noDataview addSubview:label];
	[label mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.right.mas_equalTo(noDataview);
		make.height.mas_equalTo(0.5);
	}];
	
	noDataview.backgroundColor=[UIColor whiteColor];
	UIImage * image = [UIImage imageNamed:imageName];
	UIImageView *imageView = [[UIImageView alloc] init];
	imageView.image = image;
	[noDataview addSubview:imageView];
	[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.mas_equalTo(noDataview);
	}];
	
	return noDataview;
}

+ (UIView *)NoMessageView:(NSString *)imageName {
	UIView *noMessageView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, kSCREEN_WIDTH, kSCREEN_HEIGHT-64)];
	noMessageView.backgroundColor = [UIColor whiteColor];
	
	UIImage *image = [UIImage imageNamed:imageName];
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kSCREEN_WIDTH-image.size.width)/2, image.size.height/4, image.size.width, image.size.height)];
	imageView.image = image;
	[noMessageView addSubview:imageView];
	return noMessageView;
}

+ (UIImage *)generateImageWithColor:(UIColor *)color {
	CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, rect);
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

// 传入字符串、字体大小以及尺寸限制，得到字符串对应的尺寸
+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font size:(CGSize)size {
	CGRect rect = [string boundingRectWithSize:size//限制最大的宽度和高度
									   options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
									attributes:@{NSFontAttributeName: font}//传人的字体字典
									   context:nil];
	
	return rect.size;
}

// 设置 UILabel 行间距
+ (NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.lineSpacing = lineSpace;
	NSRange range = NSMakeRange(0, [string length]);
	[attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
	return attributedString;
}

#pragma mark - 获取业务类流程的类

+ (YSFlowModel *)getFlowModelWithProcessDefinitionKey:(NSString *)processDefinitionKey {
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"YSFlowList" ofType:@"plist"];
	NSArray *flowArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
	for (NSDictionary *flowDic in flowArray) {
		NSLog(@"流程：%@  定义key: %@",flowDic[@"name"],flowDic[@"processDefinitionKey"]);
	}
	YSFlowModel *flowModel;
	for (NSDictionary *flowDic in flowArray) {
		if ([flowDic[@"processDefinitionKey"] isEqual:processDefinitionKey]) {
			flowModel = [YSFlowModel yy_modelWithDictionary:flowDic];
		}
	}
	return flowModel;
}

#pragma mark - 加密方法

+ (NSString*)encryptString:(NSString *)string {
	NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
	size_t plainTextBufferSize = [data length];
	const void *vplainText = (const void *)[data bytes];
	
	CCCryptorStatus ccStatus;
	uint8_t *bufferPtr = NULL;
	size_t bufferPtrSize = 0;
	size_t movedBytes = 0;
	
	bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
	bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
	memset((void *)bufferPtr, 0x0, bufferPtrSize);
	
	const void *vkey = (const void *) [gkey UTF8String];
	const void *vinitVec = (const void *) [gIv UTF8String];
	ccStatus = CCCrypt(kCCEncrypt,
					   kCCAlgorithm3DES,
					   kCCOptionPKCS7Padding,
					   vkey,
					   kCCKeySize3DES,
					   vinitVec,
					   vplainText,
					   plainTextBufferSize,
					   (void *)bufferPtr,
					   bufferPtrSize,
					   &movedBytes);
	
	NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
	NSString *result = [GTMBase64 stringByEncodingData:myData];
	return result;
}


//字符串替换
+ (NSString *)removeSpaceAndNewline:(NSString *)str {
	NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
	temp = [temp stringByReplacingOccurrencesOfString:@"-" withString:@""];
	return temp;
}

+ (NSString *)getAvatarUrlString:(NSString *)headImg {
	return headImg;
	//    if (![headImg containsString:@"newp-head"]) {
	//        if (headImg.length > 0) {
	//            NSArray *firstArray = [headImg componentsSeparatedByString:@"/"];
	//            NSString *firstString = firstArray[firstArray.count-1];
	//            NSArray *resultArray = [firstString componentsSeparatedByString:@"."];
	//            NSString *noOrUUID = resultArray[resultArray.count-2];
	//            NSString *md5String = [[[NSString stringWithFormat:@"%@", noOrUUID] MD5Digest] uppercaseString];
	//            NSString *imageUrl = [[[headImg stringByReplacingOccurrencesOfString:@"p-head" withString:@"newp-head"]substringToIndex:headImg.length-noOrUUID.length-1] stringByAppendingFormat:@"%@.jpg", md5String];
	//            return [imageUrl lowercaseStringWithLocale:[NSLocale currentLocale]];
	//        } else {
	//            return @"";
	//        }
	//    } else {
	//        return headImg;
	//    }
}

+ (BOOL)saveTimeStamp:(id)response {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *time = [userDefaults objectForKey:@"aclTimestamp"];
	if (![response[@"data"] isEqual:[NSNull null]]) {
		[userDefaults setObject:response[@"data"] forKey:@"aclTimestamp"];
	}
	return [time isEqual:response[@"data"]] ? YES : NO;
}

+ (BOOL)saveContactsTimestamp:(id)response {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *time = [userDefaults objectForKey:@"contactsTimestamp"];
	if (![response[@"data"] isEqual:[NSNull null]]) {
		[userDefaults setObject:response[@"data"][@"contactsTimestamp"] forKey:@"contactsTimestamp"];
	}
	return [time isEqual:response[@"data"][@"contactsTimestamp"]] ? YES : NO;
}
+ (NSString *)getContactsTimestamp {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *time = [userDefaults objectForKey:@"contactsTimestamp"];
	return time;
}
+ (void)deleteFileWithName:(NSString *)name {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
	//文件名
	NSString *uniquePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:name];
	BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
	if (!blHave) {
		DLog(@"%@", [NSString stringWithFormat:@"没有%@这个文件", name]);
	} else {
		BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
		if (blDele) {
			DLog(@"删除成功！");
		}else {
			DLog(@"删除失败！");
		}
	}
}

+ (NSString *)getIPAddress {
	NSString *ip = @"Error";
	struct ifaddrs *interfaces = nil;
	struct ifaddrs *temp_addr = nil;
	
	int success = getifaddrs(&interfaces);
	if (!success) {
		temp_addr = interfaces;
		while (temp_addr != NULL) {
			if (temp_addr->ifa_addr->sa_family == AF_INET) {
				if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
					ip = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
				}
				if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"pdp_ip0"]) {
					ip = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
				}
			}
			temp_addr = temp_addr->ifa_next;
		}
	}
	freeifaddrs(interfaces);
	return ip;
}

+ (NSString *)replaceStr:(NSString *)phoneStr {
	
	NSString *resultStr = @"";
	if (phoneStr) {
		NSString *searchStr = phoneStr;
		NSString *regExpStr = @"[ ].";
		NSString *replacement = @"";
		NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:regExpStr options:NSRegularExpressionCaseInsensitive error:nil];
		
		resultStr = [regularExpression stringByReplacingMatchesInString:searchStr options:NSMatchingReportProgress range:NSMakeRange(0, searchStr.length) withTemplate:replacement];
	}
	
	return resultStr;
}

+ (BOOL)containEmpty:(NSDictionary *)payload {
	BOOL containEmpty = NO;
	for (id key in payload) {
		NSString *string = [payload objectForKey:key];
		if ([string isEqual:@""]) {
			containEmpty = YES;
		}
	}
	if (containEmpty) {
		QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
		}];
		
		QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"提示" message:@"请输入完整信息！" preferredStyle:QMUIAlertControllerStyleAlert];
		[alertController addAction:action1];
		[alertController showWithAnimated:YES];
	}
	return (containEmpty == YES) ? YES : NO;
}

+ (NSDate *)dateWithString:(NSString *)dataString {
	NSDateFormatter * format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate * date = [format dateFromString:dataString];
	return date;
}

+ (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string limited:(NSInteger)limited {
	NSMutableString *futureString = [NSMutableString stringWithString:textField.text];
	[futureString insertString:string atIndex:range.location];
	NSInteger flag = 0;
	// 这个可以自定义,保留到小数点后两位,后几位都可以
	for (NSInteger i = futureString.length - 1; i >= 0; i--) {
		if ([futureString characterAtIndex:i] == '.') {
			// 如果大于了限制的就提示
			if (flag > limited) {
				[QMUITips showError:[NSString stringWithFormat:@"请控制在小数点后%ld位", limited] inView:[YSUtility getCurrentViewController].view hideAfterDelay:1.0];
				return NO;
			}
			break;
		}
		flag++;
	}
	
	return YES;
}

+ (void)openUrlWithType:(YSOpenUrlType)type urlString:(NSString *)urlString {
	
	urlString =  [YSUtility decimalFromString:urlString];
	if (urlString.length == 0) {
		[QMUITips showError:@"当前无可用电话号码" inView:[YSUtility getCurrentViewController].view hideAfterDelay:1.0];
	} else {
		NSURL *openUrl;
		if (type == YSOpenUrlCall) {
			openUrl = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", urlString]];
			
		} else if (type == YSOpenUrlSendMsg) {
			openUrl = [NSURL URLWithString:[NSString stringWithFormat:@"sms://%@", urlString]];
		}
		if ([[UIDevice currentDevice] systemVersion].floatValue >= 10.0) {
			[[UIApplication sharedApplication] openURL:openUrl options:@{} completionHandler:nil];
		} else {
			[[UIApplication sharedApplication] openURL:openUrl];
		}
	}
}

+ (void)checkAddressBookEnableStatus:(void (^)(BOOL))completion {
	CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
	if (authStatus == CNAuthorizationStatusNotDetermined) {
		[PPGetAddressBook requestAddressBookAuthorization];
	} else if (authStatus == CNAuthorizationStatusRestricted || authStatus == CNAuthorizationStatusDenied) {
		QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction *action) {
		}];
		QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"去设置" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
			NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
			if([[UIApplication sharedApplication] canOpenURL:url]) {
				[[UIApplication sharedApplication] openURL:url];
			}
		}];
		QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"无法访问通讯录" message:@"请在设置中打开通讯录访问权限" preferredStyle:QMUIAlertControllerStyleAlert];
		[alertController addAction:action1];
		[alertController addAction:action2];
		[alertController showWithAnimated:YES];
		completion(NO);
	} else {
		completion(YES);
	}
}

+ (BOOL)checkCameraAuth {
	AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
	if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
		QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction *action) {
		}];
		QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"去设置" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
			NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
			if([[UIApplication sharedApplication] canOpenURL:url]) {
				[[UIApplication sharedApplication] openURL:url];
			}
		}];
		QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在设置中打开相机权限" preferredStyle:QMUIAlertControllerStyleAlert];
		[alertController addAction:action1];
		[alertController addAction:action2];
		[alertController showWithAnimated:YES];
		
		return NO;
	} else {
		return YES;
	}
}

+ (void)checkCallDirectoryEnabledStatus:(void (^)(NSInteger))completion {
	CXCallDirectoryManager *manager = [CXCallDirectoryManager sharedInstance];
	[manager getEnabledStatusForExtensionWithIdentifier:@"com.yasha.ys.YaSha-Call" completionHandler:^(CXCallDirectoryEnabledStatus enabledStatus, NSError * _Nullable error) {
		if (!error) {
			completion(enabledStatus);
			//            if (enabledStatus == CXCallDirectoryEnabledStatusDisabled) {
			//                DLog(@"未授权");
			//
			//            } else if (enabledStatus == CXCallDirectoryEnabledStatusEnabled) {
			//                DLog(@"已授权");
			//                completion(YES);
			//            } else {
			//                DLog(@"未知状态");
			//                completion(NO);
			//            }
		}
	}];
}

+ (UIViewController *)getCurrentViewController {
	//    UIViewController *result = nil;
	//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
	//    if (window.windowLevel != UIWindowLevelNormal) {
	//        for (UIWindow *tempWindow in [[UIApplication sharedApplication] windows]) {
	//            if (tempWindow.windowLevel == UIWindowLevelNormal) {
	//                window = tempWindow;
	//                break;
	//            }
	//        }
	//    }
	//
	//    id  nextResponder = nil;
	//    UIViewController *appRootViewController = window.rootViewController;
	//    if (appRootViewController.presentedViewController) {
	//        nextResponder = appRootViewController.presentedViewController;
	//    } else {
	//        if (window.subviews.count > 0) {
	//            UIView *frontView = [[window subviews] objectAtIndex:0];
	//            nextResponder = [frontView nextResponder];
	//        }
	//    }
	//    if ([nextResponder isKindOfClass:[UITabBarController class]]) {
	//        UITabBarController *tabBarController = (UITabBarController *)nextResponder;
	//        UINavigationController *navigationController = (UINavigationController *)tabBarController.viewControllers[tabBarController.selectedIndex];
	//        result = navigationController.childViewControllers.lastObject;
	//    } else if ([nextResponder isKindOfClass:[UINavigationController class]]) {
	//        UIViewController *viewController = (UIViewController *)nextResponder;
	//        result = viewController.childViewControllers.lastObject;
	//    } else {
	//        result = nextResponder;
	//    }
	//     DLog(@"%@",[NSThread currentThread]);
	//    return result;
	return [self topViewController];
}
#pragma mark - private 获取最上层的VC
+(UIViewController *)topViewController {
	//    UIViewController *result = nil;
	//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
	//    if (window.windowLevel != UIWindowLevelNormal) {
	//        for (UIWindow *tempWindow in [[UIApplication sharedApplication] windows]) {
	//            if (tempWindow.windowLevel == UIWindowLevelNormal) {
	//                window = tempWindow;
	//                break;
	//            }
	//        }
	//    }
	//
	UIViewController *resultVC;
	resultVC = [self topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
	while (resultVC.presentedViewController) {
		resultVC = [self topViewController:resultVC.presentedViewController];
	}
	return resultVC;
}

+(UIViewController *)topViewController:(UIViewController *)vc {
	if ([vc isKindOfClass:[UINavigationController class]]) {
		return [self topViewController:[(UINavigationController *)vc topViewController]];
	} else if ([vc isKindOfClass:[UITabBarController class]]) {
		return [self topViewController:[(UITabBarController *)vc selectedViewController]];
	} else {
		return vc;
	}
}
+ (void)pushToContactDetailViewControllerWithuserId:(NSString *)userId {
	RLMResults *results = [YSContactModel objectsWhere:[NSString stringWithFormat:@"userId = '%@'", userId]];
	if (results.count != 0) {
		YSContactModel *contactModel = results[0];
		YSContactDetailViewController *contactDetailViewController = [[YSContactDetailViewController alloc] init];
		contactDetailViewController.contactModel = contactModel;
		[[YSUtility getCurrentViewController].navigationController pushViewController:contactDetailViewController animated:YES];
	} else {
		[QMUITips showError:@"暂无此人详情信息" inView:[self getCurrentViewController].view hideAfterDelay:1.0];
	}
}


+ (BOOL)checkDatabaseSystemSn:(NSString *)systemSn andModuleSn:(NSString *)moduleSn andCompanyId:(NSString *)companyId andPermissionValue:(NSString *)permissionValue {
	/*
	 0001K310000000000F91    幕墙
	 0001K310000000008TK6    股份
	 0001K310000000000ABV    装饰
	 
	 
	 moduleSn   project_info  信息管理控制权限
	 base_info     单据状态控制权限
	 plan_manager  项目计划管理
	 fran_info     供应链
	 
	 
	 permissionValue  9       全公司权限
	 29      单据状态控制权限
	 2       人员退场权限
	 1       供应链入口权限
	 
	 systemSn   pms    项目信息
	 srm    供应链
	 
	 
	 */
	if (permissionValue == nil) {
		NSString *conditions = [NSString stringWithFormat:@"systemSn = '%@' AND moduleSn = '%@' AND companyId = '%@'",systemSn,moduleSn,companyId];
		return [[YSACLModel objectsWhere:conditions] count] > 0;
	}else if (companyId == nil){
		NSString *conditions = [NSString stringWithFormat:@"systemSn = '%@' AND moduleSn = '%@' AND permissionValue = %d ",systemSn,moduleSn,[permissionValue intValue]];
		return [[YSACLModel objectsWhere:conditions] count] > 0;
	}else{
		NSString *conditions = [NSString stringWithFormat:@"systemSn = '%@' AND moduleSn = '%@' AND companyId = '%@' AND permissionValue = %d ",systemSn,moduleSn,companyId,[permissionValue intValue]];
		return [[YSACLModel objectsWhere:conditions] count] > 0;
	}
	
}
+ (BOOL)checkAuthoritySystemSn:(NSString *)systemSn andModuleSn:(NSArray *)moduleArray andCompanyId:(NSString *)companyId andPermissionValue:(NSString *)permissionValue{
	//systemSn 模块不会空
	NSMutableString *queryString = [[NSMutableString alloc]initWithFormat:@"systemSn = '%@'",systemSn];
	//子模块信息
	for (int i = 0; i < moduleArray.count; i++) {
		if (i == 0) {
			[queryString appendString:[NSString stringWithFormat:@" AND (moduleSn = '%@'",moduleArray[i]]];
		}else {
			[queryString appendString:[NSString stringWithFormat:@" OR moduleSn = '%@'",moduleArray[0]]];
		}
		if (i == moduleArray.count -1) {
			[queryString appendString:@")"];
		}
	}
	//公司id
	if (companyId.length) {
		[queryString appendString:[NSString stringWithFormat:@" AND companyId = '%@'",companyId]];
	}
	//权限（增删改查等）
	[queryString appendString:[NSString stringWithFormat:@" AND permissionValue = %ld",(long)[permissionValue integerValue]]];
	NSInteger count = [[YSACLModel objectsWhere:queryString] count];
	
	return count > 0;
	
}

+ (NSString *)digitalTransformation:(int)num {
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
	NSString *string = [formatter stringFromNumber:[NSNumber numberWithInt:num]];
	NSLog(@"str = %@", string);
	return string;
}
+ (NSString *)positiveFormat:(NSString *)text{
	if(!text || [text floatValue] == 0){
		return @"0.00";
	}else{
		NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
		//numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
		[numberFormatter setPositiveFormat:@",###.00;"];
		return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[text doubleValue]]];
	}
	return @"";
}
/** 返回千分位 */
+ (NSString *)thousandsFormat:(CGFloat)number {
	
	if(number == 0){
		return @"0.00";
	}else{
		NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
		//numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
		[numberFormatter setPositiveFormat:@",###.00;"];
		return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:number]];
	}
}
/** 字符串 转 nsdate*/
+ (NSDate *)dateFromString:(NSString *)string andFormatter:(NSString *)format {
	NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
	formatter.dateFormat = format;
	
	return [formatter dateFromString:string];
}

+(NSMutableAttributedString *)setUpLineSpaceWith:(NSString *)string lineSpace:(CGFloat)size{
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	[paragraphStyle setLineSpacing:size];
	paragraphStyle.alignment = NSTextAlignmentRight;
	NSMutableAttributedString *attiStr = [[NSMutableAttributedString alloc]initWithString:string];
	CGSize strSize = [string boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
	if (strSize.width > kSCREEN_WIDTH - 100*kWidthScale - 15 - 15) {//换行设置行间距
		[attiStr setAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, string.length)];
	}
	return attiStr;
}

+(NSString *)judgeData:(NSString *)str {
	if (!str) {
		return @" ";
	}
	if ([str isKindOfClass:[NSNull class]]) {
		return @" ";
	}
	if (!str.length) {
		return @" ";
	}
	NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	NSString *trimmedStr = [str stringByTrimmingCharactersInSet:set];
	if (!trimmedStr.length) {
		return @" ";
	}
	return str;
}
+ (BOOL)judgeIsEmpty:(NSString*)emptyStr {
	if ([emptyStr isKindOfClass:[NSNull class]])
	{
		return YES;
	}
	if ([emptyStr isEqualToString:@""])
	{
		return YES;
	}
	if (emptyStr == nil )
	{
		return YES;
	}
	if ([[emptyStr  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
	{
		return YES;
	}
	
	return NO;
}

// 计算字符串宽度
+ (CGFloat)calculateRowWidthWithStr:(NSString *)string fontSize:(NSInteger)fontSize controlHeight:(CGFloat)heigh {
	
	NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};//指定字号
	CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, heigh)/*计算宽度要先指定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
				   NSStringDrawingUsesFontLeading attributes:dic context:nil];
	return rect.size.width;
}

+(NSString *)decimalFromString:(NSString *)commonString {
	NSString *truePhone = [[commonString componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
	return truePhone;
}
+(void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal {
	
	CAShapeLayer *shapeLayer = [CAShapeLayer layer];
	
	[shapeLayer setBounds:lineView.bounds];
	
	if (isHorizonal) {
		
		[shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
		
	} else{
		[shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame)/2)];
	}
	
	[shapeLayer setFillColor:[UIColor clearColor].CGColor];
	//  设置虚线颜色为blackColor
	[shapeLayer setStrokeColor:lineColor.CGColor];
	//  设置虚线宽度
	if (isHorizonal) {
		[shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
	} else {
		
		[shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
	}
	[shapeLayer setLineJoin:kCALineJoinRound];
	//  设置线宽，线间距
	[shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
	//  设置路径
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, 0, 0);
	
	if (isHorizonal) {
		CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
	} else {
		CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(lineView.frame));
	}
	
	[shapeLayer setPath:path];
	CGPathRelease(path);
	//  把绘制好的虚线添加上来
	[lineView.layer addSublayer:shapeLayer];
}

+ (void)setAppIconWithName:(NSString *)iconName {
	
	if (@available(iOS 10.3, *)) {
		if (![[UIApplication sharedApplication] supportsAlternateIcons]) {
			return;
		}
		if ([iconName isEqualToString:@""]) {
			iconName = nil;
		}
		[[UIApplication sharedApplication] setAlternateIconName:iconName completionHandler:^(NSError * _Nullable error) {
			if (error) {
				//NSLog(@"更换app图标发生错误了 ： %@",error);
			}
		}];
		
	}
	
	
	
}

@end
