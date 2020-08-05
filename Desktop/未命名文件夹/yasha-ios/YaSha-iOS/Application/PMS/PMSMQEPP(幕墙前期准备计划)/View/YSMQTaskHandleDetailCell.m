//
//  YSMQTaskHandleDetailCell.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/11/1.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSMQTaskHandleDetailCell.h"
#import "YSPMSPlanPhotoViewCell.h"
#import "YSPMSMQPlanBigPhotoViewController.h"
#import "YSImageTitleButton.h"
@interface YSMQTaskHandleDetailCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) YSImageTitleButton *timeButton;
@property (nonatomic, strong) YSImageTitleButton *processButton;
@property (nonatomic,strong) YSImageTitleButton *delayButton;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UILabel *delayLabel;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) NSArray *dataArray;
@end
@implementation YSMQTaskHandleDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.text = @"";
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(20);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(280*kWidthScale, 19*kHeightScale));
    }];
    
    self.timeButton = [[YSImageTitleButton alloc]init];
    self.timeButton.space = 10;
    [self.timeButton setImage:[UIImage imageNamed:@"clock-gray"] forState:UIControlStateNormal];
    [self.timeButton setTitleColor:kUIColor(153, 153, 153, 1) forState:UIControlStateNormal];
    self.timeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.timeButton];
    [self.timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(18*kHeightScale);
        make.left.mas_equalTo(self.mas_left).offset(15*kWidthScale);
    }];
    
    
    self.processButton = [[YSImageTitleButton alloc]init];
    [self.processButton setImage:[UIImage imageNamed:@"进度"] forState:UIControlStateNormal];
    self.processButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.processButton setTitleColor:kUIColor(153, 153, 153, 1) forState:UIControlStateNormal];
    //调整与边距的距离
    self.processButton.space = 10;
    [self.contentView addSubview:self.processButton];
    [self.processButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(18*kHeightScale);
        make.left.mas_equalTo(self.timeButton.mas_right).offset(30*kWidthScale);
    }];
    //是否影响工期
    self.delayButton = [[YSImageTitleButton alloc]init];
    [self.delayButton setImage:[UIImage imageNamed:@"delay-info"] forState:UIControlStateNormal];
    self.delayButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.delayButton setTitleColor:kUIColor(153, 153, 153, 1) forState:UIControlStateNormal];
    //调整与边距的距离
    self.delayButton.space = 10;
    [self.contentView addSubview:self.delayButton];
    [self.delayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(18*kHeightScale);
        make.left.mas_equalTo(self.processButton.mas_right).offset(30*kWidthScale);
    }];
   
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 9, 10);
    layout.itemSize = CGSizeMake(109*kWidthScale, 109*kHeightScale);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    [self.collectionView registerClass:[YSPMSPlanPhotoViewCell class] forCellWithReuseIdentifier:@"YSPMSPlanPhotoViewCell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.processButton.mas_bottom).offset(15);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(109*kHeightScale);
    }];
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.backgroundColor = [UIColor whiteColor];
    self.contentLabel.font = [UIFont systemFontOfSize:16];
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.adjustsFontSizeToFitWidth = YES;
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    //延期说明分割线
    self.lineView = [UIView new];
    self.lineView.frame = CGRectMake(15, 0, kSCREEN_WIDTH - 30, 1);
    [YSUtility drawLineOfDashByCAShapeLayer:self.lineView lineLength:5 lineSpacing:5 lineColor:kGrayColor(229) lineDirection:YES];
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(_contentLabel.mas_bottom).mas_equalTo(15);
        make.height.mas_equalTo(1);
    }];
    //延误工期说明
    self.delayLabel = [[UILabel alloc]init];
    self.delayLabel.backgroundColor = [UIColor whiteColor];
    self.delayLabel.font = [UIFont systemFontOfSize:16];
    self.delayLabel.textColor = [UIColor blackColor];
    self.delayLabel.adjustsFontSizeToFitWidth = YES;
    self.delayLabel.numberOfLines = 0;
    [self.contentView addSubview:self.delayLabel];
    [self.delayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-15);
    }];
    
}
- (void)setCellDataWithModel:(YSPMSMQEarlyChildTaskModel *)model {
    self.titleLabel.text = model.title;
    [self.timeButton setTitle:[YSUtility timestampSwitchTime:model.updateTime andFormatter:@"yyyy-MM-dd"] forState:UIControlStateNormal];
    [self.processButton setTitle:[NSString stringWithFormat:@"%ld%@",[model.graphicProgress integerValue],@"%"] forState:UIControlStateNormal];
    //是否影响工资
    NSString *title = nil;
    if (model.isLimit) {
        self.delayButton.hidden = NO;
        title = @"已影响工期";
    }else{
        self.delayButton.hidden = YES;
        title = @"未影响工期";
    }
    [self.delayButton setTitle:title forState:UIControlStateNormal];
    //图片附件
    self.dataArray = model.files;
    if (model.finishRemark.length) {
        self.contentLabel.hidden = NO;
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.collectionView.mas_bottom).offset(10);
        }];
        NSString *tips = model.title.length>1?[model.title substringFromIndex:model.title.length -2]:@"操作";
        self.contentLabel.text = [NSString stringWithFormat:@"%@情况说明:%@",tips,model.finishRemark];
    }else{
        self.contentLabel.hidden = YES;
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.collectionView.mas_bottom).offset(0);
        }];
    }
   
    if (model.isLimit) {//影响工期
        self.delayLabel.hidden = NO;
        self.self.lineView.hidden = NO;
        [self.delayLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.lineView.mas_bottom).offset(10);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-15);
        }];
        self.delayLabel.text = [NSString stringWithFormat:@"影响工期说明:%@",model.isLimitRemark];
        
    }else{
        self.delayLabel.hidden = YES;
        self.self.lineView.hidden = YES;
        [self.delayLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.lineView.mas_bottom).offset(0);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_offset(0);
            make.bottom.mas_equalTo(0);
        }];
    }
}
- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    //重置tableView的高度，让他自适应
    CGFloat height = 0.0;
    height = (self.dataArray.count/3) * 109*kHeightScale + (self.dataArray.count%3 > 0? 110*kHeightScale:0);
    [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
    
}

/** cell的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YSPMSPlanPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YSPMSPlanPhotoViewCell" forIndexPath:indexPath];
    YSPMSImageModel *model = self.dataArray[indexPath.row];
   [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.filePath] placeholderImage:[UIImage imageNamed:@"ic_pg_empty_end"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *photoArray = [NSMutableArray array];
    for (YSPMSImageModel *model in self.dataArray) {
        [photoArray addObject:[NSString stringWithFormat:@"%@",model.filePath]];
    }
    YSPMSMQPlanBigPhotoViewController *PMSPlanBigPhotoViewController = [[YSPMSMQPlanBigPhotoViewController alloc]init];
    PMSPlanBigPhotoViewController.imageData = [photoArray copy];
    PMSPlanBigPhotoViewController.index = indexPath.row;
    PMSPlanBigPhotoViewController.networkingPhoto = @"networking";
    [[YSUtility getCurrentViewController] presentViewController:PMSPlanBigPhotoViewController animated:YES completion:nil];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
