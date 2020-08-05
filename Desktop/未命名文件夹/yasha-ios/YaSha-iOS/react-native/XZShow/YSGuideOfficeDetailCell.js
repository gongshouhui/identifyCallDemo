/**
*@Created by GZL on 2019/09/19 10:16:25.
*/

'use strict';
import React, {PureComponent, Component} from 'react';
import {Text, View, StyleSheet, Image, } from 'react-native';
import PCH from '../PrefixHeader';


export default class OfficeDetailCell extends PureComponent {
    render() {
        //数据,文字详情标题(蓝色问题),白色背景的便宜度,黄线的长度,文字详情的副标题,分区数,大分区标题
        const {data, title, viewStyle, yellowLineStyle,subTitle,section,sectionTitle,} = this.props;
        const bottomContent = data[data.length-1];//文字详情的最后一行
        const dataContent = data.slice(0, data.length-1);
        return(
            <View>
                {/*带点的分割头部*/}
                <View style={styles.headerViewStyle}>
                    <Text style={{color:'#8BB3F1',fontSize:12,marginTop:21}}>{'0'+String(section+1)}</Text>
                    <View style={styles.titleStyleView}>
                        <Image style={[styles.topImgStyle]} source={require('../WorkImgFolder/titleDivisionPoint.png')}/>
                        <Text style={{color:'#1768E4',fontSize:22, fontFamily:'PingFangSC-Semibold'}}>{sectionTitle}</Text>
                        <Image style={[styles.topImgStyle]} source={require('../WorkImgFolder/titleDivisionPoint.png')}/>
                    </View>
                </View>
                <View style={{width:PCH.width, height:16, alignItems:'center',marginTop:7}}>
                    <Image source={require('../WorkImgFolder/titleTravelDown.png')} style={{width:16,height:16,}}/>
                </View>
                {/*文字详情*/}
                <View style={[styles.detailViewStyle, viewStyle&&{marginLeft:viewStyle}]}>
                    <View style={styles.lineViewStyle}/>
                    <Text style={styles.detailTitleStyle}>{title}</Text>
                    <View style={[styles.lineViewStyle1,yellowLineStyle&&{width:yellowLineStyle}]}/>
                    {subTitle&&<Text style={[styles.detailContentStyle,{fontFamily:'PingFangSC-Semibold'}]}>{subTitle}</Text>}
                    {dataContent.map((info,index)=>{
                        return (
                        <Text style={[styles.detailContentStyle, {fontFamily:'PingFangSC-Regular'}]} key={index}>{info}</Text>
                        );
                    })}
                    <Text style={[styles.detailContentStyle, {marginBottom:8,fontFamily:'PingFangSC-Regular'}]}>{bottomContent}</Text>
                </View>
            </View>
        );
    }
}
const styles = StyleSheet.create({
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
    detailViewStyle:{//流程白色背景图
        width: PCH.scaleW*345,
        backgroundColor: '#FFFFFF',
        borderRadius: 4,
        marginTop:7,
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
        marginTop: 20,
        marginLeft: 10,
        fontFamily:'PingFangSC-Semibold',
    },
    lineViewStyle1: {//黄线
        marginLeft: 10,
        marginTop: -8,
        width: PCH.scaleW*186,
        height: 8*PCH.scaleH,
        backgroundColor: 'rgba(247, 181, 0, 0.3)',
        borderRadius: 4,
    },
    detailContentStyle:{
        marginTop: 8,
        marginRight: 10,
        marginLeft: 10,
        color: '#333333',
        fontSize: 14,
        lineHeight:28,//行间距
    },
});