//
//  YSSupplyMaterialInfoPageViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/14.
//

#import "YSSupplyMaterialInfoPageViewController.h"
#import "YSSupplyMaterialPriceViewController.h"
#import "YSSupplyMaterialInfoViewController.h"
#import <SDCycleScrollView.h>

@interface YSSupplyMaterialInfoPageViewController ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic,strong) NSMutableArray *subViewControllers;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@end

@implementation YSSupplyMaterialInfoPageViewController
- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"基本信息",@"限价信息"];
    }
    return _dataArray;
}
- (NSMutableArray *)subViewControllers {
    if (!_subViewControllers) {
        _subViewControllers = [NSMutableArray arrayWithCapacity:2];
        YSSupplyMaterialInfoViewController *supplyMaterialInfoViewController = [[YSSupplyMaterialInfoViewController alloc]initWithStyle:UITableViewStylePlain];
        //刷新轮播图
        [supplyMaterialInfoViewController setCycleScrollViewRefresh:^(NSArray *imageUrls) {
            _cycleScrollView.imageURLStringsGroup = imageUrls;
            if (imageUrls.count > 0) {
                _cycleScrollView.placeholderImage = [UIImage new];
            }
            _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        }];
        supplyMaterialInfoViewController.materialID = self.materialID;
        [_subViewControllers addObject:supplyMaterialInfoViewController];
        YSSupplyMaterialPriceViewController *supplyMaterialPriceViewController = [[YSSupplyMaterialPriceViewController alloc]initWithStyle:UITableViewStyleGrouped];
        supplyMaterialPriceViewController.materialID = self.materialID;
        [_subViewControllers addObject:supplyMaterialPriceViewController];
    }
    return _subViewControllers;
}
//- (instancetype)init {
//    if (self = [super init]) {
//        self.menuItemWidth = kSCREEN_WIDTH/2 - 15*kWidthScale;
//    }
//    return self;
//}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.dataArray.count;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    return self.subViewControllers[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.dataArray[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 147*kHeightScale, kSCREEN_WIDTH, 40);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 187*kHeightScale, kSCREEN_WIDTH, kSCREEN_HEIGHT-187*kHeightScale - 64);
}


- (void)viewDidLoad {
   
    [super viewDidLoad];
     //self.menuItemWidth = kSCREEN_WIDTH/2 - 15*kWidthScale;
    //self.title = @"材料信息";
    [self doNetworking];
    [self createCycleScorllView];
}
- (void)createCycleScorllView
{
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 147*kHeightScale ) delegate:self placeholderImage:[UIImage imageNamed:@"材料信息_banner"]];
    _cycleScrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_cycleScrollView];
}
- (void)doNetworking {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
