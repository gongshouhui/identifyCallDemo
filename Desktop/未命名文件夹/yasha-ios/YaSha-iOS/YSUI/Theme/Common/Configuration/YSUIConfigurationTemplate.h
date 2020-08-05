//
//  YSUIConfigurationTemplate.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/7/28.
//

#import <Foundation/Foundation.h>
#import "YSThemeProtocol.h"

/**
 *  QMUIConfigurationTemplate 是一份配置表，用于配合 QMUIKit 来管理整个 App 的全局样式，使用方式如下：
 *  1. 在 QMUI 项目代码的文件夹里找到 QMUIConfigurationTemplate 目录，把里面所有文件复制到自己项目里。
 *  2. 在自己项目的 AppDelegate 里 #import "QMUIConfigurationTemplate.h"，然后在 application:didFinishLaunchingWithOptions: 里调用 [QMUIConfigurationTemplate setupConfigurationTemplate]，即可让配置表生效。
 *  3. 更新 QMUIKit 的版本时，请留意 Release Log 里是否有提醒更新配置表，请尽量保持自己项目里的配置表与 QMUIKit 里的配置表一致，避免遗漏新的属性。
 */
@interface YSUIConfigurationTemplate : NSObject<YSThemeProtocol>

@end
