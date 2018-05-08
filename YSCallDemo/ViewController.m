//
//  ViewController.m
//  YSCallDemo
//
//  Created by 龚守辉 on 2018/5/4.
//  Copyright © 2018年 mianduijifengba. All rights reserved.
//

#import "ViewController.h"
#import "CallDirectoryHandler.h"
#import "YSContactModel.h"
#import <Realm/Realm.h>
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self realmConfiguation];
    // Do any additional setup after loading the view, typically from a nib.
}
//配置数据库用于和扩展程序共享
- (void)realmConfiguation {
    
            NSURL *url = [[[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.yasha.group"] URLByAppendingPathComponent:@"IDCall"] URLByAppendingPathExtension:@"realm"];
            [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
    // APP Group 宿主程序数据库共享
    RLMRealmConfiguration *configuration = [RLMRealmConfiguration defaultConfiguration];
    configuration.fileURL = [[[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.yasha.group"] URLByAppendingPathComponent:@"IDCall"] URLByAppendingPathExtension:@"realm"];
    [RLMRealmConfiguration setDefaultConfiguration:configuration];
    NSLog(@"数据库地址:%@", [RLMRealmConfiguration defaultConfiguration].fileURL);
    // 数据迁移
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    
    
}

//准备数据库
- (IBAction)addPhoneNum:(id)sender {
    
    YSContactModel *contactModel = [[YSContactModel alloc]init];
    contactModel.name = @"张珊";
    contactModel.phone = 8617196631806;
    YSContactModel *contactTwo = [[YSContactModel alloc]init];
    contactTwo.name = @"李思";
    contactTwo.phone = 8615639073943;
    YSContactModel *contactthree = [[YSContactModel alloc]init];
    contactthree.name = @"李五";
    contactthree.phone = 8617303762002;
    YSContactModel *contactfour = [[YSContactModel alloc]init];
    contactfour.name = @"李刘";
    contactfour.phone = 8615439073846;
    YSContactModel *contactfive = [[YSContactModel alloc]init];
    contactfive.name = @"李奇";
    contactfive.phone = 8615638973942;
    NSArray *contactArr = @[contactModel,contactTwo,contactthree,contactfour,contactfive];

    RLMRealm *realm = [RLMRealm defaultRealm];
//    [realm beginWriteTransaction];
//    [realm deleteAllObjects];
//    [realm commitWriteTransaction];
    
    [realm beginWriteTransaction];
     [realm deleteAllObjects];
    [realm addObjects:contactArr];
    [realm commitWriteTransaction];
    
    
    [realm beginWriteTransaction];
    RLMResults *results = [[YSContactModel allObjects] sortedResultsUsingKeyPath:@"phone" ascending:YES];
    [realm commitWriteTransaction];
    NSLog(@"results---%@",results);
    
    
}

//检测授权
- (IBAction)checkAuthorization:(id)sender {
    // 获取权限状态
    CXCallDirectoryManager *manager = [CXCallDirectoryManager sharedInstance];
    // 获取权限状态
    //call target的标识符
    [manager getEnabledStatusForExtensionWithIdentifier:@"yasuo.YSCallDemo.CallExtension" completionHandler:^(CXCallDirectoryEnabledStatus enabledStatus, NSError * _Nullable error) {
        if (!error) {
            NSString *title = nil;
            if (enabledStatus == CXCallDirectoryEnabledStatusDisabled) {
                /*
                 CXCallDirectoryEnabledStatusUnknown = 0,
                 CXCallDirectoryEnabledStatusDisabled = 1,
                 CXCallDirectoryEnabledStatusEnabled = 2,
                 */
                title = @"未授权，请在设置->电话授权相关权限";
            }else if (enabledStatus == CXCallDirectoryEnabledStatusEnabled) {
                title = @"已经授权";
            }else if (enabledStatus == CXCallDirectoryEnabledStatusUnknown) {
                title = @"不知道";
            }
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:title
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"有错误"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}
//更新号码，扩展程序从共享的数据库读取数据
- (IBAction)updatePhone:(id)sender {
    CXCallDirectoryManager *manager = [CXCallDirectoryManager sharedInstance];
   
    [manager reloadExtensionWithIdentifier:@"yasuo.YSCallDemo.CallExtension" completionHandler:^(NSError * _Nullable error) {
        
        if (error == nil) {
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                        
                                                                           message:@"更新成功"
                                        
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                            
                                                                  handler:^(UIAlertAction * action) {}];
            
            
            
            [alert addAction:defaultAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }else{
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                        
                                                                           message:@"更新失败"
                                        
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                            
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
