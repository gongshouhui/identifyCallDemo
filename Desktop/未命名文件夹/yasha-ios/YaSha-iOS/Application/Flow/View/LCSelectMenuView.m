//
//  LCSelectMenuView.m
//  LCSelectMenuView
//
//  Created by lcc on 2017/6/30.
//  Copyright © 2017年 early bird international. All rights reserved.
//

#import "LCSelectMenuView.h"
#import "UIView+Extension.h"



@interface LCSelectMenuView ()

@property (nonatomic,strong) UIScrollView *scrollView; //滚动菜单

@property (nonatomic,strong) UIView *bottomBarView;    //底部滚动条

@property (nonatomic,strong) UIButton *currentSelectBtn;  //当前选中的按钮

@property (nonatomic,copy) NSMutableArray *buttonsArray;  //存放所有的菜单按钮

@property (nonatomic,assign) CGFloat totalTitleWidth;

@property (nonatomic,assign) BOOL isBlock;    //防止block重复传递造成死循环

@property (nonatomic,strong) UIView *view;

@end

@implementation LCSelectMenuView

- (instancetype)init{

    if (self = [super init]) {
       
        
    }
    
    return self;
}


- (void)setUI{

    
//    [self addSubview:self.scrollView];
    [self addSubview:self.view];
    
    
}


#pragma -mark- setter and  getter

- (void)setCurrentPage:(NSInteger)currentPage {
    //防止重复设置
    if (_currentPage == currentPage) {

        return;
    }
    _currentPage = currentPage;
    if (self.titleArray.count == 0) {
        return;
    }
    //改变当前的按钮状态以及偏移对应的菜单
    UIButton *currentBtn = self.buttonsArray[currentPage];
    for (int i = 0; i < self.buttonsArray.count ; i++) {
        UIButton *btn = self.buttonsArray[i];
        if (btn.tag == currentBtn.tag) {
            currentBtn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
}

- (void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    [self setUI];
    self.isBlock = YES;
        for (int i = 0; i < titleArray.count; i++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:self.titleArray[i] forState:UIControlStateNormal];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn setTitleColor:kUIColor(189, 215, 254, 1.0) forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"ico16-location-empty"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"ico16-location"] forState:UIControlStateSelected];
            
            //上 左 下 右
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.tag = i+1;
            btn.frame = CGRects((20+85*i), 12, 70, 20);
            btn.titleLabel.textAlignment = NSTextAlignmentLeft;
            [btn addTarget:self action:@selector(changeSelectedState:) forControlEvents:UIControlEventTouchUpInside];
            
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            
            [self.view addSubview:btn];
            [self.buttonsArray addObject:btn];
            
            //默认选择第一个
            if (i == 0) {
                btn.selected = YES;
                btn.titleLabel.font = [UIFont systemFontOfSize:14];
                self.currentSelectBtn = btn;
            }
        }
}



- (void)changeSelectedState:(UIButton *)button{
    [UIView animateWithDuration:0.2 animations:^{
        if(self.pageSelectBlock && self.isBlock){
            self.currentPage = button.tag-1;  //更新当前的curPage
            self.pageSelectBlock(button.tag);
        }
        //默认将传递打开
        self.isBlock = YES;
    }];
}

#pragma -mark- lazyload

- (NSMutableArray *)buttonsArray{
 
    if (!_buttonsArray) {
        _buttonsArray = [NSMutableArray new];
    }
    
    return _buttonsArray;
}

- (UIScrollView *)scrollView{

    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        
        _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-2);
        
    }
    
    return _scrollView;
}

- (UIView *)view{
    if (!_view) {
        _view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44*kHeightScale)];
//        _view.backgroundColor = kUIColor(46, 106, 253, 1);
         [_view  setGradientBackgroundWithColors:@[kUIColor(84, 106, 253, 1),kUIColor(46, 193, 255, 1)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    }
    return _view;
}

//- (UIView *)bottomBarView{
//
//    if (!_bottomBarView) {
//        _bottomBarView = [UIView new];
//        _bottomBarView.backgroundColor = LCColorRGB(173, 135, 72);
//    }
//
//    return _bottomBarView;
//}

@end
