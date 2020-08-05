//
//  YSFlowElectronicDataViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/21.
//

#import "YSFlowElectronicDataViewController.h"
#import "YSNewsAttachmentCell.h"
#import "YSPMSInfoHeaderView.h"
#import "YSNewsAttachmentViewController.h"
#import "YSNewsAttachmentModel.h"

@interface YSFlowElectronicDataViewController ()

@property (nonatomic,strong) YSPMSInfoHeaderView *infoHeaderView;

@end

@implementation YSFlowElectronicDataViewController

- (void)initTableView {
    [super initTableView];
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    [self.tableView registerClass:[YSNewsAttachmentCell class] forCellReuseIdentifier:@"FlowElectronicDataCell"];
    [self doNetworking];
}

- (void)doNetworking {
    [QMUITips hideAllTipsInView:self.view];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.applyInfosArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.applyInfosArray[section][1] count];
}

- (CGFloat)tableView:(UITableView *)tableView  heightForHeaderInSection:(NSInteger)section {
    return 52*kHeightScale;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10*kHeightScale, kSCREEN_WIDTH, 42*kHeightScale)];
    backView.backgroundColor = [UIColor whiteColor];
    self.infoHeaderView = [[YSPMSInfoHeaderView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [backView addSubview:self.infoHeaderView];
    NSMutableArray *headlineArray = [NSMutableArray array];
    for (NSArray *arr in self.applyInfosArray) {
        [headlineArray addObject:arr[0]];
    }
    self.infoHeaderView.positionLabel.text = headlineArray[section];
    return backView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60*kHeightScale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSNewsAttachmentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[YSNewsAttachmentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FlowElectronicDataCell"];
    }
    [cell setElectronicData:self.applyInfosArray[indexPath.section][1]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for (NSDictionary *dic in self.applyInfosArray[indexPath.section][1]) {
        DLog(@"--------%@",dic[@"viewPath"]);
        YSNewsAttachmentModel *model = [[YSNewsAttachmentModel alloc]init];
        model.viewPath = dic[@"viewPath"];
        model.filePath = dic[@"filePath"];
        YSNewsAttachmentViewController *NewsAttachmentViewController = [[YSNewsAttachmentViewController alloc]init];
        NewsAttachmentViewController.attachmentModel = model;
        [self.navigationController pushViewController:NewsAttachmentViewController animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"电子资料";
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
