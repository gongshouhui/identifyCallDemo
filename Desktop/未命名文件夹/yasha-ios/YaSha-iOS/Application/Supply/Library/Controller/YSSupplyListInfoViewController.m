//
//  YSSupplyListInfoViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/1/29.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSSupplyListInfoViewController.h"
#import "YSPMSInfoDetailHeaderCell.h"
#import "YSSupplyFinancialViewController.h"  //财务信息
#import "YSSupplyContactViewController.h"    //联系人信息
#import "YSSupplyAddressViewController.h"    //地址信息
#import "YSSupplyBankViewController.h"       //银行信息
#import "YSSupplyCargoController.h"          //供货信息
#import "YSSupplySupplierViewController.h"   //关联供应商

@interface YSSupplyListInfoViewController ()

@property (nonatomic, strong) NSMutableArray *titleArrayOne;
@property (nonatomic, strong) NSMutableArray *titleArrayTwo;
@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, strong) YSSupplyListModel *infoModel;

@end

@implementation YSSupplyListInfoViewController

- (void)initTableView {
    [super initTableView];
    self.title = _model.name;
    _contentArray = [NSMutableArray array];
    _titleArrayOne = [NSMutableArray arrayWithObjects:@"供应商编码",@"供应商简称",@"公司类别",@"供应商分类",@"企业性质",@"销售模式",@"营业执照",@"组织机构代码证",@"税务登记号",@"注册日期",@"企业注册地址",@"注册币种",@"注册资金(万)",@"法人代表",@"经营范围",@"准入评级",@"准入日期",@"失效日期",@"状态", nil];
    _titleArrayTwo = [NSMutableArray arrayWithObjects:@"财务信息",@"联系人信息",@"地址信息",@"银行信息",@"供货信息",@"关联供应商",@"冻结原因",@"黑名单原因", nil];
    if (!_model.isBlackList) {
        [_titleArrayOne removeObject:@"失效日期"];
        [_titleArrayTwo removeObject:@"黑名单原因"];
    }
    if (!_model.isFrozen) {
        [_titleArrayTwo removeObject:@"冻结原因"];
    }
    [self doNetworking];
    [self.tableView registerClass:[YSPMSInfoDetailHeaderCell class] forCellReuseIdentifier:@"SupplyListCellOne"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SupplyListCellTwo"];
}
- (void)doNetworking {
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain, getFranInfoDetailApp, _model.id] isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"========%@",response);
        if (![response[@"data"] isEqual:[NSNull null]]) {
            self.infoModel  = [YSDataManager getSupplyDetailsData:response][0];
            [self.contentArray addObject:self.infoModel.no];
            [self.contentArray addObject:self.infoModel.shortName];
            [self.contentArray addObject:self.infoModel.companyType];
            [self.contentArray addObject:self.infoModel.category];
            [self.contentArray addObject:self.infoModel.comNature];
            [self.contentArray addObject:self.infoModel.saleModel];
            [self.contentArray addObject:self.infoModel.license];
            [self.contentArray addObject:self.infoModel.organ];
            [self.contentArray addObject:self.infoModel.taxNo];
            [self.contentArray addObject: [YSUtility timestampSwitchTime:self.infoModel.registerDate andFormatter:@"yyyy-MM-dd"]];
            [self.contentArray addObject:[NSString stringWithFormat:@"%@%@%@",self.infoModel.province,self.infoModel.city,self.infoModel.area]];
            [self.contentArray addObject:self.infoModel.registerCurrency];
            [self.contentArray addObject:[NSString stringWithFormat:@"%.2f",self.infoModel.registerMoney]];
            [self.contentArray addObject:self.infoModel.legalPerson];
            [self.contentArray addObject:self.infoModel.busScope];
            [self.contentArray addObject:self.infoModel.achieveLevel];
            [self.contentArray addObject:[YSUtility timestampSwitchTime:self.infoModel.admitDate andFormatter:@"yyyy-MM-dd"]];
            if (_model.isBlackList) {
                [self .contentArray addObject:[YSUtility timestampSwitchTime:self.infoModel.invalidDate andFormatter:@"yyyy-MM-dd"]];
            }
            [self.contentArray addObject:self.infoModel.status];
            
        }
        [self.tableView cyl_reloadData];
    } failureBlock:^(NSError *error) {
        DLog(@"========%@",error);
    } progress:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.contentArray.count > 0) {
        if (section == 0) {
            return self.titleArrayOne.count;
        }else{
            return self.titleArrayTwo.count;
        }
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        YSPMSInfoDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SupplyListCellOne" forIndexPath:indexPath];
        cell.titleLabel.text = self.titleArrayOne[indexPath.row];
        if (self.contentArray.count > 0) {
            cell.contentLabel.text = self.contentArray[indexPath.row];
        }
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SupplyListCellTwo" forIndexPath:indexPath];
        cell.textLabel.text = self.titleArrayTwo[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:@"SupplyListCellOne" cacheByIndexPath:indexPath configuration:^(YSPMSInfoDetailHeaderCell *cell) {
            if (self.contentArray.count > 0) {
                if ([self.contentArray[indexPath.row] length]>0) {
                    cell.contentLabel.font = [UIFont systemFontOfSize:13];
                    cell.contentLabel.text = self.contentArray[indexPath.row];
                }else{
                    cell.contentLabel.text = @"设置";
                }
            }
        }] + 10;
    }else{
        return 45*kHeightScale;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                YSSupplyFinancialViewController *SupplyFinancialViewController = [[YSSupplyFinancialViewController alloc]initWithStyle:UITableViewStyleGrouped];
                SupplyFinancialViewController.model = self.infoModel;
                [self.navigationController pushViewController:SupplyFinancialViewController animated:YES];
                break;
            }
            case 1:
            {
                YSSupplyContactViewController *SupplyContactViewController = [[YSSupplyContactViewController alloc]initWithStyle:UITableViewStyleGrouped];
                SupplyContactViewController.id = _model.id;
                [self.navigationController pushViewController:SupplyContactViewController animated:YES];
                break;
            }
            case 2:
            {
                YSSupplyAddressViewController *SupplyAddressViewController = [[YSSupplyAddressViewController alloc]initWithStyle:UITableViewStyleGrouped];
                SupplyAddressViewController.id = _model.id;
                [self.navigationController pushViewController:SupplyAddressViewController animated:YES];
                break;
            }
            case 3:
            {
                YSSupplyBankViewController *SupplyBankViewController = [[YSSupplyBankViewController alloc]initWithStyle:UITableViewStyleGrouped];
                SupplyBankViewController.id = _model.id;
                [self.navigationController pushViewController:SupplyBankViewController animated:YES];
                break;
            }
            case 4:
            {
                YSSupplyCargoController *SupplyCargoController = [[YSSupplyCargoController alloc]initWithStyle:UITableViewStyleGrouped];
                SupplyCargoController.id = _model.id;
                [self.navigationController pushViewController:SupplyCargoController animated:YES];
                break;
            }
            case 5:
            {
                YSSupplySupplierViewController *SupplySupplierViewController = [[YSSupplySupplierViewController alloc]initWithStyle:UITableViewStyleGrouped];
                SupplySupplierViewController.id = _model.id;
                [self.navigationController pushViewController:SupplySupplierViewController animated:YES];
                break;
            }
            case 6:
            {
                [self handleLayoutBlockAndAnimation];
                break;
            }
        }
    }
}

