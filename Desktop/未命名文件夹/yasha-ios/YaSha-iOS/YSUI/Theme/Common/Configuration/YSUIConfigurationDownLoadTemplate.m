//
//  YSUIConfigurationDownLoadTemplate.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/11/20.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSUIConfigurationDownLoadTemplate.h"

@implementation YSUIConfigurationDownLoadTemplate
- (YSUIConfigurationTemplate *)defaultTemple {
    if (!_defaultTemple) {
        _defaultTemple = [[YSUIConfigurationTemplate alloc]init];
    }
    return _defaultTemple;
}
- (YSThemeConfigModel *)configModel {//将本地沙盒中的json文件转化为模型文件
    if (!_configModel) {
        // 获取文件路径
        NSString *unZipPath = [YSDocumentPath stringByAppendingPathComponent:[YSUserDefaults valueForKey:YSSkinSign]];
    NSString *path = [NSString stringWithFormat:@"%@/skinResource/config.json",unZipPath];
        // 将文件数据化
        NSData *data = [NSData dataWithContentsOfFile:path];
        // 对数据进行JSON格式化并返回字典形式
        if (data) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            _configModel = [YSThemeConfigModel yy_modelWithJSON:dic];
			//解决app桌面突变设置不成功的情况
			if ([_configModel.iconName isEqualToString:@"newYear"]) {//bundle里存好的APP图标名字
				[YSUtility setAppIconWithName:@"newYear"];
			}
        }else{
            _configModel = nil;
        }
       
    }
    return _configModel;
}
- (void)setupConfigurationTemplate {
    
    // === 修改配置值 === //
    
#pragma mark - Global Color
    
    QMUICMI.clearColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];       // UIColorClear : 透明色
    QMUICMI.whiteColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];       // UIColorWhite : 白色（不用 [UIColor whiteColor] 是希望保持颜色空间为 RGB）
    QMUICMI.blackColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];       // UIColorBlack : 黑色（不用 [UIColor blackColor] 是希望保持颜色空间为 RGB）
    QMUICMI.grayColor = UIColorGray4;                                           // UIColorGray  : 最常用的灰色
    QMUICMI.grayDarkenColor = UIColorGray3;                                     // UIColorGrayDarken : 深一点的灰色
    QMUICMI.grayLightenColor = UIColorGray7;                                    // UIColorGrayLighten : 浅一点的灰色
    QMUICMI.redColor = UIColorMake(250, 58, 58);                                // UIColorRed : 红色
    QMUICMI.greenColor = UIColorTheme4;                                         // UIColorGreen : 绿色
    QMUICMI.blueColor = UIColorMake(49, 189, 243);                              // UIColorBlue : 蓝色
    QMUICMI.yellowColor = UIColorTheme3;                                        // UIColorYellow : 黄色
    
    QMUICMI.linkColor = UIColorMake(56, 116, 171);                              // UIColorLink : 文字链接颜色
    QMUICMI.disabledColor = UIColorGray;                                        // UIColorDisabled : 全局 disabled 的颜色，一般用于 UIControl 等控件
    QMUICMI.backgroundColor = UIColorWhite;                                     // UIColorForBackground : 界面背景色，默认用于 QMUICommonViewController.view 的背景色
    QMUICMI.maskDarkColor = UIColorMakeWithRGBA(0, 0, 0, .35f);                 // UIColorMask : 深色的背景遮罩，默认用于 QMAlertController、QMUIDialogViewController 等弹出控件的遮罩
    QMUICMI.maskLightColor = UIColorMakeWithRGBA(255, 255, 255, .5f);           // UIColorMaskWhite : 浅色的背景遮罩，QMUIKit 里默认没用到，只是占个位
    QMUICMI.separatorColor = UIColorMake(222, 224, 226);                        // UIColorSeparator : 全局默认的分割线颜色，默认用于列表分隔线颜色、UIView (QMUI_Border) 分隔线颜色
    QMUICMI.separatorDashedColor = UIColorMake(17, 17, 17);                     // UIColorSeparatorDashed : 全局默认的虚线分隔线的颜色，默认 QMUIKit 暂时没用到
    QMUICMI.placeholderColor = UIColorGray8;                                    // UIColorPlaceholder，全局的输入框的 placeholder 颜色，默认用于 QMUITextField、QMUITextView，不影响系统 UIKit 的输入框
    
    // 测试用的颜色
    QMUICMI.testColorRed = UIColorMakeWithRGBA(255, 0, 0, .3);
    QMUICMI.testColorGreen = UIColorMakeWithRGBA(0, 255, 0, .3);
    QMUICMI.testColorBlue = UIColorMakeWithRGBA(0, 0, 255, .3);
    
    
