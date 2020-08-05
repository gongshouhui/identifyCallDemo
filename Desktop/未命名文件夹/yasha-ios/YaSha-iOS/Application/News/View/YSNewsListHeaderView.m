//
//  YSNewsListHeaderView.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/9/29.
//

#import "YSNewsListHeaderView.h"

@interface YSNewsListHeaderView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, assign) YSNewsType newsType;

@end

@implementation YSNewsListHeaderView

+ (YSNewsListHeaderView *)initwithType:(YSNewsType)newsType {
    return [[self alloc] initwithType:newsType];
}

- (YSNewsListHeaderView *)initwithType:(YSNewsType)newsType {
    _newsType = newsType;
    return [self initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, newsType == YSNewsTypeNews ? 10 + 30*kHeightScale + 147*kHeightScale : 10 + 30*kHeightScale)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor whiteColor];
    _searchSubject = [RACSubject subject];
    
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.backgroundImage = [[UIImage alloc] init];
    _searchBar.placeholder = @"请输入关键词";
    _searchBar.barTintColor = [UIColor whiteColor];
    [self addSubview:_searchBar];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(5);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.height.mas_equalTo(30*kHeightScale);
    }];
    
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 10+30*kHeightScale, kSCREEN_WIDTH, _newsType == YSNewsTypeNews ? 147*kHeightScale : 0) delegate:self placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    _cycleScrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_cycleScrollView];
    
  
    if (@available(iOS 13.0, *)) {
        _searchField =_searchBar.searchTextField;
    }else {
		 // 通过 KVC 获取 UISearchBar 的私有变量 searchField，设置 UISearchBar 样式
        _searchField = [_searchBar valueForKey:@"_searchField"];
    }
    YSWeak;
    if (_searchField) {
        [[_searchField rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(id x) {
            [weakSelf.searchSubject sendNext:weakSelf.searchField.text];
        }];
        [_searchField setBackgroundColor:[UIColor colorWithRed:0.97 green:0.96 blue:0.96 alpha:1.00]];
        _searchField.layer.cornerRadius = 5.0f*kHeightScale;
        _searchField.layer.masksToBounds = YES;
    }
}

@end
