//
//  YSNewsDetailView.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/9/30.
//

#import "YSNewsDetailView.h"
#import "YSNewsAttachmentCell.h"
#import "YSNewsScrollView.h"
@interface YSNewsDetailView ()<UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) YSNewsScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *creatorImageView;
@property (nonatomic, strong) UILabel *creatorLabel;
@property (nonatomic, strong) UIImageView *eyeImageView;
@property (nonatomic, strong) UILabel *visitCountLabel;
@property (nonatomic, strong) UILabel *publicTimeLabel;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation YSNewsDetailView

static NSString *cellIdentifier = @"NewsAttachmentCell";

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _scrollView = [[YSNewsScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
   
    //自己加的头view
    _containerView = [[UIView alloc] init];
    [_scrollView addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kSCREEN_WIDTH);
        //make.bottom.mas_equalTo(0);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:26];
    _titleLabel.numberOfLines = 0;
    [_containerView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_containerView.mas_top).offset(10);
        make.left.mas_equalTo(_containerView.mas_left).offset(15);
        make.right.mas_equalTo(_containerView.mas_right).offset(-15);
    }];
    
    _creatorImageView = [[UIImageView alloc] init];
    _creatorImageView.image = [UIImage imageNamed:@"亚厦股份"];
    _creatorImageView.layer.masksToBounds = YES;
    _creatorImageView.layer.cornerRadius = 17*kWidthScale;
    [_containerView addSubview:_creatorImageView];
    [_creatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(16);
        make.left.mas_equalTo(_titleLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(34*kWidthScale, 34*kHeightScale));
    }];
    
    _creatorLabel = [[UILabel alloc] init];
    _creatorLabel.font = [UIFont systemFontOfSize:15];
    [_containerView addSubview:_creatorLabel];
    [_creatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_creatorImageView.mas_centerY);
        make.left.mas_equalTo(_creatorImageView.mas_right).offset(8);
        make.height.mas_equalTo(16*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    _visitCountLabel = [[UILabel alloc] init];
    _visitCountLabel.font = [UIFont systemFontOfSize:12];
    _visitCountLabel.textColor = [UIColor lightGrayColor];
    [_containerView addSubview:_visitCountLabel];
    [_visitCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_creatorImageView.mas_centerY);
        make.right.mas_equalTo(_titleLabel.mas_right);
        make.height.mas_equalTo(14*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    _eyeImageView = [[UIImageView alloc] init];
    _eyeImageView.image = [UIImage imageNamed:@"查看"];
    [_containerView addSubview:_eyeImageView];
    [_eyeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_visitCountLabel.mas_centerY);
        make.right.mas_equalTo(_visitCountLabel.mas_left).offset(-4);
        make.size.mas_equalTo(CGSizeMake(12*kWidthScale, 8*kWidthScale));
    }];
    
    _publicTimeLabel = [[UILabel alloc] init];
    _publicTimeLabel.font = [UIFont systemFontOfSize:12];
    _publicTimeLabel.textColor = [UIColor lightGrayColor];
    [_containerView addSubview:_publicTimeLabel];
    [_publicTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_creatorImageView.mas_bottom).offset(17);
        make.left.mas_equalTo(_titleLabel.mas_left);
        make.height.mas_equalTo(14*kHeightScale);
    }];
    
    _webView = [[UIWebView alloc] init];
    _webView.scrollView.delegate = self;
    _webView.delegate = self;
    _webView.scrollView.scrollEnabled = NO;
    //[_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:nil];
    [_containerView addSubview:_webView];
    
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_publicTimeLabel.mas_bottom).offset(30);
        make.left.mas_equalTo(_containerView.mas_left);
        make.width.mas_equalTo(kSCREEN_WIDTH);
        make.height.mas_equalTo(kSCREEN_HEIGHT);
    }];
    //附件View
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 0) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerClass:[YSNewsAttachmentCell class] forCellReuseIdentifier:cellIdentifier];
    _tableView.scrollEnabled = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_containerView addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_webView.mas_bottom);
        make.left.mas_equalTo(_containerView.mas_left);
        make.right.mas_equalTo(_containerView.mas_right);
        make.bottom.mas_equalTo(_containerView.mas_bottom);
    }];
}

