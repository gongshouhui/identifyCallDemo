/**
*@Created by GZL on 2019/09/23 16:59:33.
*/

'use strict';
import React, {PureComponent, Component} from 'react';
import {Text, View, StyleSheet, TouchableOpacity, Image, SectionList, ScrollView,} from 'react-native';
import ShowCell from './YSShowCell';

//办公秩序
export default class OfficeOrderDetailVC extends PureComponent {
    static navigationOptions = ({navigation, navigationOptions}) => {
        return{
            title: '办公秩序',
        };
    };
    //itemType:cell的类型,默认为无图;1/2/3图片类型不同
    constructor(props) {
        super(props);
        this.state={
            data:[
                {
                    sectionTitle:'乘梯',
                    data:[
                        {
                            title:'文明乘梯',
                            yellowLineStyle:84,
                            itemType:1,
                            data:[
                                '自《文明乘坐电梯通知》下发之日起，若再次出现“先上后下”或“先下后上”等禁止行为的，一律视为扰乱办公秩序的违纪行为，公司将依据《员工违纪行为查处规定（试行）》，对违纪行为人做出约谈训诫、通报批评、经济惩罚等处理，屡教不改或其他情节严重者予以辞退。',
                                '建议低楼层办公的员工在高峰期间尽量改走楼梯，以减少电梯运行压力。',
                            ],
                        },
                    ],
                },
                {
                    sectionTitle:'用餐',
                    data:[
                        {
                            title:'亚厦中心员工餐厅错时用餐',
                            yellowLineStyle:219,
                            itemType:2,
                            data:[
                                '1. 1月1日--6月30日安排：',
                                '12:00 2F、3F、4F、5F低楼层员工；',
                                '12:15 6F、7F、8F中楼层员工；',
                                '12:30 9F、10F、11F、12F高楼层员工。',
                                '2. 7月1日--12月31日安排：',
                                '12:00 9F、10F、11F、12F高楼层员工；',
                                '12:15 6F、7F、8F中楼层员工；',
                                '12:30 2F、13F、4F、15F低楼层员工。',
                            ],
                        },
                        {
                            title:'用餐申请及规范',
                            yellowLineStyle:135,
                            data:[
                                '1. 平时周末不开餐，有特殊需求可申请，开餐总人数需要满足50人。如需开餐，请发邮件至行政管理部夏芬，邮件内容需写明开餐原因、开餐时间、开餐人数、支付方式、特殊需求等。',
                                '2. 禁止在公司办公区域范围内就餐（包括早餐、中餐和晚餐），如有自带饭菜，请统一于就餐时间至公司餐厅食用。',
                            ],
                        },
                    ],
                },
                {
                    sectionTitle:'安全禁烟',
                    data:[
                        {
                            title:'公共区域禁止吸烟',
                            yellowLineStyle:152,
                            itemType:3,
                            data:[
                                '禁止在公司员工集中办公区域、走廊、楼梯、电梯厅、卫生间等楼内公共场所吸烟；外来办事人员吸烟的，接待员工应当告知其遵守公司禁烟规定，否则接待员工负未劝阻连带责任。',
                            ],
                        },
                    ],
                },
                {
                    sectionTitle:'禁用自备电器',
                    wdithStyle:96,
                    data:[
                        {
                            title:'禁用自备电器',
                            yellowLineStyle:118,
                            data:[
                                '禁止使用自备的微波炉、电磁炉、电饭煲、电热水壶、电热水杯、电热台板、冰箱、烤箱、电炉、取暖器及其它大功率电器；禁止私接接线板等用电线路。 ',
                                '',
                            ],
                        },
                    ],
                },
                {
                    sectionTitle:'卫生及物品摆放',
                    wdithStyle:112,
                    data:[
                        {
                            title:'卫生及物品摆放',
                            yellowLineStyle:135,
                            data:[
                                '全体员工应当坚持上班前打扫卫生、下班前整理物品的良好习惯，坚持每周五或节日前一天进行大扫除的卫生习惯，地面必须清洁、桌面必须整洁，与工作无关的个人物品必须放置在抽屉、柜子内，办公椅不用时必须推入办公桌面板下；',
                                '工作中产生的垃圾等影响清洁、整洁的问题随时处理，工作中查阅的资料依据随时归位，始终保持卫生、秩序的工作环境。',
                            ],
                        },
                    ],
                },
            ],
        };
        this.scrollBar();
    }

