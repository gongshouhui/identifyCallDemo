/**
*@Created by GZL on 2019/09/24 17:17:51.
*/

'use strict';
import React, {PureComponent, Component} from 'react';
import {
    Text, View, StyleSheet, 
    TouchableOpacity, Image, ScrollView,
    SectionList,FlatList,ImageBackground, 
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import MallTopCell from './YSShopMallCell';
import { ShopMallOtherCell } from './YSShopMallCell';
import Carousel, { Pagination } from 'react-native-snap-carousel';


const SLIDER_1_FIRST_ITEM = 0;
export default class ShopListVC extends PureComponent {
    static navigationOptions = ({navigation, navigationOptions}) => {
        return{
            title: '商城',
        };
    };
    constructor(props) {
        super(props);
        this.state={
            slider1ActiveSlide: SLIDER_1_FIRST_ITEM,
            scrollData:[
                {
                    imgName:require('../../WorkImgFolder/limitG20China.png'),
                    title:'万事利 G20夫人礼·丝瓷套装',
                    cellType:1,
                    price:'1,264.00',
                    oldPrice:'¥1,580.00',
                    subTitle:'真丝大方巾+国瓷永丰源夫人瓷杯 各1',
                    rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                },
                {
                    imgName:require('../../WorkImgFolder/limitG20Kylin.png'),
                    title:'万事利 G20先生礼·臻藏版(红色)',
                    subTitle:'真丝红领带+麒麟青瓷杯+G20元首笔',
                    cellType:1,
                    price:'990.00',
                    oldPrice:'¥1,980.00',
                    rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                },
                {
                    imgName:require('../../WorkImgFolder/limitAllCenser.png'),
                    title:'朱炳仁铜 炉器礼盒',
                    subTitle:'一香炉+一盒采薇坊盘香+一筒线香+一香插',
                    cellType:1,
                    price:'1,733.00',
                    oldPrice:'¥2,888.00',
                    rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                },
                {
                    imgName:require('../../WorkImgFolder/limitChrysanthemumTeapot.png'),
                    title:'朱炳仁铜 金菊傲霜壶',
                    subTitle:'橘红色，15cm*15cm*12cm（不含手柄）',
                    cellType:1,
                    price:'1,560.00',
                    oldPrice:'¥2,600.00',
                    rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                },
                {
                    imgName:require('../../WorkImgFolder/limitLotusCenser.png'),
                    title:'朱炳仁铜 荷花香炉',
                    cellType:1,
                    //imgHeight:254,
                    //imgWidth:254,
                    //viewHeight:102,
                    price:'1,680.00',
                    oldPrice:'¥2,800.00',
                    subTitle:'深咖色，11cm*11cm*8cm',
                    rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                },
            ],
            limitSegmentData:[
                {
                    title:'黄金/饰品',
                    defaulTitleColor:'#FFFFFF',
                    defaultViewColor:'#C6945F',
                },
                {
                    title:'服饰/代金券',
                    defaulTitleColor:'#FFE5CD',
                    defaultViewColor:'#23221E',
                },
                {
                    title:'食品/电器',
                    defaulTitleColor:'#FFE5CD',
                    defaultViewColor:'#23221E',
                },
            ],
            limitData:[
                {
                    imgName:require('../../WorkImgFolder/limitShop1ZDF.png'),
                    title:'周大福大吉利利',
                    cellType:2,
                    imgHeight:118,
                    imgWidth:118,
                    viewHeight:150,
                    price:'882.15',
                    oldPrice:'¥1,280.00',
                    subTitle:'足金 0.9G 配红色皮绳',
                },
                {
                    imgName:require('../../WorkImgFolder/limitShop1Chicken.png'),
                    title:'金鸡足金挂件',
                    cellType:2,
                    imgHeight:118,
                    imgWidth:118,
                    viewHeight:150,
                    price:'1,196.00',
                    oldPrice:'¥1,599.00',
                    subTitle:'含金量：999‰ 金重3.67G',
                },
                {
                    imgName:require('../../WorkImgFolder/limitShop1Pearl15.png'),
                    title:'12-15mm特大淡水珍珠项链',
                    cellType:2,
                    imgHeight:118,
                    imgWidth:118,
                    viewHeight:150,
                    price:'8,000.00',
                    oldPrice:'¥52,800.00',
                    subTitle:'花王珍珠 12-15mm特大',
                },
                {
                    imgName:require('../../WorkImgFolder/limitShop1Pearl12.png'),
                    title:'12mm淡水珍珠项链',
                    cellType:2,
                    imgHeight:118,
                    imgWidth:118,
                    viewHeight:150,
                    price:'6,000.00',
                    oldPrice:'¥35,800.00',
                    subTitle:'花王珍珠 12mm',
                },
                {
                    imgName:require('../../WorkImgFolder/limitShop1Pearl11.png'),
                    title:'11mm淡水珍珠项链',
                    cellType:2,
                    imgHeight:118,
                    imgWidth:118,
                    viewHeight:150,
                    price:'2,000.00',
                    oldPrice:'¥12,800.00',
                    subTitle:'花王珍珠 11mm',
                },
                {
                    imgName:require('../../WorkImgFolder/limitShop1Pearl10.png'),
                    title:'10-11mm淡水珍珠项链',
                    cellType:2,
                    imgHeight:118,
                    imgWidth:118,
                    viewHeight:150,
                    price:'1,500.00',
                    oldPrice:'¥7,580.00',
                    subTitle:'花王珍珠 10-11mm',
                },
                {
                    imgName:require('../../WorkImgFolder/limitShop1PearlBrooch.png'),
                    title:'珍珠胸花',
                    cellType:2,
                    imgHeight:118,
                    imgWidth:118,
                    viewHeight:150,
                    price:'180.00',
                    oldPrice:'¥479.00',
                    subTitle:'花王珍珠 多种款式',
                },
                {
                    imgName:require('../../WorkImgFolder/limitShop1PearlPendant.png'),
                    title:'珍珠吊坠18K金',
                    cellType:2,
                    imgHeight:118,
                    imgWidth:118,
                    viewHeight:150,
                    price:'733.00',
                    oldPrice:'¥9,580.00',
                    subTitle:'花王珍珠 18K金 金色缀头花',
                },
            ],
            limitData1:[
                {
                    imgName:require('../../WorkImgFolder/limitShop1ZDF.png'),
                    title:'周大福大吉利利',
                    cellType:2,
                    imgHeight:118,
                    imgWidth:118,
                    viewHeight:150,
                    price:'882.15',
                    oldPrice:'¥1,280.00',
                    subTitle:'足金 0.9G 配红色皮绳',
                },
                {
                    imgName:require('../../WorkImgFolder/limitShop1Chicken.png'),
                    title:'金鸡足金挂件',
                    cellType:2,
                    imgHeight:118,
                    imgWidth:118,
                    viewHeight:150,
                    price:'1,196.00',
                    oldPrice:'¥1,599.00',
                    subTitle:'含金量：999‰ 金重3.67G',
                },
                {
                    imgName:require('../../WorkImgFolder/limitShop1Pearl15.png'),
                    title:'12-15mm特大淡水珍珠项链',
                    cellType:2,
                    imgHeight:118,
                    imgWidth:118,
                    viewHeight:150,
                    price:'8,000.00',
                    oldPrice:'¥52,800.00',
                    subTitle:'花王珍珠 12-15mm特大',
                },
                {
                    imgName:require('../../WorkImgFolder/limitShop1Pearl12.png'),
                    title:'12mm淡水珍珠项链',
                    cellType:2,
                    imgHeight:118,
                    imgWidth:118,
                    viewHeight:150,
                    price:'6,000.00',
                    oldPrice:'¥35,800.00',
                    subTitle:'花王珍珠 12mm',
                },
                {
                    imgName:require('../../WorkImgFolder/limitShop1Pearl11.png'),
                    title:'11mm淡水珍珠项链',
                    cellType:2,
                    imgHeight:118,
                    imgWidth:118,
                    viewHeight:150,
                    price:'2,000.00',
                    oldPrice:'¥12,800.00',
                    subTitle:'花王珍珠 11mm',
                },
                {
                    imgName:require('../../WorkImgFolder/limitShop1Pearl10.png'),
                    title:'10-11mm淡水珍珠项链',
                    cellType:2,
                    imgHeight:118,
                    imgWidth:118,
                    viewHeight:150,
                    price:'1,500.00',
                    oldPrice:'¥7,580.00',
                    subTitle:'花王珍珠 10-11mm',
                },
                {
                    imgName:require('../../WorkImgFolder/limitShop1PearlBrooch.png'),
                    title:'珍珠胸花',
                    cellType:2,
                    imgHeight:118,
                    imgWidth:118,
                    viewHeight:150,
                    price:'180.00',
                    oldPrice:'¥479.00',
                    subTitle:'花王珍珠 多种款式',
                },
                {
                    imgName:require('../../WorkImgFolder/limitShop1PearlPendant.png'),
                    title:'珍珠吊坠18K金',
                    cellType:2,
                    imgHeight:118,
                    imgWidth:118,
                    viewHeight:150,
                    price:'733.00',
                    oldPrice:'¥9,580.00',
                    subTitle:'花王珍珠 18K金 金色缀头花',
                },
            ],
            limitData2:[
                {
                    imgName:require('../../WorkImgFolder/limitShop2ShirtWhite.png'),
                    title:'男士衬衣(白色)',
                    cellType:2,
                    imgHeight:118,
                    imgWidth:118,
                    viewHeight:150,
                    price:'429.00',
                    oldPrice:'¥780.00',
                    subTitle:'180/104A 43圆摆 100%棉',
                },
                {
                    imgName:require('../../WorkImgFolder/limitShop2ShirtBlue.png'),
                    title:'男士衬衣(蓝色)',
                    cellType:2,
                    imgHeight:118,
                    imgWidth:118,
                    viewHeight:150,
                    price:'594.00',
                    oldPrice:'¥980.00',
                    subTitle:'180/104A 43圆摆 100%棉',
                },
                {
                    imgName:require('../../WorkImgFolder/limitShop2Scarf.png'),
                    title:'山羊绒围巾(蓝色)',
                    cellType:2,
                    imgHeight:118,
                    imgWidth:118,
                    viewHeight:150,
                    price:'594.00',
                    oldPrice:'¥1,080.00',
                    subTitle:'95.4%山羊绒 4.6%羊毛  184*30cm',
                },
                {
                    imgName:require('../../WorkImgFolder/limitShop2ShirtMoney.png'),
                    title:'500元衬衣券',
                    cellType:2,
                    imgHeight:118,
                    imgWidth:118,
                    viewHeight:150,
                    price:'275.00',
                    oldPrice:'¥500.00',
                    subTitle:'500元领衣券',
                },
            ],
            limitData3:[
                {
                    imgName:require('../../WorkImgFolder/limitShop3HYQDendrobium.png'),
                    title:'胡庆余堂铁皮枫斗',
                    cellType:2,
                    imgHeight:118,
                    imgWidth:118,
                    viewHeight:150,
                    price:'2,163.00',
                    oldPrice:'¥3,270.00',
                    subTitle:'铁皮枫斗Ⅰ 120G',
                },
                {
                    imgName:require('../../WorkImgFolder/limitShop3LZDendrobium.png'),
                    title:'立钻牌铁皮枫斗颗粒',
                    cellType:2,
                    imgHeight:118,
                    imgWidth:118,
                    viewHeight:150,
                    price:'3,650.00',
                    oldPrice:'¥3,960.00',
                    subTitle:'720G',
                },
                {
                    imgName:require('../../WorkImgFolder/limitShop3HSDendrobium.png'),
                    title:'霍山石斛',
                    cellType:2,
                    imgHeight:118,
                    imgWidth:118,
                    viewHeight:150,
                    price:'1,430.00',
                    oldPrice:'¥2,880.00',
                    subTitle:'28G/瓶*2',
                },
                {
                    imgName:require('../../WorkImgFolder/limitShop3XHLJ.png'),
                    title:'西湖龙井龙坞茶叶礼盒',
                    cellType:2,
                    imgHeight:118,
                    imgWidth:118,
                    viewHeight:150,
                    price:'400.00',
                    oldPrice:'¥650.00',
                    subTitle:'1包/盒',
                },
                {
                    imgName:require('../../WorkImgFolder/limitShop3GLRice.png'),
                    title:'格力电饭煲',
                    cellType:2,
                    imgHeight:118,
                    imgWidth:118,
                    viewHeight:150,
                    price:'1,699.00',
                    oldPrice:'¥1,899.00',
                    subTitle:'黑色 4L 6.6KG',
                },
                {
                    imgName:require('../../WorkImgFolder/limitShop3Dryer.png'),
                    title:'戴森吹风机',
                    cellType:2,
                    imgHeight:118,
                    imgWidth:118,
                    viewHeight:150,
                    price:'2,828.00',
                    oldPrice:'¥2,990.00',
                    subTitle:'型号HD01 1.89KG',
                },
            ],
            preferentialSegmentData:[
                {
                    title:'万事利',
                    defaulTitleColor:'#FFFFFF',
                    defaultViewColor:'#E05B44',
                },
                {
                    title:'朱炳仁铜',
                    defaulTitleColor:'#BD8E5A',
                    defaultViewColor:'#FBCCA0',
                },
                {
                    title:'悦蓉',
                    defaulTitleColor:'#BD8E5A',
                    defaultViewColor:'#FBCCA0',
                },
            ],
            preferentialData:[
                {
                    sectionTitle:'万事利',
                    data:[
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1FHYF.png'),
                            title:'双面印花大方巾--凤凰于飞',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            price:'790.00',
                            oldPrice:'¥1580.00',
                            subTitle:'100%桑蚕丝香氛丝巾',
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1GYNFSG.png'),
                            title:'APEC睡衣--国韵',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            price:'2490.00',
                            oldPrice:'¥4980.00',
                            subTitle:'100%桑蚕丝 女款粉色',
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1GYNLSG.png'),
                            title:'100%桑蚕丝 男款青色',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            price:'2490.00',
                            oldPrice:'¥4980.00',
                            subTitle:'100%桑蚕丝 男款青色',
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1SMDFJ.png'),
                            title:'100%桑蚕丝 双面印花大方巾-喜柿(咖色)',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            price:'249.00',
                            oldPrice:'¥498.00',
                            subTitle:'88*88cm 咖色/红色/蓝绿色',
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1CSPJMGJR.png'),
                            title:'100%桑蚕丝 真丝绒披肩-玫瑰佳人(橙色)',
                            subTitle:'60*180cm 橙色/卡其/酒红',
                            price:'640.00',
                            oldPrice:'¥1280.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1YMWJHF.png'),
                            title:'100%羊毛围巾-回眸(粉色)',
                            subTitle:'120*200cm 粉色/橘色',
                            price:'540.00',
                            oldPrice:'¥1080.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1YMWJMYZ.png'),
                            title:'100%羊毛围巾-马语者(咖色)',
                            subTitle:'130*130cm 咖色/墨绿/浅灰',
                            price:'440.00',
                            oldPrice:'¥880.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1Suit.png'),
                            title:'经典君之礼套装',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            price:'718.40',
                            oldPrice:'¥898.00',
                            subTitle:'真丝领带—+海上明珠会议三件套盖杯 各1',
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1SuitSY.png'),
                            title:'丝羽-丝伞套装（黄色）',
                            subTitle:'双面印花真丝大方巾+雀翎晴雨伞 各1',
                            price:'490.00',
                            oldPrice:'¥980.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1SuitParis.png'),
                            title:'巴黎恋人-黄色丝伞套装',
                            subTitle:'双面印花中方巾+晴雨伞 各1  另有蓝色、粉色可选',
                            price:'249.00',
                            oldPrice:'¥498.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1SuitNote.png'),
                            title:'皇家风范-智能记事本套装（蓝色）',
                            subTitle:'无线充电记事本+宝珠笔 各1',
                            price:'268.00',
                            oldPrice:'¥536.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1SuitXG.png'),
                            title:'寻桂套装',
                            subTitle:'真丝大方巾+寻桂保温杯 各1',
                            price:'340.00',
                            oldPrice:'¥680.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1SuitQuilt.png'),
                            title:'真丝健康便携被',
                            subTitle:'120cm*90cm 100%桑蚕丝 填充物净含量120g',
                            price:'299.00',
                            oldPrice:'¥680.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1Scarf.png'),
                            title:'满满-橙色真丝中方巾',
                            subTitle:'橙色 小猪款 63*63cm 100%桑蚕丝',
                            price:'238.80',
                            oldPrice:'¥398.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1HCSJ.png'),
                            title:'杭城三绝（曲院风荷）',
                            subTitle:'真丝长巾+西湖龙井+丝绸折扇 各1',
                            price:'398.00',
                            oldPrice:'¥780.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1Paint.png'),
                            title:'锦绣西湖卷轴画',
                            subTitle:'160cm*35cm',
                            price:'390.00',
                            oldPrice:'¥780.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                    ],
                },
            ],
            preferentialData1:[
                {
                    sectionTitle:'万事利',
                    data:[
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1FHYF.png'),
                            title:'双面印花大方巾--凤凰于飞',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            price:'790.00',
                            oldPrice:'¥1580.00',
                            subTitle:'100%桑蚕丝香氛丝巾',
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1GYNFSG.png'),
                            title:'APEC睡衣--国韵',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            price:'2490.00',
                            oldPrice:'¥4980.00',
                            subTitle:'100%桑蚕丝 女款粉色',
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1GYNLSG.png'),
                            title:'100%桑蚕丝 男款青色',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            price:'2490.00',
                            oldPrice:'¥4980.00',
                            subTitle:'100%桑蚕丝 男款青色',
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1SMDFJ.png'),
                            title:'100%桑蚕丝 双面印花大方巾-喜柿(咖色)',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            price:'249.00',
                            oldPrice:'¥498.00',
                            subTitle:'88*88cm 咖色/红色/蓝绿色',
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1CSPJMGJR.png'),
                            title:'100%桑蚕丝 真丝绒披肩-玫瑰佳人(橙色)',
                            subTitle:'60*180cm 橙色/卡其/酒红',
                            price:'640.00',
                            oldPrice:'¥1280.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1YMWJHF.png'),
                            title:'100%羊毛围巾-回眸(粉色)',
                            subTitle:'120*200cm 粉色/橘色',
                            price:'540.00',
                            oldPrice:'¥1080.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1YMWJMYZ.png'),
                            title:'100%羊毛围巾-马语者(咖色)',
                            subTitle:'130*130cm 咖色/墨绿/浅灰',
                            price:'440.00',
                            oldPrice:'¥880.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1Suit.png'),
                            title:'经典君之礼套装',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            price:'718.40',
                            oldPrice:'¥898.00',
                            subTitle:'真丝领带—+海上明珠会议三件套盖杯 各1',
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1SuitSY.png'),
                            title:'丝羽-丝伞套装（黄色）',
                            subTitle:'双面印花真丝大方巾+雀翎晴雨伞 各1',
                            price:'490.00',
                            oldPrice:'¥980.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1SuitParis.png'),
                            title:'巴黎恋人-黄色丝伞套装',
                            subTitle:'双面印花中方巾+晴雨伞 各1  另有蓝色、粉色可选',
                            price:'249.00',
                            oldPrice:'¥498.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1SuitNote.png'),
                            title:'皇家风范-智能记事本套装（蓝色）',
                            subTitle:'无线充电记事本+宝珠笔 各1',
                            price:'268.00',
                            oldPrice:'¥536.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1SuitXG.png'),
                            title:'寻桂套装',
                            subTitle:'真丝大方巾+寻桂保温杯 各1',
                            price:'340.00',
                            oldPrice:'¥680.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1SuitQuilt.png'),
                            title:'真丝健康便携被',
                            subTitle:'120cm*90cm 100%桑蚕丝 填充物净含量120g',
                            price:'299.00',
                            oldPrice:'¥680.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1Scarf.png'),
                            title:'满满-橙色真丝中方巾',
                            subTitle:'橙色 小猪款 63*63cm 100%桑蚕丝',
                            price:'238.80',
                            oldPrice:'¥398.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1HCSJ.png'),
                            title:'杭城三绝（曲院风荷）',
                            subTitle:'真丝长巾+西湖龙井+丝绸折扇 各1',
                            price:'398.00',
                            oldPrice:'¥780.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop1Paint.png'),
                            title:'锦绣西湖卷轴画',
                            subTitle:'160cm*35cm',
                            price:'390.00',
                            oldPrice:'¥780.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                    ],
                },
            ],
            preferentialData2:[
                {
                    sectionTitle:'朱炳仁铜1',
                    data:[
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop2FXL.png'),
                            title:'福星炉',
                            subTitle:'铁锈红，7cm*7cm*3.5cm',
                            price:'153.00',
                            oldPrice:'¥255.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop2XWW.png'),
                            title:'小旺碗礼盒',
                            subTitle:'一匙+一碗',
                            price:'1155.00',
                            oldPrice:'¥258.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop2GS.png'),
                            title:'花开满福刮痧板套装',
                            subTitle:'一刮痧板+两瓶精油',
                            price:'160.00',
                            oldPrice:'¥268.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop2JGB.png'),
                            title:'鸡缸杯',
                            subTitle:'金色，8cm*8cm*3.5cm',
                            price:'168.00',
                            oldPrice:'¥280.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                    ],
                },
                {
                    sectionTitle:'朱炳仁铜',
                    data:[
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop2QEXQL.png'),
                            title:'桥耳小琴炉',
                            subTitle:'深咖色，6.5cm*6.5cm*4cm',
                            price:'191.00',
                            oldPrice:'¥318.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop2WQXL.png'),
                            title:'武曲星炉',
                            subTitle:'深咖色，7cm*7cm*5cm',
                            price:'215.00',
                            oldPrice:'¥358.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop2WSRYH.png'),
                            title:'万事如意礼盒',
                            subTitle:'一镇纸+一流苏挂件',
                            price:'274.00',
                            oldPrice:'¥456.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop2CXRUNote.png'),
                            title:'称心如意笔记本套装',
                            subTitle:'一本+一笔+一U盘+一书签',
                            price:'311.00',
                            oldPrice:'¥518.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop2HTP.png'),
                            title:'清流启坤系列海棠盘',
                            subTitle:'墨绿色，20cm*20cm*1cm',
                            price:'408.00',
                            oldPrice:'¥680.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop2XFZ.png'),
                            title:'小飞猪',
                            subTitle:'墨绿色，10cm*4.5cm*9cm',
                            price:'528.00',
                            oldPrice:'¥880.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop2QXHWQ.png'),
                            title:'七星壶之文曲星壶',
                            subTitle:'金色，13.5*13.5*7cm(不含手柄)',
                            price:'768.00',
                            oldPrice:'¥1,280.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop2ZL.png'),
                            title:'逐鹿顺意',
                            subTitle:'橘色，16cm*10cm*39cm',
                            price:'960.00',
                            oldPrice:'¥1,600.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop2CTea.png'),
                            title:'禅茶一味礼盒(光面)',
                            subTitle:'两杯+两杯碟+一茶罐+一茶匙+一茶针',
                            price:'880.00',
                            oldPrice:'¥1,500.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                    ]
                },
            ],
            preferentialData3:[
                {
                    sectionTitle:'悦蓉1210',
                    data:[
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop3SuitXZLHTZ.png'),
                            data:[
                                {
                                    title:'杭州礼物套盒-53cm*53cm小方丝巾(100%桑蚕丝)+茶叶+王星记扇子',
                                    price:'299.00',
                                    oldPrice:'¥598.00',
                                },
                                {
                                    title:'杭州礼物套盒-30*180cm长丝巾(100%桑蚕丝)+茶叶+王星记扇子',
                                    price:'399.00',
                                    oldPrice:'¥798.00',
                                },
                                {
                                    title:'杭州礼物套盒-90cm*90cm大方丝巾/30cm*180cm围巾(100%桑蚕丝)+茶叶+王星记扇子',
                                    price:'499.00',
                                    oldPrice:'¥998.00',
                                },
                            ],
                        },
                    ],
                },
                {
                    sectionTitle:'悦蓉',
                    data:[
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop3SuitSYRWJ.png'),
                            title:'丝羊绒围巾',
                            subTitle:'多款可选 30cm*180cm 100%桑蚕丝',
                            price:'199.00',
                            oldPrice:'¥1080.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop3SuitTXDYFWJ.png'),
                            title:'天下第一福围巾(真丝)',
                            subTitle:'大红色 200cm*300cm 100%桑蚕丝',
                            price:'218.00',
                            oldPrice:'¥980.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop3SuitTXDYFWJSYR.png'),
                            title:'天下第一福围巾(丝羊绒)',
                            subTitle:'大红色 200cm*300cm 20.5%桑蚕丝+5.5%绵羊毛+43%粘纤+11%聚酯纤维+10%锦纶+10%腈纶',
                            price:'158.00',
                            oldPrice:'¥680.00',
                            cellType:1,
                            imgHeight:195,
                            imgWidth:175,
                            viewHeight:145,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop3SuitTXDYFWJMDEM.png'),
                            title:'天下第一福围巾(莫代尔棉)',
                            subTitle:'大红色 30cm*180cm 100%莫代尔棉',
                            price:'99.00',
                            oldPrice:'¥498.00',
                            cellType:1,
                            imgHeight:195,
                            imgWidth:175,
                            viewHeight:145,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop3SuitKMJHLH.png'),
                            title:'开门见红礼盒',
                            subTitle:'对联+红包袋+日历',
                            price:'185.00',
                            oldPrice:'¥398.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop3SuitPW.png'),
                            title:'品味套装',
                            subTitle:'50*180cm女士丝巾+小罐茶9',
                            price:'248.00',
                            oldPrice:'¥496.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop3SuitLX.png'),
                            title:'丝家旅行套装',
                            subTitle:'125G蚕丝空调被+真丝眼罩+眼罩袋+手拎袋  ',
                            price:'299.00',
                            oldPrice:'¥897.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop3SuitTSZL.png'),
                            title:'天使之泪套装',
                            subTitle:'女士大丝巾(古韵杭州款90*90)+丝巾扣',
                            price:'450.00',
                            oldPrice:'¥1,280.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop3SuitYSH.png'),
                            title:'友善套装',
                            subTitle:'50*180女士丝巾+100%桑蚕丝领带+扇子8寸+签字笔',
                            price:'199.00',
                            oldPrice:'¥398.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop3SuitShX.png'),
                            title:'书香套装',
                            subTitle:'30*120男士丝巾+真丝充电笔记本+16GU盘+签字笔+真丝书签',
                            price:'299.00',
                            oldPrice:'¥598.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop3SuitXShC.png'),
                            title:'先生瓷-海上明珠三件套',
                            subTitle:'100%桑蚕丝领带—+海上明珠会议三件套盖杯 各1',
                            price:'680.00',
                            oldPrice:'¥1,360.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop3SuitLGLJ.png'),
                            title:'龙冠西湖龙井茶套装',
                            subTitle:'明后龙井',
                            price:'499.00',
                            oldPrice:'¥799.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop3NoteLine.png'),
                            title:'风华韶光无线充电笔记本',
                            subTitle:'23.6*16.8*3.8cm桑蚕丝封面(4000毫安 8GU盘)',
                            price:'325.00',
                            oldPrice:'¥725.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop3ShBD.png'),
                            title:'无线丝绸鼠标垫',
                            subTitle:'丝绸鼠标垫带无线充电功能',
                            price:'148.00',
                            oldPrice:'¥368.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop3QHSh.png'),
                            title:'王星记女扇-青花扇',
                            subTitle:'21*1*0.5cm,展开最宽37cm',
                            price:'79.00',
                            oldPrice:'¥88.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop3ShYMan.png'),
                            title:'睡衣-年华-男长袖 (紫)',
                            subTitle:'XL',
                            price:'814.00',
                            oldPrice:'¥1,480.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop3ShYWomen.png'),
                            title:'睡衣-年华-女长袖(粉)',
                            subTitle:'XL',
                            price:'814.00',
                            oldPrice:'¥1,480.00',
                            cellType:1,
                            imgHeight:175,
                            imgWidth:175,
                            viewHeight:115,
                            rightTopImgName:require('../../WorkImgFolder/mallReserveStar.png'),
                        },
                    ],
                },
                {
                    sectionTitle:'悦蓉1',
                    data:[
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop3SuitDSJ.png'),
                            data:[
                                {
                                    title:'采薇坊套装-采薇坊线香+朱炳仁铜器+大方巾+王星记丝扇',
                                    price:'599.00',
                                    oldPrice:'¥1,797.00',
                                },
                                {
                                    title:'采薇坊套装-采薇坊线香+朱炳仁铜器+长巾+王星记丝扇',
                                    price:'499.00',
                                    oldPrice:'¥1,497.00',
                                },
                                {
                                    title:'采薇坊套装-采薇坊线香+朱炳仁铜器+小方巾+王星记丝扇',
                                    price:'399.00',
                                    oldPrice:'¥1,197.00',
                                },
                            ],
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop3SuitSSh.png'),
                            data:[
                                {
                                    title:'丝扇套装-大方巾+王星记男扇',
                                    price:'370.00',
                                    oldPrice:'¥740.00',
                                },
                                {
                                    title:'丝扇套装-长巾+王星记男扇',
                                    price:'314.00',
                                    oldPrice:'¥628.00',
                                },
                                {
                                    title:'丝扇套装-小方巾+王星记男扇',
                                    price:'214.00',
                                    oldPrice:'¥428.00',
                                },
                            ],
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop3ZhXYL.png'),
                            data:[
                                {
                                    title:'浙厢有礼丝瓷茶套装-大方巾1+壶1+杯2+收纳袋1',
                                    price:'499.00',
                                    oldPrice:'¥1,497.00',
                                },
                                {
                                    title:'浙厢有礼丝瓷茶套装-长巾1+壶1+杯2+收纳袋1',
                                    price:'399.00',
                                    oldPrice:'¥1,197.00',
                                },
                                {
                                    title:'浙厢有礼丝瓷茶套装-小方巾1+壶1+杯2+收纳袋1',
                                    price:'299.00',
                                    oldPrice:'¥897.00',
                                },
                            ],
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop3G20Cha.png'),
                            data:[
                                {
                                    title:'G20夫人礼丝瓷套装-女士大方巾90*90cm(杭城时异)+国瓷永丰源夫人瓷杯 各1',
                                    price:'980.00',
                                    oldPrice:'¥1,960.00',
                                },
                                {
                                    title:'G20夫人礼丝瓷套装-女士长巾50*180cm(杭城时异)+国瓷永丰源夫人瓷杯 各1',
                                    price:'888.00',
                                    oldPrice:'¥1,760.00',
                                },
                                {
                                    title:'G20夫人礼丝瓷套装-女士小方巾53*53cm(杭城时异)+国瓷永丰源夫人瓷杯 各1',
                                    price:'780.00',
                                    oldPrice:'¥1,560.00',
                                },
                            ],
                        },
                        {
                            imgName:require('../../WorkImgFolder/preferentialShop3SJD.png'),
                            data:[
                                {
                                    title:'大方巾90*90cm-单款丝巾系列A(古道丝路)',
                                    price:'316.00',
                                    oldPrice:'¥1,580.00',
                                },
                                {
                                    title:'大方巾90*90cm-单款丝巾系列B',
                                    price:'256.00',
                                    oldPrice:'¥1,280.00',
                                },
                                {
                                    title:'大方巾90*90cm-单款丝巾系列C(烟雨青尘-蓝)',
                                    price:'236.00',
                                    oldPrice:'¥1,180.00',
                                },
                                {
                                    title:'大方巾90*90cm-单款丝巾系列D',
                                    price:'216.00',
                                    oldPrice:'¥1,080.00',
                                },
                                {
                                    title:'长巾50*180cm-单款丝巾系列(多款)',
                                    price:'200.00',
                                    oldPrice:'¥798.00',
                                },
                                {
                                    title:'小方巾53*53cm-单款丝巾系列(多款)',
                                    price:'92.00',
                                    oldPrice:'¥368.00',
                                },
                            ],
                        },
                    ],
                },
            ],
            data:[],

        };
    }

    //限量特惠分段控制器
    onClickLimitBtn=(choseIndex)=>{
        this.state.limitSegmentData.map((item,index)=>{
            this.refs['limitBtn'+String(index)].changeLimitStyle('#FFE5CD','#23221E');
        });
        this.refs['limitBtn'+String(choseIndex)].changeLimitStyle('#FFFFFF','#C6945F');

        const {limitData1, limitData2, limitData3} =this.state;
        switch (choseIndex){
            case 0:{
                this.setState({
                    limitData:limitData1,
                });
            }
            break;
            case 1:{
                this.setState({
                    limitData:limitData2,
                });
            }
            break;
            case 2:{
                this.setState({
                    limitData:limitData3,
                });
            }
            break;
        }
    }
    //优惠购分段控制器
    onClickPreferentialBtn=(choseIndex)=>{
        this.state.preferentialSegmentData.map((item,index)=>{
            this.refs['preferentialBtn'+String(index)].changeLimitStyle('#BD8E5A','#FBCCA0');
        });
        this.refs['preferentialBtn'+String(choseIndex)].changeLimitStyle('#FFFFFF','#E05B44');

        const {preferentialData1, preferentialData2, preferentialData3} =this.state;
        switch (choseIndex){
            case 0:{
                this.setState({
                    preferentialData:preferentialData1,
                });
            }
            break;
            case 1:{
                this.setState({
                    preferentialData:preferentialData2,
                });
            }
            break;
            case 2:{
                this.setState({
                    preferentialData:preferentialData3,
                });
            }
            break;
        }
    }


    //限量特惠
    renderLimitItem=(item,index)=>{
        const imgWidth = item.imgWidth;
        return(
            <MallTopCell imgName={item.imgName}
                         title={item.title}
                         cellType={item.cellType}
                         imgHeight={item.imgHeight}
                         imgWidth={item.imgWidth}
                         viewHeight={item.viewHeight}
                         price={item.price}
                         oldPrice={item.oldPrice}
                         subTitle={item.subTitle}
                         rightTopImgName={item.rightTopImgName}
                         viewLeft={Math.floor((PCH.width-imgWidth*3)/4)}
                         btnActiveOpacity={1}
                         key={index}
            />);
    }
    //优惠购
    renderSectionHeader=({section})=>{
        if(section.sectionTitle==='悦蓉1'){
            const {data} = section.data;
            return(
                <View>
                    <View style={{height:Math.floor((PCH.width-175*2)/4),}}/>
                    <FlatList data={section.data}
                              keyExtractor={(item, index)=> String(index)}
                              renderItem={({item,index})=>this.renderPreferentialColumnItem(item, index)}
                              ItemSeparatorComponent={()=>{return(<View style={{height:Math.floor((PCH.width-175*2)/4),}}/>)}}//分割线
                          
                    />
                </View>
            );
        }else if (section.sectionTitle==='悦蓉1210'){
            return(
                <FlatList data={section.data}
                          keyExtractor={(item, index)=> String(index)}
                          renderItem={({item,index})=>this.renderPreferentialColumnItem(item, index)}
                          ItemSeparatorComponent={()=>{return(<View style={{height:Math.floor((PCH.width-175*2)/4),}}/>)}}//分割线
                />
            );
        }
        return(
            <View>
                {section.sectionTitle==='悦蓉'&&<View style={{height:Math.floor((PCH.width-175*2)/4),}}/>}
                <FlatList data={section.data}
                          keyExtractor={(item, index)=> String(index)}
                          renderItem={({item,index})=>this.renderPreferentialItem(item, index)}
                          horizontal={false} // 水平还是垂直
                          numColumns={2}//numColumns需要配合horizontal={false}使用
                          columnWrapperStyle={{marginBottom:5}}
                          ItemSeparatorComponent={()=>{return(<View style={{height:Math.floor((PCH.width-175*2)/4),}}/>)}}//分割线
                />
            </View>);
    }
    renderSectionFooter=({section})=>{
        if(section.sectionTitle==='朱炳仁铜1'){
            const data = [
                {
                    title:'彩铜瓶-4.5cm*4.5cm*7cm',
                    price:'168.00',
                    oldPrice:'¥280.00',
                },
                {
                    title:'彩铜瓶-3.5cm*3.5cm*8cm',
                    price:'168.00',
                    oldPrice:'¥280.00',
                },
                {
                    title:'彩铜瓶-4.5cm*4.5cm*6cm',
                    price:'168.00',
                    oldPrice:'¥280.00',
                },
                {
                    title:'彩铜瓶-5cm*5cm*6cm',
                    price:'168.00',
                    oldPrice:'¥280.00',
                },
            ];
            return(
                <View>
                    <View style={{height:Math.floor((PCH.width-175*2)/4),}}/>
                    <ShopMallOtherCell imgName={require('../../WorkImgFolder/preferentialShop2CTP.png')}
                                       data={data}
                                       viewLeft={Math.floor((PCH.width-175*2)/3)}
                    />
                    <View style={{height:Math.floor((PCH.width-175*2)/4),}}/>
                </View>
            );
        }
    }
    //优惠购
    renderPreferentialItem= (item,index)=>{
        const imgWidth = item.imgWidth;
        return(
            <MallTopCell imgName={item.imgName}
                         title={item.title}
                         cellType={item.cellType}
                         imgHeight={item.imgHeight}
                         imgWidth={item.imgWidth}
                         viewHeight={item.viewHeight}
                         price={item.price}
                         oldPrice={item.oldPrice}
                         subTitle={item.subTitle}
                         rightTopImgName={item.rightTopImgName}
                         viewLeft={Math.floor((PCH.width-imgWidth*2)/3)}
                         btnActiveOpacity={1}
                         key={index}
            />);
    }
    //优惠购
    renderPreferentialColumnItem=(item,index)=>{
        return(
            <ShopMallOtherCell imgName={item.imgName}
                               data={item.data}
                               viewLeft={Math.floor((PCH.width-175*2)/3)}
            />
        );
    }
 
    //顶部轮播cell
    _renderItemWithParallax({item, index}, parallaxProps) {
        return (
            <MallTopCell imgName={item.imgName}
                         title={item.title}
                         cellType={item.cellType}
                         price={item.price}
                         oldPrice={item.oldPrice}
                         subTitle={item.subTitle}
                         rightTopImgName={item.rightTopImgName}
                         viewLeft={index!=0&&20*PCH.scaleW}
                         btnActiveOpacity={1}
                         key={index}
            />
        );
    }

    render() {
        const {
            preferentialData, scrollData,
            slider1ActiveSlide,limitSegmentData,
            limitData,preferentialSegmentData,
        } = this.state;
        return(
            <View style={{flex:1}}>
                <ScrollView style={{flex:1}}>
                <LinearGradient colors={['#E7BF85', '#E7AD67',]}>
                    <Image source={require('../../WorkImgFolder/mallListTop.png')} style={{width:"100%",height:640*PCH.scaleW,}}/>
                    <ImageBackground source={require('../../WorkImgFolder/topScrollBackImg.png')} style={{width:'100%',height:482,}}>
                    <View style={styles.topScrollViewStyle}>
                        <Carousel ref={c => this._slider1Ref = c}
                                  data={scrollData}
                                  renderItem={this._renderItemWithParallax}
                                  sliderWidth={PCH.width}
                                  itemWidth={254}
                                  firstItem={SLIDER_1_FIRST_ITEM}
                                  loop={true}
                                  onSnapToItem={(index) => this.setState({ slider1ActiveSlide: index })}
                        />
                    </View>
                    </ImageBackground>
                    <View style={styles.pointBackViewStyle}>
                        <Pagination dotsLength={scrollData.length}
                                    activeDotIndex={slider1ActiveSlide}
                                    containerStyle={{ paddingVertical: 8 }}
                                    dotColor={'white'}
                                    dotStyle={{ width: 14, height: 6, borderRadius: 4, }}
                                    inactiveDotColor={'#C58F55'}
                                    inactiveDotStyle={{ width:8, height:6, borderRadius: 4, }}
                                    inactiveDotOpacity={1}
                                    inactiveDotScale={0.8}
                                    carouselRef={this._slider1Ref}
                                    tappableDots={!!this._slider1Ref}
                        />
                    </View>
                </LinearGradient>
                <LinearGradient colors={['#E7BF85', '#E7AD67',]}>{/*限制购物*/}
                    <Image source={require('../../WorkImgFolder/limitBanner.png')} style={{width:PCH.width,height:82*PCH.scaleW,resizeMode:'stretch'}}/>
                    <View style={styles.limitSegmentViewStyle}>
                        {limitSegmentData.map((item,index)=>{
                            return(
                                <SegmentBtnView title={item.title}
                                                defaulTitleColor={item.defaulTitleColor}
                                                defaultViewColor={item.defaultViewColor}
                                                onClickLimitBtn={this.onClickLimitBtn}
                                                key={index}
                                                index={index}
                                                ref={'limitBtn'+String(index)}
                                />);
                        })}
                    </View>
                    <FlatList data={limitData}
                              ref='limitFlatList'
                              keyExtractor={(item, index)=> String(index)}
                              renderItem={({item,index})=>this.renderLimitItem(item, index)}
                              horizontal={false} // 水平还是垂直
                              numColumns={3}//numColumns需要配合horizontal={false}使用
                              columnWrapperStyle={{marginBottom:5}}
                              ItemSeparatorComponent={()=>{return(<View style={{height:Math.floor((PCH.width-118*3)/4),}}/>)}}//分割线
                    />
                </LinearGradient>
                <LinearGradient colors={['#FDE4C9', '#FFF0DF',]}>{/*优惠购物*/}
                    <Image source={require('../../WorkImgFolder/preferentialBanner.png')} style={{width:PCH.width,height:110*PCH.scaleW,marginTop:4}}/>
                    <View style={styles.limitSegmentViewStyle}>
                        {preferentialSegmentData.map((item,index)=>{
                            return(
                                <SegmentBtnView title={item.title}
                                                defaulTitleColor={item.defaulTitleColor}
                                                defaultViewColor={item.defaultViewColor}
                                                onClickLimitBtn={this.onClickPreferentialBtn}
                                                key={index}
                                                index={index}
                                                ref={'preferentialBtn'+String(index)}
                                />);
                        })}
                    </View>
                    <SectionList sections={preferentialData}
                                 renderItem={()=>{return(<View/>)}}
                                 keyExtractor={(item, index) => item + index}
                                 stickySectionHeadersEnabled={false}
                                 automaticallyAdjustContentInsets={false}
                                 renderSectionHeader={this.renderSectionHeader}
                                 renderSectionFooter={this.renderSectionFooter}
                    />
                    <View style={{width:PCH.width,alignItems:'center',paddingVertical:16}}>
                        <Text style={{fontSize:13,color:'rgba(0, 0, 0, 0.25)',fontFamily:'PingFangSC-Regular'}}>©️ 2019 亚厦股份(YaSha).  All Rights Reserved.</Text>
                    </View>
                </LinearGradient>
                </ScrollView>
            </View>
        );
    }
}
const styles = StyleSheet.create({
    container:{
    },
    topScrollViewStyle:{//轮播图的背景视图
        width:PCH.width,
        height:356,
        marginTop:126,
    },
    pointBackViewStyle:{//点的背景视图
        flexDirection:'row',
        alignItems:'center',
        justifyContent:'center',
        height:56,
        width:PCH.width,
    },
    pointViewStyle:{//点
        height:8,
        backgroundColor:'rgba(197, 143, 85, 1)',
        borderRadius:4,
        marginLeft:8,
    },
    limitSegmentViewStyle:{//内购限量分段控制器的背景视图
        width:'100%',
        height:59*PCH.scaleH,
        flexDirection:'row',
        alignItems:'center',
        justifyContent:'space-evenly',
        borderTopLeftRadius:4,
        borderTopRightRadius:4
    },
    segmentBtnViewStyle:{
        height:39*PCH.scaleH,
        width:118*PCH.scaleW,
        justifyContent:'center',
        alignItems:'center',
        borderRadius:4,
    },
    segmentTitleStyle:{
        fontSize:12,
        fontFamily:"PingFangSC-Regular",
    },
});


