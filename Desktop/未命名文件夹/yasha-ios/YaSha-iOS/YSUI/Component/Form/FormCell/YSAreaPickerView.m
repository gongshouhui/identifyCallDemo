//
//  YSAreaPickerView.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/16.
//

#import "YSAreaPickerView.h"

@interface YSAreaPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) NSArray *areaArray;
@property (nonatomic, strong) YSAddressModel *addressModel;

@end

@implementation YSAreaPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, kSCREEN_HEIGHT-350, kSCREEN_WIDTH, 350);
        [self initUI];
    }
    return self;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (void)initUI {
    _sendAddressSubject = [RACSubject subject];
    _sendCancelSubject = [RACSubject subject];
    _addressModel = [[YSAddressModel alloc] init];
    
    [self addSubview:self.pickerView];
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(50);
        make.left.bottom.right.mas_equalTo(self);
    }];
    
    _cancelButton = [[UIButton alloc] init];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:kThemeColor forState:UIControlStateNormal];
    YSWeak;
    [[_cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf.sendCancelSubject sendNext:nil];
        [weakSelf clearData];
    }];
    [self addSubview:_cancelButton];
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 50));
    }];
    
    _confirmButton = [[UIButton alloc] init];
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_confirmButton setTitle:@"完成" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:kThemeColor forState:UIControlStateNormal];
   
    [[_confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf updateAddress];
        [weakSelf.sendAddressSubject sendNext:weakSelf.addressModel];
        [weakSelf clearData];
    }];
    [self addSubview:_confirmButton];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 50));
    }];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.00];
    [self addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_cancelButton.mas_bottom);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
    [self initData];
}

- (void)setAreaPickerType:(YSAreaPickerType)areaPickerType {
    _areaPickerType = areaPickerType;
    [self.pickerView reloadAllComponents];
}

- (void)clearData {
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    [self.pickerView selectRow:0 inComponent:1 animated:NO];
    [self.pickerView selectRow:0 inComponent:2 animated:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pickerView reloadAllComponents];
    });
}

- (void)initData {
    
//    //本地地址获取
//    // 获取文件路径
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"json"];
//    // 将文件数据化
//    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//    self.areaArray = [YSDataManager getAreaData:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [QMUITips hideAllToastInView:self animated:YES];
//        [self.pickerView selectRow:0 inComponent:0 animated:NO];
//        [self.pickerView selectRow:0 inComponent:1 animated:NO];
//        [self.pickerView selectRow:0 inComponent:2 animated:NO];
//        [self.pickerView reloadAllComponents];
//    });
    
    //网络地址获取
    [QMUITips showLoadingInView:self];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, getAreaTree];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if ([response[@"code"] intValue] == 1) {
                self.areaArray = [YSDataManager getAreaData:response];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [QMUITips hideAllToastInView:self animated:YES];
                    [self.pickerView selectRow:0 inComponent:0 animated:NO];
                    [self.pickerView selectRow:0 inComponent:1 animated:NO];
                    [self.pickerView selectRow:0 inComponent:2 animated:NO];
                    [self.pickerView reloadAllComponents];
                });
            }
        });
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [QMUITips hideAllToastInView:self animated:YES];
        });

    } progress:nil];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.areaPickerType + 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {
            return self.areaArray.count;
            break;
        }
        case 1:
        {
            YSProvinceModel *provinceModel = [self.areaArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
            return provinceModel.cities.count;
            break;
        }
        case 2:
        {
            YSProvinceModel *provinceModel = [self.areaArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
            YSCityModel *cityModel = [provinceModel.cities objectAtIndex:[self.pickerView selectedRowInComponent:1]];
            return cityModel.areas.count;
            break;
        }
        default:
        {
            return 0;
            break;
        }
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {
            YSProvinceModel *provinceModel = [self.areaArray objectAtIndex:row];
            return provinceModel.name;
            break;
        }
        case 1:
        {
            YSProvinceModel *provinceModel = [self.areaArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
            YSCityModel *cityModel = [provinceModel.cities objectAtIndex:row];
            return cityModel.name;
            break;
        }
        case 2:
        {
            YSProvinceModel *provinceModel = [self.areaArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
            YSCityModel *cityModel = [provinceModel.cities objectAtIndex:[self.pickerView selectedRowInComponent:1]];
            YSAreaModel *areaModel = [cityModel.areas objectAtIndex:row];
            return areaModel.name;
            break;
        }
        default:
        {
            return @"";
            break;
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        [self.pickerView selectRow:row inComponent:1 animated:NO];
        [self.pickerView selectedRowInComponent:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pickerView reloadComponent:1];
        });
        [self.pickerView selectRow:row inComponent:2 animated:NO];
        [self.pickerView selectedRowInComponent:2];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pickerView reloadComponent:2];
        });
    } else if (component == 1) {
        [self.pickerView selectRow:row inComponent:2 animated:NO];
        [self.pickerView selectedRowInComponent:2];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pickerView reloadComponent:2];
        });
    } else {
        [self.pickerView selectedRowInComponent:2];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pickerView reloadComponent:2];
        });
    }
    [self updateAddress];
}

- (void)updateAddress {
    YSProvinceModel *provinceModel = [_addressModel.province isEqual:[NSNull null]] ? [self.areaArray objectAtIndex:0] : [self.areaArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    YSCityModel *cityModel = [_addressModel.province isEqual:[NSNull null]] ? [provinceModel.cities objectAtIndex:0] : [provinceModel.cities objectAtIndex:[self.pickerView selectedRowInComponent:1]];
    YSAreaModel *areaModel = [_addressModel.province isEqual:[NSNull null]] ? [cityModel.areas objectAtIndex:0] : [cityModel.areas objectAtIndex:[self.pickerView selectedRowInComponent:2]];
    
    _addressModel.province = provinceModel.name;
    _addressModel.provinceCode = provinceModel.code;
    _addressModel.city = cityModel.name;
    _addressModel.cityCode = cityModel.code;
    _addressModel.area = areaModel.name;
    _addressModel.areaCode = areaModel.code;
    if (_areaPickerType == YSAreaPickerProvince) {
        _addressModel.city = @"";
        _addressModel.cityCode = @"";
        _addressModel.area = @"";
        _addressModel.areaCode = @"";
    } else if (_areaPickerType == YSAreaPickerCity) {
        _addressModel.area = @"";
        _addressModel.areaCode = @"";
    }
}

@end

@implementation YSProvinceModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"cities" : [YSCityModel class]};
}

@end

@implementation YSCityModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"areas" : [YSAreaModel class]};
}

@end

@implementation YSAreaModel

@end

@implementation YSAddressModel

@end
