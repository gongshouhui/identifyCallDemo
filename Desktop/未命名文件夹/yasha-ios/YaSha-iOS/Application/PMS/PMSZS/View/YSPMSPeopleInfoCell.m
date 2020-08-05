//
//  YSPMSPeopleInfoCell.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/8/31.
//
//

#import "YSPMSPeopleInfoCell.h"

@interface YSPMSPeopleInfoCell()

@property(nonatomic,strong)UIImageView *headerImage;

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)QMUIButton *noButton;

//@property(nonatomic,strong)UIButton *phoneButton;

@property(nonatomic,strong)QMUIButton *startButton;

@property(nonatomic,strong)QMUIButton *endButton;
/**项目兼职按钮*/
@property (nonatomic,strong) UILabel *parttimeBtn;//默认隐藏,显示时需要改数据
@property (nonatomic,strong) UIImageView *parttimeIV;
/**岗位名臣按钮*/
@property (nonatomic,strong) QMUIButton *jobStationBtn;//默认隐藏,显示时需要改数据

//@property(nonatomic,strong)UIButton *exitButton;

@property (nonatomic, strong) NSNumber *exitBool;
@property (nonatomic, strong) NSNumber *enterBool;

@end

@implementation YSPMSPeopleInfoCell
- (NSNumber *)exitBool {
    if (!_exitBool) {
        _exitBool = [[NSNumber alloc]initWithBool:[YSUtility checkDatabaseSystemSn:MQInfomanagement andModuleSn:ZSModuleIdentification andCompanyId:MQcompanyId andPermissionValue:MQPeopleExitPermissionValue]];
    }
    return _exitBool;
}
- (NSNumber *)enterBool {
    if (!_enterBool) {
        _enterBool = [[NSNumber alloc]initWithBool:[YSUtility checkDatabaseSystemSn:MQInfomanagement andModuleSn:ZSModuleIdentification andCompanyId:MQcompanyId andPermissionValue:MQPeopleEnterPermissionValue]];
    }
    return _enterBool;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
    
}

- (void)initUI {
    self.headerImage = [[UIImageView alloc]init];
    self.headerImage.layer.masksToBounds = YES;
    self.headerImage.layer.cornerRadius = 18*kWidthScale;
    [self.contentView addSubview:self.headerImage];
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(16*kHeightScale);
        make.left.mas_equalTo(self.contentView.mas_left).offset(22*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(36*kWidthScale, 36*kHeightScale));
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.textColor = kUIColor(51, 51, 51, 1.0);
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerImage.mas_bottom).offset(12);
        make.left.mas_equalTo(self.contentView.mas_left).offset(5*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(70*kWidthScale, 16*kHeightScale));
        make.bottom.mas_equalTo(-10).priority(100);
    }];
    
    self.noButton = [[QMUIButton alloc]init];
    self.noButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.noButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.noButton];
    [self.noButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.left.mas_equalTo(self.headerImage.mas_right).offset(25*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(150*kWidthScale, 20*kHeightScale));
    }];
    
    self.phoneButton = [[QMUIButton alloc]init];
    self.phoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.phoneButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.phoneButton];
    [self.phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.noButton.mas_bottom).offset(5);
        make.left.mas_equalTo(self.headerImage.mas_right).offset(25*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(150*kWidthScale, 20*kHeightScale));
    }];
    //项目兼职
    self.parttimeIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"职位"]];
    [self.contentView addSubview:self.parttimeIV];
    [self.parttimeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneButton.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(self.headerImage.mas_right).offset(25*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(13, 13));
        
    }];
    self.parttimeIV.hidden = YES;
   
    self.parttimeBtn = [[UILabel alloc]init];
    self.parttimeBtn.textColor = [UIColor blackColor];
    self.parttimeBtn.numberOfLines = 0;
    [self.contentView addSubview:self.parttimeBtn];
    [self.parttimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.parttimeIV.mas_top).mas_equalTo(-5);
        make.left.mas_equalTo(self.parttimeIV.mas_right).offset(8);
        make.right.mas_equalTo(-15);
    }];
    self.parttimeBtn.hidden = YES;//默认隐藏
    //岗位名称
    self.jobStationBtn = [[QMUIButton alloc]init];
    self.jobStationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.jobStationBtn setImage:[UIImage imageNamed:@"职位"] forState:UIControlStateNormal];
    self.jobStationBtn.imagePosition = QMUIButtonImagePositionLeft;
    self.jobStationBtn.spacingBetweenImageAndTitle = 8;
    [self.jobStationBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.jobStationBtn];
    [self.jobStationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.parttimeBtn.mas_bottom).mas_equalTo(0);
        make.left.mas_equalTo(self.headerImage.mas_right).offset(25*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(0*kWidthScale, 0*kHeightScale));
    }];
    self.jobStationBtn.hidden = YES;//默认隐藏
    
    
    self.startButton = [[QMUIButton alloc]init];
    self.startButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.startButton];
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.jobStationBtn.mas_bottom).offset(5);
        make.left.mas_equalTo(self.headerImage.mas_right).offset(25*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(150*kWidthScale, 20*kHeightScale));
    }];
    
    
    self.endButton = [[QMUIButton alloc]init];
    self.endButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.endButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.endButton];
    [self.endButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.startButton.mas_bottom).offset(5);
        make.left.mas_equalTo(self.headerImage.mas_right).offset(25*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(150*kWidthScale, 20*kHeightScale));
        make.bottom.mas_equalTo(-10).priority(100);
    }];
    
    
    self.exitButton = [[UIButton alloc]init];
    self.exitButton.backgroundColor = kUIColor(255, 192, 0, 1.0);
    [self.contentView addSubview:self.exitButton];
    [self.exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(16);
        make.left.mas_equalTo(self.noButton.mas_right).offset(65*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(50*kWidthScale, 23*kHeightScale));
    }];
    
}

