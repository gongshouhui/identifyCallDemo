//
//  YSThemeConfigModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/11/26.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface YSThemeNavBarModel : NSObject
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *titleColor;
@property (nonatomic,strong) NSString *barButtonColor;
@property (nonatomic,assign) BOOL statusBarStytleLightContent;
@end
@interface YSThemeTabBarItemModel : NSObject
@property (nonatomic, strong) NSString *normalImage;

@property (nonatomic, strong) NSString *selectedImage;

@property (nonatomic, strong) NSString *normalTitleColor;

@property (nonatomic, strong) NSString *selectedTitleColor;
@end
@interface YSThemeTabBarModel : NSObject
@property (nonatomic,strong) NSString *background_image;
@property (nonatomic,strong) NSArray<YSThemeTabBarItemModel *> *items;
@end
@interface YSThemeWorkBenchModel : NSObject
@property (nonatomic,strong) NSString *needTodo;
@property (nonatomic, strong) NSString *calendar;
@property (nonatomic, strong) NSString *newsBulletin;
@property (nonatomic, strong) NSString *itemHR;
@property (nonatomic, strong) NSString *assets;
@property (nonatomic, strong) NSString *repair;
@property (nonatomic, strong) NSString *PMSZS;
@property (nonatomic, strong) NSString *PMSMQ;
@property (nonatomic, strong) NSString *supply;
@property (nonatomic, strong) NSString *EMS;
@property (nonatomic, strong) NSString *recharge;
@property (nonatomic, strong) NSString *videoMetting;
@property (nonatomic,strong) NSString *workService;
@property (nonatomic, strong) NSString *add;
@end
@interface YSThemeConfigModel : NSObject
@property (nonatomic,strong) NSString *iconName;
/**压缩包解压相对路径*/
@property (nonatomic,strong) NSString *jsonPath;

@property (nonatomic,strong) NSString *imageFolderPath;
@property (nonatomic, strong) YSThemeWorkBenchModel *workBench;
/**工作台banner*/
@property (nonatomic,strong) NSString *workBenchBanner;

@property (nonatomic, strong) NSString *appIcon;

@property (nonatomic, strong) YSThemeNavBarModel *themeNavi;

@property (nonatomic, strong) NSString *loginImage;

@property (nonatomic, strong) NSString *themeColor;

@property (nonatomic, strong) NSString *personInfoBg;

@property (nonatomic, strong) NSString *meInfoBg;

@property (nonatomic, strong) YSThemeTabBarModel *themeTabbar;
/**节日额外闪屏页*/
@property (nonatomic, strong) NSString *screenImage;
/**引导页图片名字*/
@property (nonatomic,strong) NSArray<NSString *> *guidePage;
@property (nonatomic,strong) NSString *loginBgColor;
@end



NS_ASSUME_NONNULL_END
