//
//  YSXRMFJDAddressChoseView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/5/27.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSXRMFJDAddressChoseView.h"
#import "YSCRMFJDAddressProvincesModel.h"

@interface YSXRMFJDAddressChoseView ()

@property (nonatomic, strong) NSIndexPath *provincePath;
@property (nonatomic, strong) NSIndexPath *cityPath;
@property (nonatomic, strong) NSIndexPath *areaPath;

@property (nonatomic, strong) NSMutableArray *addressInfoArray;


@end

@implementation YSXRMFJDAddressChoseView
{
    UIView *blackBaseView;
    CGFloat btn1Height;
    CGFloat btn2Height;
    CGFloat btn3Height;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.autoresizesSubviews = NO;
        _provinceArray = [[NSMutableArray alloc]init];
        _cityArray = [[NSMutableArray alloc]init];
        _regionsArray = [[NSMutableArray alloc]init];
        _addressInfoArray = [NSMutableArray new];
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    blackBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    blackBaseView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.7];
//    blackBaseView.alpha = 0;
    [self addSubview:blackBaseView];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHidenGes)];
//    [blackBaseView addGestureRecognizer:tap];
    
    _areaWhiteBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 243*kHeightScale, kSCREEN_WIDTH, 49*kHeightScale)];
    _areaWhiteBaseView.backgroundColor = [UIColor colorWithHexString:@"#F9FAFB"];
    
    [self addSubview:_areaWhiteBaseView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*kWidthScale, 0, kSCREEN_WIDTH, 49*kHeightScale)];
    titleLabel.text = @"所在地区";
    titleLabel.textColor = [UIColor colorWithHexString:@"#111A34"];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(16)];
    [_areaWhiteBaseView addSubview:titleLabel];
    
    UIButton *closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [closeBtn setImage:[UIImage imageNamed:@"CRMYXAddressCloseBtn"] forState:(UIControlStateNormal)];
    [closeBtn addTarget:self action:@selector(tapHidenGes) forControlEvents:(UIControlEventTouchUpInside)];
    [_areaWhiteBaseView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22*kWidthScale, 22*kHeightScale));
        make.right.mas_equalTo(-15*kWidthScale);
        make.centerY.mas_equalTo(0);
    }];
    
    _btnWhiteBaseView = [[UIView alloc] initWithFrame:(CGRectMake(0, CGRectGetMaxY(_areaWhiteBaseView.frame), _areaWhiteBaseView.mj_w, 49*kHeightScale))];
    _btnWhiteBaseView.backgroundColor = [UIColor whiteColor];
    [blackBaseView addSubview:_btnWhiteBaseView];
    
    CGFloat btn_width = kSCREEN_WIDTH/3;
    for (int i = 0; i < 3; i++) {
        UIButton *areaBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        areaBtn.frame = CGRectMake(btn_width * i, 0, btn_width, 49*kHeightScale);
        [areaBtn setTitleColor:[UIColor colorWithHexString:@"#666F83"] forState:UIControlStateNormal];
        areaBtn.tag = 100 + i;
        areaBtn.backgroundColor = [UIColor whiteColor];
        areaBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(16)];
        [areaBtn setTitle:@"" forState:UIControlStateNormal];
        [areaBtn addTarget:self action:@selector(areaBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        areaBtn.userInteractionEnabled = NO;
        [_btnWhiteBaseView addSubview:areaBtn];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(areaBtn.frame)-1, 48*kWidthScale, 2*kHeightScale)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#2F86F6"];
        [_btnWhiteBaseView addSubview:lineView];
        lineView.tag = 300 + i;
        lineView.hidden = YES;
        if (i == 0) {
            areaBtn.userInteractionEnabled = YES;
            [areaBtn setTitle:@"请选择" forState:UIControlStateNormal];
            [areaBtn setTitleColor:[UIColor colorWithHexString:@"#2F86F6"] forState:UIControlStateNormal];
            areaBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            areaBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15*kWidthScale, 0, 0);
            lineView.hidden = NO;
            lineView.frame = CGRectMake(15*kWidthScale, lineView.mj_y, lineView.mj_w, lineView.mj_h);

        }else {
            lineView.center = CGPointMake(areaBtn.center.x, lineView.center.y);

        }
    }
    
    _areaScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_areaWhiteBaseView.frame)+49*kHeightScale, kSCREEN_WIDTH, CGRectGetHeight(self.frame)-kBottomHeight-CGRectGetMaxY(_areaWhiteBaseView.frame)-49*kHeightScale)];
    _areaScrollView.delegate = self;
    _areaScrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, CGRectGetHeight(_areaScrollView.frame));
    _areaScrollView.pagingEnabled = YES;
    _areaScrollView.showsVerticalScrollIndicator = NO;
    _areaScrollView.showsHorizontalScrollIndicator = NO;
    [blackBaseView addSubview:_areaScrollView];
    
    for (int i = 0; i < 3; i++) {
        UITableView *area_tableView = [[UITableView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH * i, 0, kSCREEN_WIDTH, CGRectGetHeight(_areaScrollView.frame)) style:UITableViewStylePlain];
        area_tableView.separatorInset = UIEdgeInsetsMake(0, 15*kWidthScale, 0, 15*kWidthScale);
    
        area_tableView.delegate = self;
        area_tableView.dataSource = self;
        area_tableView.tag = 200 + i;
        [_areaScrollView addSubview:area_tableView];
    }
    
    UIView *bottomView = [[UIView alloc] initWithFrame:(CGRectMake(0, CGRectGetMaxY(_areaScrollView.frame), kSCREEN_WIDTH, kSCREEN_HEIGHT-CGRectGetMaxY(_areaScrollView.frame)))];
    bottomView.backgroundColor = [UIColor whiteColor];
    [blackBaseView addSubview:bottomView];
}
#pragma mark - tapHidenGes
- (void)tapHidenGes
{
    [UIView animateWithDuration:0.25 animations:^{
        blackBaseView.alpha = 0;
        _areaWhiteBaseView.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, 380);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark - areaBtnAction
- (void)areaBtnAction:(UIButton *)btn
{
    for (UIView *view in _btnWhiteBaseView.subviews) {
        if (view.tag >= 300) {
            view.hidden = YES;
        }
    }
    UIView *lineView = [_btnWhiteBaseView viewWithTag:300 + btn.tag - 100];
    lineView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _areaScrollView.contentOffset = CGPointMake(kSCREEN_WIDTH * (btn.tag - 100), 0);
    }];
}
- (void)setProvinceArray:(NSMutableArray *)provinceArray
{
    _provinceArray = provinceArray;
    UITableView *tableView = [_areaScrollView viewWithTag:200];
    [tableView reloadData];
}
- (void)setCityArray:(NSMutableArray *)cityArray
{
    _cityArray = cityArray;
    UITableView *tableView = [_areaScrollView viewWithTag:201];
    [tableView reloadData];
    _areaScrollView.contentSize = CGSizeMake(kSCREEN_WIDTH * 2, CGRectGetHeight(_areaScrollView.frame));
    [UIView animateWithDuration:0.5 animations:^{
        _areaScrollView.contentOffset = CGPointMake(kSCREEN_WIDTH, 0);
    }];
}
- (void)setRegionsArray:(NSMutableArray *)regionsArray
{
    _regionsArray = regionsArray;
    UITableView *tableView = [_areaScrollView viewWithTag:202];
    [tableView reloadData];
    _areaScrollView.contentSize = CGSizeMake(kSCREEN_WIDTH * 3, CGRectGetHeight(_areaScrollView.frame));
    [UIView animateWithDuration:0.5 animations:^{
        _areaScrollView.contentOffset = CGPointMake(kSCREEN_WIDTH * 2, 0);
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableView.tag - 200) {
        case 0:
        {
            return _provinceArray.count;
        }
            break;
        case 1:
        {
            return _cityArray.count;
        }
            break;
        case 2:
        {
            return _regionsArray.count;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50 * kHeightScale;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIButton *btn1 = [_btnWhiteBaseView viewWithTag:100];
    UIButton *btn2 = [_btnWhiteBaseView viewWithTag:101];
    UIButton *btn3 = [_btnWhiteBaseView viewWithTag:102];
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"area_cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"area_cell"];
    }
//    cell.textLabel.highlightedTextColor = [UIColor colorWithHexString:@"#2F86F6"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#111A34"];
    cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(16)];
    switch (tableView.tag - 200) {
        case 0:
        {
            YSCRMFJDAddressProvincesModel *addressAreaModel = _provinceArray[indexPath.row];
            cell.textLabel.text = addressAreaModel.name;
            if ([addressAreaModel.name isEqualToString:btn1.currentTitle]) {
                UIImageView *choseImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CRMYXAddressChoseBtn"]];
                choseImg.frame = CGRectMake(0, 0, 22*kWidthScale, 22*kHeightScale);
                cell.accessoryView = choseImg;
                cell.textLabel.textColor = [UIColor colorWithHexString:@"#2F86F6"];
            }else {
                cell.accessoryView = nil;
                cell.textLabel.textColor = [UIColor colorWithHexString:@"#111A34"];
            }
        }
            break;
        case 1:
        {
            YSCRMFJDAddressProvincesModel *addressAreaModel = _cityArray[indexPath.row];
            cell.textLabel.text = addressAreaModel.name;
            if ([addressAreaModel.name isEqualToString:btn2.currentTitle]) {
                UIImageView *choseImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CRMYXAddressChoseBtn"]];
                choseImg.frame = CGRectMake(0, 0, 22*kWidthScale, 22*kHeightScale);
                cell.accessoryView = choseImg;
                cell.textLabel.textColor = [UIColor colorWithHexString:@"#2F86F6"];
            }else {
                cell.accessoryView = nil;
                cell.textLabel.textColor = [UIColor colorWithHexString:@"#111A34"];
            }
        }
            break;
        case 2:
        {
            YSCRMFJDAddressProvincesModel *addressAreaModel = _regionsArray[indexPath.row];
            cell.textLabel.text = addressAreaModel.name;
            if ([addressAreaModel.name isEqualToString:btn3.currentTitle]) {
                UIImageView *choseImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CRMYXAddressChoseBtn"]];
                choseImg.frame = CGRectMake(0, 0, 22*kWidthScale, 22*kHeightScale);
                cell.accessoryView = choseImg;
                cell.textLabel.textColor = [UIColor colorWithHexString:@"#2F86F6"];
            }else {
                cell.accessoryView = nil;
                cell.textLabel.textColor = [UIColor colorWithHexString:@"#111A34"];
            }
        }
            break;
        default:
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIButton *btn1 = [_btnWhiteBaseView viewWithTag:100];
    UIButton *btn2 = [_btnWhiteBaseView viewWithTag:101];
    UIButton *btn3 = [_btnWhiteBaseView viewWithTag:102];
    
    for (UIView *view in _btnWhiteBaseView.subviews) {
        if (view.tag >= 300) {
            view.hidden = YES;
        }
    }
    
    UIView *lineView1 = [_btnWhiteBaseView viewWithTag:300];
    UIView *lineView2 = [_btnWhiteBaseView viewWithTag:301];
    UIView *lineView3 = [_btnWhiteBaseView viewWithTag:302];
    switch (tableView.tag - 200) {
        case 0:
        {
            
            // 取消上次选中
            if (self.provincePath) {
                UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.provincePath];
                oldCell.accessoryView = nil;
                oldCell.textLabel.textColor = [UIColor colorWithHexString:@"#111A34"];

            }
            self.provincePath = indexPath;
            YSCRMFJDAddressProvincesModel *addressAreaModel = _provinceArray[indexPath.row];
            // addressAreaModel.sh_name
            btn1Height = [YSXRMFJDAddressChoseView getLabelWidth:addressAreaModel.name font:16 height:49*kHeightScale] + 25*kWidthScale;
            [btn1 setTitle:addressAreaModel.name forState:UIControlStateNormal];
            [btn1 setTitleColor:[UIColor colorWithHexString:@"#666F83"] forState:UIControlStateNormal];
            btn1.frame = CGRectMake(btn1.mj_x, btn1.mj_y, btn1Height, btn1.mj_h);
            btn2.frame = CGRectMake(btn1Height, btn2.mj_y, btn2.mj_w, btn2.mj_h);
           
            // 防止第一次选中短的 第二次选中短的 btn2被btn3盖住
            btn3.frame = CGRectMake(CGRectGetMaxX(btn2.frame), btn3.mj_y, btn3.mj_w, btn3.mj_h);
            btn1.userInteractionEnabled = YES;
            btn2.userInteractionEnabled = YES;
            btn3.userInteractionEnabled = NO;
            [btn2 setTitle:@"请选择" forState:UIControlStateNormal];
            [btn2 setTitleColor:[UIColor colorWithHexString:@"#2F86F6"] forState:UIControlStateNormal];
            [btn3 setTitle:@"" forState:UIControlStateNormal];
            
            lineView2.hidden = NO;
            lineView1.frame = CGRectMake(15*kWidthScale, lineView1.mj_y, btn1Height - 25*kWidthScale, lineView1.mj_h);
            lineView2.frame = CGRectMake(btn2.mj_x, lineView2.mj_y, lineView2.mj_w, lineView2.mj_h);
            lineView2.center = CGPointMake(btn2.center.x, lineView2.center.y);
            if ([self.address_delegate respondsToSelector:@selector(selectIndex:selectDataArrayIndexID:)]) {
                if (self.addressInfoArray.count != 0) {
                    [self.addressInfoArray replaceObjectAtIndex:0 withObject:addressAreaModel];
                }else {
                    [self.addressInfoArray addObject:addressAreaModel];
                }
                [self.address_delegate selectIndex:1 selectDataArrayIndexID:indexPath.row];//addressAreaModel.sh_id
            }
        }
            break;
        case 1:
        {
            // 取消上次选中
            if (self.cityPath) {
                UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.cityPath];
                oldCell.accessoryView = nil;
                oldCell.textLabel.textColor = [UIColor colorWithHexString:@"#111A34"];

            }
            self.cityPath = indexPath;
            YSCRMFJDAddressProvincesModel *addressAreaModel = _cityArray[indexPath.row];
            btn2Height = [YSXRMFJDAddressChoseView getLabelWidth:addressAreaModel.name font:16 height:49*kWidthScale] + 25*kWidthScale;//addressAreaModel.sh_name
            [btn2 setTitle:addressAreaModel.name forState:UIControlStateNormal];
            [btn2 setTitleColor:[UIColor colorWithHexString:@"#666F83"] forState:UIControlStateNormal];
            [btn3 setTitle:@"请选择" forState:UIControlStateNormal];
            [btn3 setTitleColor:[UIColor colorWithHexString:@"#2F86F6"] forState:UIControlStateNormal];
            lineView3.hidden = NO;

            btn3.userInteractionEnabled = YES;
            btn2.frame = CGRectMake(btn1Height, btn2.mj_y, btn2Height, btn2.mj_h);
            btn3.frame = CGRectMake(btn1Height + btn2Height, btn3.mj_y, btn3.mj_w, btn3.mj_h);
            
            lineView2.frame = CGRectMake(btn2.mj_x, lineView1.mj_y, btn2Height - 25*kWidthScale, lineView1.mj_h);
            lineView2.center = CGPointMake(btn2.center.x, lineView2.center.y);
            
            lineView3.frame = CGRectMake(btn3.mj_x, lineView3.mj_y, lineView3.mj_w, lineView3.mj_h);
            lineView3.center = CGPointMake(btn3.center.x, lineView3.center.y);

            if ([self.address_delegate respondsToSelector:@selector(selectIndex:selectDataArrayIndexID:)]) {
                if (self.addressInfoArray.count >= 2) {
                    [self.addressInfoArray replaceObjectAtIndex:1 withObject:addressAreaModel];
                }else {
                    [self.addressInfoArray addObject:addressAreaModel];
                }
                [self.address_delegate selectIndex:2 selectDataArrayIndexID:indexPath.row];//addressAreaModel.sh_id
            }
        }
            break;
        case 2:
        {
            // 取消上次选中
            if (self.areaPath) {
                UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.areaPath];
                oldCell.accessoryView = nil;
                oldCell.textLabel.textColor = [UIColor colorWithHexString:@"#111A34"];

            }
            self.areaPath = indexPath;
            YSCRMFJDAddressProvincesModel *addressAreaModel = _regionsArray[indexPath.row];
            btn3Height = [YSXRMFJDAddressChoseView getLabelWidth:addressAreaModel.name font:16 height:30] + 20;
            [btn3 setTitle:addressAreaModel.name forState:UIControlStateNormal];//addressAreaModel.sh_name
            [btn3 setTitleColor:[UIColor colorWithHexString:@"#666F83"] forState:UIControlStateNormal];
            lineView3.hidden = NO;
            /*若下次选择 地址显示上次的值 需要判断显示 是否越界
            if (btn1Height + btn2Height + btn3Height > 375) {
                btn3Height = 375 - (btn1Height + btn2Height);
            }
            lineView3.frame = CGRectMake(btn1Height + btn2Height + 10, 78, btn3Height - 20, 2);
            btn3.frame = CGRectMake(btn1Height + btn2Height, 50, btn3Height, 30);
             */
            if (self.addressInfoArray.count >= 3) {
                [self.addressInfoArray replaceObjectAtIndex:2 withObject:addressAreaModel];
            }else {
                [self.addressInfoArray addObject:addressAreaModel];
            }
            
            [self hidenAreaView];
        }
            break;
        default:
            break;
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *choseImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CRMYXAddressChoseBtn"]];
    choseImg.frame = CGRectMake(0, 0, 22*kWidthScale, 22*kHeightScale);
    cell.accessoryView = choseImg;
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#2F86F6"];

    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    for (UIView *view in _areaWhiteBaseView.subviews) {
        if (view.tag >= 300) {
            view.hidden = YES;
        }
    }
    if (scrollView == _areaScrollView) {
        UIView *lineView = [_areaWhiteBaseView viewWithTag:300 + scrollView.contentOffset.x / kSCREEN_WIDTH];
        lineView.hidden = NO;
    }
    
    
}
#pragma mark - showAreaView
- (void)showAreaView
{
    self.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        blackBaseView.alpha = 0.6;
        _areaWhiteBaseView.frame = CGRectMake(0, 667 - 380, 375, 380);
    }];
}

