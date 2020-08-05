//
//  YSRejectPickerView.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/8/27.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSRejectPickerView.h"
#import "AppDelegate.h"
@interface YSRejectPickerView()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) UIButton *cancelButton;
@property (nonatomic,strong) UIButton *confirmButton;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) YSRejectNodeModel *selectedModel;
@end
@implementation YSRejectPickerView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    self.backgroundColor = [UIColor whiteColor];
    _cancelButton = [[UIButton alloc] init];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor colorWithHexString:@"#40000000"] forState:UIControlStateNormal];
    [self addSubview:_cancelButton];
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(60, 50));
    }];
    YSWeak;
    [[_cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf closePickerViewAnimated:YES];
    }];
    _confirmButton = [[UIButton alloc] init];
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_confirmButton setTitle:@"完成" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor colorWithHexString:@"#FF007AFF"] forState:UIControlStateNormal];
    [self addSubview:_confirmButton];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(60, 50));
    }];
    [[_confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        YSStrong;
        if (!strongSelf.selectedModel) {
            strongSelf.selectedModel = strongSelf.dataArray.firstObject;
        }
        strongSelf.selectComplete(strongSelf.selectedModel);
        [strongSelf closePickerViewAnimated:YES];
    }];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    self.titleLabel.text = @"指定节点";
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(_cancelButton.mas_centerY);
    }];
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.00];
    [self addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_cancelButton.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    UIPickerView *pickView = [[UIPickerView alloc]init];
    self.pickerView = pickView;
    pickView.dataSource = self;
    pickView.delegate = self;
    [self addSubview:pickView];
    [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_cancelButton.mas_bottom).offset(1);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}
- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self.pickerView reloadAllComponents];
}
- (void)showPickerViewOnWindowAnimated:(BOOL)animated selectComplete:(SelectedComplete)completeBlock{
    if (completeBlock) {
        self.selectComplete = completeBlock;
    }
    
    self.bgView = [[UIView alloc]init];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.3;
    UIWindow *window =  ((AppDelegate*)([UIApplication sharedApplication].delegate)).window;
    //UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [window addSubview:self];
    [self setNeedsUpdateConstraints];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
    [self layoutIfNeeded];
    
    if (animated) {
        
        [UIView animateWithDuration:0.3 animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(260*kHeightScale);
            }];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
    [self.pickerView reloadAllComponents];
}
- (void)closePickerViewAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [self.bgView removeFromSuperview];
        }];
       
        
    }else{
        [self removeFromSuperview];
        [self.bgView removeFromSuperview];
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    YSRejectNodeModel *model = self.dataArray[row];
    return [NSString stringWithFormat:@"%@  %@  %@",model.userCode,model.userName,model.nodeName];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedModel = self.dataArray[row];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
   
    return 30;
}
@end