#pragma mark - UIControl
    
    QMUICMI.controlHighlightedAlpha = 0.5f;                                     // UIControlHighlightedAlpha : UIControl 系列控件在 highlighted 时的 alpha，默认用于 QMUIButton、 QMUINavigationTitleView
    QMUICMI.controlDisabledAlpha = 0.5f;                                        // UIControlDisabledAlpha : UIControl 系列控件在 disabled 时的 alpha，默认用于 QMUIButton
    
#pragma mark - UIButton
    QMUICMI.buttonHighlightedAlpha = UIControlHighlightedAlpha;                 // ButtonHighlightedAlpha : QMUIButton 在 highlighted 时的 alpha，不影响系统的 UIButton
    QMUICMI.buttonDisabledAlpha = UIControlDisabledAlpha;                       // ButtonDisabledAlpha : QMUIButton 在 disabled 时的 alpha，不影响系统的 UIButton
    QMUICMI.buttonTintColor = self.themeTintColor;                              // ButtonTintColor : QMUIButton 默认的 tintColor，不影响系统的 UIButton
    
    QMUICMI.ghostButtonColorBlue = UIColorBlue;                                 // GhostButtonColorBlue : QMUIGhostButtonColorBlue 的颜色
    QMUICMI.ghostButtonColorRed = UIColorRed;                                   // GhostButtonColorRed : QMUIGhostButtonColorRed 的颜色
    QMUICMI.ghostButtonColorGreen = UIColorGreen;                               // GhostButtonColorGreen : QMUIGhostButtonColorGreen 的颜色
    QMUICMI.ghostButtonColorGray = UIColorGray;                                 // GhostButtonColorGray : QMUIGhostButtonColorGray 的颜色
    QMUICMI.ghostButtonColorWhite = UIColorWhite;                               // GhostButtonColorWhite : QMUIGhostButtonColorWhite 的颜色
    
    QMUICMI.fillButtonColorBlue = UIColorBlue;                                  // FillButtonColorBlue : QMUIFillButtonColorBlue 的颜色
    QMUICMI.fillButtonColorRed = UIColorRed;                                    // FillButtonColorRed : QMUIFillButtonColorRed 的颜色
    QMUICMI.fillButtonColorGreen = UIColorGreen;                                // FillButtonColorGreen : QMUIFillButtonColorGreen 的颜色
    QMUICMI.fillButtonColorGray = UIColorGray;                                  // FillButtonColorGray : QMUIFillButtonColorGray 的颜色
    QMUICMI.fillButtonColorWhite = UIColorWhite;                                // FillButtonColorWhite : QMUIFillButtonColorWhite 的颜色
    
    
#pragma mark - TextField & TextView
    QMUICMI.textFieldTintColor = self.themeTintColor;                           // TextFieldTintColor : QMUITextField、QMUITextView 的 tintColor，不影响 UIKit 的输入框
    QMUICMI.textFieldTextInsets = UIEdgeInsetsMake(0, 7, 0, 7);                 // TextFieldTextInsets : QMUITextField 的内边距，不影响 UITextField
    
#pragma mark - NavigationBar
    
    QMUICMI.navBarHighlightedAlpha = 0.2f;                                      // NavBarHighlightedAlpha : QMUINavigationButton 在 highlighted 时的 alpha
    QMUICMI.navBarDisabledAlpha = 0.2f;                                         // NavBarDisabledAlpha : QMUINavigationButton 在 disabled 时的 alpha
    QMUICMI.navBarButtonFont = UIFontMake(17);                                  // NavBarButtonFont : QMUINavigationButtonTypeNormal 的字体（由于系统存在一些 bug，这个属性默认不对 UIBarButtonItem 生效）
    QMUICMI.navBarButtonFontBold = UIFontBoldMake(17);                          // NavBarButtonFontBold : QMUINavigationButtonTypeBold 的字体
    //    QMUICMI.navBarBackgroundImage = UIImageMake(@"navigationbar_background");   // NavBarBackgroundImage : UINavigationBar 的背景图
