//
//  YSRepotedDetailRecordNoViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/6/10.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSRepotedDetailRecordNoViewController.h"
#import "YSReportedInfoViewController.h"
#import "YSTrackingOtherInfoViewController.h"
#import "YSFlowAttachmentViewController.h"
#import "YSReportFolderAddViewController.h"
#import "YSRetoredModifyGViewController.h"
#import "YSTrackingModifyViewController.h"

@interface YSRepotedDetailRecordNoViewController ()
@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, strong) NSArray *viewControllersArray;
@end

@implementation YSRepotedDetailRecordNoViewController

- (NSArray *)titlesArray {
    if (!_titlesArray) {
        _titlesArray = @[@"报备/评估", @"其他信息"];
    }
    return _titlesArray;
}

- (NSArray *)viewControllersArray {
    if (!_viewControllersArray) {
        if (_isEdit) {
            YSRetoredModifyGViewController *infoVC = [[YSRetoredModifyGViewController alloc] init];
            infoVC.id = self.billid;
            YSTrackingModifyViewController *otherInfoVC = [[YSTrackingModifyViewController alloc] init];
            otherInfoVC.id = self.billid;
            _viewControllersArray = @[infoVC, otherInfoVC];
        }else {
            YSReportedInfoViewController *infoVC = [[YSReportedInfoViewController alloc] init];
            infoVC.id = self.billid;
            YSTrackingOtherInfoViewController *otherInfoVC = [[YSTrackingOtherInfoViewController alloc] init];
            otherInfoVC.id = self.billid;
            _viewControllersArray = @[infoVC, otherInfoVC];
        }
    }
    return _viewControllersArray;
}

- (instancetype)init {
    if (self = [super init]) {
        self.menuItemWidth = kSCREEN_WIDTH / 2 - 15*kWidthScale;
    }
    return self;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    menuView.backgroundColor = [UIColor whiteColor];
    return CGRectMake(0, 0, kSCREEN_WIDTH, 40*kHeightScale);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 40*kHeightScale, kSCREEN_WIDTH, kSCREEN_HEIGHT-40*kHeightScale-kBottomHeight);
}

- (void)viewDidLoad {
    [self titlesArray];
    [self viewControllersArray];
    self.title = self.isEdit ? @"修改项目跟踪详情" : @"项目跟踪详情";
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"附件" position:QMUINavigationButtonPositionRight target:self action:@selector(attachment)];
}

- (void)attachment {
    if (self.isEdit) {
        YSRetoredModifyGViewController *infoVC = self.viewControllersArray[0];
        if ([infoVC.model.proReportInfo.bizStatusStr isEqualToString:@"备案阶段"] && ([infoVC.model.proReportInfo.flowStatusStr isEqualToString:@"输入中"]||[infoVC.model.proReportInfo.flowStatusStr isEqualToString:@"未提交"] || [infoVC.model.proReportInfo.flowStatusStr isEqualToString:@"驳回"])) {
            //可以修改附件
            YSReportFolderAddViewController *folderVC = [YSReportFolderAddViewController new];
            
            [self.navigationController pushViewController:folderVC animated:YES];
        }else {
            // 只能查看
            YSReporetModel *model = infoVC.model;
            if (model.fileVos.count > 0) {
                YSFlowAttachmentViewController *FlowAttachmentViewController = [[YSFlowAttachmentViewController alloc] initWithStyle:UITableViewStyleGrouped];
                FlowAttachmentViewController.attachMentArray = infoVC.model.fileVos;
                [self.navigationController pushViewController:FlowAttachmentViewController animated:YES];
            }else {
                [QMUITips showInfo:@"暂无附件" inView:self.view hideAfterDelay:1];
            }
            
        }
    }else {
        // 只能查看
        YSReportedInfoViewController *infoVC = self.viewControllersArray[0];
        YSReporetModel *model = infoVC.model;
        if (model.fileVos.count > 0) {
            YSFlowAttachmentViewController *FlowAttachmentViewController = [[YSFlowAttachmentViewController alloc] initWithStyle:UITableViewStyleGrouped];
            FlowAttachmentViewController.attachMentArray = infoVC.model.fileVos;
            [self.navigationController pushViewController:FlowAttachmentViewController animated:YES];
        }else {
            [QMUITips showInfo:@"暂无附件" inView:self.view hideAfterDelay:1];
        }
        
    }
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return _titlesArray.count;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return _viewControllersArray[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return _titlesArray[index];
}
- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    DLog(@"切换子控制的信息:%@", info);
    switch ([[info objectForKey:@"index"] integerValue]) {
        case 0:
            {// 基本信息页面
                
            }
            break;
        case 1:
        {// 其他信息页面
            if (_isEdit) {
                YSRetoredModifyGViewController *basicInfoVC = _viewControllersArray[0];
                YSTrackingModifyViewController *trackInfoVC = _viewControllersArray[1];
                trackInfoVC.recordNoDic = [NSMutableDictionary dictionaryWithDictionary:basicInfoVC.recordNoDic];
            }
        }
            break;
        default:
            break;
    }
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
