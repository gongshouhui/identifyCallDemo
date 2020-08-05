//
//  YSCRMEnumChoseGView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/6/4.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCRMEnumChoseGView.h"

@interface YSCRMEnumChoseGView ()<PGPickerViewDataSource, PGPickerViewDelegate>

@property (nonatomic, assign) NSInteger choseIndex;

@end

@implementation YSCRMEnumChoseGView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        _dataArray = [NSMutableArray new];
        self.backgroundColor = [UIColor colorWithHexString:@"#F9FAFB"];
        _choseIndex = 0;
        [self loadSubViews];
    }
    return self;
}


- (void)loadSubViews {
    
    _cancelBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(18)];
    [_cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#666F83"] forState:(UIControlStateNormal)];
    [self addSubview:_cancelBtn];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15*kWidthScale);
        make.height.mas_equalTo(23*kHeightScale);
        make.top.mas_equalTo(14*kHeightScale);
    }];
    
    _confirmBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _confirmBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(18)];
    [_confirmBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [_confirmBtn setTitleColor:[UIColor colorWithHexString:@"#2F86F6"] forState:(UIControlStateNormal)];
    [self addSubview:_confirmBtn];
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15*kWidthScale);
        make.height.mas_equalTo(23*kHeightScale);
        make.top.mas_equalTo(14*kHeightScale);
    }];
    @weakify(self);
    [[_confirmBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        if (self.choseEnumBlock && self.dataArray.count != 0) {
            self.choseEnumBlock(self.dataArray[self.choseIndex]);
        }
    }];
    
    _pickerView = [[PGPickerView alloc] initWithFrame:CGRectMake(0, 51*kHeightScale, kSCREEN_WIDTH, CGRectGetHeight(self.frame)-51*kHeightScale)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.rowHeight = 55*kHeightScale;
    _pickerView.middleTextColor = [UIColor colorWithHexString:@"#C5CAD5"];
    _pickerView.lineBackgroundColor = [UIColor colorWithHexString:@"#E2E4EA"];
    
    _pickerView.textColorOfSelectedRow = [UIColor colorWithHexString:@"#2F86F6"];
    _pickerView.textFontOfSelectedRow = [UIFont systemFontOfSize:16];
    _pickerView.textColorOfOtherRow = [UIColor colorWithHexString:@"#C5CAD5"];
    _pickerView.textFontOfOtherRow = [UIFont systemFontOfSize:16];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [self addSubview:_pickerView];

}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    [self.pickerView reloadAllComponents];
    
}

#pragma mark--pickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(PGPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(PGPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count;
}
- (NSString *)pickerView:(PGPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    YSCRMYXGEnumModel *model = self.dataArray[row];
    if (self.type == YSCRMEnumChoseGViewType2) {
        return model.projectName;
    }
    return model.name;
}

- (void)pickerView:(PGPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.choseIndex = row;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
