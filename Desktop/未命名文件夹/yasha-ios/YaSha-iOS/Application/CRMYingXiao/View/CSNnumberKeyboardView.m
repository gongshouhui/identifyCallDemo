//
//  CSNnumberKeyboardView.m
//  ProductionToolsDemo
//
//  Created by GZl on 2019/9/9.
//  Copyright © 2019 龙禧. All rights reserved.
//

#import "CSNnumberKeyboardView.h"

@interface CSNnumberKeyboardView ()

@property (nonatomic, copy) NSString *showNumStr;//显示的数字(没有币种)
@property (nonatomic, assign) CGFloat moneyFont;//显示的文字大小


@end


@implementation CSNnumberKeyboardView


- (instancetype)initWithFrame:(CGRect)frame withCurrencyStr:(NSString*)currencyStr withCurrentMoney:(NSString*)currentMoney {
    if ([super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CSNnumberKeyboardView" owner:self options:nil] firstObject];
        self.frame = frame;
        self.showNumStr = currencyStr;//金额
        self.moneyLab.text = currencyStr;
        self.moneyFont = 24;
        self.currencyStr = [currentMoney isEqualToString:@"美元"]?@"$":@"¥";//币种
        self.currencyLab.text = currentMoney;
        for (int i = 0; i < 14; i++) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedKeyboardBtnAction:)];
            [[self viewWithTag:1000+i] addGestureRecognizer:tap];
            tap.view.tag = 2000+i;
            
        }
        if (currencyStr.length>=1) {
            self.clearBtn.hidden = NO;
        }
        [self layoutViewChangeLabelFont];
    }
    return self;
}


//清除按钮
- (IBAction)clickedClearBtnAction:(UIButton *)sender {
    self.showNumStr = @"";
    self.moneyFont = 24;
    self.moneyLab.font = [UIFont systemFontOfSize:24];
    self.moneyLab.text = @"";
    sender.hidden = YES;
    if (self.clickedKeyboardBlock) {
        self.clickedKeyboardBlock(self.showNumStr);
    }
}

- (void)clickedKeyboardBtnAction:(UITapGestureRecognizer *)sender {
    switch (sender.view.tag) {
        case 2011://回收视图
        {
            if (self.choseBtnBlock) {
                self.choseBtnBlock(YES);
            }
        }
            break;
        case 2012://删除键
        {
            if (![YSUtility judgeIsEmpty:self.showNumStr]) {
                if (self.showNumStr.length == 1) {
                    self.showNumStr = @"";
                    self.moneyFont = 24;
                    self.moneyLab.font = [UIFont systemFontOfSize:24];
                }else {
                    self.showNumStr = [NSString stringWithFormat:@"%@", [self.showNumStr substringToIndex:self.showNumStr.length-1]];
                }
            }
        }
            break;
        case 2013://确定键
        {
            if (self.choseBtnBlock) {
                self.choseBtnBlock(YES);
            }
        }
            break;
        case 2010://小数点
        {
            if ([YSUtility judgeIsEmpty:self.showNumStr]) {
                self.showNumStr = @"0.";
            }else if (![self.showNumStr containsString:@"."]) {
                self.showNumStr = [NSString stringWithFormat:@"%@.", self.showNumStr];
            }
        }
            break;
        default://其他的为数字键 1000-1009
        {
            if (![self.showNumStr containsString:@"."]) {//不包含小数点
                if ([self.showNumStr isEqualToString:@"0"]) {
                    //第一位 为0
                    self.showNumStr = [NSString stringWithFormat:@"%ld", sender.view.tag-2000];
                }else {
                    // 第一位 不为0
                    self.showNumStr = [NSString stringWithFormat:@"%@%ld", self.showNumStr, sender.view.tag-2000];
                }
                
            }else {//包含小数点
                NSArray *pointArray = [self.showNumStr componentsSeparatedByString:@"."];
                //小数点之后保留两位
                if ([[pointArray lastObject] length] < 2) {
                    self.showNumStr = [NSString stringWithFormat:@"%@%ld", self.showNumStr, sender.view.tag-2000];
                }
            }
        }
            break;
    }
    self.clearBtn.hidden = [YSUtility judgeIsEmpty:self.showNumStr];
    [self changeMoneyLabeFont];
    self.moneyLab.text = self.showNumStr;
    if (self.clickedKeyboardBlock) {
        self.clickedKeyboardBlock(self.showNumStr.length == 0 ? @"" : [NSString stringWithFormat:@"%@%@", self.currencyStr, self.showNumStr]);
    }
}

//根据字符串长度更改文字大小
- (void)layoutViewChangeLabelFont {
    if ([YSUtility calculateRowWidthWithStr:self.showNumStr fontSize:self.moneyFont controlHeight:57] > (kSCREEN_WIDTH-141-17-50-10)*BIZ && self.moneyFont != 10) {
        self.moneyFont = self.moneyFont - 2;
        [self layoutViewChangeLabelFont];
    }else {
        self.moneyLab.font = [UIFont systemFontOfSize:self.moneyFont];
    }
}
- (void)changeMoneyLabeFont {
    if ([YSUtility calculateRowWidthWithStr:self.showNumStr fontSize:self.moneyFont controlHeight:57] > (kSCREEN_WIDTH-141-17-50-10)*BIZ && self.moneyFont != 10) {
        self.moneyFont = self.moneyFont-2;
        self.moneyLab.font = [UIFont systemFontOfSize:self.moneyFont];
    }else if (self.moneyFont < 24 && [YSUtility calculateRowWidthWithStr:self.showNumStr fontSize:self.moneyFont+1 controlHeight:57] < (kSCREEN_WIDTH-141-17-50-10)*BIZ) {
        self.moneyFont = self.moneyFont+1;
        self.moneyLab.font = [UIFont systemFontOfSize:self.moneyFont];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
