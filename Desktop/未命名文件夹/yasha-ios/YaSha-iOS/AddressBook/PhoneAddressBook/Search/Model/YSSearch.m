//
//  YSSearch.m
//  YaSha-iOS
//
//  Created by mHome on 2016/12/4.
//
//

#import "YSSearch.h"
#import "PinYin4Objc.h"
#import "YSPhoneAddressBookModel.h"

@implementation YSSearch
static BOOL isIncludeChineseInNSString(NSString *string) {
    for (int i=0; i<string.length; i++) {
        unichar ch = [string characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff) {
            return true;
        }
    }
    return false;
}

static BOOL validateNumber(NSString *number) {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
+ (NSArray  *)searchText:(NSString *)searchText inDataArray:(NSArray *)dataArray {
    
    NSMutableArray *results = [NSMutableArray array];
    // 参数不合法
    if (searchText.length <= 0 || dataArray.count <= 0) return results;
    //输入电话进行查找
    if (validateNumber(searchText)) {
        for (YSPhoneAddressBookModel *contact in dataArray) {
            DLog(@"--------%@",contact.tel);
            NSRange resultRange = [contact.tel rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (resultRange.length > 0) {// 找到了
                [results addObject:contact];
            }
        }
    }
    if (isIncludeChineseInNSString(searchText)) { // 输入了中文-只查询中文
        for (YSPhoneAddressBookModel *contact in dataArray) {
            NSRange resultRange = [contact.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (resultRange.length > 0) {// 找到了
                [results addObject:contact];
            }
        }
    }else {
        for (YSPhoneAddressBookModel *contact in dataArray) {
            if (isIncludeChineseInNSString(contact.name)) {// 待查询中有中文--转为拼音
                // 设置输入格式
                NSString *hanziText = contact.name;
                if ([hanziText length]) {
                    NSMutableString *ms = [[NSMutableString alloc] initWithString:hanziText];
                    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
                        DLog(@"pinyin: %@", ms);
                    }
                    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
                       DLog(@"pinyin: %@", ms);
                        // 删除分隔符
                        NSString *completeNOSeparatorPinyin = [ms stringByReplacingOccurrencesOfString:@" " withString:@""];
                        
                        // 查询没有分隔符中是否包含 (不能使用有分隔符的拼音来查询, 因为输入的里面可能不会包含分隔符, 导致查询不到)
                        NSRange resultRange = [completeNOSeparatorPinyin rangeOfString:searchText options:NSCaseInsensitiveSearch];
                        if (resultRange.length > 0) {// 找到了
                            [results addObject:contact];
                            continue; // 进入下一次循环, 不再执行下面这段代码
                        }
                        NSMutableString *headOfPinyin = [NSMutableString string];
                        NSArray *pinyinArray = [ms componentsSeparatedByString:@" "];
                        for (NSString *singlePinyin in pinyinArray) {
                            if (singlePinyin) { // 取每个拼音的首字母
                                [headOfPinyin appendString:[singlePinyin substringToIndex:1]];
                            }
                        }
                        
                        NSRange headResultRange = [headOfPinyin rangeOfString:searchText options:NSCaseInsensitiveSearch];
                        if (headResultRange.length > 0) {// 找到了
                            [results addObject:contact];
                        }
                        DLog(@"========%@",results);
                    }  
                }
            }else { // 姓名是英文的, 那么直接查询英文
                NSRange resultRange = [contact.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (resultRange.length > 0) {// 找到了
                    [results addObject:contact];
                }
            }
            
        }
        
    }
    return results;
}


@end
