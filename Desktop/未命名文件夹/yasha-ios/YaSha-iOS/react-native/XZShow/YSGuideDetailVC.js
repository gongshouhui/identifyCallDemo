/**
*@Created by GZL on 2019/09/19 10:11:47.
*/

import React, {PureComponent, Component} from 'react';
import {Text, View, StyleSheet, FlatList, Image, TouchableOpacity, } from 'react-native';
import DetailCell from './YSGuideOfficeDetailCell';

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

//该VC有 图文寄件/办公用品、礼品/用章 三个页面转换
export default class GuideDetailVC extends PureComponent {
    static navigationOptions = ({navigation, navigationOptions}) => {
        return{
            title: navigation.getParam('title'),
        };
    };
    constructor(props) {
        super(props);
        if(this.props.navigation.getParam('title')==='图文寄件'){
            this.state={
                data:[
                    {
                        sectionTitle:'图文',
                        title:'蓝钻打印需要走什么流程？',
                        subTitle:'蓝钻图文打印等需走如下流程：',
                        data:[
                            '1. 填写打印单，流程中心-通用流程-行政管理-蓝钻图文打印申请单。',
                            '2. 提供流程单号及需打印装订材料等前往亚厦中心A座2楼208。',
                            '3. 打印装订完成后在确认单上签字领取。',
                        ],
                    },
                    {
                        sectionTitle:'寄件',
                        title:'顺丰寄件怎么寄？',
                        subTitle:'顺丰寄件需走以下流程：',
                        data:[
                            '1. 公司件需要OA发起顺丰寄件流程，流程完结并在寄件流程中打印快递单并拿到亚厦中心A座204寄出。',
                            '2. 个人件可直接拿到A座204填写运单直接寄出。',
                            '3. 顺丰到付件需在OA发起顺丰到付件流程。',
                            '4. 费用分摊选择项目部或其他时必须从项目库或组织架构中选择(除部分未中标项目）',
                            '5. 经办人提交完寄件流程和到付件流程请确认流程办结。',
                        ],
                    },
                ],
            };
        }else if (this.props.navigation.getParam('title')==='办公用品、礼品'){
            this.state={
                data:[
                    {
                        sectionTitle:'办公用品',
                        title:'申请办公用品走什么流程？',
                        subTitle:'申请办公用品走如下流程：',
                        data:[
                            '1. 一般办公用办公用品由部门负责申请办公用品的同事在每个月10号开始提交申请流程（为期3个工作日），如遇节假日顺延。每个月25号左右发放。申请数量为一个月的实际使用量，不得设立二级仓库。',
                            '2. 部门负责申请办公用品的同事，需加一下“亚厦办公用品申请”QQ群： 135457530，群里会及时更新办公用品编码和申请要求。',
                            '3. 一些特殊不备货的办公用品，可单独走办公用品流程申请，写明申请内容和事由。',
                            '4. 办公用品申请入口：OA-资产管理（EAM）-办公用品申请 -  按表格内容填写。',
                        ],
                    },
                    {
                        sectionTitle:'礼品',
                        title:'申请礼品走什么流程？',
                        subTitle:'申请礼品走如下流程：',
                        data:[
                            '1. 经理以上职务可申请礼品。',
                            '2. 项目部申请需勾选”是否为项目“为”是“，”是否为营销“选择”否“，并选择正确的项目名称和项目经理。考核项目不予申请。',
                            '3. 营销团队和区域公司申请礼品，需勾选”是否为营销“选：是”，”是否为项目“选”否“。 营销人员账面为负不予申请。',
                            '4. 所有申请礼品的部门，必须写清楚申请事由和用途。费用归属按实际使用人分摊。',
                            '5. 礼品申请入口：OA-资产管理（EAM）-礼品申请 -  按表格内容填写（申请物品按增行搜索对应的礼品名称）。',
                        ],
                    },
                    {
                        sectionTitle:'Tips',
                        title:'需求流程发起之后，什么时候可以领取物品？',
                        data:[
                            '1. 物品领取时长影响因素：物品特殊性、领导审批速度、有无定制要求、供应商送货时间',
                            '2. 流程发起之后，如果着急领取，需自行催促各个审批环节。若仓库有库存，流程到仓管员处，仓管员会联系领取；若无库存，需要采购，采购专员在收到申请流程后一般会当天处理采购流程，需求人也可联系采购专员沟通到货时长。',
                        ],  
                    },
                ],
            };
        }else if (this.props.navigation.getParam('title')==='用章'){
            this.state={
                data:this.props.navigation.getParam('data'),
            };
        }
    }
    //cell
    _renderItem = (item, index)=>{
        const section = this.state.data.map(o=>o.sectionTitle).indexOf(item.sectionTitle)
        return(
            <DetailCell title={item.title}
                        data={item.data}
                        viewStyle={15}
                        index={index}
                        subTitle={item.subTitle}
                        section={section}
                        sectionTitle={item.sectionTitle}
                        yellowLineStyle={PCH.scaleW*253} 
                />
        );
    };
    //点击顶部按钮
    onBtnPress= (title)=>{
        const indexPath_section = this.state.data.map(item=>item.sectionTitle).indexOf(title);
        this.state.data.map((item,index)=>{
            this.refs['btn'+String(index)].changeStyle('#666F83',false);
        });
        this.refs['btn'+String(indexPath_section)].changeStyle('#2F86F6',true);
        this.refs.flatList.scrollToIndex({ viewPosition: 0, index:indexPath_section});

    }
    //手指停止拖动界面
    onScrollEndDrag = (e:Object)=>{
        const offsetY = e.nativeEvent.contentOffset.y; //滑动距离
        if(this.props.navigation.getParam('title')==='办公用品、礼品'){
            if (offsetY>=350&&offsetY<PCH.height){
                this.state.data.map((item,index)=>{
                    this.refs['btn'+String(index)].changeStyle('#666F83',false);
                });
                this.refs['btn'+String(1)].changeStyle('#2F86F6',true);
            }else if(offsetY>=PCH.height) {
                this.state.data.map((item,index)=>{
                    this.refs['btn'+String(index)].changeStyle('#666F83',false);
                });
                this.refs['btn'+String(2)].changeStyle('#2F86F6',true);
            }else if(offsetY<350&&offsetY>=0){
                this.state.data.map((item,index)=>{
                    this.refs['btn'+String(index)].changeStyle('#666F83',false);
                });
                this.refs['btn'+String(0)].changeStyle('#2F86F6',true);
            }
        }else {//图文寄件/用章
            if(offsetY>=0&&offsetY<100){
                this.refs['btn1'].changeStyle('#666F83',false);
                this.refs['btn0'].changeStyle('#2F86F6',true);
            }else {
                this.refs['btn0'].changeStyle('#666F83',false);
                this.refs['btn1'].changeStyle('#2F86F6',true);
            }
        }
    }
    //动画停止滚动的时候
    onMomentumScrollEnd =(e:Object)=>{

        /*
        const contentSizeHeight = e.nativeEvent.contentSize.height; //scrollView contentSize高度
        const oriageScrollHeight = e.nativeEvent.layoutMeasurement.height; //scrollView高度
        if (offsetY + oriageScrollHeight >= contentSizeHeight){
            Console.log('上传滑动到底部事件')
        }*/
        const offsetY = e.nativeEvent.contentOffset.y; //滑动距离
        if(this.props.navigation.getParam('title')==='办公用品、礼品'){
            if (offsetY>=350&&offsetY<PCH.height){
                this.state.data.map((item,index)=>{
                    this.refs['btn'+String(index)].changeStyle('#666F83',false);
                });
                this.refs['btn'+String(1)].changeStyle('#2F86F6',true);
            }else if(offsetY>=PCH.height) {
                this.state.data.map((item,index)=>{
                    this.refs['btn'+String(index)].changeStyle('#666F83',false);
                });
                this.refs['btn'+String(2)].changeStyle('#2F86F6',true);
            }else if(offsetY<350&&offsetY>=0){
                this.state.data.map((item,index)=>{
                    this.refs['btn'+String(index)].changeStyle('#666F83',false);
                });
                this.refs['btn'+String(0)].changeStyle('#2F86F6',true);
            }
        }else {//图文寄件/用章
            if(offsetY>=0&&offsetY<100){
                this.refs['btn1'].changeStyle('#666F83',false);
                this.refs['btn0'].changeStyle('#2F86F6',true);
            }else {
                this.refs['btn0'].changeStyle('#666F83',false);
                this.refs['btn1'].changeStyle('#2F86F6',true);
            }
        }


    };

