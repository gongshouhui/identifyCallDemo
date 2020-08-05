/**
*@Created by GZL on 2019/09/23 13:22:32.
*/

'use strict';
import React, {PureComponent, Component} from 'react';
import {Text, View, StyleSheet, TouchableOpacity, Image, SectionList, ScrollView,} from 'react-native';
import ShowCell from './YSShowCell';


export default class ArchivesDetailVC extends PureComponent {
    static navigationOptions = ({navigation, navigationOptions}) => {
        return{
            title: '档案',
        };
    };
    //最小的celll的内部标题类型(默认是1:一个蓝色标题; 2是两个蓝色标题)
    constructor(props) {
        super(props);
        this.state={
            data:[
                {
                    sectionTitle:'证件营业执照类',
                    data:[
                        {
                            title:'证件类及执业印章借用/归还',
                            subTitle:'需要走什么流程？',
                            yellowLineStyle:228,
                            itemStyle:2,//有两个蓝色标题
                            data:[
                                '借用需要走如下流程：',
                                '1. 借用人员事先与档案室进行沟通借阅事宜，确定证书是否外借及借件编号',
                                '2. OA上发起借用流程（由本人发起或由同事代发起），进入路径：OA-证书管理系统-借用申请（归还就选归还操作）-填写内容添加证书；',
                                '3. 借用流程批完后，打印证书借用申请单到亚厦中心A座档案室315室借阅，借用及归还都需本人在单据上签字确认。',
                            ],
                        },
                    ],
                },
                {
                    sectionTitle:'项目类',
                    wdithStyle:65,
                    data:[
                        {
                            title:'项目印章借用归还需要走什么流程？',
                            yellowLineStyle:287,
                            data:[
                                '项目印章借用及归还需要走如下流程：',
                                '1. 项目印章由走流程人员事先与档案室进行沟通事宜，确定印章是否外借。',
                                '2. OA上发起流程（由本人发起或由同事代发起），进入路径：OA-流程中心-发起流程-印章借用流程单；',
                                '3. 提交流程单后由行政管理岗人员确认后协同到档案室。',
                                '4. 相关借用人员到档案室315室现场填写携印外出使用审批单后进行办理印章借用（借用携印外出使用审批单需印章留样及本人签字)，填写纸质印章借用登记表；',
                                '5. 印章归还需在OA上发起流程，进入路径：OA-流程中心-发起流程-印章归还流程单（归还印章时，在外出使用审批单留样及本人签字）',
                            ],
                        },
                    ],
                },
                {
                    sectionTitle:'工程会计人事类',
                    data:[
                        {
                            title:'借阅需要走什么流程？',
                            yellowLineStyle:186,
                            data:[
                                '除证件类档案借阅需要走如下流程：',
                                '1. 借阅人员事先与档案室进行沟通借阅事宜，确定档案是否外借及借件编号；',
                                '2. OA上发起借阅流程（由本人发起或由同事代发起），进入路径：OA-新流程中心-通用流程-行政管理-档案资料借用申请单；',
                                '3. 提交档案资料借用申请单至档案室；',
                                '4. 借阅流程批完后，打印流程到档案室315室借阅，借用需本人在单据上签字确认；',
                                '5. 借阅完成后，档案归还档案室，并在原先的借用申请单上签字确认并注明日期。',
                            ],
                        },
                    ],
                },
                {
                    sectionTitle:'档案室执业类',
                    data:[
                        {
                            title:'加盖执业印章需要走什么流程？',
                            yellowLineStyle:253,
                            data:[
                                '印章盖章需要走如下流程：',
                                '1. 执业印章及项目印章由走发起人事先与档案室进行沟通盖章事宜，确定印章是否外借。',
                                '2. OA上发起盖章流程（由本人发起或由同事代发起），进入路径：OA-流程中心-发起流程-输入盖章字样进行搜索（根据需要盖章的材料内容进行选择流程名称里相应的盖章申请流程）',
                                '3. 提交流程单后由行政管理岗人员确认后转阅或协同到档案室。',
                                '4. 流程到档案室后带相关盖章的材料到亚厦中心A座档案室315室盖章，盖章完需填写纸质印章盖章登记表。',
                            ],
                        },
                    ],
                },
                {
                    sectionTitle:'档案移出',
                    wdithStyle:65,
                    data:[
                        {
                            title:'离职时本人证件移出需要走什么流程？',
                            yellowLineStyle:304,
                            data:[
                                '证件类、人事类及执业印章档案移出需要走如下流程：',
                                '1. 离职或挂靠移出由走流程人员去证书管理岗办理内部通知函申请流程；',
                                '2. 打印出单据后到315档案室办理移出，单据需本人确认签字，填写证书移出登记表。 ',
                                '3. 办理后，由档案室人员在OA上-亚厦综合管理-证书移除-添加移除证书。',
                            ],
                        },
                        {
                            title:'工程合同移出，需要走什么流程？',
                            yellowLineStyle:270,
                            data:[
                                '除内部通知函而移出的档案，其他档案移出/作废/长期借用等特列情况的需要走如下流程：',
                                '1. 借阅人员事先与档案室进行沟通',
                                '2. OA上发起借阅流程（由本人发起或由同事代发起），进入路径：OA-新流程中心-通用流程-行政管理-档案资料借阅异常处理申请单',
                                '3. 提交申请单至档案室',
                                '4. 流程批完后，至档案室315室签字确认。',
                            ],
                        },
                    ],
                },
                {
                    sectionTitle:'移交续借',
                    wdithStyle:65,
                    data:[
                        {
                            title:'移交需要走什么流程？',
                            yellowLineStyle:186,
                            data:[
                                '移交需要走如下流程：',
                                '1. 移交人员事先与档案室进行沟通移交事宜，确定档案是否需要移交，移交清单电子档发给档案室；',
                                '2. OA上发起移交流程（由本人发起或由同事代发起），进入路径：OA-新流程成中心-通用流程-行政管理-档案资料交接登记表',
                                '3. 提交档案资料交接登记表至档案室',
                                '4. 移交流程批完后，至档案室315室移交，移交清单+纸质文件+扫描件。',
                            ],
                        },
                        {
                            title:'续借需要走什么流程？',
                            yellowLineStyle:186,
                            itemStyle:3,
                            data:[
                                '借阅最长期限为1个月，超过一个月要走续借申请。',
                                '证件类续借：',
                                '1. 先走证书归还（路径：OA-证书管理系统-归还操作），备注一下是续借，写上原单号；',
                                '2. 档案室把归还申请审批通过后，再由申请人提交证书借用申请单（路径：OA-证书管理系统-借用申请），流程审批完后把流程单打印出来到档案室315室签字（新单据和原单据都要签字，签字后两张单据一起留存）。',
                                '除证件类档案续借：',
                                '1. 直接走档案资料借用申请单，备注续借和原单号（路径：OA-新流程成中心-通用流程-行政管理-档案资料借用申请单）；',
                                '2. 流程审批完后流程单打印出来到档案室315室签字（新单据和原单据都要签字，签字后两张单据一起留存）。',
                            ],
                        },
                    ],
                },
            ],
        };
        this.scrollBar();
    }
    scrollBar=()=>{
        let chose_index = this.props.navigation.getParam('index');
        this.timer = setTimeout(
            () => { 
                if(chose_index>=4 && chose_index<=5){
                    chose_index = 4;
                }else if (chose_index>=6){
                    chose_index = 5;
                }
                this.state.data.map((item,index)=>{
                    this.refs['btn'+String(index)].changeStyle('#666F83',false);
                });
                this.refs['btn'+String(chose_index)].changeStyle('#2F86F6',true);
                this.refs['sectionList'].scrollToLocation({itemIndex:0, sectionIndex:chose_index});
            },
            300
        );
    }
    componentWillUnmount() {    
        this.timer && clearTimeout(this.timer);
    }
    //点击箭头移动顶部scrollView
    onLeftBtnPress = ()=>{
        this.refs['scrollView'].scrollTo({x:0, y:0, animated: true});
    }
    onRightBtnPress = ()=>{
        this.refs['scrollView'].scrollToEnd({animated:false});
    }
    // 点击顶部按钮事件 证件营业执照 项目类 工程会计人事类 档案室职业类 档案移出 移交续借
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
        const offsetY = Math.floor(e.nativeEvent.contentOffset.y/420.0); //滑动距离
        this.changeTopBtnStyle(offsetY);
    }
    //动画停止滚动的时候
    onSectionnListMomentumScrollEnd =(e:Object)=>{
        const offsetY = Math.floor(e.nativeEvent.contentOffset.y/420.0); //滑动距离
        this.changeTopBtnStyle(offsetY);
    };

    changeTopBtnStyle=(offsetY)=>{
        console.log('不应该走这个方法的');
        if(offsetY>=0&&offsetY<=4){//sectionList滑动
            this.state.data.map((item,index)=>{
                this.refs['btn'+String(index)].changeStyle('#666F83',false);
            });
            this.refs['btn'+String(offsetY)].changeStyle('#2F86F6',true);
        }else if(offsetY===5){//档案移出
            this.state.data.map((item,index)=>{
                this.refs['btn'+String(index)].changeStyle('#666F83',false);
            });
            this.refs['btn4'].changeStyle('#2F86F6',true);
        }else if(offsetY>=6){
            this.state.data.map((item,index)=>{
                this.refs['btn'+String(index)].changeStyle('#666F83',false);
            });
            this.refs['btn5'].changeStyle('#2F86F6',true);
        }
        if(offsetY>=0&&offsetY<2){//处理scrollView
            this.refs['scrollView'].scrollTo({x:0, y:0, animated: false});
        }else if(offsetY===2){
            this.refs['scrollView'].scrollTo({x:100, y:0, animated: false});
        }else if(offsetY>=3){
            this.refs['scrollView'].scrollToEnd({animated:false});
        }
    }
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
        if(item.itemStyle===2){
            return(
                <View style={styles.detailViewStyle}>
                    <View style={styles.lineViewStyle}/>
                    <Text style={styles.detailTitleStyle}>{item.title}</Text>
                    <Text style={[styles.detailTitleStyle,{marginTop:5}]}>{item.subTitle}</Text>
                    <View style={[styles.lineViewStyle1,{width:item.yellowLineStyle}]}/>
                    <Text style={styles.detailContentStyle}>{item.data[0]}</Text>
                    <Text style={styles.detailContentStyle}>{item.data[1]}</Text>
                    <Text style={styles.detailContentStyle}>{item.data[2]}</Text>
                    <Text style={[styles.detailContentStyle, {marginTop:8,marginBottom:8}]}>{item.data[3]}</Text>
                </View>
            );
        }else if(item.itemStyle===3){
            return(
                <View style={styles.detailViewStyle}>
                        <View style={styles.lineViewStyle}/>
                        <Text style={styles.detailTitleStyle}>{item.title}</Text>
                        <View style={[styles.lineViewStyle1,{width:item.yellowLineStyle}]}/>
                        <Text style={styles.detailContentStyle}>{item.data[0]}</Text>
                        <Text style={[styles.detailContentStyle,{fontFamily:'PingFangSC-Medium'}]}>{item.data[1]}</Text>
                        <Text style={styles.detailContentStyle}>{item.data[2]}</Text>
                        <Text style={styles.detailContentStyle}>{item.data[3]}</Text>
                        <Text style={[styles.detailContentStyle,{fontFamily:'PingFangSC-Medium'}]}>{item.data[4]}</Text>
                        <Text style={styles.detailContentStyle}>{item.data[5]}</Text>
                        <Text style={[styles.detailContentStyle, {marginTop:8,marginBottom:8}]}>{item.data[6]}</Text>
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
        let chose_index = this.props.navigation.getParam('index');
        let btn_index = 0.0;
        let slatList_y = 0.0;
        //顶部按钮的处理 slatList初始位置
        if(chose_index===1){
            //slatList_y = 480.0;
        }else if(chose_index===2){
            //slatList_y = 1170.0;
            btn_index = 2;
        }else if(chose_index===3){
            //slatList_y = 1620.0;
            btn_index = 3;
        }else if(chose_index===4){
            //slatList_y = 2140.0;
            btn_index = 4;
        }else if(chose_index===5){
            //slatList_y = 2400.0;
            chose_index = 4;
            btn_index = 4;
        }else if (chose_index>=6){
            //slatList_y = 2800.0;
            chose_index = 5;
            btn_index = 5;
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
            wdithStyle:this.props.wdithStyle?this.props.wdithStyle:112,
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