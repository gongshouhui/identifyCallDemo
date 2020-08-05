//
//  YSPMSPeopleInfoCell.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/8/31.
//
//

#import <UIKit/UIKit.h>
#import "YSPMSPeopleInfoModel.h"

@interface YSPMSPeopleInfoCell : UITableViewCell

@property(nonatomic,strong)QMUIButton *phoneButton;
@property(nonatomic,strong)UIButton *exitButton;

- (void)setPeopleInfoCell:(YSPMSPeopleInfoModel *)cellModel personType:(NSInteger)type;
- (void)setZSPeopleInfoCell:(YSPMSPeopleInfoModel *)cellModel;

@end
