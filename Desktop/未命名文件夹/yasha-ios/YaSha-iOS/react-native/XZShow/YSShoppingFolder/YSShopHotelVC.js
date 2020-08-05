/**
*@Created by GZL on 2019/09/29 10:20:05.
*/

'use strict';
import React, {PureComponent, Component} from 'react';
import {Text, View, StyleSheet, TouchableOpacity, Image, ScrollView,FlatList,NativeModules} from 'react-native';
import HotelCell from './YSHotelCell';

var YSModules = NativeModules.YSReactNativeModel
export default class ShopHotelVC extends PureComponent {
    static navigationOptions = ({navigation, navigationOptions}) => {
        return{
            title: '酒店'
        };
    };
    constructor(props) {
        super(props);
        this.state={
            optionSegmentData:['钱江新城','公司附近','西湖景区','滨江区','绍兴市',],
            data:[
                {
                    leftImg:require('../../WorkImgFolder/01ruilaikesi.png'),
                    title:'瑞莱克斯大酒店',
                    subTitle:'杭州市望江东路333号',
                    //isFood
                    remarkTitle1:'无餐厅',
                    isMeet:true,
                    remarkTitle2:'有会场',
                    //hintMessage:
                    price:'230～460',
                    phone:'订房热线：0571-81065555 /袁玲 15372020292',
                    //otherPhone:
                },
                {
                    leftImg:require('../../WorkImgFolder/01JieTeMan.png'),
                    title:'捷特曼大酒店',
                    subTitle:'杭州市望江东路鲲鹏路363号',
                    //isFood
                    remarkTitle1:'无餐厅',
                    remarkTitle2:'无会场',
                    //isMeet:true,
                    //hintMessage:
                    price:'328～398',
                    phone:'订房热线：0571-86568777 / 章经理 18657101393',
                    //otherPhone:
                },
                {
                    leftImg:require('../../WorkImgFolder/01hangzhouHuaChenFengTing.png'),
                    title:'杭州华辰凤庭大酒店',
                    subTitle:'杭州市鹜江路333号',
                    //isFood
                    remarkTitle1:'无餐厅',
                    remarkTitle2:'无会场',
                    //isMeet:true,
                    //hintMessage:
                    price:'348～1288',
                    phone:'订房热线：0571-28297706/28297707',
                    otherPhone:'陈建军 13588157127'
                },
                {
                    leftImg:require('../../WorkImgFolder/01JuZiShuiJing.png'),
                    title:'桔子水晶酒店',
                    subTitle:'杭州市钱江路555号',
                    //isFood
                    remarkTitle1:'无餐厅',
                    remarkTitle2:'无会场',
                    //isMeet:true,
                    hintMessage:'连锁店均可享受协议价',
                    price:'435～734',
                    phone:'订房热线：4008121121/0571-87322655',
                    otherPhone:'徐国成 15120061614'
                },
                {
                    leftImg:require('../../WorkImgFolder/01hangzhouHuaRuiLiJiangHeHui.png'),
                    title:'杭州瑞立江河汇酒店',
                    subTitle:'杭州市江干区之江路1229号',
                    //isFood
                    remarkTitle1:'无餐厅',
                    remarkTitle2:'无会场',
                    //isMeet:true,
                    //hintMessage:'连锁店均可享受协议价',
                    price:'498～5888',
                    phone:'订房热线：李涛 13957112301',
                    //otherPhone:'徐国成 15120061614'
                },
                {
                    leftImg:require('../../WorkImgFolder/01hangzhouWanHao.png'),
                    title:'杭州钱江新城万豪酒店',
                    subTitle:'杭州市江干区剧院路399号',
                    //isFood
                    remarkTitle1:'无餐厅',
                    remarkTitle2:'有会场',
                    isMeet:true,
                    //hintMessage:'连锁店均可享受协议价',
                    price:'850～1150',
                    phone:'订房热线：陈超 17328867030',
                    //otherPhone:'徐国成 15120061614'
                },
                {
                    leftImg:require('../../WorkImgFolder/01hangzhouZhouJi.png'),
                    title:'杭州洲际酒店',
                    subTitle:'杭州市江干区解放东路2号',
                    isFood:true,
                    remarkTitle1:'有餐厅',
                    remarkTitle2:'无会场',
                    //isMeet:true,
                    //hintMessage:'连锁店均可享受协议价',
                    price:'950～1550',
                    phone:'订房热线：0571-89810000/89810032/89810056',
                    otherPhone:' 刘德旺 15057111689'
                },
                {
                    leftImg:require('../../WorkImgFolder/01ZunLanQianJiang.png'),
                    title:'尊蓝钱江豪华精选',
                    subTitle:'杭州市上城区望江东路39号',
                    isFood:true,
                    remarkTitle1:'有餐厅',
                    remarkTitle2:'无会场',
                    //isMeet:true,
                    //hintMessage:'连锁店均可享受协议价',
                    price:'913～2312',
                    phone:'订房热线：28237777转预定部 / 0571-26897180',
                    otherPhone:' 王林芳 15372098255'
                },
            ],
            qianJiangData:[
                {
                    leftImg:require('../../WorkImgFolder/01ruilaikesi.png'),
                    title:'瑞莱克斯大酒店',
                    subTitle:'杭州市望江东路333号',
                    //isFood
                    remarkTitle1:'无餐厅',
                    isMeet:true,
                    remarkTitle2:'有会场',
                    //hintMessage:
                    price:'230～460',
                    phone:'订房热线：0571-81065555 /袁玲 15372020292',
                    //otherPhone:
                },
                {
                    leftImg:require('../../WorkImgFolder/01JieTeMan.png'),
                    title:'捷特曼大酒店',
                    subTitle:'杭州市望江东路鲲鹏路363号',
                    //isFood
                    remarkTitle1:'无餐厅',
                    remarkTitle2:'无会场',
                    //isMeet:true,
                    //hintMessage:
                    price:'328～398',
                    phone:'订房热线：0571-86568777 / 章经理 18657101393',
                    //otherPhone:
                },
                {
                    leftImg:require('../../WorkImgFolder/01hangzhouHuaChenFengTing.png'),
                    title:'杭州华辰凤庭大酒店',
                    subTitle:'杭州市鹜江路333号',
                    //isFood
                    remarkTitle1:'无餐厅',
                    remarkTitle2:'无会场',
                    //isMeet:true,
                    //hintMessage:
                    price:'348～1288',
                    phone:'订房热线：0571-28297706/28297707',
                    otherPhone:'陈建军 13588157127'
                },
                {
                    leftImg:require('../../WorkImgFolder/01JuZiShuiJing.png'),
                    title:'桔子水晶酒店',
                    subTitle:'杭州市钱江路555号',
                    //isFood
                    remarkTitle1:'无餐厅',
                    remarkTitle2:'无会场',
                    //isMeet:true,
                    hintMessage:'连锁店均可享受协议价',
                    price:'435～734',
                    phone:'订房热线：4008121121/0571-87322655',
                    otherPhone:'徐国成 15120061614'
                },
                {
                    leftImg:require('../../WorkImgFolder/01hangzhouHuaRuiLiJiangHeHui.png'),
                    title:'杭州瑞立江河汇酒店',
                    subTitle:'杭州市江干区之江路1229号',
                    //isFood
                    remarkTitle1:'无餐厅',
                    remarkTitle2:'无会场',
                    //isMeet:true,
                    //hintMessage:'连锁店均可享受协议价',
                    price:'498～5888',
                    phone:'订房热线：李涛 13957112301',
                    //otherPhone:'徐国成 15120061614'
                },
                {
                    leftImg:require('../../WorkImgFolder/01hangzhouWanHao.png'),
                    title:'杭州钱江新城万豪酒店',
                    subTitle:'杭州市江干区剧院路399号',
                    //isFood
                    remarkTitle1:'无餐厅',
                    remarkTitle2:'有会场',
                    isMeet:true,
                    //hintMessage:'连锁店均可享受协议价',
                    price:'850～1150',
                    phone:'订房热线：陈超 17328867030',
                    //otherPhone:'徐国成 15120061614'
                },
                {
                    leftImg:require('../../WorkImgFolder/01hangzhouZhouJi.png'),
                    title:'杭州洲际酒店',
                    subTitle:'杭州市江干区解放东路2号',
                    isFood:true,
                    remarkTitle1:'有餐厅',
                    remarkTitle2:'无会场',
                    //isMeet:true,
                    //hintMessage:'连锁店均可享受协议价',
                    price:'950～1550',
                    phone:'订房热线：0571-89810000/89810032/89810056',
                    otherPhone:' 刘德旺 15057111689'
                },
                {
                    leftImg:require('../../WorkImgFolder/01ZunLanQianJiang.png'),
                    title:'尊蓝钱江豪华精选',
                    subTitle:'杭州市上城区望江东路39号',
                    isFood:true,
                    remarkTitle1:'有餐厅',
                    remarkTitle2:'无会场',
                    //isMeet:true,
                    //hintMessage:'连锁店均可享受协议价',
                    price:'913～2312',
                    phone:'订房热线：28237777转预定部 / 0571-26897180',
                    otherPhone:' 王林芳 15372098255'
                },
            ],
            companyData:[
                {
                    leftImg:require('../../WorkImgFolder/02SongQianGuQing.png'),
                    title:'宋城千古情酒店',
                    subTitle:'杭州市之江路148号',
                    //isFood
                    remarkTitle1:'无餐厅',
                    //isMeet:true,
                    remarkTitle2:'无会场',
                    hintMessage:'需提前预定才可享受协议价',
                    price:'290～360',
                    phone:'订房热线：0571-56021616 ',
                    //otherPhone:
                },
                {
                    leftImg:require('../../WorkImgFolder/02Vienna.png'),
                    title:'维也纳酒店转塘美院店',
                    subTitle:'杭州市转塘街道丽景路18号',
                    //isFood
                    remarkTitle1:'无餐厅',
                    //isMeet:true,
                    remarkTitle2:'无会场',
                    hintMessage:'连锁店均可享受协议价',
                    price:'294～338',
                    phone:'订房热线：40088882888/0571-87609966',
                    otherPhone:'涂经理 15919059144',
                },
                {
                    leftImg:require('../../WorkImgFolder/02LingYueYinQI.png'),
                    title:'珑悦隐栖转塘美院店',
                    subTitle:'杭州市转塘美上商业中心3号楼',
                    isFood:true,
                    remarkTitle1:'有餐厅',
                    isMeet:true,
                    remarkTitle2:'有会场',
                    //hintMessage:'连锁店均可享受协议价',
                    price:'298～528',
                    phone:'订房热线：0571-88059666/87559771',
                    otherPhone:'廖黎黎 13867162102',
                },
                {
                    leftImg:require('../../WorkImgFolder/02XinKaiYuan.png'),
                    title:'新开元大酒店（杭州复兴店）',
                    subTitle:'杭州市上城区复兴路399号，近南复路',
                    //isFood
                    remarkTitle1:'无餐厅',
                    //isMeet:true,
                    remarkTitle2:'无会场',
                    //hintMessage:'连锁店均可享受协议价',
                    price:'398～468',
                    phone:'订房热线：0571-86558888 / 邵承志 13335719396',
                    //otherPhone:'廖黎黎 13867162102',
                },
                {
                    leftImg:require('../../WorkImgFolder/02DongHangYunYi.png'),
                    title:'杭州东航云逸酒店',
                    subTitle:'杭州市西湖区九溪路13号',
                    //isFood:true,
                    remarkTitle1:'无餐厅',
                    isMeet:true,
                    remarkTitle2:'有会场',
                    //hintMessage:'连锁店均可享受协议价',
                    price:'500～600',
                    phone:'订房热线：0571-86567777转78008',
                    otherPhone:' 裘玉洁 13093727771',
                },
                {
                    leftImg:require('../../WorkImgFolder/02LiJingMeiLu.png'),
                    title:'丽晶美庐酒店',
                    subTitle:'杭州市西湖区之北路8号',
                    isFood:true,
                    remarkTitle1:'有餐厅',
                    isMeet:true,
                    remarkTitle2:'有会场',
                    //hintMessage:'连锁店均可享受协议价',
                    price:'700～2950',
                    phone:'订房热线：0571-87900807 / 王挺贵 15268546335',
                    //otherPhone:' 裘玉洁 13093727771',
                },
                {
                    leftImg:require('../../WorkImgFolder/02LuChengRose.png'),
                    title:'绿城玫瑰园度假酒店',
                    subTitle:'杭州市西湖区之江路128号',
                    isFood:true,
                    remarkTitle1:'有餐厅',
                    isMeet:true,
                    remarkTitle2:'有会场',
                    //hintMessage:'连锁店均可享受协议价',
                    price:'980～3980',
                    phone:'订房热线：0571-87667188 / 曹鑫鉴 15869182107 ',
                    //otherPhone:' 裘玉洁 13093727771',
                },
            ],
            xiHuData:[
                {
                    leftImg:require('../../WorkImgFolder/03ZheLuWangHu.png'),
                    title:'浙旅.望湖宾馆',
                    subTitle:'杭州市环城西路2号',
                    isFood:true,
                    remarkTitle1:'有餐厅',
                    //isMeet:true,
                    remarkTitle2:'无会场',
                    //hintMessage:'需提前预定才可享受协议价',
                    price:'700～3000',
                    phone:'订房热线：李少扬 18167101371',
                    //otherPhone:
                }, 
                {
                    leftImg:require('../../WorkImgFolder/03XinXinHotel.png'),
                    title:'杭州新新饭店',
                    subTitle:'杭州市西湖区北山路58号',
                    isFood:true,
                    remarkTitle1:'有餐厅',
                    isMeet:true,
                    remarkTitle2:'有会场',
                    //hintMessage:'需提前预定才可享受协议价',
                    price:'739～3199',
                    phone:'订房热线：0571-87660007/87660008',
                    otherPhone:'韩伊 13958129526'
                },
                {
                    leftImg:require('../../WorkImgFolder/03DaHuanHotel.png'),
                    title:'杭州大华饭店',
                    subTitle:'杭州市上城区南山路171号',
                    isFood:true,
                    remarkTitle1:'有餐厅',
                    //isMeet:true,
                    remarkTitle2:'无会场',
                    //hintMessage:'需提前预定才可享受协议价',
                    price:'898～2080',
                    phone:'订房热线：李华 13989848366',
                    //otherPhone:'韩伊 13958129526'
                },
                {
                    leftImg:require('../../WorkImgFolder/03HuangLongHotel.png'),
                    title:'杭州黄龙饭店',
                    subTitle:'杭州市西湖区曙光路120号',
                    //isFood:true,
                    remarkTitle1:'无餐厅',
                    //isMeet:true,
                    remarkTitle2:'无会场',
                    //hintMessage:'需提前预定才可享受协议价',
                    price:'900～2750',
                    phone:'订房热线：陈弦 13957118035',
                    //otherPhone:'韩伊 13958129526'
                },
                {
                    leftImg:require('../../WorkImgFolder/03Sofitel.png'),
                    title:'杭州索菲特西湖大酒店',
                    subTitle:'杭州市西湖大道333号',
                    //isFood:true,
                    remarkTitle1:'无餐厅',
                    //isMeet:true,
                    remarkTitle2:'无会场',
                    //hintMessage:'需提前预定才可享受协议价',
                    price:'950~3240',
                    phone:'订房热线：周琳烨 18072804116',
                    //otherPhone:'韩伊 13958129526'
                },
                {
                    leftImg:require('../../WorkImgFolder/03XiZiHotel.png'),
                    title:'浙江西子宾馆',
                    subTitle:'杭州市西湖区南山路37号，近雷峰塔及长桥公园',
                    isFood:true,
                    remarkTitle1:'有餐厅',
                    isMeet:true,
                    remarkTitle2:'有会场',
                    //hintMessage:'需提前预定才可享受协议价',
                    price:'990～4850',
                    phone:'订房热线：钟鸣 13957194653',
                    //otherPhone:'韩伊 13958129526'
                },
                {
                    leftImg:require('../../WorkImgFolder/03GrandHyatt.png'),
                    title:'君悦酒店（原凯悦酒店）',
                    subTitle:'杭州市上城区湖滨路28号音乐喷泉对面',
                    isFood:true,
                    remarkTitle1:'有餐厅',
                    //isMeet:true,
                    remarkTitle2:'无会场',
                    hintMessage:'总价另加15%服务费',
                    price:'1100～1600',
                    phone:'订房热线：赵添琛 18958186933',
                    //otherPhone:'韩伊 13958129526'
                },
                {
                    leftImg:require('../../WorkImgFolder/03XiHuGuoMinGuan.png'),
                    title:'杭州西湖国宾馆',
                    subTitle:'杭州市西湖区杨公堤18号',
                    //isFood:true,
                    remarkTitle1:'无餐厅',
                    //isMeet:true,
                    remarkTitle2:'无会场',
                    //hintMessage:'总价另加15%服务费',
                    price:'1380～4180',
                    phone:'订房热线：蒋涛 13758257536',
                    //otherPhone:'韩伊 13958129526'
                },
            ],
            binJiangData:[
                {
                    leftImg:require('../../WorkImgFolder/04QianTangJunYan.png'),
                    title:'杭州钱塘君廷酒店',
                    subTitle:'杭州市滨江区明德路16号',
                    isFood:true,
                    remarkTitle1:'有餐厅',
                    isMeet:true,
                    remarkTitle2:'有会场',
                    //hintMessage:'总价另加15%服务费',
                    price:'298~518',
                    phone:'订房热线：王前程 13675895397',
                    //otherPhone:'韩伊 13958129526'
                },
            ],
            shaoXingData:[
                {
                    leftImg:require('../../WorkImgFolder/05ShaoXingHotel.png'),
                    title:'绍兴饭店',
                    subTitle:'绍兴市环山路8号',
                    isFood:true,
                    remarkTitle1:'有餐厅',
                    isMeet:true,
                    remarkTitle2:'有会场',
                    //hintMessage:'总价另加15%服务费',
                    price:'565～1255',
                    phone:'订房热线：孙芳 13385857507',
                    //otherPhone:'韩伊 13958129526'
                },
            ],
        };
    }
    onClickLimitBtn=(choseIndex)=>{
        this.state.optionSegmentData.map((item,index)=>{
            this.refs['limitBtn'+String(index)].changeLimitStyle('#0B4874','#A6DEFB');
        });
        this.refs['limitBtn'+String(choseIndex)].changeLimitStyle('#FFFFFF','#5DBAED');
        if(choseIndex===0){
            this.setState({
                data:this.state.qianJiangData,
            });
        }else if(choseIndex === 1){
            this.setState({
                data:this.state.companyData,
            });
        }else if(choseIndex===2){
            this.setState({
                data:this.state.xiHuData,
            });
        }else if(choseIndex === 3){
            this.setState({
                data:this.state.binJiangData,
            });
        }else if(choseIndex===4){
            this.setState({
                data:this.state.shaoXingData,
            });
        }
    }
    renderItem=(item,index)=>{
        return(
            <HotelCell leftImg={item.leftImg}
                       title={item.title}
                       subTitle={item.subTitle}
                       isFood={item.isFood}
                       remarkTitle1={item.remarkTitle1}
                       remarkTitle2={item.remarkTitle2}
                       isMeet={item.isMeet}
                       hintMessage={item.hintMessage}
                       price={item.price}
                       phone={item.phone}
                       otherPhone={item.otherPhone}
            />
        );
    }
    // 数据下载
    downImgPress=()=>{
        YSModules.pushWebViewInfo('http://file.chinayasha.com/oa/2019/09/10/hotel.pdf','0')
    }
    render() {
        const {optionSegmentData,data}=this.state;
        return(
            <View style={styles.container}>
                <ScrollView style={{backgroundColor:'#CEEEFD'}}>
                    <Image style={{width:'100%',height:758*PCH.scaleW}} source={require('../../WorkImgFolder/shopHotelTopImg.png')}/>
                    <Image style={{width:'100%',height:328*PCH.scaleW}} source={require('../../WorkImgFolder/shopHotelTopAddress.png')}/>
                    {/*协议酒店精选*/}
                    <Image style={{width:'100%',height:66*PCH.scaleW}} source={require('../../WorkImgFolder/titleHotelXYJDJX.png')}/>
                    <View style={styles.optionSegmentViewStyle}>
                        {optionSegmentData.map((item,index)=>{
                            return(
                                <SegmentBtnView title={item}
                                                onClickLimitBtn={this.onClickLimitBtn}
                                                selectTitleColor={index===0&&'#FFFFFF'}
                                                selectViewColor={index===0&&'#5DBAED'}
                                                key={index}
                                                index={index}
                                                ref={'limitBtn'+String(index)}
                                />);
                        })}
                    </View>
                    <FlatList data={data}
                              keyExtractor={(item, index)=> String(index)}
                              renderItem={({item,index})=>this.renderItem(item, index)}
                              ItemSeparatorComponent={()=>{return(<View style={{width:'100%',height:10,backgroundColor:'#CEEEFD'}}/>);}}
                    />
                    {/*协议酒店明细*/}
                    <Image style={{width:'100%',height:66*PCH.scaleW}} source={require('../../WorkImgFolder/titleHotelXYJDMX.png')}/>
                    <View style={styles.bottomViewStyle}>
                        <Text style={{fontFamily:'PingFangSC-Regular',color:'rgba(0, 0, 0, 0.5)',fontSize:12}}>具体房型对应价格，可下载明细文档查看。本活动为亚厦员工内部福利，请合理合规使用。</Text>
                        <TouchableOpacity onPress={this.downImgPress}>
                            <Image source={require('../../WorkImgFolder/protocolDown.png')} style={styles.downImgStyle}/>
                        </TouchableOpacity>
                    </View>
                    <Text style={styles.ltdStyle}>©️ 2019 亚厦股份(YaSha).  All Rights Reserved.</Text>
                </ScrollView>
            </View>
        );
    }
}
const styles = StyleSheet.create({
    container:{
        flex:1,
    },
    scrollViewStyle:{
        backgroundColor:"#CEEEFD",
    },
    optionSegmentViewStyle:{//内购限量分段控制器的背景视图
        width:'100%',
        height:60*PCH.scaleH,
        flexDirection:'row',
        alignItems:'center',
        justifyContent:'space-evenly',
        borderTopLeftRadius:4,
        borderTopRightRadius:4,
        backgroundColor:"#CEEEFD",
    },
    segmentBtnViewStyle:{
        height:40*PCH.scaleH,
        width:68*PCH.scaleW,
        justifyContent:'center',
        alignItems:'center',
        borderRadius:4,
    },
    segmentTitleStyle:{
        fontSize:14,
        fontFamily:"PingFangSC-Regular",
    },
    bottomViewStyle:{
        width:360*PCH.scaleW,
        height:144,
        paddingLeft:16,
        paddingTop:20,
        marginLeft:8*PCH.scaleW,
        backgroundColor:'#FFFFFF',
    },
    downImgStyle:{
        width:325,
        height:58,
        marginTop:10,
    },
    ltdStyle:{
        fontSize:13,
        fontFamily:'PingFangSC-Regular',
        color:'rgba(0, 0, 0, 0.25)',
        marginLeft:46*PCH.scaleW,
        marginTop:56*PCH.scaleH,
        marginBottom:20*PCH.scaleH,
    },
});

class SegmentBtnView extends Component{
    constructor(props){
        super(props);
        this.state={
            selectTitleColor:this.props.selectTitleColor?this.props.selectTitleColor:'#0B4874',
            selectViewColor:this.props.selectViewColor?this.props.selectViewColor:'#A6DEFB',
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
        const {title} = this.props;
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