#pragma mark - hidenAreaView
- (void)hidenAreaView
{
//    UIButton *btn1 = [_btnWhiteBaseView viewWithTag:100];
//    UIButton *btn2 = [_btnWhiteBaseView viewWithTag:101];
//    UIButton *btn3 = [_btnWhiteBaseView viewWithTag:102];
    
    [UIView animateWithDuration:0.25 animations:^{
        blackBaseView.alpha = 0;
        _areaWhiteBaseView.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, 380);
    }completion:^(BOOL finished) {
        self.hidden = YES;
        if ([self.address_delegate respondsToSelector:@selector(getSelectAddressInfor:)]) {
//            NSString *proviceStr = [btn1.currentTitle isEqualToString:@"请选择"] ? @"" : btn1.currentTitle;
//            NSString *cityStr = [btn2.currentTitle isEqualToString:@"请选择"] ? @"" : btn2.currentTitle;
//            NSString *areaStr = [btn3.currentTitle isEqualToString:@"请选择"] ? @"" : btn3.currentTitle;
            [self.address_delegate getSelectAddressInfor:self.addressInfoArray];
        }
        [self removeFromSuperview];
    }];
}
+ (CGFloat)getLabelWidth:(NSString *)textStr font:(CGFloat)fontSize height:(CGFloat)labelHeight
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5 * kWidthScale; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize],NSParagraphStyleAttributeName:paraStyle};
    CGSize size = [textStr boundingRectWithSize:CGSizeMake(1000, labelHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    return size.width;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
