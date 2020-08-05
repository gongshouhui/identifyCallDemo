//
//  YSApplicationCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 16/11/23.
//  Copyright © 2016年 方鹏俊. All rights reserved.
//

#import "YSApplicationCell.h"

@interface YSApplicationCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) QMUILabel *messageNumberLabel;

@end

@implementation YSApplicationCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:12];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = [UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.00];
    [self.contentView addSubview:self.nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(_iconImageView.mas_bottom).offset(12);
        make.height.mas_equalTo(12);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    _messageNumberLabel = [[QMUILabel alloc] init];
    _messageNumberLabel.textColor = UIColorWhite;
    _messageNumberLabel.textAlignment = NSTextAlignmentCenter;
    _messageNumberLabel.layer.masksToBounds = YES;
    _messageNumberLabel.layer.cornerRadius = 10*kWidthScale;
    _messageNumberLabel.backgroundColor = UIColorRed;
    [self.contentView addSubview:self.messageNumberLabel];
    [_messageNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImageView.mas_top).offset(-4);
        make.right.mas_equalTo(_iconImageView.mas_right).offset(4);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
}

- (void)setCellModel:(YSApplicationModel *)cellModel {
    _cellModel = cellModel;
  
    if ([cellModel.imageName isKindOfClass:[UIImage class]]) {
        _iconImageView.image = cellModel.imageName;
    }else{//图片名字
        _iconImageView.image = [UIImage imageNamed:_cellModel.imageName];
    }
    _nameLabel.text = _cellModel.name;
    if (_cellModel.unreadCount > 99) {
        _messageNumberLabel.text = @"99+";
        _messageNumberLabel.font = [UIFont systemFontOfSize:8];
    } else {
        _messageNumberLabel.text = [NSString stringWithFormat:@"%zd", _cellModel.unreadCount];
        _messageNumberLabel.font = [UIFont systemFontOfSize:10];
    }
    [_messageNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImageView.mas_top).offset(-10);
        make.right.mas_equalTo(_iconImageView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(_cellModel.unreadCount == 0 ? 0 : 20*kWidthScale, _cellModel.unreadCount == 0 ? 0 : 20*kWidthScale));
    }];
}
- (void)setSelfHelpItem:(YSHRSelpItem *)selfHelpItem {
    _selfHelpItem = selfHelpItem;
    _nameLabel.text = selfHelpItem.name;
    if ([selfHelpItem.name containsString:@"请假"]) {
        _iconImageView.image = [UIImage imageNamed:@"请假1"];
        [_iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(38*kWidthScale*0.93, 30*kHeightScale*0.93));
        }];
    }
    if ([selfHelpItem.name containsString:@"人事证明"]) {
        _iconImageView.image = [UIImage imageNamed:@"人事证明申请1"];
        [_iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(34*kWidthScale*0.93, 34*kHeightScale*0.93));
        }];
    }
    if ([selfHelpItem.name containsString:@"人事资料"]) {
        _iconImageView.image = [UIImage imageNamed:@"人事资料申请1"];
        [_iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40*kWidthScale*0.93, 28*kHeightScale*0.93));
        }];
    }
    if ([selfHelpItem.name containsString:@"超市卡"]) {
        _iconImageView.image = [UIImage imageNamed:@"超市卡1"];
        [_iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(37*kWidthScale*0.93, 28*kHeightScale*0.93));
        }];
    }
    if ([selfHelpItem.name containsString:@"补贴"]) {
        _iconImageView.image = [UIImage imageNamed:@"补贴申请1"];
        [_iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(34*kWidthScale*0.93, 35*kHeightScale*0.93));
        }];
    }
    if ([selfHelpItem.name containsString:@"加班"]) {
        _iconImageView.image = [UIImage imageNamed:@"加班1"];
        [_iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(43*kWidthScale*0.93, 31*kHeightScale*0.93));
        }];
    }
    if ([selfHelpItem.name containsString:@"薪资卡"]) {
        _iconImageView.image = [UIImage imageNamed:@"薪资卡1"];
        [_iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(37*kWidthScale*0.93, 28*kHeightScale*0.93));
        }];
    }
    if ([selfHelpItem.name containsString:@"离职证明"]) {
        _iconImageView.image = [UIImage imageNamed:@"离职证明申请1"];
        [_iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(37*kWidthScale*0.93, 30*kHeightScale*0.93));
        }];
    }
    
}
// hr服务修改icon图
- (void)setHrIconModel:(YSApplicationModel *)hrIconModel {
        _hrIconModel = hrIconModel;
 [_iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {

	 make.size.mas_equalTo(CGSizeMake(33*kWidthScale, 33*kWidthScale));
 }];
    if ([hrIconModel.imageName isKindOfClass:[UIImage class]]) {
        _iconImageView.image = hrIconModel.imageName;
    }else{//图片名字
        _iconImageView.image = [UIImage imageNamed:hrIconModel.imageName];
    }
    _nameLabel.text = hrIconModel.name;
    if (hrIconModel.unreadCount > 99) {
        _messageNumberLabel.text = @"99+";
        _messageNumberLabel.font = [UIFont systemFontOfSize:8];
    } else {
        _messageNumberLabel.text = [NSString stringWithFormat:@"%zd", _cellModel.unreadCount];
        _messageNumberLabel.font = [UIFont systemFontOfSize:10];
    }
    [_messageNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImageView.mas_top).offset(-10);
        make.right.mas_equalTo(_iconImageView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(hrIconModel.unreadCount == 0 ? 0 : 20*kWidthScale, hrIconModel.unreadCount == 0 ? 0 : 20*kWidthScale));
    }];

}

