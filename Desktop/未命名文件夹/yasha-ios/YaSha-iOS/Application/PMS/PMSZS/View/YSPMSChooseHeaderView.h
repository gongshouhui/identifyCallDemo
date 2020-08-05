//
//  YSPMSChooseHeaderView.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/9.
//
//

#import <UIKit/UIKit.h>

@interface YSPMSChooseHeaderView : UICollectionReusableView

@property(strong,nonatomic)UILabel *titleLab;
-(void)setFilterTitle:(NSString *)title andIndex:(NSInteger)index;

@end