#warning 设置导航栏的颜色
    QMUICMI.navBarBackgroundImage = [YSUIHelper imageWithColor:self.themeNavColor];   // NavBarBackgroundImage : UINavigationBar 的背景图
    QMUICMI.navBarShadowImage = [UIImage new];                                  // NavBarShadowImage : UINavigationBar.shadowImage，也即导航栏底部那条分隔线
    QMUICMI.navBarBarTintColor = nil;                                           // NavBarBarTintColor : UINavigationBar.barTintColor，也即背景色
    QMUICMI.navBarTintColor = self.themeNavBarTintColor;                                     // NavBarTintColor : QMUINavigationBar 的 tintColor，也即导航栏上面的按钮颜色
    QMUICMI.navBarTitleColor = self.themeNavTitleColor;                                 // NavBarTitleColor : UINavigationBar 的标题颜色，以及 QMUINavigationTitleView 的默认文字颜色
    //    QMUICMI.navBarTitleFont = UIFontBoldMake(17);                               // NavBarTitleFont : UINavigationBar 的标题字体，以及 QMUINavigationTitleView 的默认字体
    QMUICMI.navBarTitleFont = [UIFont systemFontOfSize:18];                               // NavBarTitleFont : UINavigationBar 的标题字体，以及 QMUINavigationTitleView 的默认字体
    QMUICMI.navBarLargeTitleColor = nil;                                        // NavBarLargeTitleColor : UINavigationBar 在大标题模式下的标题颜色，仅在 iOS 11 之后才有效
    QMUICMI.navBarLargeTitleFont = nil;                                         // NavBarLargeTitleFont : UINavigationBar 在大标题模式下的标题字体，仅在 iOS 11 之后才有效
    QMUICMI.navBarBackButtonTitlePositionAdjustment = UIOffsetZero;             // NavBarBarBackButtonTitlePositionAdjustment : 导航栏返回按钮的文字偏移
    QMUICMI.navBarBackIndicatorImage = [UIImage qmui_imageWithShape:QMUIImageShapeNavBack size:CGSizeMake(12, 20) tintColor:NavBarTintColor];                                     // NavBarBackIndicatorImage : 导航栏的返回按钮的图片
    QMUICMI.navBarCloseButtonImage = [UIImage qmui_imageWithShape:QMUIImageShapeNavClose size:CGSizeMake(16, 16) tintColor:NavBarTintColor];     // NavBarCloseButtonImage : QMUINavigationButton 用到的 × 的按钮图片
    
    QMUICMI.navBarLoadingMarginRight = 3;                                       // NavBarLoadingMarginRight : QMUINavigationTitleView 里左边 loading 的右边距
    QMUICMI.navBarAccessoryViewMarginLeft = 5;                                  // NavBarAccessoryViewMarginLeft : QMUINavigationTitleView 里右边 accessoryView 的左边距
    QMUICMI.navBarActivityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;// NavBarActivityIndicatorViewStyle : QMUINavigationTitleView 里左边 loading 的主题
    QMUICMI.navBarAccessoryViewTypeDisclosureIndicatorImage = [UIImage qmui_imageWithShape:QMUIImageShapeTriangle size:CGSizeMake(8, 5) tintColor:UIColorWhite];     // NavBarAccessoryViewTypeDisclosureIndicatorImage : QMUINavigationTitleView 右边箭头的图片
    
#pragma mark - TabBar
    
    QMUICMI.tabBarBackgroundImage = [[UIImage qmui_imageWithColor:UIColorMake(249, 249, 249)] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];   // TabBarBackgroundImage : UITabBar 的背景图，建议使用 resizableImage，否则在 UITabBar (NavigationController) 的 setBackgroundImage: 里会每次都视为 image 发生了变化（isEqual: 为 NO）
    QMUICMI.tabBarBarTintColor = nil;                                           // TabBarBarTintColor : UITabBar 的 barTintColor
    QMUICMI.tabBarShadowImageColor = UIColorSeparator;                          // TabBarShadowImageColor : UITabBar 的 shadowImage 的颜色，会自动创建一张 1px 高的图片
    QMUICMI.tabBarTintColor = UIColorMake(4, 189, 231);                         // TabBarTintColor : UITabBar 的 tintColor
    QMUICMI.tabBarItemTitleColor = UIColorGray6;                                // TabBarItemTitleColor : 未选中的 UITabBarItem 的标题颜色
    QMUICMI.tabBarItemTitleColorSelected = TabBarTintColor;                     // TabBarItemTitleColorSelected : 选中的 UITabBarItem 的标题颜色
    QMUICMI.tabBarItemTitleFont = nil;                                          // TabBarItemTitleFont : UITabBarItem 的标题字体
    
#pragma mark - Toolbar
    
    QMUICMI.toolBarHighlightedAlpha = 0.4f;                                     // ToolBarHighlightedAlpha : QMUIToolbarButton 在 highlighted 状态下的 alpha
    QMUICMI.toolBarDisabledAlpha = 0.4f;                                        // ToolBarDisabledAlpha : QMUIToolbarButton 在 disabled 状态下的 alpha
    QMUICMI.toolBarTintColor = UIColorBlue;                                     // ToolBarTintColor : UIToolbar 的 tintColor，以及 QMUIToolbarButton normal 状态下的文字颜色
    QMUICMI.toolBarTintColorHighlighted = [ToolBarTintColor colorWithAlphaComponent:ToolBarHighlightedAlpha];   // ToolBarTintColorHighlighted : QMUIToolbarButton 在 highlighted 状态下的文字颜色
    QMUICMI.toolBarTintColorDisabled = [ToolBarTintColor colorWithAlphaComponent:ToolBarDisabledAlpha];         // ToolBarTintColorDisabled : QMUIToolbarButton 在 disabled 状态下的文字颜色
    QMUICMI.toolBarBackgroundImage = nil;                                       // ToolBarBackgroundImage : UIToolbar 的背景图
    QMUICMI.toolBarBarTintColor = nil;                                          // ToolBarBarTintColor : UIToolbar 的 tintColor
    QMUICMI.toolBarShadowImageColor = UIColorSeparator;                         // ToolBarShadowImageColor : UIToolbar 的 shadowImage 的颜色，会自动创建一张 1px 高的图片
    QMUICMI.toolBarButtonFont = UIFontMake(17);                                 // ToolBarButtonFont : QMUIToolbarButton 的字体
    
