//
//  YSManagerTeamHeaderView.h
//  YaSha-iOS
//
//  Created by GZl on 2019/3/26.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface YSManagerTeamBtnView : UIView

@property (nonatomic, strong) UILabel *numberLab;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *lineLab;


@end

// 我的团队 顶部视图
@interface YSManagerTeamHeaderView : UIView

@property (nonatomic, strong) UILabel *titLab;
@property(nonatomic,copy) void (^choseSequenceBlock)(NSInteger index);

- (void)upNumberDataWith:(nullable NSDictionary*)dataDic;

@end

NS_ASSUME_NONNULL_END
