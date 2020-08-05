//
//  YSPMSAccessoryInfoViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/30.
//
//

#import "YSPMSAccessoryInfoViewController.h"
#import "YSPMSInfoDetailHeaderCell.h"

@interface YSPMSAccessoryInfoViewController ()

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation YSPMSAccessoryInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArray = @[@"附件信息",@"类型",@"上传人",@"上传时间"];
    self.title = @"附件详情";
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.tableView registerClass:[YSPMSInfoDetailHeaderCell class] forCellReuseIdentifier:@"AccessoryInfoCell"];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 52*kHeightScale;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10*kHeightScale, kSCREEN_WIDTH, 42*kHeightScale)];
    backView.backgroundColor = [UIColor whiteColor];
    self.infoHeaderView = [[YSPMSInfoHeaderView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [backView addSubview:self.infoHeaderView];
    self.infoHeaderView.positionLabel.text = @"2017年8月";
    
    return backView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPMSInfoDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccessoryInfoCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[YSPMSInfoDetailHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccessoryInfoCell"];
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, kSCREEN_WIDTH, 0, 0);
    [cell.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cell.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80*kWidthScale, 25*kHeightScale));
    }];
    [cell.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cell.contentView.mas_centerY);
        make.left.mas_equalTo(cell.titleLabel.mas_right).offset(17);
        make.size.mas_equalTo(CGSizeMake(180*kWidthScale, 25*kHeightScale));
    }];
    cell.titleLabel.text = _titleArray[indexPath.row%4];
    cell.contentLabel.text = @"后台数据";
    if (indexPath.row%4 == 0) {
        UIButton *lookFileButton = [[UIButton alloc]init];
        lookFileButton.backgroundColor = kUIColor(42, 138, 219, 1.0);
        [lookFileButton setTitle:@"查看" forState:UIControlStateNormal];
        [cell addSubview:lookFileButton];
        [lookFileButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            make.left.mas_equalTo(cell.contentLabel.mas_right).offset(17);
            make.size.mas_equalTo(CGSizeMake(50*kWidthScale, 25*kHeightScale));
        }];
    }
    
    return cell;
}

@end