#pragma mark - SearchBar
    
    //    QMUICMI.searchBarTextFieldBackground = UIColorMake(237, 238, 240);          // SearchBarTextFieldBackground : QMUISearchBar 里的文本框的背景颜色
    //    QMUICMI.searchBarTextFieldBorderColor = nil;                                // SearchBarTextFieldBorderColor : QMUISearchBar 里的文本框的边框颜色
    //    QMUICMI.searchBarBottomBorderColor = UIColorClear;                          // SearchBarBottomBorderColor : QMUISearchBar 底部分隔线颜色
    //    QMUICMI.searchBarBarTintColor = UIColorWhite;                               // SearchBarBarTintColor : QMUISearchBar 的 barTintColor，也即背景色
    //    QMUICMI.searchBarTintColor = self.themeTintColor;                           // SearchBarTintColor : QMUISearchBar 的 tintColor，也即上面的操作控件的主题色
    //    QMUICMI.searchBarTextColor = UIColorBlack;                                  // SearchBarTextColor : QMUISearchBar 里的文本框的文字颜色
    //    QMUICMI.searchBarPlaceholderColor = UIColorMake(136, 136, 143);             // SearchBarPlaceholderColor : QMUISearchBar 里的文本框的 placeholder 颜色
    //    QMUICMI.searchBarFont = nil;                                                // SearchBarFont : QMUISearchBar 里的文本框的文字字体及 placeholder 的字体
    //    QMUICMI.searchBarSearchIconImage = nil;                                     // SearchBarSearchIconImage : QMUISearchBar 里的放大镜 icon
    //    QMUICMI.searchBarClearIconImage = nil;                                      // SearchBarClearIconImage : QMUISearchBar 里的文本框输入文字时右边的清空按钮的图片
    //    QMUICMI.searchBarTextFieldCornerRadius = 4.0;                               // SearchBarTextFieldCornerRadius : QMUISearchBar 里的文本框的圆角大小
    
    QMUICMI.searchBarTextFieldBackground = UIColorWhite;          // SearchBarTextFieldBackground : QMUISearchBar 里的文本框的背景颜色
    QMUICMI.searchBarTextFieldBorderColor = UIColorMake(205, 208, 210);                                // SearchBarTextFieldBorderColor : QMUISearchBar 里的文本框的边框颜色
    QMUICMI.searchBarBottomBorderColor = UIColorMake(205, 208, 210);                          // SearchBarBottomBorderColor : QMUISearchBar 底部分隔线颜色
    QMUICMI.searchBarBarTintColor = UIColorMake(247, 247, 247);                               // SearchBarBarTintColor : QMUISearchBar 的 barTintColor，也即背景色
    QMUICMI.searchBarTintColor = self.themeTintColor;                           // SearchBarTintColor : QMUISearchBar 的 tintColor，也即上面的操作控件的主题色
    QMUICMI.searchBarTextColor = UIColorBlack;                                  // SearchBarTextColor : QMUISearchBar 里的文本框的文字颜色
    QMUICMI.searchBarPlaceholderColor = UIColorPlaceholder;             // SearchBarPlaceholderColor : QMUISearchBar 里的文本框的 placeholder 颜色
    QMUICMI.searchBarFont = nil;                                                // SearchBarFont : QMUISearchBar 里的文本框的文字字体及 placeholder 的字体
    QMUICMI.searchBarSearchIconImage = nil;                                     // SearchBarSearchIconImage : QMUISearchBar 里的放大镜 icon
    QMUICMI.searchBarClearIconImage = nil;                                      // SearchBarClearIconImage : QMUISearchBar 里的文本框输入文字时右边的清空按钮的图片
    QMUICMI.searchBarTextFieldCornerRadius = 4.0;                               // SearchBarTextFieldCornerRadius : QMUISearchBar 里的文本框的圆角大小
    