- (void)handleLayoutBlockAndAnimation {
    
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 300*kWidthScale, 350*kHeightScale)];
    contentView.backgroundColor = UIColorWhite;
    contentView.layer.cornerRadius = 6;
    
    UITextView *label = [[UITextView alloc] init];
    //    label.numberOfLines = 0;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:24];
    paragraphStyle.paragraphSpacing = 16;
    NSMutableAttributedString *attributedString;
    if (_model.isFrozen) {
        attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"冻结原因:\n%@",_model.frozenReason] attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColorBlack, NSParagraphStyleAttributeName: paragraphStyle}];
    }
    if (_model.isBlackList) {
        attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"冻结原因:\n%@", _model.frozenReason] attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColorBlack, NSParagraphStyleAttributeName: paragraphStyle}];
    }
    
    NSDictionary *codeAttributes = CodeAttributes(16);
    [attributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        [attributedString addAttributes:codeAttributes range:codeRange];
    }];
    label.attributedText = attributedString;
    [contentView addSubview:label];
    
    UIEdgeInsets contentViewPadding = UIEdgeInsetsMake(20, 20, 20, 20);
    CGFloat contentLimitWidth = CGRectGetWidth(contentView.bounds) - UIEdgeInsetsGetHorizontalValue(contentViewPadding);
    CGSize labelSize = [label sizeThatFits:CGSizeMake(contentLimitWidth, CGFLOAT_MAX)];
    label.frame = CGRectMake(contentViewPadding.left, contentViewPadding.top, contentLimitWidth, 350*kHeightScale);
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = contentView;
    // 以 presentViewController 的形式展示
    [self presentViewController:modalViewController animated:NO completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (UIView *)makePlaceHolderView {
    return [YSUtility NoDataView:@"无数据"];
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
