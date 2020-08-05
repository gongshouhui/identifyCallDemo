/**
*@Created by GZL on 2019/09/23 10:37:02.
*/

'use strict';
import React, {PureComponent, Component} from 'react';
import {Text, View, StyleSheet, TouchableOpacity, Image, SectionList, } from 'react-native';
import ShowCell from './YSShowCell';


//办公设备详情页
export default class OfficeSectionDetailVC extends PureComponent {
    static navigationOptions = ({navigation, navigationOptions}) => {
        return{
            title: navigation.getParam('title'),
        };
    };
    constructor(props) {
        super(props);
        if(this.props.navigation.getParam('title')==='办公设备'){
            this.state={
                data:[
                    {
                        sectionTitle:'办公设备',
                        data:[
                            {
                                title:'办公固定资产如何申请？',
                                yellowLineStyle:203,
                                data:[
                                    '申请需要走如下流程：',
                                    '1. 申请人事先确认好部门需求并与固定资产管理员进行电话沟通，确认申请办公设备的规格型号等相关事宜；',
                                    '2. OA上发起固定资产申请流程（进入路径：OA—资产管理系统—资产申请—固定资产申请,填写相关信息进行申请。) ',
                                    '3. 注意事项：针对非标准配置的办公设备采购，附件需说明物品的品牌型号等相关信息（可附带电商销售平台的截图进行说明），并在说明栏内对采购原因及用途进行详细阐述。',
                                ],
                            },
                        ],
                    },
                    {
                        sectionTitle:'电子设备',
                        data:[
                            {
                                title:'如何申请电脑？',
                                yellowLineStyle:135,
                                data:[
                                    '电脑申请流程如下：',
                                    '1. OA系统-资产管理-资产申请-申请-固定资产申请',
                                    '2. 申请类别选择电子设备',
                                    '3. 物品明细选择笔记本或者显示器和主机。',
                                ],
                            },
                            {
                                title:'鼠标键盘U盘如何申请？',
                                yellowLineStyle:198,
                                data:[
                                    '备件申请流程如下:',
                                    '1. OA系统-资产管理-固定资产-个人资产-备件申请-增加配件',
                                    '2. 选中电脑之后点击备件申请',
                                    '3. 明细类可选择电脑配件、电脑周边、电子配件（非电脑）',
                                    '4. 鼠标键盘等常规备件流程到资产管理员处即可领取',
                                ],
                            },
                            {
                                title:'如何申请考勤机？',
                                yellowLineStyle:152,
                                data:[
                                    '资产申请流程如下：',
                                    '1. OA系统-资产管理-资产申请-申请-考勤机申请',
                                    '2. 根据高峰期打卡人数合理申请配置',
                                ],
                            },
                        ],
                    },
                ],
            };
        }
    }

    //点击顶部按钮事件
    onBtnPress= (title)=>{
        const indexPath_section = this.state.data.map(item=>item.sectionTitle).indexOf(title);
        if(indexPath_section===0){
            this.refs['btn1'].changeStyle('#666F83',false);
            this.refs['btn0'].changeStyle('#2F86F6',true);
        }else if(indexPath_section===1){
            this.refs['btn0'].changeStyle('#666F83',false);
            this.refs['btn1'].changeStyle('#2F86F6',true);
        }
        this.refs.sectionList.scrollToLocation({itemIndex:0, sectionIndex:indexPath_section});

    }

    //手指停止拖动界面
    onScrollEndDrag = (e:Object)=>{
        const offsetY = e.nativeEvent.contentOffset.y; //滑动距离
        if(offsetY>=0&&offsetY<230){
            this.refs['btn1'].changeStyle('#666F83',false);
            this.refs['btn0'].changeStyle('#2F86F6',true);
        }else {
            this.refs['btn0'].changeStyle('#666F83',false);
            this.refs['btn1'].changeStyle('#2F86F6',true);
        } 
    }
    //动画停止滚动的时候
    onMomentumScrollEnd =(e:Object)=>{

        const offsetY = e.nativeEvent.contentOffset.y; //滑动距离
        if(offsetY>=0&&offsetY<230){
            this.refs['btn1'].changeStyle('#666F83',false);
            this.refs['btn0'].changeStyle('#2F86F6',true);
        }else {
            this.refs['btn0'].changeStyle('#666F83',false);
            this.refs['btn1'].changeStyle('#2F86F6',true);
        }


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
                slatList_y = 490+140;
            }else {
                slatList_y = 490;
            }
        }
        return(
            <View style={styles.container}>
                <View style={styles.topBtnViewStyle}>
                    {data.map((item,index)=>{
                        return(
                            <BtnView ref={'btn'+String(index)}
                                     title={item.sectionTitle}
                                     onBtnPress={this.onBtnPress}
                                     textColor={index===btn_index&&'#2F86F6'}
                                     lineShow={index===btn_index&&true}
                                     key={index}
                            />);
                    })}
                </View>
                <SectionList sections={data}
                             renderItem={({item,index,section})=>this._renderItem(item, index,section)}
                             keyExtractor={(item, index) => item + index}
                             stickySectionHeadersEnabled={false}
                             ref='sectionList'
                             renderSectionHeader={this.renderSectionHeader}
                             contentOffset={{x:0,y:slatList_y}}
                             onScrollEndDrag={this.onScrollEndDrag}//用户停止拖动界面
                             onMomentumScrollEnd={this.onMomentumScrollEnd}//滚动动画停止
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
        justifyContent:'space-around'
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
});


class BtnView extends Component {
    constructor(props){
        super(props);
        this.state={
            title:this.props.title?this.props.title:'标题',
            textColor:this.props.textColor?this.props.textColor:'#666F83',
            isHidden:this.props.lineShow,//默认不显示 为false
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
        const {title, textColor, isHidden} = this.state;
        return(
            <TouchableOpacity onPress={this._onPress}>
            <View style={{width:64,alignItems:"center",height:43}}>
                <Text style={[{color:textColor,fontFamily:'PingFangSC-Regular',fontSize:16,marginTop:10},textColor&&{color:textColor}]}>{title}</Text>
                <View style={[{width:64,height:2,marginTop:9},isHidden&&textColor&&{backgroundColor:textColor},]}/>
            </View>
            </TouchableOpacity>
        );
    }
}
