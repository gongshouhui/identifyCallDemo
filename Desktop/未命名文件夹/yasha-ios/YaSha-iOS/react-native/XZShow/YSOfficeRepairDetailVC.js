/**
*@Created by GZL on 2019/09/20 15:04:06.
*/

'use strict';
import React, {PureComponent, Component} from 'react';
import {Text, View, StyleSheet, TouchableOpacity, FlatList, ScrollView, Image,} from 'react-native';
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
            <TouchableOpacity onPress={this._onPress} style={{marginLeft:17,}}>
            <View style={{width:64*PCH.scaleW,alignItems:"center",height:43,}}>
                <Text style={[{color:textColor,fontFamily:'PingFangSC-Regular',fontSize:16,marginTop:10},textColor&&{color:textColor}]}>{title}</Text>
                <View style={[{width:64*PCH.scaleW,height:2,marginTop:9},isHidden&&textColor&&{backgroundColor:textColor},]}/>
            </View>
            </TouchableOpacity>
        );
    }
}

export default class OfficeRepairDetailVC extends PureComponent {
    static navigationOptions = ({navigation, navigationOptions}) => {
        return{
            title: '报修无忧'
        };
    };
    constructor(props) {
        super(props);
        this.state={
            data:[
                {
                    sectionTitle:'通讯',
                    title:'手机移动信号不好？',
                    yellowLineStyle:169*PCH.scaleW,
                    data:[
                        '公司已经全面覆盖移动网络信号，语音信号弱请开通移动4G高清语音通话功能，操作步骤请在亚厦门户搜索“移动4G信号及通话优化设置”。',
                        ' ',
                    ],
                },
                {
                    sectionTitle:'打印机',
                    title:'打印机坏了要找谁？',
                    yellowLineStyle:169*PCH.scaleW,
                    data:[
                        '请拨打信息部热线28208777，耗材更换可以拨打信息部热线，或者携带旧耗材前往A座8F行政管理部自行领取更换。',
                        ' ',
                    ],
                },
                {
                    sectionTitle:'钥匙',
                    title:'钥匙哪里借？',
                    yellowLineStyle:118*PCH.scaleW,
                    data:[
                        '1. 亚厦A座办公室钥匙可在行政管理部夏芬处借/领用；',
                        '2. 借/领用时需要出示工牌，登记表格；',
                        '3. 钥匙归还时，需要原钥匙交回，并登记表格；',
                        '4. 钥匙遗失时，需通知行政管理部，并对整套锁芯及钥匙做赔偿。',
                    ],
                },
                {
                    sectionTitle:'电路',
                    title:'工位跳闸要找谁？',
                    yellowLineStyle:152*PCH.scaleW,
                    data:[
                        '请联系物业处理，联系电话：28208090。',
                        ' ',
                    ],
                },
                {
                    sectionTitle:'桌椅',
                    title:'办公柜门打不开找谁？',
                    yellowLineStyle:186*PCH.scaleW,
                    data:[
                        '请联系行政管理部葛品裕处理，',
                        '联系电话：13757192324。',
                    ],
                },
                {
                    sectionTitle:'网络',
                    title:'电脑网络不行怎么办？',
                    yellowLineStyle:186*PCH.scaleW,
                    data:[
                        '请联系信息部，IT热线：28208777（998777）',
                        ' ',
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
                this.refs['flatList'].scrollToIndex({ viewPosition: 0, index:chose_index});
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

    //点击顶部//'通讯', '打印机', '钥匙', '电路', '桌椅', '网络',
    onBtnPress = (title)=>{
        const indexPath_section = this.state.data.map(item=>item.sectionTitle).indexOf(title);
        //顶部scrollVIew的偏移
        if(indexPath_section<=2){
            this.refs['scrollView'].scrollTo({x:0, y:0, animated: false});
        }else if(indexPath_section>=3){
            this.refs['scrollView'].scrollToEnd({animated:false});
        }
        this.state.data.map((item,index)=>{
            this.refs['btn'+String(index)].changeStyle('#666F83',false);
        });
        this.refs['btn'+String(indexPath_section)].changeStyle('#2F86F6',true);
        this.refs['flatList'].scrollToIndex({ viewPosition: 0, index:indexPath_section});
        
        
    }
    //cell
    _renderItem = (item, index)=>{
        const section = this.state.data.map(o=>o.sectionTitle).indexOf(item.sectionTitle)
        return(
            <DetailCell title={item.title}
                        data={item.data}
                        viewStyle={15}
                        index={index}
                        section={section}
                        sectionTitle={item.sectionTitle}
                        yellowLineStyle={item.yellowLineStyle} 
                />
        );
    };
    //手指停止拖动界面
    onFlastListScrollEndDrag = (e:Object)=>{
        const offsetY = Math.floor(e.nativeEvent.contentOffset.y/264.0); //滑动距离
        if(offsetY>=0&&offsetY<=3){//flastList滑动
            this.state.data.map((item,index)=>{
                this.refs['btn'+String(index)].changeStyle('#666F83',false);
            });
            this.refs['btn'+String(offsetY)].changeStyle('#2F86F6',true);
        }
        if(offsetY===0){//处理scrollView
            this.refs['scrollView'].scrollTo({x:0, y:0, animated: false});
        }else if(offsetY>=3){
            this.refs['scrollView'].scrollToEnd({animated:false});
        }
    }
    //动画停止滚动的时候
    onFlastListMomentumScrollEnd =(e:Object)=>{
        const offsetY = Math.floor(e.nativeEvent.contentOffset.y/264.0); //滑动距离
        if(offsetY>=0&&offsetY<=3){//flastList滑动
            this.state.data.map((item,index)=>{
                this.refs['btn'+String(index)].changeStyle('#666F83',false);
            });
            this.refs['btn'+String(offsetY)].changeStyle('#2F86F6',true);
        }
        if(offsetY===0){//处理scrollView
            this.refs['scrollView'].scrollTo({x:0, y:0, animated: false});
        }else if(offsetY>=3){
            this.refs['scrollView'].scrollToEnd({animated:false});
        }
    };
    render() {
        const {data} = this.state;
        const chose_index = this.props.navigation.getParam('index');
        let scrollView_x = 0.0;
        let flatList_y = 0.0;
        if(chose_index>=3){//顶部按钮处理
            scrollView_x=2;
        }
        if (chose_index>=3){
            flatList_y=3;
        }else {
            flatList_y = chose_index;
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
                                contentOffset={{x:scrollView_x*64,y:0}}
                                >
                        {data.map((item,index)=>{
                            return(
                                <BtnView  ref={'btn'+String(index)}
                                          title={item.sectionTitle}
                                          onBtnPress={this.onBtnPress}
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
                <FlatList data={data}
                          renderItem={({item,index})=>this._renderItem(item, index)}
                          keyExtractor={(item, index)=> String(index)}
                          ItemSeparatorComponent={()=>{return(<View style={{width:PCH.width,height:20,backgroundColor:'#F3F8FF'}}/>)}}
                          ref='flatList'
                          //contentOffset={{x:0.0,y:flatList_y*284}}
                          onScrollEndDrag={this.onFlastListScrollEndDrag}//用户停止拖动界面
                          onMomentumScrollEnd={this.onFlastListMomentumScrollEnd}//滚动动画停止
                />
            </View>
        );
    }
}
const styles = StyleSheet.create({
    container:{
        flex:1,
    },
    topBtnViewStyle:{
        backgroundColor:'white',
        width:PCH.width,
        height:43,
        flexDirection:'row',
        alignItems:'center'
    },
});