//
//  YSFormCommonCell.h
//  Form
//
//  Created by 方鹏俊 on 2017/11/9.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSFormRowModel.h"

@interface YSFormCommonCell : UITableViewCell

@property (nonatomic, strong) YSFormRowModel *cellModel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic,strong) UIImageView *arrowView;
@property (nonatomic, strong) RACSubject *sendValueSubject;
@property (nonatomic, strong) RACSubject *sendFormCellModelSubject;
@property (nonatomic, strong) RACSubject *sendOptionsSubject;
@property (nonatomic,strong) RACSubject *sendMultipleOptionsSubject;
@property (nonatomic, strong) RACSubject *sendAreaSubject;
@property (nonatomic, strong) RACSubject *sendEditSectionSubject;
@property (nonatomic, strong) RACSubject *sendDeleteSectionSubject;
@property (nonatomic, strong) RACSubject *sendImageDataSubject;

- (void)addTitleLabel;
- (void)addDetailLabel;


@end

@interface YSFormCellModel : NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
