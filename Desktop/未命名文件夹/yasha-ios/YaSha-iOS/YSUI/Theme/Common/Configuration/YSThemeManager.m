//
//  YSThemeManager.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/7/27.
//

#import "YSThemeManager.h"
#import "ZipArchive.h"
#import "YSUIConfigurationDownLoadTemplate.h"
#import "YSScreenImageViewController.h"
NSString *const YSThemeChangedNotification = @"YSThemeChangedNotification";
NSString *const YSThemeBeforeChangedName = @"YSThemeBeforeChangedName";
NSString *const YSThemeAfterChangedName = @"YSThemeAfterChangedName";

@implementation YSThemeManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static YSThemeManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (void)setCurrentTheme:(NSObject<YSThemeProtocol> *)currentTheme {
    BOOL isThemeChanged;
    if (_currentTheme == nil) {//第一次读取默认皮肤设置
        isThemeChanged = NO;
    }else{
        isThemeChanged = _currentTheme == currentTheme?NO:YES;
    }
    NSObject<YSThemeProtocol> *themeBeforeChanged = nil;
    if (isThemeChanged) {
        themeBeforeChanged = _currentTheme;
    }
    _currentTheme = currentTheme;
    [currentTheme setupConfigurationTemplate];
    if (isThemeChanged) {
        [currentTheme setupConfigurationTemplate];
        [[NSNotificationCenter defaultCenter] postNotificationName:YSThemeChangedNotification object:self userInfo:@{YSThemeBeforeChangedName: themeBeforeChanged ?themeBeforeChanged: [NSNull null], YSThemeAfterChangedName: currentTheme ?currentTheme: [NSNull null]}];
    }
}
//工作台图标更换，所以要单独添加一个皮肤更换通知
- (void)checkoutNewSkin {
    
    //获取主题包下载地址
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@common/theme/1",YSDomain] isNeedCache:NO parameters:nil successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            if ([response[@"data"][@"path"] length]) { //x后台有默认的皮肤包
                NSString *skinSign = [YSUserDefaults valueForKey:YSSkinSign];
                NSString *filePath = [YSDocumentPath stringByAppendingPathComponent:[YSUserDefaults valueForKey:YSSkinSign]];
                if (skinSign && [skinSign isEqualToString:response[@"data"][@"sign"]] && [[NSFileManager defaultManager] fileExistsAtPath:filePath]) {//本地已经下载更新过
                    //在delegate启动时已经加载了
                }else{//下载
                    
                    [self downZipWithSkinData:response];
                }
                
            }else{//后台未设置默认皮肤或者下架了节日皮肤
                NSString *localSkinSign = [YSUserDefaults valueForKey:YSSkinSign];
                if (localSkinSign) {//只在本地还有皮肤包时，删除时，做默认皮肤切换
                    //删除皮肤文件
                   
                    NSString *unZipPath = [YSDocumentPath stringByAppendingPathComponent: [YSUserDefaults valueForKey:YSSkinSign]];
                    [[NSFileManager defaultManager] removeItemAtPath:unZipPath error:nil];
                    //删除皮肤标识
                    [YSUserDefaults removeObjectForKey:YSSkinSign];
                    //切回默认皮肤
                    YSUIConfigurationTemplate *defautTemple = [[YSUIConfigurationTemplate alloc]init];
                    self.currentTheme = defautTemple;
                    [YSUserDefaults setObject:@"YSUIConfigurationTemplate" forKey:YSSelectedThemeClassName];
                    //切回默认的APP图标
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                          [YSUtility setAppIconWithName:nil];
                    });
                }
            }
        }
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}
- (void)downZipWithSkinData:(id)skinData {
    NSString *downUrlString = skinData[@"data"][@"path"];
    NSString *saveZipPath = [YSDocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",skinData[@"data"][@"sign"]]];//保存的zip文件夹名字按照皮肤标识来命名
    NSString *unZipPath = [YSDocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",skinData[@"data"][@"sign"]]];
    [YSNetManager ys_downLoadFileWithUrlString:downUrlString parameters:nil savaPath:saveZipPath successBlock:^(id response) {
        if (response) {
            BOOL success = [SSZipArchive unzipFileAtPath:response toDestination:unZipPath];
            if (success) {//解压成功
                //删除上一次保存的皮肤包,首先要保证上一次是存在的
                NSString *lastSkinSign = [YSUserDefaults valueForKey:YSSkinSign];
                if (lastSkinSign && ![lastSkinSign isEqualToString:skinData[@"data"][@"sign"]]) {//和本次标识符不同时删除
                     [[NSFileManager defaultManager] removeItemAtPath:[YSDocumentPath stringByAppendingPathComponent:[YSUserDefaults valueForKey:YSSkinSign]] error:nil];
                }
                //保存或更新皮肤标识符
                [YSUserDefaults setValue:skinData[@"data"][@"sign"] forKey:YSSkinSign];
                [YSUserDefaults synchronize];
                //删除压缩包
                [[NSFileManager defaultManager] removeItemAtPath:saveZipPath error:nil];
                
                // 获取文件路径
                NSString *path = [NSString stringWithFormat:@"%@/skinResource/config.json",unZipPath];
                NSDictionary *dic = [self readLocalFileWithPath:path];
                if (dic) {
                    YSThemeConfigModel *configModel = [YSThemeConfigModel yy_modelWithJSON:dic];
                    if ([configModel.iconName isEqualToString:@"newYear"]) {//bundle里存好的APP图标名字
                        [YSUtility setAppIconWithName:@"newYear"];
                    }
                    
                    //更换皮肤
                    YSUIConfigurationDownLoadTemplate *temple = [[YSUIConfigurationDownLoadTemplate alloc]init];
                    temple.configModel = configModel;
                    self.currentTheme = temple;
                    //删除version data 下次启动app时可以加载新皮肤引导页
                    if (configModel.guidePage.count) {//
                        //这个路径是第三方里面定义的，会有风险
                        NSString *versionPath =  [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Version.data"];//引导页是根据这个来判断的
                        [[NSFileManager defaultManager] removeItemAtPath:versionPath error:nil];
                    }
                }
                
                
            }
            
        }
    } failureBlock:^(NSError *error) {
        
    } downLoadProgress:nil];
    
    
}
// 读取本地JSON文件
- (NSDictionary *)readLocalFileWithPath:(NSString *)path {
    // 将文件数据化
    NSData *data = [NSData dataWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    if (data) {
        return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    }else{
        return nil;
    }
    
}
- (void)addFestivalScreenImage {
    //有下载皮肤标识并且节日闪屏页不为空
    NSString *skinSign = [YSUserDefaults valueForKey:YSSkinSign];
    YSUIConfigurationDownLoadTemplate *downTemple = [[YSUIConfigurationDownLoadTemplate alloc]init];
    CGFloat scale = kSCREEN_WIDTH/kSCREEN_HEIGHT;
    UIImage *screenImage = nil;
    if (scale >= 0.56) {//不带刘海平的比例
        screenImage = [downTemple getImageWithName:[NSString stringWithFormat:@"%@0.56",downTemple.configModel.screenImage]];
    }else{//0.46刘海屏
      screenImage = [downTemple getImageWithName:[NSString stringWithFormat:@"%@0.46",downTemple.configModel.screenImage]];
    }
   
    if (skinSign && screenImage) {
        //显示闪屏页
        UIWindow *window = [[UIWindow alloc] init];
        window.frame = [UIScreen mainScreen].bounds;
        
        window.backgroundColor = [UIColor clearColor];
        
        window.windowLevel = UIWindowLevelStatusBar;
        [window makeKeyAndVisible];
        self.window = window;
        YSScreenImageViewController *vc = [[YSScreenImageViewController alloc]init];
        vc.image = screenImage;
        self.window.rootViewController = vc;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.window = nil;
    });
        
    }
}


@end
