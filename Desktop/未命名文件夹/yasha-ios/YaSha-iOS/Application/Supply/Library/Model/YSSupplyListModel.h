//
//  YSSupplyListModel.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/10/19.
//

#import <Foundation/Foundation.h>

@interface YSSupplyListModel : NSObject

@property(nonatomic, strong)NSString *name;//供应商名称
@property(nonatomic, strong)NSString *busScope;//经营范围
@property(nonatomic, strong)NSString *id;//供应商id
@property(nonatomic, strong)NSString *province;
@property(nonatomic, strong)NSString *city;
@property(nonatomic, strong)NSString *area;
@property(nonatomic, assign)NSInteger isFrozen; //是否冻结
@property(nonatomic, strong)NSString *frozenReason;//冻结原因
@property(nonatomic, assign)NSInteger isBlackList;//是否黑名单
@property(nonatomic, strong)NSString *blackListReason;//黑名单原因
@property(nonatomic, strong)NSString *no;//供应商编码
@property(nonatomic, strong)NSString *shortName;//供应商简称
@property(nonatomic, strong)NSString *companyType;//公司类别
@property(nonatomic, strong)NSString *category;//供应商分类
@property(nonatomic, strong)NSString *cateGoryStr;//列表供货类别
@property(nonatomic, strong)NSString *comNature;//企业性质
@property(nonatomic, strong)NSString *saleModel;//销售模式
@property(nonatomic, strong)NSString *license;//营业执照
@property(nonatomic, strong)NSString *organ;//组织机构代码证
@property(nonatomic, strong)NSString *taxNo;//税务登记号
@property(nonatomic, strong)NSString *registerDate;//注册日期
@property(nonatomic, strong)NSString *registerCurrency;//注册资金币种
@property(nonatomic, assign)double registerMoney;//注册资金
@property(nonatomic, strong)NSString *legalPerson;//法人代表
@property(nonatomic, strong)NSString *achieveLevel;//准入等级
@property(nonatomic, strong)NSString *admitDate;//准入日期
@property(nonatomic, strong)NSString *invalidDate;//失效日期
@property(nonatomic, strong)NSString *status;//状态
@property(nonatomic, strong)NSString *payWay;//付款方式
@property(nonatomic, strong)NSString *payTerm;//付款条件
@property(nonatomic, strong)NSString *payCurrency;//付款币种
@property(nonatomic, strong)NSString *billCurrency;//发票币种
@property(nonatomic, strong)NSString *taxCategory;//税种
@property(nonatomic, strong)NSString *taxRate;//税率




@end
