/**
*@Created by GZL on 2019/09/29 09:33:44.
*/

'use strict';
import React, {PureComponent, Component} from 'react';
import {Text, View, StyleSheet, ImageBackground, Image, } from 'react-native';


export default class FoodMenuVC extends PureComponent {
    static navigationOptions = ({navigation, navigationOptions}) => {
        return{
            title: '每周菜单'
        };
    };
    render() {
        return(
            <View style={styles.container}>
                <Image source={require('../../WorkImgFolder/hallQRcode.png')} style={{width:178*PCH.scaleW,height:178*PCH.scaleH,marginTop:65*PCH.scaleH}}/>
                <View style={styles.middleTextViewStyle}>
                    <View style={styles.lineView}/>
                    <Text style={{color:'#333333',fontFamily:"PingFangSC-Light",fontSize:15}}>微信关注</Text>
                    <View style={styles.lineView}/>
                </View>
                <Text style={{color:'#333333',fontFamily:"PingFangSC-Semibold",fontSize:15,marginTop:8*PCH.scaleH}}>「礼信年年亚厦餐厅」公众号</Text>
                <Text style={{color:'#999999',fontFamily:'PingFangSC-Regular',fontSize:12,marginTop:8*PCH.scaleH}}>及时获取餐厅每周菜单</Text>
                <View style={{flex:1,justifyContent:'flex-end',flexDirection:'row'}}>
                    <ImageBackground style={styles.backImgStyle} source={require('../../WorkImgFolder/hallQRcodeBottomImg.png')}>
                        <Image source={require('../../WorkImgFolder/hallQRcodeBottomLogo.png')} style={{width:178,height:20,marginTop:17}}/>
                    </ImageBackground>
                </View>
            </View>
        );
    }
}
const styles = StyleSheet.create({
    container:{
        flex:1,
        backgroundColor:'rgba(251, 246, 240, 1)',
        alignItems:'center',
    },
    middleTextViewStyle:{
        width:200,
        flexDirection:'row',
        alignItems:'center',
        justifyContent:'space-between',
        marginTop:32,
    },
    lineView:{
        width:50,
        height:2,
        backgroundColor:'rgba(51, 51, 51, 1)',
    },
    backImgStyle:{
        width:'100%',
        height:265*PCH.scaleH,
        alignItems:'center',
        marginBottom:0,
    },
});