// 我的绩效 修改icon图
- (void)setIconModel:(YSApplicationModel *)iconModel {
    _iconModel = iconModel;
    
    [_iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28*kWidthScale, 28*kHeightScale));
    }];

    if ([_iconModel.imageName isKindOfClass:[UIImage class]]) {
        _iconImageView.image = _iconModel.imageName;
    }else{//图片名字
        _iconImageView.image = [UIImage imageNamed:_iconModel.imageName];
    }
    
    _nameLabel.text = _iconModel.name;
    if (_iconModel.unreadCount > 99) {
        _messageNumberLabel.text = @"99+";
        _messageNumberLabel.font = [UIFont systemFontOfSize:8];
    } else {
        _messageNumberLabel.text = [NSString stringWithFormat:@"%zd", _cellModel.unreadCount];
        _messageNumberLabel.font = [UIFont systemFontOfSize:10];
    }
    [_messageNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImageView.mas_top).offset(-10);
        make.right.mas_equalTo(_iconImageView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(_cellModel.unreadCount == 0 ? 0 : 20*kWidthScale, _cellModel.unreadCount == 0 ? 0 : 20*kWidthScale));
    }];
}

- (void)setManagerModel:(YSApplicationModel *)managerModel {
    
    _managerModel = managerModel;
    CGSize imgSize = CGSizeMake(31*kWidthScale, 33*kHeightScale);
    switch ([managerModel.id integerValue]) {
        case 0:
            {
                imgSize = CGSizeMake(31*kWidthScale, 33*kHeightScale);
            }
            break;
        case 1:
        {
            imgSize = CGSizeMake(36*kWidthScale, 31*kHeightScale);
        }
            break;
        case 2:
        {
            imgSize = CGSizeMake(32*kWidthScale, 34*kHeightScale);
        }
            break;
        case 3:
        {
            imgSize = CGSizeMake(35*kWidthScale, 29*kHeightScale);
            
            [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_iconImageView.mas_bottom).offset(14);
            }];

        }
            break;
        default:
            break;
    }
    [_iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(imgSize);
    }];
    
    if ([managerModel.imageName isKindOfClass:[UIImage class]]) {
        _iconImageView.image = managerModel.imageName;
    }else{//图片名字
        _iconImageView.image = [UIImage imageNamed:managerModel.imageName];
    }
    
    _nameLabel.text = managerModel.name;
    if (managerModel.unreadCount > 99) {
        _messageNumberLabel.text = @"99+";
        _messageNumberLabel.font = [UIFont systemFontOfSize:8];
    } else {
        _messageNumberLabel.text = [NSString stringWithFormat:@"%zd", _cellModel.unreadCount];
        _messageNumberLabel.font = [UIFont systemFontOfSize:10];
    }
    [_messageNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImageView.mas_top).offset(-10);
        make.right.mas_equalTo(_iconImageView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(_cellModel.unreadCount == 0 ? 0 : 20*kWidthScale, _cellModel.unreadCount == 0 ? 0 : 20*kWidthScale));
    }];
    
}

@end
