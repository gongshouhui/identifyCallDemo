//
//  YSFlowTenderHeaderView.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/23.
//

#import <UIKit/UIKit.h>


@interface YSFlowTenderHeaderView : UIView


@property (nonatomic, strong) UIImageView *dropDownImageView;
@property (nonatomic, strong) UILabel *unitLabel;
- (void)setFlowTenderHeaderData:(NSDictionary *)dic andIsspread:(NSString *)spreadStr;


@end