#pragma mark - TableView / TableViewCell
    
    QMUICMI.tableViewEstimatedHeightEnabled = NO;                               // TableViewEstimatedHeightEnabled : 是否要开启全局 UITableView 的 estimatedRow(Section/Footer)Height
    
    QMUICMI.tableViewBackgroundColor = nil;                                     // TableViewBackgroundColor : Plain 类型的 QMUITableView 的背景色颜色
    QMUICMI.tableViewGroupedBackgroundColor = UIColorMake(246, 246, 246);       // TableViewGroupedBackgroundColor : Grouped 类型的 QMUITableView 的背景色
    QMUICMI.tableSectionIndexColor = UIColorGrayDarken;                         // TableSectionIndexColor : 列表右边的字母索引条的文字颜色
    QMUICMI.tableSectionIndexBackgroundColor = UIColorClear;                    // TableSectionIndexBackgroundColor : 列表右边的字母索引条的背景色
    QMUICMI.tableSectionIndexTrackingBackgroundColor = UIColorClear;            // TableSectionIndexTrackingBackgroundColor : 列表右边的字母索引条在选中时的背景色
    QMUICMI.tableViewSeparatorColor = UIColorSeparator;                         // TableViewSeparatorColor : 列表的分隔线颜色
    
    QMUICMI.tableViewCellNormalHeight = 56;                                     // TableViewCellNormalHeight : 列表默认的 cell 高度
    QMUICMI.tableViewCellTitleLabelColor = UIColorGray3;                        // TableViewCellTitleLabelColor : QMUITableViewCell 的 textLabel 的文字颜色
    QMUICMI.tableViewCellDetailLabelColor = UIColorGray5;                       // TableViewCellDetailLabelColor : QMUITableViewCell 的 detailTextLabel 的文字颜色
    QMUICMI.tableViewCellBackgroundColor = UIColorWhite;                        // TableViewCellBackgroundColor : QMUITableViewCell 的背景色
    QMUICMI.tableViewCellSelectedBackgroundColor = UIColorMake(238, 239, 241);  // TableViewCellSelectedBackgroundColor : QMUITableViewCell 点击时的背景色
    QMUICMI.tableViewCellWarningBackgroundColor = UIColorYellow;                // TableViewCellWarningBackgroundColor : QMUITableViewCell 用于表示警告时的背景色，备用
    QMUICMI.tableViewCellDisclosureIndicatorImage = [UIImage qmui_imageWithShape:QMUIImageShapeDisclosureIndicator size:CGSizeMake(6, 10) lineWidth:1 tintColor:UIColorMake(173, 180, 190)];    // TableViewCellDisclosureIndicatorImage : QMUITableViewCell 当 accessoryType 为 UITableViewCellAccessoryDisclosureIndicator 时的箭头的图片
    QMUICMI.tableViewCellCheckmarkImage = [UIImage qmui_imageWithShape:QMUIImageShapeCheckmark size:CGSizeMake(15, 12) tintColor:self.themeTintColor];  // TableViewCellCheckmarkImage : QMUITableViewCell 当 accessoryType 为 UITableViewCellAccessoryCheckmark 时的打钩的图片
    QMUICMI.tableViewCellDetailButtonImage = [UIImage qmui_imageWithShape:QMUIImageShapeDetailButtonImage size:CGSizeMake(20, 20) tintColor:self.themeTintColor]; // TableViewCellDetailButtonImage : QMUITableViewCell 当 accessoryType 为 UITableViewCellAccessoryDetailButton 或 UITableViewCellAccessoryDetailDisclosureButton 时右边的 i 按钮图片
    QMUICMI.tableViewCellSpacingBetweenDetailButtonAndDisclosureIndicator = 12; // TableViewCellSpacingBetweenDetailButtonAndDisclosureIndicator : 列表 cell 右边的 i 按钮和向右箭头之间的间距（仅当两者都使用了自定义图片并且同时显示时才生效）
    
    QMUICMI.tableViewSectionHeaderBackgroundColor = UIColorMake(244, 244, 244);                         // TableViewSectionHeaderBackgroundColor : Plain 类型的 QMUITableView sectionHeader 的背景色
    QMUICMI.tableViewSectionFooterBackgroundColor = UIColorMake(244, 244, 244);                         // TableViewSectionFooterBackgroundColor : Plain 类型的 QMUITableView sectionFooter 的背景色
    QMUICMI.tableViewSectionHeaderFont = UIFontBoldMake(12);                                            // TableViewSectionHeaderFont : Plain 类型的 QMUITableView sectionHeader 里的文字字体
    QMUICMI.tableViewSectionFooterFont = UIFontBoldMake(12);                                            // TableViewSectionFooterFont : Plain 类型的 QMUITableView sectionFooter 里的文字字体
    QMUICMI.tableViewSectionHeaderTextColor = UIColorGray5;                                             // TableViewSectionHeaderTextColor : Plain 类型的 QMUITableView sectionHeader 里的文字颜色
    QMUICMI.tableViewSectionFooterTextColor = UIColorGray;                                              // TableViewSectionFooterTextColor : Plain 类型的 QMUITableView sectionFooter 里的文字颜色
    QMUICMI.tableViewSectionHeaderAccessoryMargins = UIEdgeInsetsMake(0, 15, 0, 0);                     // TableViewSectionHeaderAccessoryMargins : Plain 类型的 QMUITableView sectionHeader accessoryView 的间距
    QMUICMI.tableViewSectionFooterAccessoryMargins = UIEdgeInsetsMake(0, 15, 0, 0);                     // TableViewSectionFooterAccessoryMargins : Plain 类型的 QMUITableView sectionFooter accessoryView 的间距
    QMUICMI.tableViewSectionHeaderContentInset = UIEdgeInsetsMake(4, 15, 4, 15);                        // TableViewSectionHeaderContentInset : Plain 类型的 QMUITableView sectionHeader 里的内容的 padding
    QMUICMI.tableViewSectionFooterContentInset = UIEdgeInsetsMake(4, 15, 4, 15);                        // TableViewSectionFooterContentInset : Plain 类型的 QMUITableView sectionFooter 里的内容的 padding
    
    QMUICMI.tableViewGroupedSectionHeaderFont = UIFontMake(12);                                         // TableViewGroupedSectionHeaderFont : Grouped 类型的 QMUITableView sectionHeader 里的文字字体
    QMUICMI.tableViewGroupedSectionFooterFont = UIFontMake(12);                                         // TableViewGroupedSectionFooterFont : Grouped 类型的 QMUITableView sectionFooter 里的文字字体
    QMUICMI.tableViewGroupedSectionHeaderTextColor = UIColorGrayDarken;                                 // TableViewGroupedSectionHeaderTextColor : Grouped 类型的 QMUITableView sectionHeader 里的文字颜色
    QMUICMI.tableViewGroupedSectionFooterTextColor = UIColorGray;                                       // TableViewGroupedSectionFooterTextColor : Grouped 类型的 QMUITableView sectionFooter 里的文字颜色
    QMUICMI.tableViewGroupedSectionHeaderAccessoryMargins = UIEdgeInsetsMake(0, 15, 0, 0);                     // TableViewGroupedSectionHeaderAccessoryMargins : Grouped 类型的 QMUITableView sectionHeader accessoryView 的间距
    QMUICMI.tableViewGroupedSectionFooterAccessoryMargins = UIEdgeInsetsMake(0, 15, 0, 0);                     // TableViewGroupedSectionFooterAccessoryMargins : Grouped 类型的 QMUITableView sectionFooter accessoryView 的间距
    QMUICMI.tableViewGroupedSectionHeaderDefaultHeight = UITableViewAutomaticDimension;                 // TableViewGroupedSectionHeaderDefaultHeight : Grouped 类型的 QMUITableView sectionHeader 的默认高度（也即没使用自定义的 sectionHeaderView 时的高度），注意如果不需要间距，请用 CGFLOAT_MIN
    QMUICMI.tableViewGroupedSectionFooterDefaultHeight = UITableViewAutomaticDimension;                 // TableViewGroupedSectionFooterDefaultHeight : Grouped 类型的 QMUITableView sectionFooter 的默认高度（也即没使用自定义的 sectionFooterView 时的高度），注意如果不需要间距，请用 CGFLOAT_MIN
    QMUICMI.tableViewGroupedSectionHeaderContentInset = UIEdgeInsetsMake(16, PreferredVarForDevices(20, 15, 15, 15), 8, PreferredVarForDevices(20, 15, 15, 15));    // TableViewGroupedSectionHeaderContentInset : Grouped 类型的 QMUITableView sectionHeader 里的内容的 padding
    QMUICMI.tableViewGroupedSectionFooterContentInset = UIEdgeInsetsMake(8, 15, 2, 15);                 // TableViewGroupedSectionFooterContentInset : Grouped 类型的 QMUITableView sectionFooter 里的内容的 padding
    
