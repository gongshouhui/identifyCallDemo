//
//  MyScrollView.m
//  dingding
//
//  Created by mac on 16/4/14.
//  Copyright © 2016年 wyq. All rights reserved.
//

#import "MyScrollView.h"
#import "UIView+Utils.h"

@implementation MyScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
}
- (void)setTitleArr:(NSMutableArray *)titleArr{
    DLog(@"%lu",(unsigned long)titleArr.count);
    [self creatBtn:titleArr];
}

- (void)creatBtn:(NSMutableArray *)arr{
    UIButton * btn;
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    for (int i=0; i<arr.count; i++) {
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
        CGFloat length = [arr[i] boundingRectWithSize:CGSizeMake(20000, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        btn.frame = CGRectMake(15+w, 12, length, 30);
        
        NSString * title = [arr objectAtIndex:i];
        btn.tag = i+1;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
        w = btn.frame.size.width + btn.frame.origin.x +20;
        
        [self addSubview:btn];
        _btn = btn;
        _imv = [[UIImageView alloc]initWithFrame:CGRectMake(btn.right+10 , 20, 10, 15)];
        _imv.image = [UIImage imageNamed:@"选择"];
        [self addSubview:_imv];
        if (i==arr.count-1) {
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            btn.enabled = NO;
            _imv.hidden = YES;
        }
        else{
            [btn setTitleColor:[UIColor colorWithRed:42.0/255.0 green:138.0/255.0 blue:229.0/255.0 alpha:1.0]forState:UIControlStateNormal];
            btn.enabled = YES;
            
        }
        
    }
	
    self.contentSize = CGSizeMake(btn.frame.origin.x+60, 0);
    [self scrollRectToVisible:btn.frame animated:YES];
    
}

- (void)btn:(UIButton *)sender{
    
 
    NSString * title = sender.titleLabel.text;
    NSInteger tag = sender.tag;
    if (self.btnClick) {
        self.btnClick(title,tag);
    }
    
}


@end
