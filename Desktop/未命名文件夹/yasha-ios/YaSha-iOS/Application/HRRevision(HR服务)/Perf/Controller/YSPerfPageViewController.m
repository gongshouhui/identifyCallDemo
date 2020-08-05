//
//  YSPerfPageViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/25.
//
//

#import "YSPerfPageViewController.h"
#import "YSPerfListViewController.h"

@interface YSPerfPageViewController ()

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) QMUIPopupMenuView *rightPopupMenuView;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation YSPerfPageViewController
- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"月", @"季", @"年"];
    }
    return _dataArray;
}
- (QMUIPopupMenuView *)rightPopupMenuView {
    if (!_rightPopupMenuView) {
        _rightPopupMenuView = [[QMUIPopupMenuView alloc] init];
        _rightPopupMenuView.automaticallyHidesWhenUserTap = YES;
        _rightPopupMenuView.maskViewBackgroundColor = UIColorMaskWhite;
        _rightPopupMenuView.maximumWidth = 100*kWidthScale;
       _rightPopupMenuView.shouldShowItemSeparator = YES;
        _rightPopupMenuView.separatorInset = UIEdgeInsetsMake(0, _rightPopupMenuView.padding.left, 0, _rightPopupMenuView.padding.right);
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (NSInteger i = 2015; i <= [[[NSDate date] dateByAddingHours:8] year]; i ++) {
            QMUIPopupMenuItem *popupMenuItem = [QMUIPopupMenuItem itemWithImage:UIImageMake(@"") title:[NSString stringWithFormat:@"%zd", i] handler:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"selectPerfYear" object:self userInfo:@{@"year": [NSString stringWithFormat:@"%zd", i]}];
                [_rightPopupMenuView hideWithAnimated:YES];
            }];
            [mutableArray addObject:popupMenuItem];
        }
        _rightPopupMenuView.items = [mutableArray copy];
        _rightPopupMenuView.didHideBlock = ^(BOOL hidesByUserTap) {
            
        };
    }
    return _rightPopupMenuView;
}
- (instancetype)init {
    if (self = [super init]) {
        self.menuItemWidth = kSCREEN_WIDTH / 3 - 15*kWidthScale;
    }
    return self;
}
- (void)viewDidLoad {
     [super viewDidLoad];
    self.title = @"我的绩效";
   
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_rightButton setImage:UIImageMake(@"年份") forState:UIControlStateNormal];
    YSWeak;
    [[_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        YSStrong;
        [strongSelf.rightPopupMenuView showWithAnimated:YES];
        [strongSelf.rightPopupMenuView layoutWithTargetView:strongSelf.rightButton];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    
   
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.dataArray.count;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    YSPerfListViewController *monthPerfListViewController = [[YSPerfListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    monthPerfListViewController.perfType = MonthPerf;
    YSPerfListViewController *qtlyPerfListViewController = [[YSPerfListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    qtlyPerfListViewController.perfType = QtlyPerf;
    YSPerfListViewController *yearPerfListViewController = [[YSPerfListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    yearPerfListViewController.perfType = YearPerf;
    NSArray *viewControllers = @[monthPerfListViewController, qtlyPerfListViewController, yearPerfListViewController];
    
    return viewControllers[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.dataArray[index];
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    menuView.backgroundColor = [UIColor whiteColor];
    return CGRectMake(0, 0, kSCREEN_WIDTH, 40*kHeightScale);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 40*kHeightScale, kSCREEN_WIDTH, kSCREEN_HEIGHT-40*kHeightScale-kTopHeight);
}


@end
