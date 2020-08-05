//
//  YSIdentPhoneViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/27.
//

#import "YSIdentPhoneViewController.h"
#import "YSFormRowModel.h"
#import "YSFormCommonCell.h"
#import "CallDirectoryHandler.h"
#import "YSIdentPhoneModel.h"
#import "YSIndentPhoneCell.h"
#import "YSIdentPhoneHelpViewController.h"
#import "YSContactModel.h"

@interface YSIdentPhoneViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *configArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) QMUICollectionViewPagingLayout *collectionViewLayout;
@property (nonatomic, strong) NSArray *imageArray;

@end

@implementation YSIdentPhoneViewController

static NSString *cellIdentifier = @"FormCommonCell";

- (NSArray *)configArray {
    if (!_configArray) {
        YSFormRowModel *model0 = [[YSFormRowModel alloc] init];
        model0.title = @"更新号码识别库";
        model0.rowName = @"YSFormDetailCell";
        model0.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        YSFormRowModel *model1 = [[YSFormRowModel alloc] init];
        model1.title = @"清空号码识别库";
        model1.rowName = @"YSFormDetailCell";
        model1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        YSFormRowModel *model2 = [[YSFormRowModel alloc] init];
        model2.title = @"使用帮助";
        model2.rowName = @"YSFormDetailCell";
        model2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _configArray = @[model0, model1, model2];
    }
    return _configArray;
}

- (QMUICollectionViewPagingLayout *)collectionViewLayout {
    if (!_collectionViewLayout) {
        _collectionViewLayout = [[QMUICollectionViewPagingLayout alloc] initWithStyle:QMUICollectionViewPagingLayoutStyleScale];
    }
    return _collectionViewLayout;
}

- (NSArray *)imageArray {
    if (!_imageArray) {
        _imageArray = @[@"CallKit_1", @"CallKit_2", @"CallKit_3", @"CallKit_4"];
    }
    return _imageArray;
}

- (void)initSubviews {
    [super initSubviews];
    self.title = @"号码识别";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[YSFormCommonCell class] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.tableView];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT/3.0*2.0) collectionViewLayout:self.collectionViewLayout];
    self.collectionViewLayout = [[QMUICollectionViewPagingLayout alloc] initWithStyle:QMUICollectionViewPagingLayoutStyleScale];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[YSIndentPhoneCell class] forCellWithReuseIdentifier:@"Cell"];
    self.tableView.tableFooterView = self.collectionView;
    
    self.collectionViewLayout.sectionInset = [self sectionInset];
}