#pragma mark - UIWindowLevel
    QMUICMI.windowLevelQMUIAlertView = UIWindowLevelAlert - 4.0;                // UIWindowLevelQMUIAlertView : QMUIModalPresentationViewController、QMUIPopupContainerView 里使用的 UIWindow 的 windowLevel
    QMUICMI.windowLevelQMUIImagePreviewView = UIWindowLevelStatusBar + 1.0;     // UIWindowLevelQMUIImagePreviewView : QMUIImagePreviewViewController 里使用的 UIWindow 的 windowLevel
    
#pragma mark - QMUILog
    QMUICMI.shouldPrintDefaultLog = YES;                                        // ShouldPrintDefaultLog : 是否允许输出 QMUILogLevelDefault 级别的 log
    QMUICMI.shouldPrintInfoLog = YES;                                           // ShouldPrintInfoLog : 是否允许输出 QMUILogLevelInfo 级别的 log
    QMUICMI.shouldPrintWarnLog = YES;                                           // ShouldPrintInfoLog : 是否允许输出 QMUILogLevelWarn 级别的 log
    
#pragma mark - Others
    
    QMUICMI.supportedOrientationMask = UIInterfaceOrientationMaskAll;           // SupportedOrientationMask : 默认支持的横竖屏方向
    QMUICMI.automaticallyRotateDeviceOrientation = YES;                         // AutomaticallyRotateDeviceOrientation : 是否在界面切换或 viewController.supportedOrientationMask 发生变化时自动旋转屏幕
    QMUICMI.statusbarStyleLightInitially = self.statusBarStytleLightContent;                                 // StatusbarStyleLightInitially : 默认的状态栏内容是否使用白色，默认为 NO，也即黑色
    QMUICMI.needsBackBarButtonItemTitle = NO;                                   // NeedsBackBarButtonItemTitle : 全局是否需要返回按钮的 title，不需要则只显示一个返回image
    QMUICMI.hidesBottomBarWhenPushedInitially = YES;                            // HidesBottomBarWhenPushedInitially : QMUICommonViewController.hidesBottomBarWhenPushed 的初始值，默认为 NO，以保持与系统默认值一致，但通常建议改为 YES，因为一般只有 tabBar 首页那几个界面要求为 NO
    QMUICMI.navigationBarHiddenInitially = NO;                                  // NavigationBarHiddenInitially : QMUINavigationControllerDelegate preferredNavigationBarHidden 的初始值，默认为NO
    QMUICMI.shouldFixTabBarTransitionBugInIPhoneX = YES;                        // ShouldFixTabBarTransitionBugInIPhoneX : 是否需要自动修复 iOS 11 下，iPhone X 的设备在 push 界面时，tabBar 会瞬间往上跳的 bug
    
}