    scrollBar=()=>{
        const chose_index = this.props.navigation.getParam('index');
        this.timer = setTimeout(
            () => { 
                this.state.data.map((item,index)=>{
                    this.refs['btn'+String(index)].changeStyle('#666F83',false);
                });
                this.refs['btn'+String(chose_index)].changeStyle('#2F86F6',true);
                this.refs['sectionList'].scrollToLocation({itemIndex:0, sectionIndex:chose_index});
            },
            300
        );
    }
    componentWillUnmount() {    //清除定时器的默认写法
        this.timer && clearTimeout(this.timer);
    }
    //点击箭头移动顶部scrollView
    onLeftBtnPress = ()=>{
        this.refs['scrollView'].scrollTo({x:0, y:0, animated: true});
    }
    onRightBtnPress = ()=>{
        this.refs['scrollView'].scrollToEnd({animated:false});
    }

    changeScrollViewWithOffset = (offsetY)=>{
        if(offsetY<800&&offsetY>=0){//乘梯 
            this.state.data.map((item,index)=>{
                this.refs['btn'+String(index)].changeStyle('#666F83',false);
            });
            this.refs['btn0'].changeStyle('#2F86F6',true);
        }else if(offsetY>=800&&offsetY<855+777+270+50){//用餐 
            this.state.data.map((item,index)=>{
                this.refs['btn'+String(index)].changeStyle('#666F83',false);
            });
            this.refs['btn1'].changeStyle('#2F86F6',true);
        }else if(offsetY>=855+777+270+50&&offsetY<429+855+777+270+50+50){//安全禁烟
            this.state.data.map((item,index)=>{
                this.refs['btn'+String(index)].changeStyle('#666F83',false);
            });
            this.refs['btn2'].changeStyle('#2F86F6',true);
        }else if(offsetY>=429+855+777+270+50+50&&offsetY<150+429+855+777+270+50+50){//禁用自备电器
            this.state.data.map((item,index)=>{
                this.refs['btn'+String(index)].changeStyle('#666F83',false);
            });
            this.refs['btn3'].changeStyle('#2F86F6',true);
        }else if(offsetY>0){//卫生及物品摆放
            this.state.data.map((item,index)=>{
                this.refs['btn'+String(index)].changeStyle('#666F83',false);
            });
            this.refs['btn4'].changeStyle('#2F86F6',true);
        }

        if(offsetY>=0&&offsetY<429+855+777+270+50+50){//处理scrollView
            this.refs['scrollView'].scrollTo({x:0, y:0, animated: false});
        }else if(offsetY>=429+855+777+270+50+50){
            this.refs['scrollView'].scrollToEnd({animated:false});
        }
    };
    // 点击顶部按钮事件: 乘梯 用餐 安全禁烟 禁用自备电器 卫生及物品摆放
    onBtnPress = (title)=>{
        const indexPath_section = this.state.data.map(item=>item.sectionTitle).indexOf(title);
        //顶部scrollVIew的偏移
        if(indexPath_section<=1){
            this.refs['scrollView'].scrollTo({x:0, y:0, animated: false});
        }else if(indexPath_section>=3){
            this.refs['scrollView'].scrollToEnd({animated:false});
        }else if (indexPath_section===2){//工程会计人事类
            this.refs['scrollView'].scrollTo({x:100, y:0, animated: false});
        }
        this.state.data.map((item,index)=>{
            this.refs['btn'+String(index)].changeStyle('#666F83',false);
        });
        this.refs['btn'+String(indexPath_section)].changeStyle('#2F86F6',true);
        this.refs['sectionList'].scrollToLocation({itemIndex:0, sectionIndex:indexPath_section});
        
        
    };

    //手指停止拖动界面/
    onSectionListScrollEndDrag = (e:Object)=>{
        const offsetY = e.nativeEvent.contentOffset.y; //滑动距离
        this.changeScrollViewWithOffset(offsetY);
    };
    //动画停止滚动的时候
    onSectionnListMomentumScrollEnd =(e:Object)=>{
        const offsetY = e.nativeEvent.contentOffset.y; //滑动距离
        this.changeScrollViewWithOffset(offsetY);
    };

