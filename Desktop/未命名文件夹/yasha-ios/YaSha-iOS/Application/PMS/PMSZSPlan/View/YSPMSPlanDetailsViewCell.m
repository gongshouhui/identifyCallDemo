//
//  YSPMSPlanDetailsViewCell.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/27.
//

#import "YSPMSPlanDetailsViewCell.h"
#import "YSPMSPlanPhotoViewCell.h"


@interface YSPMSPlanDetailsViewCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *timeButton;
@property (nonatomic, strong) UIButton *processButton;
@property (nonatomic, strong) UILabel *completeAmountLabel;
@property (nonatomic, strong) UILabel *allCompleteAmountLabel;
@end

@implementation AFIndexedCollectionView

@end

@implementation YSPMSPlanDetailsViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
       
    }
    return self;
}
- (void)initUI {
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.text = @"格栅吊顶工程开工";
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(20);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(280*kWidthScale, 19*kHeightScale));
    }];
    
    self.timeButton = [[UIButton alloc]init];
    [self.timeButton setTitleColor:kUIColor(153, 153, 153, 1) forState:UIControlStateNormal];
    self.timeButton.titleLabel.font = [UIFont systemFontOfSize:12];
  
    [self.contentView addSubview:self.timeButton];
    [self.timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(18*kHeightScale);
        make.left.mas_equalTo(self.mas_left).offset(15*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(85*kWidthScale, 15*kHeightScale));
    }];
    
    
    self.processButton = [[UIButton alloc]init];
    self.processButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.processButton setTitleColor:kUIColor(153, 153, 153, 1) forState:UIControlStateNormal];
    //设置button文字的位置
    self.processButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //调整与边距的距离
    self.processButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.contentView addSubview:self.processButton];
    [self.processButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(18*kHeightScale);
        make.left.mas_equalTo(self.timeButton.mas_right).offset(30*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(60*kWidthScale, 15*kHeightScale));
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 9, 10);
    layout.itemSize = CGSizeMake(109*kWidthScale, 109*kHeightScale);
    //    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[AFIndexedCollectionView alloc] initWithFrame:CGRectMake(0, 96*kHeightScale, kSCREEN_WIDTH, 120*kHeightScale) collectionViewLayout:layout];
    [self.collectionView registerClass:[YSPMSPlanPhotoViewCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.processButton.mas_bottom).offset(15);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, 120*kHeightScale));
    }];
    
    DLog(@"--------%f",self.collectionView.frame.size.height);
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.backgroundColor = [UIColor whiteColor];
    self.contentLabel.font = [UIFont systemFontOfSize:16];
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.adjustsFontSizeToFitWidth = YES;
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-50*kHeightScale);
        make.width.mas_equalTo(334*kWidthScale);
    }];
    
    self.completeAmountLabel = [[UILabel alloc]init];
    self.completeAmountLabel.text = @"本次完工量： 52 ㎡";
    self.completeAmountLabel.font = [UIFont systemFontOfSize:12];
    self.completeAmountLabel.textColor = kUIColor(42, 138, 219, 1);
    [self.contentView addSubview:self.completeAmountLabel];
    [self.completeAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).offset(16);
        make.size.mas_equalTo(CGSizeMake(120*kWidthScale, 12*kHeightScale));
    }];
    
    self.allCompleteAmountLabel = [[UILabel alloc]init];
    self.allCompleteAmountLabel.text = @"累计完工量： 152 ㎡";
    self.allCompleteAmountLabel.font = [UIFont systemFontOfSize:12];
    self.allCompleteAmountLabel.textColor = kUIColor(42, 138, 219, 1);
    [self.contentView addSubview:self.allCompleteAmountLabel];
    [self.allCompleteAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.completeAmountLabel.mas_right).offset(80*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(150*kWidthScale, 12*kHeightScale));
    }];
    
}

- (void) setPlanDetailsDataCell:(YSPMSPlanListModel *)model  {
    self.titleLabel.text = model.name;
    [self.timeButton setImage:[UIImage imageNamed:@"clock-gray"] forState:UIControlStateNormal];
    [self.timeButton setTitle:[YSUtility timestampSwitchTime:model.createTime andFormatter:@"yyyy.MM.dd"] forState:UIControlStateNormal];
    self.timeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //调整与边距的距离
    self.timeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.contentLabel.text = model.remark;
    self.completeAmountLabel.text = [NSString stringWithFormat:@"本次完工量 : %@㎡",model.thisTimeCompletion == nil ? @"0" : model.thisTimeCompletion];
    self.allCompleteAmountLabel.text = [NSString stringWithFormat:@"累计完工量 : %@㎡", model.grandTotalCompletion == nil ? @"0" : model.grandTotalCompletion];
     [self.processButton setImage:[UIImage imageNamed:@"进度"] forState:UIControlStateNormal];
    [self.processButton setTitle:[NSString stringWithFormat:@"%@%@",model.completionRatio == nil ? @"0" : model.completionRatio,@"%"] forState:UIControlStateNormal];
}

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath
{
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate = dataSourceDelegate;
    self.collectionView.indexPath = indexPath;
    [self.collectionView reloadData];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
