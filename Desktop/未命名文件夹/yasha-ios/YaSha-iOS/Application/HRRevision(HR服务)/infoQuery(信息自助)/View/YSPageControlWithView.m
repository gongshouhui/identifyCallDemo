//
//  YSPageControlWithView.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2019/1/17.
//  Copyright © 2019年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPageControlWithView.h"
#define pageDistance 12      // 边距

@interface YSPageControlWithView (){
    
    NSInteger pageNumber;                    // 总的个数
    NSInteger currentPageNumber;            //  当前的下标
    UIImage   *currentImage;               //   当前图片
    UIImage   *pageIndicatorImage;        //    接下来图片
    
    CGSize    currentImageSize;          // 当前图片的Size
    CGSize    pageIndicatorImageSize;   //  接下来图片的Size
    
}
@end
@implementation YSPageControlWithView

-(instancetype)initWithCusPageControl:(CGRect)frame pageNum:(NSInteger)pageNum currentPageIndex:(NSInteger)currentPageIndex currentShowImage:(UIImage *)currentShowImage pageIndicatorShowImage:(UIImage *)pageIndicatorShowImage{
    if(self=[super initWithFrame:frame]){
        self.frame=frame;
        pageNumber=pageNum;
        currentPageNumber=currentPageIndex;
        currentImage=currentShowImage;
        pageIndicatorImage=pageIndicatorShowImage;
        
        currentImageSize=currentImage.size;
        pageIndicatorImageSize=pageIndicatorImage.size;
        
        [self createUI];   // 创建对应的UI
    }
    return self;
}
+(instancetype)cusPageControlWithView:(CGRect)frame pageNum:(NSInteger)pageNum currentPageIndex:(NSInteger)currentPageIndex currentShowImage:(UIImage *)currentShowImage pageIndicatorShowImage:(UIImage *)pageIndicatorShowImage{
    return [[self alloc]initWithCusPageControl:frame pageNum:pageNum currentPageIndex:currentPageIndex currentShowImage:currentShowImage pageIndicatorShowImage:pageIndicatorShowImage];
}

#pragma mark 创建对应的UI
-(void)createUI{
    for (int i=0;i<pageNumber; i++) {       // 创建对应的Button和设置Frame
        UIButton *button=[[UIButton alloc]init];
        [self addSubview:button];
        button.tag=i;
        [button addTarget:self action:@selector(clickPageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self calculateFrame]; // 计算对应的Frame
}
#pragma mark 计算各个视图对应的Frame
-(void)calculateFrame{
    CGFloat needMinWidth=(pageNumber-1)*(pageIndicatorImageSize.width+pageDistance)+currentImageSize.width; // 边距和Page的最小宽度
    CGFloat beginXValue=self.frame.size.width/2-needMinWidth/2;   // 开始的X值
    
    for (int i=0; i<self.subviews.count; i++) {
        UIView *view=self.subviews[i];
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button=(UIButton *)view;
            if(i==currentPageNumber){   // 当前的点
                [button setImage:currentImage forState:UIControlStateNormal];       // 设置对应的UIImage
                [button setImage:currentImage forState:UIControlStateHighlighted];
                
                button.frame=CGRectMake(beginXValue+(pageIndicatorImageSize.width+pageDistance)*currentPageNumber, (self.frame.size.height/2-currentImageSize.height/2), currentImageSize.width, currentImageSize.height); // 设置对应的Frame
            }
            else{  // 接下来的点
                
                CGFloat heightWithButton=self.frame.size.height/2-pageIndicatorImageSize.height/2;
                if(i>currentPageNumber){
                    button.frame=CGRectMake(beginXValue+pageDistance*i+(i-1)*pageIndicatorImageSize.width+currentImageSize.width, heightWithButton, pageIndicatorImageSize.width, pageIndicatorImageSize.height);
                }
                else{
                    button.frame=CGRectMake(beginXValue+(pageIndicatorImageSize.width+pageDistance)*i, heightWithButton, pageIndicatorImageSize.width, pageIndicatorImageSize.height);
                }
                [button setImage:pageIndicatorImage forState:UIControlStateNormal];      // 设置对应的UIImage
                [button setImage:pageIndicatorImage forState:UIControlStateHighlighted];
            }
        }
    }
}
#pragma mark 点击了对应的点
-(void)clickPageAction:(UIButton *)sender{
    
    if([self.delegate respondsToSelector:@selector(pageControlView:indexNum:)]){
        [self.delegate pageControlView:self indexNum:sender.tag];
    }
}
#pragma mark  重写Setting方法
-(void)setIndexNumWithSlide:(NSInteger)indexNumWithSlide{
    
    if (indexNumWithSlide>=self.subviews.count) return;
    
    if (currentPageNumber!=indexNumWithSlide) {
       
        _indexNumWithSlide=indexNumWithSlide;
        currentPageNumber=indexNumWithSlide;
        [self calculateFrame]; // 重写计算对应的Frame
    }
}

@end