- (void)setPeopleInfoCell:(YSPMSPeopleInfoModel *)cellModel personType:(NSInteger)type {
    /**0:项目人员 1： 只能人员*/
    //项目人员：1. 字段展示顺序：【工号】、【电话】、【项目兼职】（若没有项目兼职，则不显示）、【进场时间】（若待进场，则不显示【进场时间】）、【退场时间】（若未退场，则不显示【退场时间】；
    //职能人员：1. 字段展示顺序：【工号】、【电话】、【岗位名称】、【进场时间】、【退场时间】（若未退场，则不显示【退场时间】；
    self.nameLabel.text = cellModel.name;
    if (cellModel.image.length > 0) {
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YSImageDomain, [YSUtility getAvatarUrlString:cellModel.image]]] placeholderImage:[UIImage imageNamed:@"人员信息-头像"]];
    }else{
        self.headerImage.image = [UIImage imageNamed:@"人员信息-头像"];
    }
    //工号
    [self.noButton setImage:[UIImage imageNamed:@"工号"] forState:UIControlStateNormal];
    [self.noButton setTitle:cellModel.code forState:UIControlStateNormal];
    self.noButton.imagePosition = QMUIButtonImagePositionLeft;
    self.noButton.spacingBetweenImageAndTitle = 10;
    //电话号码
    [self.phoneButton setImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
    [self.phoneButton setTitle:cellModel.mobile forState:UIControlStateNormal];
    self.phoneButton.imagePosition = QMUIButtonImagePositionLeft;
    self.phoneButton.spacingBetweenImageAndTitle = 11;
//    //兼职

    if (cellModel.partTimeStr.length && type == 0) {//项目人员
        self.parttimeIV.hidden = NO;
        [self.parttimeIV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(13, 13));
            
        }];
        [self.parttimeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.parttimeIV.mas_top).mas_equalTo(-5);
        }];
        self.parttimeBtn.hidden = NO;
        self.parttimeBtn.text = cellModel.partTimeStr;

    }else{
        self.parttimeBtn.hidden = YES;
        self.parttimeIV.hidden = YES;
        [self.parttimeIV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(0, 0));
            
        }];
        [self.parttimeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.parttimeIV.mas_top).mas_equalTo(-8);
        }];
    }
    if (cellModel.jobStation.length && type == 1) {//职能人员需要显示
        self.jobStationBtn.hidden = NO;
        
        [self.jobStationBtn setTitle:cellModel.jobStation forState:UIControlStateNormal];
        [self.jobStationBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.parttimeBtn.mas_bottom).mas_equalTo(5);
            make.left.mas_equalTo(self.headerImage.mas_right).offset(25*kWidthScale);
            make.size.mas_equalTo(CGSizeMake(150*kWidthScale, 20*kHeightScale));
        }];
    }else{
        self.jobStationBtn.hidden = YES;
        [self.jobStationBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.parttimeBtn.mas_bottom).mas_equalTo(5);
            make.left.mas_equalTo(self.headerImage.mas_right).offset(25*kWidthScale);
            make.size.mas_equalTo(CGSizeMake(0*kWidthScale, 0*kHeightScale));
        }];
    }
    
    if (cellModel.enterDate.length > 0) {
        self.startButton.hidden = NO;
        [self.startButton setImage:[UIImage imageNamed:@"进场"] forState:UIControlStateNormal];
        [self.startButton setTitle:[YSUtility timestampSwitchTime:cellModel.enterDate andFormatter:@"yyyy-MM-dd"] forState:UIControlStateNormal];
        self.startButton.imagePosition = QMUIButtonImagePositionLeft;
        self.startButton.spacingBetweenImageAndTitle = 8;
        [self.startButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.jobStationBtn.mas_bottom).offset(5);
            make.left.mas_equalTo(self.headerImage.mas_right).offset(25*kWidthScale);
            make.size.mas_equalTo(CGSizeMake(150*kWidthScale, 20*kHeightScale));
        }];
    }else {
        self.startButton.hidden = YES;
        [self.startButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.jobStationBtn.mas_bottom).offset(0);
            make.left.mas_equalTo(self.headerImage.mas_right).offset(25*kWidthScale);
            make.size.mas_equalTo(CGSizeMake(0*kWidthScale, 0*kHeightScale));
        }];
    }
    if (cellModel.leaveDate.length > 0) {
         self.endButton.hidden = NO;
        [self.endButton setImage:[UIImage imageNamed:@"退场"] forState:UIControlStateNormal];
        [self.endButton setTitle:[YSUtility timestampSwitchTime:cellModel.leaveDate andFormatter:@"yyyy-MM-dd"] forState:UIControlStateNormal];
        self.endButton.imagePosition = QMUIButtonImagePositionLeft;
        self.endButton.spacingBetweenImageAndTitle = 8;
        [self.endButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.startButton.mas_bottom).offset(5);
            make.left.mas_equalTo(self.headerImage.mas_right).offset(25*kWidthScale);
            make.size.mas_equalTo(CGSizeMake(150*kWidthScale, 20*kHeightScale));
        }];
    }else {
        self.endButton.hidden = YES;
        [self.endButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.startButton.mas_bottom).offset(0);
            make.left.mas_equalTo(self.headerImage.mas_right).offset(25*kWidthScale);
            make.size.mas_equalTo(CGSizeMake(0*kWidthScale, 0*kHeightScale));
        }];
    }
    //调整上下约束便于自动计算高度
    
    if ((!self.noButton.hidden  + !self.phoneButton.hidden + !self.parttimeBtn.hidden + !self.startButton.hidden + !self.endButton.hidden) > 2) {//右边头像加名字可以显示完
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headerImage.mas_bottom).offset(12);
            make.left.mas_equalTo(self.contentView.mas_left).offset(5*kWidthScale);
            make.size.mas_equalTo(CGSizeMake(70*kWidthScale, 16*kHeightScale));
            make.bottom.mas_equalTo(-10).priority(10);
        }];
    }else{
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headerImage.mas_bottom).offset(12);
            make.left.mas_equalTo(self.contentView.mas_left).offset(5*kWidthScale);
            make.size.mas_equalTo(CGSizeMake(70*kWidthScale, 16*kHeightScale));
            make.bottom.mas_equalTo(-10).priority(200);
        }];
    }
    
    if([cellModel.status isEqual:@"10"]){
       
        if (self.enterBool) {
            self.exitButton.hidden = NO;
            [self.exitButton setTitle:@"进场" forState:UIControlStateNormal];
        }else{
            self.exitButton.hidden = YES;
        }
    }else if([cellModel.status isEqual:@"20"]){
       
        if (self.exitBool) {
             self.exitButton.hidden = NO;
            [self.exitButton setTitle:@"退场" forState:UIControlStateNormal];
        }else{
            self.exitButton.hidden = YES;
        }
    }else{
        self.exitButton.hidden = YES;
    }
  

}
- (void)setZSPeopleInfoCell:(YSPMSPeopleInfoModel *)cellModel {
    DLog(@"======%@",cellModel.name);
    [self.exitButton setTitle:@"退场" forState:UIControlStateNormal];
    self.nameLabel.text = cellModel.name;
    if (cellModel.image.length > 0) {
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YSImageDomain, [YSUtility getAvatarUrlString:cellModel.image]]] placeholderImage:[UIImage imageNamed:@"人员信息-头像"]];
    }else{
        self.headerImage.image = [UIImage imageNamed:@"人员信息-头像"];
    }
    
    if (cellModel.enterDate.length > 0) {
        [self.startButton setImage:[UIImage imageNamed:@"进场"] forState:UIControlStateNormal];
        [self.startButton setTitle:[YSUtility timestampSwitchTime:cellModel.enterDate andFormatter:@"yyyy-MM-dd"] forState:UIControlStateNormal];
        self.startButton.imagePosition = QMUIButtonImagePositionLeft;
        self.startButton.spacingBetweenImageAndTitle = 8;
    }else{
        [self.exitButton removeFromSuperview];
    }
    if (cellModel.leaveDate.length > 0) {
        [self.endButton setImage:[UIImage imageNamed:@"退场"] forState:UIControlStateNormal];
        [self.endButton setTitle:[YSUtility timestampSwitchTime:cellModel.leaveDate andFormatter:@"yyyy-MM-dd"] forState:UIControlStateNormal];
    
        self.endButton.imagePosition = QMUIButtonImagePositionLeft;
        self.endButton.spacingBetweenImageAndTitle = 11;
        
        [self.exitButton removeFromSuperview];
    }
    [self.noButton setImage:[UIImage imageNamed:@"工号"] forState:UIControlStateNormal];
    [self.noButton setTitle:cellModel.code forState:UIControlStateNormal];
    self.noButton.imagePosition = QMUIButtonImagePositionLeft;
    self.noButton.spacingBetweenImageAndTitle = 11;
    [self.phoneButton setImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
    [self.phoneButton setTitle:cellModel.mobile forState:UIControlStateNormal];
    self.phoneButton.imagePosition = QMUIButtonImagePositionLeft;
    self.phoneButton.spacingBetweenImageAndTitle = 11;
    
    
}

@end