    //区头
    renderSectionHeader=({section})=>{
        const index = this.state.data.map(item =>item.sectionTitle).indexOf(section.sectionTitle);
        return(
            <View style={styles.headerSectionViewStyle}>
                <Text style={{color:'#8BB3F1',fontSize:12,marginTop:21*PCH.scaleH}}>{'0'+String(index+1)}</Text>
                <View style={styles.titleStyleView}>
                    <Image style={[styles.topImgStyle]} source={require('../WorkImgFolder/titleDivisionPoint.png')}/>
                    <Text style={{color:'#1768E4',fontSize:22, fontFamily:'PingFangSC-Semibold'}}>{section.sectionTitle}</Text>
                    <Image style={[styles.topImgStyle]} source={require('../WorkImgFolder/titleDivisionPoint.png')}/>
                </View>
                <View style={{width:PCH.width, height:16, alignItems:'center',marginTop:7*PCH.scaleH}}>
                    <Image source={require('../WorkImgFolder/titleTravelDown.png')} style={{width:16*PCH.scaleW,height:16*PCH.scaleH,}}/>
                </View>
            </View>
        );
    }
    //cell  ShowCell
    _renderItem = (item, index,section)=>{
        if(item.itemType===1){
            return(
                <View style={styles.detailViewStyle}>
                    <View style={styles.lineViewStyle}/>
                    <Text style={styles.detailTitleStyle}>{item.title}</Text>
                    <View style={[styles.lineViewStyle1,{width:item.yellowLineStyle}]}/>
                    <Text style={styles.detailContentStyle}>{item.data[0]}</Text>
                    <Text style={styles.detailContentStyle}>{item.data[1]}</Text>
                    <Image style={{width:330,height:558,marginVertical:8}} source={require('../WorkImgFolder/officeUseLift.png')}/>
                </View>
            );
        }else if(item.itemType===2){
            return(
                <View style={styles.detailViewStyle}>
                        <View style={styles.lineViewStyle}/>
                        <Text style={styles.detailTitleStyle}>{item.title}</Text>
                        <View style={[styles.lineViewStyle1,{width:item.yellowLineStyle}]}/>
                        {item.data.map((info,index)=>{
                            let titleFamily = 'PingFangSC-Regular';
                            if(index===0||index===4){
                                titleFamily='PingFangSC-Medium';
                            }
                            return(
                                <Text style={[styles.detailContentStyle,{fontFamily:titleFamily}]} key={index}>{info}</Text>
                            );
                        })}
                        <Image style={{width:330,height:480,marginVertical:8}} source={require('../WorkImgFolder/officeMealTime.png')}/>
                </View>
            );
        }else if(item.itemType===3){
            return(
                <View style={styles.detailViewStyle}>
                        <View style={styles.lineViewStyle}/>
                        <Text style={styles.detailTitleStyle}>{item.title}</Text>
                        <View style={[styles.lineViewStyle1,{width:item.yellowLineStyle}]}/>
                        <Text style={[styles.detailContentStyle,]}>{item.data[0]}</Text>
                        <Image style={{width:330,height:244,marginVertical:8}} source={require('../WorkImgFolder/officeNoSmoking.png')}/>
                </View>
            );
        }
        return(
            <ShowCell title={item.title}
                      data={item.data}
                      viewStyle={15}
                      index={index}
                      yellowLineStyle={item.yellowLineStyle} 
            />
        );
    }

