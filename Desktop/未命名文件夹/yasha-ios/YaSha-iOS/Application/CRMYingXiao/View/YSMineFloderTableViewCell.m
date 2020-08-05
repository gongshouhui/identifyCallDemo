//
//  YSMineFloderTableViewCell.m
//  YaSha-iOS
//
//  Created by GZl on 2019/5/10.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSMineFloderTableViewCell.h"

@interface YSMineFloderTableViewCell ()

@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *sizeLab;

@end

@implementation YSMineFloderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self loadSubView];
    }
    return self;
}

- (void)loadSubView {
    
    // 选择按钮
    _choseBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_choseBtn setImage:[UIImage imageNamed:@"unselected+normal"] forState:(UIControlStateNormal)];
    [self.contentView addSubview:_choseBtn];
    [_choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10*kWidthScale);
        make.top.mas_equalTo(22*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(28*kWidthScale, 28*kHeightScale));
    }];
    //示意图
    _holderImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"附件其它类型"]];
    [self.contentView addSubview:_holderImg];
    [_holderImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15*kWidthScale);
        make.top.mas_equalTo(14*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(44*kWidthScale, 44*kHeightScale));
    }];
//    NSArray *fileTypeArray = @[@"word", @"ppt", @"excel", @"txt", @"image", @"media", @"pdf", @"zip"];
    // 防止越界
//    _fileTypeImageView.image = [UIImage imageNamed:(_cellModel.fileType > 0 && _cellModel.fileType < 9) ?  fileTypeArray[_cellModel.fileType - 1] : @"附件其它类型"];
    //文件名称
    _nameLab = [[UILabel alloc] init];
    _nameLab.textColor = [UIColor colorWithHexString:@"#111A34"];
    _nameLab.numberOfLines = 2;
    _nameLab.text = @"文件名称.png";
    _nameLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(16)];
    [self.contentView addSubview:_nameLab];
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14*kHeightScale);
        make.left.mas_equalTo(_holderImg.mas_right).offset(14*kWidthScale);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15*kWidthScale);
    }];
    //时间
    _timeLab = [[UILabel alloc] init];
    _timeLab.textColor = [UIColor colorWithHexString:@"#858B9C"];
    _timeLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(12)];
    _timeLab.text = @"2019-05-10";
    [self.contentView addSubview:_timeLab];
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLab.mas_left);

        make.top.mas_equalTo(_nameLab.mas_bottom).offset(4*kHeightScale);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-16*kHeightScale);
    }];
    //大小
    _sizeLab = [[UILabel alloc] init];
    _sizeLab.textColor = [UIColor colorWithHexString:@"#858B9C"];
    _sizeLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(12)];
    [self.contentView addSubview:_sizeLab];
    [_sizeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_timeLab.mas_right).offset(14*kWidthScale);
        make.top.mas_equalTo(_timeLab.mas_top);
    }];
}

// 文件
- (void)setFolderModel:(YSNewsAttachmentModel *)folderModel {
    if (!_folderModel) {
        _folderModel = folderModel;
    }
    NSArray *fileTypeArray = @[@"word", @"ppt", @"excel", @"txt", @"image", @"media", @"pdf", @"zip"];
    _holderImg.layer.masksToBounds = NO;
    if (folderModel.fileType < 9) {
        _holderImg.image = [UIImage imageNamed:fileTypeArray[folderModel.fileType]];
        if (folderModel.fileType == 4 && folderModel.choseImg ) {
            _holderImg.image = folderModel.choseImg;
            _holderImg.layer.cornerRadius = 2;
            _holderImg.layer.masksToBounds = YES;
        }
    }else {
        _holderImg.image = [UIImage imageNamed:@"附件其它类型"];
    }
    _nameLab.text = folderModel.fileName;
    _timeLab.text = folderModel.createTime;
    _sizeLab.text = folderModel.filePath;
    
}

- (void)setFolderNetworkModel:(YSNewsAttachmentModel *)folderNetworkModel {
    
    _folderNetworkModel = folderNetworkModel;
    
    NSArray *fileTypeArray = @[@"word", @"ppt", @"excel", @"txt", @"image", @"media", @"pdf", @"zip", @"附件其它类型"];
    _holderImg.layer.masksToBounds = NO;
    if (folderNetworkModel.fileType < 9) {
        _holderImg.image = [UIImage imageNamed:fileTypeArray[folderNetworkModel.fileType >= 1 ?folderNetworkModel.fileType-1 : 8]];
        if (folderNetworkModel.fileType-1 == 4 && folderNetworkModel.choseImg ) {
            _holderImg.image = folderNetworkModel.choseImg;
            _holderImg.layer.cornerRadius = 2;
            _holderImg.layer.masksToBounds = YES;
        }
    }else {
        _holderImg.image = [UIImage imageNamed:@"附件其它类型"];
    }
    _nameLab.text = folderNetworkModel.name;
    _timeLab.text = folderNetworkModel.createTime?[YSUtility timestampSwitchTime:folderNetworkModel.createTime andFormatter:@"yyyy-MM-dd"]:@" ";
    _sizeLab.text = [YSUtility getFileSize:folderNetworkModel.fileSize];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