#pragma mark - <QDThemeProtocol>
- (UIColor *)themeTintColor {
    if (self.configModel.themeColor.length) {
        return [UIColor colorWithHexString:self.configModel.themeColor];
    }else{//返回默认
        return self.defaultTemple.themeTintColor;
    }
}
#pragma mark - 导航栏
- (UIColor *)themeNavBarTintColor {
    if (self.configModel.themeNavi.barButtonColor.length) {//下载配置
        return [UIColor colorWithHexString:self.configModel.themeNavi.barButtonColor];
    }else {//返回默认
        return self.defaultTemple.themeNavBarTintColor;
    }
}
- (UIColor *)themeNavTitleColor {
    if (self.configModel.themeNavi.titleColor.length) {
        return [UIColor colorWithHexString:self.configModel.themeNavi.titleColor];
    }else{
        return self.defaultTemple.themeNavBarTintColor;
    }
}
//导航栏颜色
- (UIColor *)themeNavColor {
    if (self.configModel.themeNavi.color.length) {
        return [UIColor colorWithHexString:self.configModel.themeNavi.color];
    }else{
        return self.defaultTemple.themeNavColor;
    }
   
}
- (UIColor *)loginButtonColor {
    if (self.configModel.loginBgColor.length) {
        return [UIColor colorWithHexString:self.configModel.loginBgColor];
    }else{
        return self.defaultTemple.loginButtonColor;
    }
}
- (BOOL)statusBarStytleLightContent {
    return self.configModel.themeNavi.statusBarStytleLightContent;
}
#pragma mark - tabbar
- (NSArray *)themeTabBarItemImage {
    NSMutableArray *mutArray = [NSMutableArray array];
    for (YSThemeTabBarItemModel *model in self.configModel.themeTabbar.items) {
        UIImage *image = [self getOriginImageWithImage:[self getImageWithName:model.normalImage]];
        if (image) {
            [mutArray addObject:image];
        }
        
    }
    if (mutArray.count == 4) {
        return [mutArray copy];
    }
    return self.defaultTemple.themeTabBarItemImage;
    
}

- (NSArray *)themeTabBarItemImageSelected {
    NSMutableArray *mutArray = [NSMutableArray array];
    for (YSThemeTabBarItemModel *model in self.configModel.themeTabbar.items) {
         UIImage *image = [self getOriginImageWithImage:[self getImageWithName:model.selectedImage]];
        if (image) {
            [mutArray addObject:image];
        }
        
    }
    if (mutArray.count == 4) {
        return [mutArray copy];
    }
    return self.defaultTemple.themeTabBarItemImageSelected;
}
/**tabbar item正常状态下的颜色*/
- (UIColor *)themeTabBarItemNormalColor {
    if (self.configModel.themeTabbar.items.firstObject.normalTitleColor.length) {
        return [UIColor colorWithHexString:self.configModel.themeTabbar.items.firstObject.normalTitleColor];
    }else {
        return self.defaultTemple.themeTabBarItemNormalColor;
    }
    
}
/**tabbar item选中状态下的颜色*/
- (UIColor *)themeTabBarItemSelectedColor {
    if (self.configModel.themeTabbar.items.firstObject.normalTitleColor.length) {
        return [UIColor colorWithHexString:self.configModel.themeTabbar.items.firstObject.selectedTitleColor];
    }else {
        return self.defaultTemple.themeTabBarItemSelectedColor;
    }
}
- (UIImage *)themeTabBarBackgroundImage {

    return  [self getImageWithName:self.configModel.themeTabbar.background_image];
}
- (UIColor *)themeListTextColor {
    return self.themeTintColor;
}
- (UIColor *)themeCodeColor {
    return self.themeTintColor;
}