    render() {
        const {data} =this.state;
        const chose_index = this.props.navigation.getParam('index');
        let btn_index = 0;
        let slatList_y=0.0;
        if (chose_index >= 1){
            //顶部按钮的处理
            btn_index = 1;
            //slatList初始位置
            if(chose_index===3){//申请考勤机
                //slatList_y = 490+140;
            }else {
                //slatList_y = 490;
            }
        }
        return(
            <View style={styles.container}>
                <View style={styles.topBtnViewStyle}>
                    <TouchableOpacity onPress={this.onLeftBtnPress}>
                        <Image source={require('../WorkImgFolder/scrollLeftBtnImg.png')} style={{width:12,height:24,marginLeft:4}}/>
                    </TouchableOpacity>
                    <ScrollView horizontal={true} 
                                showsHorizontalScrollIndicator={false}
                                ref='scrollView'
                                style={{width:PCH.width-(40*PCH.scaleW)}}
                                contentOffset={{x:btn_index*64,y:0}}
                                >
                        {data.map((item,index)=>{
                            return(
                                <BtnView  ref={'btn'+String(index)}
                                          title={item.sectionTitle}
                                          onBtnPress={this.onBtnPress}
                                          wdithStyle={item.wdithStyle}
                                          textColor={index===chose_index&&'#2F86F6'}
                                          lineShow={index===chose_index&&true}
                                          key={index}
                                />
                            );
                        })}
                    </ScrollView>
                    <TouchableOpacity style={{marginHorizontal:6}} onPress={this.onRightBtnPress}>
                        <Image source={require('../WorkImgFolder/scrollRightBtnImg.png')} style={{width:12,height:24,marginRight:4}}/>
                    </TouchableOpacity>
                </View>
                <SectionList sections={data}
                             renderItem={({item,index,section})=>this._renderItem(item, index,section)}
                             keyExtractor={(item, index) => item + index}
                             stickySectionHeadersEnabled={false}
                             ref='sectionList'
                             renderSectionHeader={this.renderSectionHeader}
                             //contentOffset={{x:0,y:slatList_y}}
                             onScrollEndDrag={this.onSectionListScrollEndDrag}//用户停止拖动界面
                             onMomentumScrollEnd={this.onSectionnListMomentumScrollEnd}//滚动动画停止
                />
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container:{
        flex: 1,
        backgroundColor: '#F3F8FF',
        alignItems:'center',
    },
    topBtnViewStyle:{
        backgroundColor:'white',
        width:PCH.width,
        height:43,
        flexDirection:'row',
        alignItems:'center'
    },
    headerSectionViewStyle:{
        flex:1,
        width:PCH.width,
        justifyContent: 'center',
        backgroundColor: '#F3F8FF',
        flexDirection: 'row',
        flexWrap: 'wrap',
    },
    titleStyleView: {
        width:PCH.width,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-around',
        marginTop: 2,
    },
    topImgStyle: {//分割点图片
        width: 69*PCH.scaleW,
        height: 15*PCH.scaleW,
        resizeMode:'contain',
    },
    detailViewStyle:{//流程白色背景图
        width: PCH.scaleW*345,
        backgroundColor: '#FFFFFF',
        borderRadius: 4,
        marginTop:7*PCH.scaleH,
        marginLeft:15,
    },
    lineViewStyle:{//蓝线
        width: PCH.scaleW*345,
        height: 4*PCH.scaleH,
        backgroundColor: '#1768E4',
        borderTopRightRadius: 4,
        borderTopLeftRadius: 4,
    },
    detailTitleStyle:{
        fontSize: 16,
        color: '#1768E4',
        marginTop: 20*PCH.scaleH,
        marginLeft: 10*PCH.scaleW,
        fontFamily:'PingFangSC-Semibold'
    },
    lineViewStyle1: {//黄线
        marginLeft: 10*PCH.scaleW,
        marginTop: -8*PCH.scaleH,
        width: PCH.scaleW*186,
        height: 8*PCH.scaleH,
        backgroundColor: 'rgba(247, 181, 0, 0.3)',
        borderRadius: 4,
    },
    detailContentStyle:{
        marginTop: 8*PCH.scaleH,
        marginHorizontal: 10*PCH.scaleW,
        color: '#333333',
        fontSize: 14,
        fontFamily:'PingFangSC-Regular',
        lineHeight:28,//行间距
    },
});

class BtnView extends Component {
    constructor(props){
        super(props);
        this.state={
            title:this.props.title?this.props.title:'标题',
            textColor:this.props.textColor?this.props.textColor:'#666F83',
            isHidden:this.props.lineShow,//默认不显示 为false
            wdithStyle:this.props.wdithStyle?this.props.wdithStyle:65,
        };
    }
    //点击按钮事件
    _onPress=()=>{
        this.props.onBtnPress(this.props.title);
    };
    //使用refs回调改变本控件
    changeStyle=(textColor,isHidden)=>{
        this.setState({
            textColor:textColor,
            isHidden:isHidden,
        });
    }
    render(){
        const {title, textColor, isHidden,wdithStyle,} = this.state;
        return(
            <TouchableOpacity onPress={this._onPress} style={{marginLeft:17}}>
            <View style={{width:wdithStyle,alignItems:"center",height:43}}>
                <Text style={[{color:textColor,fontFamily:'PingFangSC-Regular',fontSize:16,marginTop:10},textColor&&{color:textColor}]}>{title}</Text>
                <View style={[{width:wdithStyle,height:2,marginTop:9},isHidden&&textColor&&{backgroundColor:textColor},]}/>
            </View>
            </TouchableOpacity>
        );
    }
}
