/**
*@Created by GZL on 2019/09/29 11:07:59.
*/

'use strict';
import React, {PureComponent, Component} from 'react';
import {Text, View, StyleSheet, TouchableOpacity, Image, } from 'react-native';


export default class HotelCell extends PureComponent {

    constructor(props) {
        super(props);
    }
    render() {
        const {
            leftImg,title,subTitle,
            isFood,isMeet,hintMessage,remarkTitle1,remarkTitle2,
            price,phone,otherPhone
        }=this.props;
        return(
            <View style={styles.container}>
                <View style={styles.topBackViewStyle}>
                    <Image source={leftImg} style={styles.leftImg}/>
                    <View style={styles.rightBackStyle}>
                        <Text style={styles.titleStyle}>{title}</Text>
                        <Text style={styles.subTitleStyle}>{subTitle}</Text>
                        <View style={{flexDirection:'row',marginTop:2,}}>
                            <View style={[styles.remarkViewStyle,isFood&&{borderColor:'#FF6925'}]}>
                                <Text style={[styles.remarkTitleStyle,isFood&&{color:'#FF6925'}]}>{remarkTitle1}</Text>
                            </View>
                            <View style={[styles.remarkViewStyle,isMeet&&{borderColor:'#FF6925'},{marginLeft:4}]}>
                                <Text style={[styles.remarkTitleStyle,isMeet&&{color:'#FF6925'}]}>{remarkTitle2}</Text>
                            </View>
                        </View>
                        {hintMessage&&
                        <Text style={styles.hintMessageStyle}>{hintMessage}</Text>
                        }
                        <View style={styles.priceViewStyle}>
                            <Text style={{fontFamily:'PingFangSC-Regular',fontSize:14,color:'#F44745'}}>¥</Text>
                            <Text style={styles.priceStyle}>{price}</Text>
                        </View>
                    </View>
                </View>
                <View style={styles.bottomView}>
                    <View style={{width:4,height:4,borderRadius:4,backgroundColor:'#5DBAED',marginLeft:12,marginTop:6}}/>
                    <Text style={[styles.phoneStyle, !otherPhone&&{marginBottom:9}]}>{phone}</Text>
                    {otherPhone&&<Text style={[styles.phoneStyle, {marginBottom:9,marginLeft:90}]}>{otherPhone}</Text>}
                </View>
            </View>
        );
    }
}
const styles = StyleSheet.create({
    container:{
        backgroundColor:'#CEEEFD',
    },
    topBackViewStyle:{
        backgroundColor:'#FFFFFF',
        flexDirection:'row',
        alignItems:'center',
        paddingLeft:8,
        marginLeft:8,
        height:144,
        width:360*PCH.scaleW,
    },
    leftImgStyle:{
        width:98,
        height:128,
    },
    rightBackStyle:{
        marginLeft:19,
        width:236*PCH.scaleW,
    },
    titleStyle:{
        fontFamily:'PingFangSC-Medium',
        fontSize:16,
        color:'#000000',
        marginTop:7,
    },
    subTitleStyle:{
        fontFamily:'PingFangSC-Regular',
        fontSize:12,
        color:'rgba(0, 0, 0, 0.25)',
        marginTop:2,
    },
    remarkViewStyle:{
        borderStyle:'solid',
        borderColor:'rgba(102, 102, 102, 1)',
        borderWidth:1,
        width:38,
        height:16,
        borderRadius:2,
        marginTop:9,
        alignItems:'center',
    },
    remarkTitleStyle:{
        fontFamily:'PingFangSC-Regular',
        color:'rgba(102, 102, 102, 1)',
        fontSize:10,
    },
    hintMessageStyle:{
        fontSize:12,
        //fontFamily:'MicrosoftYaHeiUI',
        color:'#F44745',
        marginTop:8,
    },
    priceViewStyle:{
        flex:1,
        width:236*PCH.scaleW,
        flexDirection:'row',
        justifyContent:'flex-end',
        alignItems:'flex-end',
        paddingRight:8,
        paddingBottom:8,
    },
    priceStyle:{
        fontFamily:"PingFangSC-Semibold",
        fontSize:20,
        color:'#F44745',
    },
    bottomView:{
        flexDirection:'row',
        flexWrap:'wrap',
        width:360*PCH.scaleW,
        backgroundColor:'#F2FBFF',
        paddingTop:9,
        marginLeft:8,
    },
    phoneStyle:{
        //fontFamily:'MicrosoftYaHeiUI',
        fontSize:12,
        color:'#333333',
        marginLeft:12,
    },
});