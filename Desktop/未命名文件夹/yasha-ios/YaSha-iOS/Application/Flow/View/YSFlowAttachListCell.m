//
//  YSFlowAttachListCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/30.
//

#import "YSFlowAttachListCell.h"

@implementation YSFlowAttachListCell

@end


@interface YSFlowAttachPSListCell ()

@property (nonatomic, strong) UILabel *createTimeLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation YSFlowAttachPSListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _createTimeLabel = [[UILabel alloc] init];
    _createTimeLabel.textColor = [UIColor colorWithRed:0.62 green:0.62 blue:0.62 alpha:1.00];
    _createTimeLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_createTimeLabel];
    [_createTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(14*kHeightScale);
    }];
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.numberOfLines = 0;
    _messageLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_messageLabel];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_createTimeLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(_createTimeLabel.mas_left);
        make.right.mas_equalTo(_createTimeLabel.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
    }];
}

- (void)setCellModel:(YSFlowAttachPSListModel *)cellModel {
    _cellModel = cellModel;
    _createTimeLabel.text = [YSUtility formatTimestamp:_cellModel.createTime Length:16];
    _messageLabel.text = _cellModel.message;
}

@end


@interface YSFlowAttachFileListCell ()

@property (nonatomic, strong) UIImageView *fileTypeImageView;
@property (nonatomic, strong) UILabel *fileNameLabel;
@property (nonatomic, strong) UILabel *fileSizeLabel;
@property (nonatomic, strong) UILabel *downloadLabel;

@end

@implementation YSFlowAttachFileListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _fileTypeImageView = [[UIImageView alloc] init];
    [self addSubview:_fileTypeImageView];
    [_fileTypeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(50*kWidthScale, 50*kHeightScale));
    }];
    
    _downloadLabel = [[UILabel alloc] init];
    _downloadLabel.text = @"预览";
    _downloadLabel.textAlignment = NSTextAlignmentRight;
    _downloadLabel.textColor = kThemeColor;
    _downloadLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_downloadLabel];
    [_downloadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(60*kWidthScale, 60*kHeightScale));
    }];
    
    _fileNameLabel = [[UILabel alloc] init];
    _fileNameLabel.numberOfLines = 2;
    _fileNameLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_fileNameLabel];
    [_fileNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_fileTypeImageView.mas_top);
        make.left.mas_equalTo(_fileTypeImageView.mas_right).offset(25);
        make.right.mas_equalTo(_downloadLabel.mas_left).offset(-5);
        make.height.mas_greaterThanOrEqualTo(16*kHeightScale);
    }];
    
    _fileSizeLabel = [[UILabel alloc] init];
    _fileSizeLabel.font = [UIFont systemFontOfSize:10];
    _fileSizeLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:_fileSizeLabel];
    [_fileSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_fileTypeImageView.mas_bottom);
        make.left.mas_equalTo(_fileNameLabel.mas_left);
        make.right.mas_equalTo(_fileNameLabel.mas_right);
        make.height.mas_equalTo(12*kHeightScale);
    }];
}

- (void)setCellModel:(YSNewsAttachmentModel *)cellModel {
    _cellModel = cellModel;
    _fileNameLabel.text = _cellModel.fileName;
    _fileSizeLabel.text = [YSUtility getFileSize:_cellModel.fileSize];
    NSArray *fileTypeArray = @[@"word", @"ppt", @"excel", @"txt", @"image", @"media", @"pdf", @"zip"];
    // 防止越界
    _fileTypeImageView.image = [UIImage imageNamed:(_cellModel.fileType > 0 && _cellModel.fileType < 9) ?  fileTypeArray[_cellModel.fileType - 1] : @"附件其它类型"];
}

@end


@interface YSFlowAttachFlowListCell ()



@end

@implementation YSFlowAttachFlowListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
}

- (void)setCellModel:(YSFlowAttachFlowListModel *)cellModel {
    _cellModel = cellModel;
}

@end
