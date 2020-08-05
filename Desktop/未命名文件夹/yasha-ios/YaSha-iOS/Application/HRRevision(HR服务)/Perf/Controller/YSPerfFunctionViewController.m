//
//  YSPerfFunctionViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/18.
//

#import "YSPerfFunctionViewController.h"

#import "YSPerfPageViewController.h"    // 我的绩效
#import "YSPerfExamListViewController.h"    // 计划审核
#import "YSPerfEvaluaPageController.h"    // 绩效评估
#import "YSHRPerformanceGradeController.h"
#import "YSHRPerformanceRewardController.h"
#import "YSApplicationCell.h"

@interface YSPerfFunctionViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) int i;

@end

@implementation YSPerfFunctionViewController

- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"绩效"];
}

//设置统计离开该模块
- (void)viewWillDisappear:(BOOL)animated {
      [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"绩效"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的绩效";
    [self getDatasourceArray];
    // 引导图不对 切变形 去掉
//    [self addGuideView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    tapGesture.delegate = self;
    tapGesture.numberOfTouchesRequired = 1;
//    [self.view addGestureRecognizer:tapGesture];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    DLog(@"输出=%@", NSStringFromClass([touch.view.superview class]));
    if ([NSStringFromClass([touch.view.superview class]) isEqualToString:@"YSApplicationCell"]) {
        
        return NO;
    }
    return YES;
    
}
- (void)addGuideView {
    NSUserDefaults *userdefaults =YSUserDefaults;
    BOOL isFirst = [userdefaults boolForKey:@"isFirstInterOne"];
    if (!isFirst) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"01绩效首页"]];
        _imageView.frame = self.view.bounds;
        _imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissGuideView)];
        [_imageView addGestureRecognizer:tap];
        
        [[UIApplication sharedApplication].keyWindow addSubview:_imageView];
        [userdefaults setBool:YES forKey:@"isFirstInterOne"];
        [userdefaults synchronize];
    }
}

- (void)dismissGuideView {
    _i += 1;
    if (_i == 1) {
        _imageView.image = [UIImage imageNamed:@"02绩效首页"];     
    }else if (_i == 2) {
        _imageView.image = [UIImage imageNamed:@"03绩效首页"];
    }else{
        [_imageView removeFromSuperview];
    }
    
}


- (void)getDatasourceArray {
    [self.dataSourceArray addObjectsFromArray:[YSDataManager getApplicationsData:@[
  
                                                                                   @{@"id": @"0",
                                                                                     @"name": @"绩效结果",
                                                                                     @"imageName": @"ic_app_hr_results"},
  
  
                                                                                    @{@"id": @"1",
                                                                                     @"name": @"我的绩效",
                                                                                     @"imageName": @"ic_app_hr_myperfor"},
                                                                                   @{@"id": @"2",
                                                                                     @"name": @"计划审核",
                                                                                     @"imageName": @"ic_app_hr_planreview"},
                                                                                   @{@"id": @"3",
                                                                                     @"name": @"绩效评估",
                                                                                     @"imageName": @"ic_app_hr_perforeval"}
//                                                                                      @{@"id": @"4",
//                                                                                     @"name": @"奖励信息",
//                                                                                     @"imageName":@"奖励信息"}
                                                                                   
                                                                                ]]];
    self.imageName = @"绩效banner";
    [self.collectionView reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YSApplicationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    YSApplicationModel *cellModel = self.dataSourceArray[indexPath.row];
    cell.iconModel = cellModel;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YSApplicationModel *model =  self.dataSourceArray[indexPath.row];
    switch ([model.id intValue]) {
        case 0:
        {
            
            YSHRPerformanceGradeController *gradeVC = [[YSHRPerformanceGradeController alloc] init];
//            YSPerfPageViewController *perfPageViewController = [[YSPerfPageViewController alloc] init];
            [self.navigationController pushViewController:gradeVC animated:YES];
            break;
        }
        case 1:
        {
            YSPerfPageViewController *perfPageViewController = [[YSPerfPageViewController alloc] init];
             [self.navigationController pushViewController:perfPageViewController animated:YES];
            break;
        }
        case 2:
        {
            YSPerfExamListViewController *perfExamListViewController = [[YSPerfExamListViewController alloc] init];
            [self.navigationController pushViewController:perfExamListViewController animated:YES];
            break;
        }
        case 3:
        {
            YSPerfEvaluaPageController *perfEvaluaPageController = [[YSPerfEvaluaPageController alloc] init];
            [self.navigationController pushViewController:perfEvaluaPageController animated:YES];
            break;
        }
       case 4:
        {
            YSHRPerformanceRewardController *vc = [[YSHRPerformanceRewardController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
    }
}

@end
