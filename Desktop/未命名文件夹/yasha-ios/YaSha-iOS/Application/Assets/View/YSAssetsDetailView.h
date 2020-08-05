//
//  YSAssetsDetailView.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/24.
//
//

#import <UIKit/UIKit.h>
#import "YSAssetsDetailModel.h"

@interface YSAssetsDetailView : UIView

@property (nonatomic, strong) YSAssetsDetailModel *cellModel;
@property (nonatomic, strong) UIButton *retryButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *finishButton;
@property (nonatomic, strong) UILabel *informationLabel;

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *confirmNormalButton;
@property (nonatomic, strong) UIButton *confirmErrorButton;

- (void)setCellModel:(YSAssetsDetailModel *)cellModel withReconfirm:(NSString *)reconfirm history:(BOOL)history;
- (void)setErrorStatus;
- (void)setErrorStatusWithCellModel:(YSAssetsDetailModel *)cellModel;
- (void)setSearchWithCellModel:(YSAssetsDetailModel *)cellModel;

@end