- (UIColor *)themeGridItemTintColor {
    return nil;
}

- (NSString *)themeName {
    return @"Default";
}


- (UIImage *)themeLogoImage {
    if (self.configModel.loginImage.length) {
        return [self getImageWithName:self.configModel.loginImage];
    }else {
        return self.defaultTemple.themeLogoImage;
    }
    
}


- (UIImage *)themeContactBackgroundImage {
    if (self.configModel.personInfoBg.length) {
        return [self getImageWithName:self.configModel.personInfoBg];
    }else {
        return self.defaultTemple.themeContactBackgroundImage;
    }
}

- (UIImage *)themeMineBackgroundImage {
    
    if (self.configModel.meInfoBg.length) {
        return [self getImageWithName:self.configModel.meInfoBg];
    }else {
        return self.defaultTemple.themeMineBackgroundImage;
    }
}

- (UIColor *)themeCalendarColor {
    return self.themeTintColor;
}
- (UIImage *)themeWorkItemImageWithItemType:(WorkbenchItemType)itemType {
    UIImage *image = nil;
    if (itemType == WorkbenchItemNeedToDo) {
        image = [self getImageWithName:self.configModel.workBench.needTodo];
    }
    if (itemType == WorkbenchItemCalendar) {
        image = [self getImageWithName:self.configModel.workBench.calendar];
    }
    if (itemType == WorkbenchItemNewsBulletin) {
        image = [self getImageWithName:self.configModel.workBench.newsBulletin];
    }
    if (itemType == WorkbenchItemHR) {
         image = [self getImageWithName:self.configModel.workBench.itemHR];
    }
    if (itemType == WorkbenchItemAssets) {
        image = [self getImageWithName:self.configModel.workBench.assets];
    }
    if (itemType == WorkbenchItemRepair) {
        image = [self getImageWithName:self.configModel.workBench.repair];
    }
    if (itemType == WorkbenchItemPMSZS) {
         image = [self getImageWithName:self.configModel.workBench.PMSZS];
    }
    if (itemType == WorkbenchItemPMSMQ) {
         image = [self getImageWithName:self.configModel.workBench.PMSMQ];
    }
    if (itemType == WorkbenchItemSupply) {
        image = [self getImageWithName:self.configModel.workBench.supply];
    }
    if (itemType == WorkbenchItemEMS) {
        image = [self getImageWithName:self.configModel.workBench.EMS];
    }
    if (itemType == WorkbenchItemRecharge) {
         image = [self getImageWithName:self.configModel.workBench.recharge];
    }
    if (itemType == WorkbenchItemVedioMetting) {
        image = [self getImageWithName:self.configModel.workBench.videoMetting];
    }
    if (itemType == WorkbenchItemsService) {
        image = [self getImageWithName:self.configModel.workBench.workService];
    }
    
    if (itemType == WorkbenchItemAdd) {
         image = [self getImageWithName:self.configModel.workBench.add];
    }
    if (image) {
        return image;
    }
    return [self.defaultTemple themeWorkItemImageWithItemType:itemType];
}
//返回引导页图片
- (NSArray<UIImage *> *)themeGuideImages {
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSString *imageName in self.configModel.guidePage) {
        UIImage *image = [self getImageWithName:imageName];
        if (image) {
            [imageArray addObject:image];
        }
        
    }
    if (imageArray.count) {
         return [imageArray copy];
    }else{
        return self.defaultTemple.themeGuideImages;
    }
   
}
- (UIImage *)workBenchBannerImage {
    UIImage *image = [self getImageWithName:self.configModel.workBenchBanner];
    if (image) {
        return image;
    }else{
        return self.defaultTemple.workBenchBannerImage;
    }
}
#pragma mark - private
- (UIImage *)getImageWithName:(NSString *)name {
    
    NSString *unZipPath = [YSDocumentPath stringByAppendingPathComponent:[YSUserDefaults valueForKey:YSSkinSign]];
    NSString *commomPath = [unZipPath stringByAppendingPathComponent:@"skinResource/resourse"];
    NSString *imagePath = [commomPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",name]];
    return [UIImage imageWithContentsOfFile:imagePath];
}
- (UIImage *)getOriginImageWithImage:(UIImage *)image {
   UIImage *newImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return newImage;
}
@end
