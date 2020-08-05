/**
*@Created by GZL on 2019/09/12 15:22:07.
*/

import React, {PureComponent, Component} from 'react';
import {Text, View, StyleSheet, TouchableOpacity, FlatList, Image,NativeModules} from 'react-native';
import RegularShowCell from './YSShowRegularCell';
import ShowCell from './YSShowCell';

var YSModules = NativeModules.YSReactNativeModel

//亚厦班车 与 12F会议室及用餐
export default class RegularBusVC extends PureComponent {
    static navigationOptions = ({navigation, navigationOptions}) => {
        return{
            title: navigation.getParam('title'),
        };
    };
    constructor(props) {
        super(props);
        if(this.props.navigation.getParam('title')==='亚厦班车'){
            this.state={
                data:[
                    [
                        '1、在OA系统中发起班车乘坐及取消申请流程，审批通过后至车辆管理员处领取或退还乘车证；',
                        '2、进入路径：OA门户—通用流程—行政管理—班车乘坐及取消申请流程。',
                    ],
                    [
                        '班车详情参见附件: ',
                        ' ',
                    ]
                ],
            };
        }else if (this.props.navigation.getParam('title')==='12F会议室及用餐'){
            this.state={
                data:[
                    {
                        sectionTitle:'如何预定12F会议室？',
                        yellowLineStyle:180*PCH.scaleW,
                        data:[
                            '12楼会所只限客户接待，不接受内部预定，客户接待预定会议室需要走如下流程：',
                            '1. 先与相关对接人员确定好会议人数、时间、来访客户，行程安排，会议特殊要求等相关事宜；',
                            '2. OA上发起会所使用流程（由本人或本部门同事代发），进入路径：OA-新流程中心-通用流程-行政管理-会所使用申请流程（如需要商务接待协助的，请走商务接待申请使用流程）；',
                            '3. 流程发起后，线下与会所主管再次进行最后确认。',
                        ],
                    },
                    {
                        sectionTitle:'12F会所预定包厢需要走什么流程？',
                        yellowLineStyle:282*PCH.scaleW,
                        data:[
                            '12楼会所只限客户接待，不接受内部预定，客户接待预定包厢需要走如下流程',
                            '1. 先与相关对接人员确定好用餐人数、时间、来访客户，行程安排，用餐特殊要求等相关事宜；',
                            '2. OA上发起会所使用流程（由本人或本部门同事代发），进入路径：OA-新流程中心-通用流程-行政管理-会所使用申请流程（如需要商务接待协助的，请走商务接待申请使用流程）；',
                            '3. 流程发起后，线下与会所主管再次进行最后确认。',
                        ],
                    },
                    {
                        sectionTitle:'请客户在外用餐，可否在会所申领酒水？',
                        yellowLineStyle:321*PCH.scaleW,
                        data:[
                            '会所的酒水只限12楼使用，如需外带，请去仓管李炜处申领。',
                            ' ',
                        ],
                    },
                ],
            };
        }
        
    }
    headerView = ()=> {
        const title = this.props.navigation.getParam('title');
        let width_pointImg = 69*PCH.scaleW;
        if(title==='12F会议室及用餐'){
            width_pointImg = 69*PCH.scaleW;
        }
        return(
            <View style={styles.headerViewStyle}>
                <Text style={{color:'#8BB3F1',fontSize:12,marginTop:21}}>01</Text>
                <View style={styles.titleStyleView}>
                    <Image style={[styles.topImgStyle,{width:width_pointImg}]} source={require('../WorkImgFolder/titleDivisionPoint.png')}/>
                    <Text style={{color:'#1768E4',fontSize:22, fontFamily:'PingFangSC-Semibold'}}>{title}</Text>
                    <Image style={[styles.topImgStyle,{width:width_pointImg}]} source={require('../WorkImgFolder/titleDivisionPoint.png')}/>
                </View>
                <View style={{width:PCH.width, height:16, alignItems:'center',marginTop:7}}>
                    <Image source={require('../WorkImgFolder/titleTravelDown.png')} style={{width:16,height:16,}}/>
                </View>
            </View>
        );
    };
    _renderItem = (item, index) => {
        if(this.props.navigation.getParam('title')==='亚厦班车'){
            if(index===0){
                return(
                    <ShowCell title={'班车乘坐、取消需要什么流程？'}
                              data={item}
                              viewStyle={15}
                              index={index}
                              yellowLineStyle={PCH.scaleW*253} 
                    />
                );
            }else if (index===1){
                return(
                    <ShowCell title={'班车有几条路线？班车乘坐的时间？'}
                              data={item}
                              viewStyle={15}
                              index={index}
                              downImg={true}
                              onClickCellBtn={this.downImgPress}
                              yellowLineStyle={PCH.scaleW*253} 
                    />
                    // <RegularShowCell data={item}
                    //                  title='班车有几条路线？班车乘坐的时间？'
                    //                  sectionStyle={'PingFangSC-Medium'}
                    //                  index={index}
                    //                  yellowLineStyle={PCH.scaleW*287}
                    // />
                    );
            }
        }else if(this.props.navigation.getParam('title')==='12F会议室及用餐'){
            return(<ShowCell title={item.sectionTitle}
                      data={item.data}
                      viewStyle={15}
                      index={index}
                      yellowLineStyle={item.yellowLineStyle} 
                    />);
        }
        
    };

    // 数据下载
    downImgPress=()=>{
        YSModules.pushWebViewInfo('https://dfs.chinayasha.com/group2/M00/07/49/CgoPiF8D6bCANT9WAAGXxooyHqw760.pdf','1')
    }
    render() {
        const {data} = this.state;
        const index = this.props.navigation.getParam('index');
        let flatList_y = 0.0;
        if(this.props.navigation.getParam('title')==='12F会议室及用餐'&&index===2){
            flatList_y = 300.0;
        }
        return(
            <View style={styles.container}>
                <FlatList data={data}
                          renderItem={({item,index})=>this._renderItem(item, index)}
                          keyExtractor={(item, index)=> String(index)}
                          ListHeaderComponent = {()=> this.headerView()}//头部组件
                          ItemSeparatorComponent={()=>{return(<View style={{width:PCH.width,height:10,backgroundColor:'#F3F8FF'}}/>)}}
                          contentOffset={{x:0,y:flatList_y}}
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
        resizeMode:'contain',
    },
});