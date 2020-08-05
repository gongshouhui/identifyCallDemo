//
//  YSGoodsDetailSectionHeaderView.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/5/16.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSGoodsDetailSectionHeaderView.h"

@implementation YSGoodsDetailSectionHeaderView
- (void)setGoodModel:(YSFlowGoodsDetailModel *)goodModel {
	self.arrowButton.userInteractionEnabled = NO;
	_goodModel = goodModel;
	NSString *detail = [NSString stringWithFormat:@"%@  %@ ",goodModel.goodsName,goodModel.thirdCate];
	NSMutableAttributedString *attiStr = [[NSMutableAttributedString alloc]initWithString:detail];
		[attiStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#111A34" alpha:1]} range:[detail rangeOfString:goodModel.goodsName]];
		[attiStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#0081EC" alpha:1]} range:[detail rangeOfString:[NSString stringWithFormat:@" %@",goodModel.thirdCate]]];
	self.nameTitleLb.attributedText =  attiStr;
	self.applycount.text = [NSString stringWithFormat:@"%ld",goodModel.applyNumber];
	self.pricelb.text = [YSUtility thousandsFormat:goodModel.refPrice];
}
- (IBAction)expandButtonAction:(UIButton *)sender {
	if ([self.delegate respondsToSelector:@selector(expandButtonDidClick:)]) {
		[self.delegate expandButtonDidClick:self.arrowButton];
	}
}
@end
