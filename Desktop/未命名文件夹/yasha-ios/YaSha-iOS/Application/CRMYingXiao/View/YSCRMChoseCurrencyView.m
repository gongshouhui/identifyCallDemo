//
//  YSCRMChoseCurrencyView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/5/27.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCRMChoseCurrencyView.h"

@interface YSCRMChoseCurrencyView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation YSCRMChoseCurrencyView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.dataArray = @[@"美元", @"人民币"].mutableCopy;
        self.backgroundColor = [UIColor whiteColor];
        [self loadSubView];
    }
    return self;
}

- (void)loadSubView {
    _titLab = [[UILabel alloc] init];
    _titLab.textColor = [UIColor colorWithHexString:@"#111A34"];
    _titLab.text = @"人民币";
    _titLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(18)];
    _titLab.backgroundColor = [UIColor whiteColor];
    [self addSubview:_titLab];
    [_titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.mas_equalTo(0);
        make.height.mas_equalTo(57*kHeightScale);
    }];
    UIImageView *topImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico-下拉"]];
    [self addSubview:topImg];
    [topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.mas_equalTo(_titLab);
        make.left.mas_equalTo(_titLab.mas_right).offset(17);
    }];
    UILabel *lineLab = [[UILabel alloc] init];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#E2E4EA"];
    [self addSubview:lineLab];
    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, 1*kHeightScale));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(_titLab.mas_bottom);
    }];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 55*kHeightScale;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F9FAFB"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:(CGRectZero)];
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, 176*kHeightScale));
        make.top.mas_equalTo(_titLab.mas_bottom).offset(1*kHeightScale);
        make.left.mas_equalTo(0);
    }];
    
    UIButton *bottomBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    bottomBtn.backgroundColor = [UIColor whiteColor];
    [bottomBtn setTitleColor:[UIColor colorWithHexString:@"#666F83"] forState:(UIControlStateNormal)];
    [bottomBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    bottomBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(18)];
    [self addSubview:bottomBtn];
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom);
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kSCREEN_WIDTH);
    }];
    @weakify(self);
    [[bottomBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(didTableViewCellWith:)]) {
            [self removeFromSuperview];
            [self.delegate didTableViewCellWith:nil];
        }
        [self removeFromSuperview];
    }];
}

#pragma mark--tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sysCellCRM"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[ UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"sysCellCRM"];
    }
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.text = self.dataArray[indexPath.row];
    nameLab.textColor = [UIColor colorWithHexString:@"#41485D"];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(16)];
    [cell.contentView addSubview:nameLab];
    if ([self.dataArray[indexPath.row] isEqualToString:self.titLab.text]) {
        nameLab.textColor = [UIColor colorWithHexString:@"#2F86F6"];
    }
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didTableViewCellWith:)]) {
        NSString *formatterStr = @"¥"; ;
        if ([self.dataArray[indexPath.row] isEqualToString:@"美元"]) {
            formatterStr = @"$";
        }else if ([self.dataArray[indexPath.row] isEqualToString:@"欧元"]) {
            formatterStr = @"€";
        }
        [self.delegate didTableViewCellWith:formatterStr];
        [self removeFromSuperview];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