- (void)setCellModel:(YSNewsListModel *)cellModel {
    _cellModel = cellModel;
    _titleLabel.attributedText = [YSUtility getAttributedStringWithString:_cellModel.title lineSpace:8];
    _creatorLabel.text = _cellModel.creatorName;
    _visitCountLabel.text = [NSString stringWithFormat:@"%zd", _cellModel.visitCount];
    _publicTimeLabel.text = _cellModel.publicTimeStr;
}

- (void)setDataDict:(NSDictionary *)dataDict {
    _dataDict = dataDict;
    NSString *ownerName = dataDict[@"ownerName"];
    NSString *writingTime = [YSUtility formatTimestamp:dataDict[@"writingTime"] Length:10];
    NSMutableString *content = [[NSMutableString alloc] initWithString:dataDict[@"content"]];
    if (ownerName.length > 0 && writingTime.length > 0) {
        [content appendString:[NSString stringWithFormat:@"<br /><p align=\"right\">%@</p><p align=\"right\">%@</p>", ownerName, writingTime]];
    }
//    NSString *h5String = [NSString stringWithFormat:@"<!DOCTYPE html><html lang=\"en\"><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\" /><meta charset=\"UTF-8\"></head><body>%@</body></html>",content];
//    NSLog(@"============%@",h5String);
    [_webView loadHTMLString:content baseURL:nil];
}

- (void)setDataSourceArray:(NSArray *)dataSourceArray {
    _dataSourceArray = dataSourceArray;
    _scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, _scrollView.contentSize.height + (_dataSourceArray.count + 1) * (50*kHeightScale + 30));
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_webView.mas_bottom);
        make.left.mas_equalTo(_containerView.mas_left);
        make.right.mas_equalTo(_containerView.mas_right);
        make.height.mas_equalTo((_dataSourceArray.count + 1) * (50*kHeightScale + 30));
    }];
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSNewsAttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YSNewsAttachmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setCellModel:_dataSourceArray[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if ([self.delegate respondsToSelector:@selector(attachCellDidSelected:)]) {
        [self.delegate attachCellDidSelected:self.dataSourceArray[indexPath.row]];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50*kHeightScale + 30;
}
#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [QMUITips showLoadingInView:self];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    img.style.maxWidth = %f;   \
    } \
    }";
    js = [NSString stringWithFormat:js, [UIScreen mainScreen].bounds.size.width - 20];
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
 
    //调用js代码获取HTML dom高度
    // HTML5的高度
    NSString *htmlHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"];
    // HTML5的宽度
    NSString *htmlWidth = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetWidth"];
    CGFloat m5height = [htmlHeight floatValue];
    CGFloat m5width = [htmlWidth floatValue];
     //宽高比
    float i = [htmlWidth floatValue] / [htmlHeight floatValue];
    // WebView控件的最终高度
    float height = kSCREEN_WIDTH / i + 15;

    [_webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_publicTimeLabel.mas_bottom).offset(30);
        make.left.mas_equalTo(_containerView.mas_left);
        make.width.mas_equalTo(kSCREEN_WIDTH);
        make.height.mas_equalTo(height);
    }];
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect = [_publicTimeLabel convertRect: _publicTimeLabel.bounds toView:window];
    _scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, height + rect.origin.y + rect.size.height + (_dataSourceArray.count + 1) * (50*kHeightScale + 30));
    // _scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, height + rect.origin.y + rect.size.height + (_dataSourceArray.count + 1) * (50*kHeightScale + 30));
    DLog(@"contentSize----%@",NSStringFromCGSize(_scrollView.contentSize));
    [self layoutIfNeeded];
    [QMUITips hideAllTipsInView:self];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGFloat webHeight = _webView.scrollView.contentSize.height;
        CGFloat webWidth = _webView.scrollView.contentSize.width;
        [_webView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_publicTimeLabel.mas_bottom).offset(30);
            make.left.mas_equalTo(_containerView.mas_left);
            make.width.mas_equalTo(webWidth);
            make.height.mas_equalTo(webHeight);
        }];
        UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
        CGRect rect = [_publicTimeLabel convertRect: _publicTimeLabel.bounds toView:window];
        _scrollView.contentSize = CGSizeMake(webWidth, webHeight + rect.origin.y + rect.size.height + (_dataSourceArray.count + 1) * (50*kHeightScale + 30));
        // _scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, height + rect.origin.y + rect.size.height + (_dataSourceArray.count + 1) * (50*kHeightScale + 30));
        DLog(@"contentSize----%@",NSStringFromCGSize(_scrollView.contentSize));
        [self layoutIfNeeded];
    }
}
@end