- (UIEdgeInsets)sectionInset {
    return UIEdgeInsetsMake(36, 36, 36, 36);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.configArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFormRowModel *cellModel = self.configArray[indexPath.row];
    YSFormCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[NSClassFromString(cellModel.rowName) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    [cell setCellModel:cellModel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            [self updateIdentificationPhoneNumbers1];
            break;
        }
        case 1:
        {
            [self deleteCallKitData];
            break;
        }
        case 2:
        {
            YSIdentPhoneHelpViewController *identPhoneHelpViewController = [[YSIdentPhoneHelpViewController alloc] init];
            [self.navigationController pushViewController:identPhoneHelpViewController animated:YES];
            break;
        }
    }
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YSIndentPhoneCell *cell = (YSIndentPhoneCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell setNeedsLayout];
    [cell setImageName:self.imageArray[indexPath.row]];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(CGRectGetWidth(collectionView.bounds) - UIEdgeInsetsGetHorizontalValue(self.collectionViewLayout.sectionInset), CGRectGetHeight(collectionView.bounds) - UIEdgeInsetsGetVerticalValue(self.collectionViewLayout.sectionInset) - self.qmui_navigationBarMaxYInViewCoordinator);
    return size;
}
/**更新号码识别库*/
- (void)updateIdentificationPhoneNumbers1 {
	[YSUtility checkCallDirectoryEnabledStatus:^(NSInteger enable) {
		if (enable == CXCallDirectoryEnabledStatusEnabled) {//已授权
            RLMResults *deleteResults = [YSIdentPhoneModel allObjects];
            if (deleteResults.count != 0) {
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm transactionWithBlock:^{
                    [realm deleteObjects:deleteResults];
                }];
                DLog(@"数据库地址:%@", realm.configuration.fileURL);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [QMUITips showLoading:@"号码库写入中，请稍后..." inView:self.view];
            });
            CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            DLog(@"数据库地址:%@", realm.configuration.fileURL);
			//postStatus
            RLMResults *results = [[YSContactModel objectsWhere:@"isOrg = NO and postStatus = '1'"] sortedResultsUsingKeyPath:@"sortNo" ascending:YES];
            DLog(@"========%@==========%zd",results,results.count);
//            [realm commitWriteTransaction];
            for (YSContactModel *model in results) {
                if (model.mobile.length == 11) {
                    RLMResults *results = [YSIdentPhoneModel objectsWhere:[NSString stringWithFormat:@"phone == %zd", [[NSString stringWithFormat:@"%@%@",@"86",[model.mobile substringToIndex:11]] integerValue]]];
                    if (results.count == 0) {
                        YSIdentPhoneModel *identPhoneModel = [[YSIdentPhoneModel alloc]init];
                        identPhoneModel.name = [NSString stringWithFormat:@"%@-%@",model.deptName,model.name];
                        DLog(@"==========%@",model.mobile);
                        identPhoneModel.phone = [[NSString stringWithFormat:@"%@%@",@"86",[model.mobile substringToIndex:11]] integerValue];
                        [realm addObject:identPhoneModel];
                    }
                }
                if (model.shortPhone.length == 6) {
                    DLog(@"----------%@",model.shortPhone);
                    DLog(@"----22222222------%@",model.name);
                    RLMResults *results = [YSIdentPhoneModel objectsWhere:[NSString stringWithFormat:@"phone == %zd",[[model.shortPhone substringToIndex:6] integerValue]]];
                    if (results.count == 0) {
                        YSIdentPhoneModel *identPhoneModel = [[YSIdentPhoneModel alloc]init];
                        identPhoneModel.name = [NSString stringWithFormat:@"%@-%@",model.deptName,model.name];
                        identPhoneModel.phone = [[NSString stringWithFormat:@"%@",[model.shortPhone substringToIndex:6]] integerValue];
                        if (![model.shortPhone isEqual:@"000000"]) {
                            [realm addObject:identPhoneModel];
                        }
                    }
                }
                if (model.shortWorkPhone.length == 6) {
                    RLMResults *results = [YSIdentPhoneModel objectsWhere:[NSString stringWithFormat:@"phone == %zd", [[NSString stringWithFormat:@"%@",[model.shortWorkPhone substringToIndex:6]]integerValue]]];
                    if (results.count == 0) {
                        YSIdentPhoneModel *identPhoneModel = [[YSIdentPhoneModel alloc]init];
                       identPhoneModel.name = [NSString stringWithFormat:@"%@-%@",model.deptName,model.name];
                        identPhoneModel.phone = [[NSString stringWithFormat:@"%@",[model.shortWorkPhone substringToIndex:6]] integerValue];
                        [realm addObject:identPhoneModel];
                    }
                }
                if (model.phone.length == 13) {
                    RLMResults *results = [YSIdentPhoneModel objectsWhere:[NSString stringWithFormat:@"phone == %zd", [[NSString stringWithFormat:@"%@%@",@"86",[[model.phone substringFromIndex:1] stringByReplacingOccurrencesOfString:@"-" withString:@""]] integerValue]]];
                    if (results.count == 0) {
                        YSIdentPhoneModel *identPhoneModel = [[YSIdentPhoneModel alloc]init];
                       identPhoneModel.name = [NSString stringWithFormat:@"%@-%@",model.deptName,model.name];
                        identPhoneModel.phone = [[NSString stringWithFormat:@"%@%@",@"86",[[model.phone substringFromIndex:1] stringByReplacingOccurrencesOfString:@"-" withString:@""]] integerValue];
                        [realm addObject:identPhoneModel];
                    }
                }
            }
            [realm commitWriteTransaction];
            CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
            
           
            
            DLog(@"数据库地址:%@", realm.configuration.fileURL);
            CXCallDirectoryManager *manager = [CXCallDirectoryManager sharedInstance];
            [manager reloadExtensionWithIdentifier:@"com.yasha.ys.YaSha-Call" completionHandler:^(NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [QMUITips hideAllToastInView:self.view animated:YES];
                    if (error) {
                        DLog(@"弹屏数据更新失败:%@", error);
                        [QMUITips showError:@"号码库更新失败" inView:self.view hideAfterDelay:1.5];
                    } else {
                        DLog(@"弹屏数据更新成功");
                        [QMUITips showSucceed:@"号码库更新成功" inView:self.view hideAfterDelay:1.5];
                    }
                });
            }];
		}else if (enable == CXCallDirectoryEnabledStatusDisabled){//未授权
			NSString *title = @"来电阻止与身份识别未授权";
			NSString *message = @"请在设置→电话→来电阻止与身份识别中开启亚厦门户的权限";
			dispatch_async(dispatch_get_main_queue(), ^{
				QMUIAlertAction *action0 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
					/** 慎用.floatValue此方法判断，只适合简单的版本判断 */
					NSURL *url1 = [NSURL URLWithString:@"App-Prefs:root=Privacy&path=PHONE"];
					NSURL *url2	= [NSURL URLWithString:UIApplicationOpenSettingsURLString];
					
					if (@available(iOS 11.0, *)) {
						[[UIApplication sharedApplication] openURL:url2 options:@{} completionHandler:nil];
					} else {
						if ([[UIApplication sharedApplication] canOpenURL:url1]){
							if (@available(iOS 10.0, *)) {
								[[UIApplication sharedApplication] openURL:url1 options:@{} completionHandler:nil];
							} else {
								[[UIApplication sharedApplication] openURL:url1];
							}
						}
					}
					
				}];
				QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:title message:message preferredStyle:QMUIAlertControllerStyleAlert];
				[alertController addAction:action0];
				[alertController showWithAnimated:YES];
			});
		}
    }];

}


- (void)deleteCallKitData {
    RLMResults *deleteResults = [YSIdentPhoneModel allObjects];
    if (deleteResults.count != 0) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm deleteObjects:deleteResults];
        }];
        CXCallDirectoryManager *manager = [CXCallDirectoryManager sharedInstance];
        [manager reloadExtensionWithIdentifier:@"com.yasha.ys.YaSha-Call" completionHandler:^(NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [QMUITips hideAllToastInView:self.view animated:YES];
                if (error) {
                    DLog(@"弹屏数据更新失败:%@", error);
                    [QMUITips showError:@"号码库清空失败" inView:self.view hideAfterDelay:1.5];
                } else {
                    DLog(@"弹屏数据更新成功");
                    [QMUITips showSucceed:@"号码库已清空" inView:self.view hideAfterDelay:1.5];
                }
            });
        }];
    } else {
        [QMUITips showSucceed:@"号码库已清空" inView:self.view hideAfterDelay:1.5];
    }
}

@end
