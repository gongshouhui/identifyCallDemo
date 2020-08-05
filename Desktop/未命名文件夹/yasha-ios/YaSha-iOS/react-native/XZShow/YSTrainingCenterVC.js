/**
*@Created by GZL on 2019/09/20 11:22:42.
*/

'use strict';
import React, {PureComponent, Component} from 'react';
import {Text, View, StyleSheet, TouchableOpacity, Image, } from 'react-native';


export default class  TrainingCenterVC extends PureComponent {//常规会议室/培训中心
    static navigationOptions = ({navigation, navigationOptions}) => {
        return{
            title: '常规会议室/培训中心'
        };
    };
    constructor(props) {
        super(props);
    }
    render() {
        return(
            <View style={styles.container}>
                <Text style={{color:'#8BB3F1',fontSize:12,marginTop:21*PCH.scaleH}}>01</Text>
                <View style={styles.titleStyleView}>
                    <Image style={[styles.topImgStyle]} source={require('../WorkImgFolder/titleDivisionPoint.png')}/>
                    <Text style={{color:'#1768E4',fontSize:22, fontFamily:'PingFangSC-Semibold'}}>常规会议室/培训中心</Text>
                    <Image style={[styles.topImgStyle]} source={require('../WorkImgFolder/titleDivisionPoint.png')}/>
                </View>
                <View style={{width:PCH.width, height:16, alignItems:'center',marginTop:7*PCH.scaleH}}>
                    <Image source={require('../WorkImgFolder/titleTravelDown.png')} style={{width:16*PCH.scaleW,height:16*PCH.scaleH,}}/>
                </View>
                <View style={styles.detailViewStyle}>
                    <View style={styles.lineViewStyle}/>
                    <Text style={styles.detailTitleStyle}>5F-11F会议室及培训中心</Text>
                    <Text style={[styles.detailTitleStyle,{marginTop:5}]}>如何预订/取消？</Text>
                    <View style={styles.lineViewStyle1}/>
                    <Text style={styles.detailContentStyle}>1. OA门户--常用系统--会议室管理--选择对应会议室及日期所在方框--点击右下角“+”--选择对应时间段；</Text>
                    <Text style={styles.detailContentStyle}>2. OA门户--常用系统--会议室管理--右上角“我的申请”--选择需要取消的会议预订--点击“终止”； </Text>
                    <Text style={[styles.detailContentStyle, {marginTop:8,marginBottom:8}]}>3. 会议室转换头、线请至行政管理部夏芬处登记借用。</Text>
                </View>
            </View>
        );
    }
}
const styles = StyleSheet.create({
    container:{
        flex: 1,
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
        height: 15*PCH.scaleH,
    },
    detailViewStyle:{//流程白色背景图
        width: PCH.scaleW*345,
        //height: 177*PCH.scaleH,//为了让他被内容撑开
        backgroundColor: '#FFFFFF',
        borderRadius: 4,
        marginTop:7*PCH.scaleH,
        //borderTopRightRadius
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
        fontFamily:'PingFangSC-Semibold',
        marginTop: 20*PCH.scaleH,
        marginLeft: 10*PCH.scaleW,
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
        lineHeight:28,//行间距
    },
});