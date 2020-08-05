//
//  YSPMSInfoPageSearchView.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/30.
//
//

#import "YSPMSInfoPageSearchView.h"

@interface YSPMSInfoPageSearchView ()<UISearchBarDelegate>

//@property (nonatomic, strong) UIButton *filtButton;

@property (nonatomic, weak) UITextField *searchField;

@end

@implementation YSPMSInfoPageSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidePMSKeyboard) name:@"hidePMSKeyboard" object:nil];
//    _searchSubject = [RACSubject subject];
//    _filtSubject = [RACSubject subject];
    
    self.filtButton = [[UIButton alloc] init];
    [self.filtButton setTitle:@"筛选" forState:UIControlStateNormal];
    [self.filtButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//      __weak typeof(self) weakSelf = self;
//    [[self.filtButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        [weakSelf.filtSubject sendNext:weakSelf.filtButton];
//    }];
    [self addSubview:self.filtButton];
    [self.filtButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(5);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
        make.right.mas_equalTo(self.mas_right).offset(-2);
        make.width.mas_equalTo(60*kWidthScale);
    }];
    
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.backgroundImage = [[UIImage alloc] init];
    _searchBar.placeholder = @"请输入供应商名称...";
    _searchBar.barTintColor = [UIColor whiteColor];
    [self addSubview:_searchBar];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(5);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
        make.right.mas_equalTo(_filtButton.mas_left).offset(-5);
    }];
    
	
    if (@available(iOS 13.0, *)) {
        _searchField =_searchBar.searchTextField;
    }else {
		 // 通过 KVC 获取 UISearchBar 的私有变量 searchField，设置 UISearchBar 样式
        _searchField = [_searchBar valueForKey:@"_searchField"];
    }
    _searchField.returnKeyType = UIReturnKeyGo;
    [_searchField setBackgroundColor:[UIColor colorWithRed:0.97 green:0.96 blue:0.96 alpha:1.00]];
        _searchField.layer.cornerRadius = 5.0f*kHeightScale;
        _searchField.layer.masksToBounds = YES;
//    }
}


- (void)hidePMSKeyboard {
    [_searchField resignFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