class PointBtnView extends Component{
    constructor(props){
        super(props);
        this.state={
            pointWidth:this.props.pointWidth?this.props.pointWidth:8,
        };
    }
    _onPress = ()=>{
        this.props.onClickPointBtn(this.props.index);
    }
    changePointStyle = (pointWidth)=>{
        this.setState({
            pointWidth:pointWidth,
        });
    }
    render(){
        const {pointWidth,} = this.state;
        return(
            <TouchableOpacity onPress={this._onPress} >
                <View style={[styles.pointViewStyle,{width:pointWidth},pointWidth===14&&{backgroundColor:'rgba(255, 255, 255, 1)'}]}/>
            </TouchableOpacity>
        );
    }
}


class SegmentBtnView extends Component{
    constructor(props){
        super(props);
        this.state={
            selectTitleColor:this.props.selectTitleColor?this.props.selectTitleColor:this.props.defaulTitleColor,
            selectViewColor:this.props.selectViewColor?this.props.selectViewColor:this.props.defaultViewColor,
        };
    }
    _onPress = ()=>{
        this.props.onClickLimitBtn(this.props.index);
    }
    changeLimitStyle = (selectTitleColor,selectViewColor)=>{
        this.setState({
            selectTitleColor:selectTitleColor,
            selectViewColor:selectViewColor,
        });
    }
    render(){
        const {defaulTitleColor,defaultViewColor,title} = this.props;
        const {selectTitleColor,selectViewColor} = this.state;
        return(
            <TouchableOpacity onPress={this._onPress}>
                <View style={[styles.segmentBtnViewStyle,selectViewColor&&{backgroundColor:selectViewColor}]}>
                    <Text style={[styles.segmentTitleStyle],selectTitleColor&&{color:selectTitleColor}}>{title}</Text>
                </View>
            </TouchableOpacity>
        );
    }
}









