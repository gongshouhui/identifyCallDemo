//
//  YSSwitchViewController.m
//  YaSha-iOS
//
//  Created by mHome on 2017/4/26.
//
//

#import "YSSwitchViewController.h"
#import "YSComplaintViewController.h"

@interface YSSwitchViewController ()

@property (nonatomic,strong) NSMutableArray * dataArr;

@end

@implementation YSSwitchViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.menuItemWidth = kSCREEN_WIDTH / 4 - 15*kWidthScale;
    }
    return self;
}


- (void)viewDidLoad {

    if ([self.type isEqual:@"70"]) {
        _dataArr = [NSMutableArray arrayWithObjects:@"因公外出",@"其他", nil];
    }else{
        _dataArr = [NSMutableArray arrayWithObjects:@"忘记打卡",@"因公外出",@"其他", nil];
    }
    self.view.backgroundColor = [UIColor redColor];
    self.title = @"申诉";
    [super viewDidLoad];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return _dataArr.count;
}
- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    if ([self.type isEqual:@"70"]) {
        YSComplaintViewController * attendingChird1=[[YSComplaintViewController alloc]init];
        YSComplaintViewController * attendingChird2=[[YSComplaintViewController alloc]init];
        attendingChird1.pageIndex = 1;
        attendingChird2.pageIndex = 2;
        attendingChird1.model = self.model;
        attendingChird2.model = self.model;
        attendingChird1.type = self.type;
        attendingChird2.type = self.type;
        NSArray *viewControllerArray = @[attendingChird1, attendingChird2];
        return viewControllerArray[index];
    }else{
        YSComplaintViewController * attendingChird0=[[YSComplaintViewController alloc]init];
        YSComplaintViewController * attendingChird1=[[YSComplaintViewController alloc]init];
        YSComplaintViewController * attendingChird2=[[YSComplaintViewController alloc]init];
        
        attendingChird0.pageIndex= 0;
        attendingChird1.pageIndex = 1;
        attendingChird2.pageIndex = 2;
        attendingChird0.model = self.model;
        attendingChird1.model = self.model;
        attendingChird2.model = self.model;
        attendingChird0.type = self.type;
        attendingChird1.type = self.type;
        attendingChird2.type = self.type;
        NSArray *viewControllerArray = @[attendingChird0, attendingChird1, attendingChird2];
        return viewControllerArray[index];
    }

}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return _dataArr[index];
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    menuView.backgroundColor = [UIColor whiteColor];
    return CGRectMake(0, 0, kSCREEN_WIDTH, 40*kHeightScale);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 40*kHeightScale, kSCREEN_WIDTH, kSCREEN_HEIGHT);
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