    render() {
        const {data} = this.state;
        const title = this.props.navigation.getParam('title');
        const chose_index = this.props.navigation.getParam('index');
        let flatList_y = 0.0;
        if (title==='办公用品、礼品'){
            flatList_y=500.0*chose_index;
        }else {
            flatList_y = 300.0*chose_index;
        }
        return(
            <View style={styles.container}>
                <View style={styles.topBtnViewStyle}>
                    {title!=='餐饮会务'&&data.map((item,index)=>{
                        return(
                            <BtnView ref={'btn'+String(index)}
                                     title={item.sectionTitle}
                                     onBtnPress={this.onBtnPress}
                                     textColor={index===chose_index&&'#2F86F6'}
                                     lineShow={index===chose_index&&true}
                                     key={index}
                            />);
                    })}
                </View>
                <FlatList data={data}
                          renderItem={({item,index})=>this._renderItem(item, index)}
                          keyExtractor={(item, index)=> String(index)}
                          ItemSeparatorComponent={()=>{return(<View style={{width:PCH.width,height:20,backgroundColor:'#F3F8FF'}}/>)}}
                          ref='flatList'
                          contentOffset={{x:0,y:flatList_y}}
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
    headerViewStyle:{
        width: PCH.width,
        justifyContent: 'center',
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
    },
});