//
//  YSFlowScoreTableViewCell.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/23.
//

#import <UIKit/UIKit.h>

@interface YSFlowScoreTableViewCell : UITableViewCell
@property (nonatomic,strong) NSDictionary *invoiceDic;
@property (nonatomic, strong) UILabel *contentLabel;

- (void)setFlowScoreData:(NSArray *)contentArray andIndexPath:(NSIndexPath *)indexPath;
- (void)setFlowScoreDataWithLine:(NSArray *)contentArray andIndexPath:(NSIndexPath *)indexPath;
- (void)setExpenseDetailWithData:(NSArray *)contentArray andIndexPath:(NSIndexPath *)indexPath;

@end
