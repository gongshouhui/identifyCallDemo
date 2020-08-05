//
//  YSNewsAttachmentCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/9/30.
//

#import "YSNewsAttachmentCell.h"

@interface YSNewsAttachmentCell ()

@property (nonatomic, strong) UIImageView *fileTypeImageView;
@property (nonatomic, strong) UILabel *fileNameLabel;
@property (nonatomic, strong) UILabel *fileSizeLabel;
@property (nonatomic, strong) UILabel *downloadLabel;
@property (nonatomic,strong) UILabel *uploadTimeLb;//附件上传时间

@end

@implementation YSNewsAttachmentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
        make.right.mas_equalTo(_downloadLabel.mas_left).mas_equalTo(-10);
    }];
    
    _fileSizeLabel = [[UILabel alloc] init];
    _fileSizeLabel.font = [UIFont systemFontOfSize:10];
    _fileSizeLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:_fileSizeLabel];
    [_fileSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_fileTypeImageView.mas_bottom);
        make.left.mas_equalTo(_fileNameLabel.mas_left);
    }];
  
     self.uploadTimeLb = [[UILabel alloc] init];
     self.uploadTimeLb.font = [UIFont systemFontOfSize:10];
     self.uploadTimeLb.textColor = [UIColor lightGrayColor];
    [self addSubview: self.uploadTimeLb];
    [ self.uploadTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.fileSizeLabel.mas_centerY);
        make.left.mas_equalTo(self.fileSizeLabel.mas_right).mas_equalTo(15);
    }];
}

- (void)setCellModel:(YSNewsAttachmentModel *)cellModel {
    _cellModel = cellModel;
    _fileNameLabel.text = _cellModel.fileName;
    _fileSizeLabel.text = [YSUtility getFileSize:_cellModel.fileSize];
    NSArray *fileTypeArray = @[@"word", @"ppt", @"excel", @"txt", @"image", @"media", @"pdf", @"zip"];
    // 防止越界
    _fileTypeImageView.image = [UIImage imageNamed:(_cellModel.fileType > 0 && _cellModel.fileType < 9) ?  fileTypeArray[_cellModel.fileType - 1] : @"附件其它类型"];
    _uploadTimeLb.text = [YSUtility timestampSwitchTime:cellModel.createTime andFormatter:@"yyyy-MM-dd hh:mm:ss"];
}

- (void)setElectronicData:(NSArray *)array {
    for (NSDictionary *dic in array) {
        DLog(@"=========%@",dic);
        _fileNameLabel.text = dic[@"fileName"];
        _fileSizeLabel.text = [YSUtility getFileSize:[dic[@"fileSize"] floatValue]];
        NSArray *fileTypeArray = @[@"word", @"ppt", @"excel", @"txt", @"image", @"media", @"pdf", @"zip"];
        _fileTypeImageView.image = [UIImage imageNamed:([dic[@"fileType"] intValue] > 0 && [dic[@"fileType"] intValue] < 9) ?  fileTypeArray[[dic[@"fileType"] intValue] - 1] : @"附件其它类型"];
    }
}

- (void)setAttachmentData:(NSArray *)array {
    _fileNameLabel.text = array[0];
    _fileSizeLabel.text = [YSUtility getFileSize:[array[4] floatValue]];
    NSArray *fileTypeArray = @[@"word", @"ppt", @"excel", @"txt", @"image", @"media", @"pdf", @"zip"];
    _fileTypeImageView.image = [UIImage imageNamed:([array[3] intValue] > 0 && [array[3] intValue] < 9) ?  fileTypeArray[[array[3] intValue] - 1] : @"附件其它类型"];
}

@end
