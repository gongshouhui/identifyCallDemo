//
//  YSPMSPlanSearchView.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/10/13.
//

#import "YSPMSPlanSearchView.h"

@interface YSPMSPlanSearchView ()

@property (nonatomic, strong) UIButton *filtButton;
@property (nonatomic, strong) UITextField *searchField;

@end

@implementation YSPMSPlanSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidePMSKeyboard) name:@"hidePMSKeyboard" object:nil];
    _searchSubject = [RACSubject subject];
//    _filtSubject = [RACSubject subject];
    
//    _filtButton = [[UIButton alloc] init];
//    [_filtButton setTitle:@"筛选" forState:UIControlStateNormal];
//    [_filtButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [[_filtButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        [_filtSubject sendNext:_filtButton];
//    }];
//    [self addSubview:_filtButton];
//    [_filtButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.mas_top).offset(5);
//        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
//        make.right.mas_equalTo(self.mas_right).offset(-2);
//        make.width.mas_equalTo(60*kWidthScale);
//    }];
    
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.backgroundImage = [[UIImage alloc] init];
    _searchBar.placeholder = @"请输入项目名称...";
    _searchBar.barTintColor = [UIColor whiteColor];
    [self addSubview:_searchBar];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(5);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
        make.right.mas_equalTo(self.mas_right).offset(-15);
    }];
    
   
    if (@available(iOS 13.0, *)) {
        _searchField =_searchBar.searchTextField;
    }else {
		 // 通过 KVC 获取 UISearchBar 的私有变量 searchField，设置 UISearchBar 样式
        _searchField = [_searchBar valueForKey:@"_searchField"];
    }
    if (_searchField) {
        [[_searchField rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(id x) {
            [_searchSubject sendNext:_searchField.text];
        }];
        [_searchField setBackgroundColor:[UIColor colorWithRed:0.97 green:0.96 blue:0.96 alpha:1.00]];
        _searchField.layer.cornerRadius = 5.0f*kHeightScale;
        _searchField.layer.masksToBounds = YES;
    }
}

- (void)hidePMSKeyboard {
    [_searchField resignFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
