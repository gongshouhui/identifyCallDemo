/**
*@Created by GZL on 2019/09/25 09:44:18.
*/

'use strict';
import React, {PureComponent, Component} from 'react';
import {Text, View, StyleSheet, TouchableOpacity, Image, ImageBackground, } from 'react-native';


export default class MallTopTypeCell extends PureComponent {
    constructor(props) {
        super(props);
    }
    render() {
        const {
            imgName,rightTopImgName,title,subTitle,
            titleStyle,cellType,price,oldPrice,
            imgWidth,imgHeight,viewHeight,viewLeft,btnActiveOpacity,
        } = this.props;
        return(
            <View style={[viewLeft&&{marginLeft:viewLeft},]}>
                <TouchableOpacity activeOpacity={btnActiveOpacity?btnActiveOpacity:0.2}>
                    <ImageBackground style={[styles.backImgStyle,imgWidth&&{width:imgWidth},imgHeight&&{height:imgHeight}]} source={imgName} imageStyle={{borderBottomLeftRadius:4,borderBottomRightRadius:4,}}>
                        {rightTopImgName&&<Image source={rightTopImgName} style={{width:37,height:37,marginTop:11,marginRight:12}}/>}
                    </ImageBackground>
                    <View style={[styles.bottomViewStyle,viewHeight&&{height:viewHeight},imgWidth&&{width:imgWidth}]}>
                        <Text style={[titleStyle?titleStyle:styles.nameStyle, {marginTop:7}]}>{title}</Text>
                        <Text style={styles.subNameStyle}>{subTitle}</Text>
                        {cellType===1&&
                            <View style={[styles.priceViewStyle]}>
                                <Text style={[styles.type1RedPriceStyle,]}>¥</Text>
                                <Text style={[styles.type1RedPriceStyle,{fontSize:20,}]}>{price}</Text>
                                <Text style={[styles.type1RedPriceStyle,{color:'rgba(0, 0, 0, 0.25)',marginLeft:8,textDecorationLine:'line-through'}]}>{oldPrice}</Text>
                            </View>}
                            {cellType===2&&
                            <View style={[styles.price2ViewStyle]}>
                                <Text style={[styles.type1RedPriceStyle,{marginBottom:8}]}>
                                    ¥
                                    <Text style={[styles.type1RedPriceStyle,{fontSize:20,}]}>{price}</Text>
                                </Text>
                                <Text style={[styles.type1RedPriceStyle,{color:'rgba(0, 0, 0, 0.25)',textDecorationLine:'line-through'},]}>{oldPrice}</Text>
                            </View>}
                    </View>
                </TouchableOpacity>
            </View>
        );
    }
}
const styles = StyleSheet.create({
    backImgStyle:{
        width:254,
        height:254,
        flexDirection:'row',
        justifyContent:'flex-end',
        borderTopLeftRadius:4,
        borderTopRightRadius:4,
    },
    bottomViewStyle:{
        width:254,
        height:102,
        backgroundColor:'#FFFFFF',
        paddingLeft:10,
        borderBottomLeftRadius:4,
        borderBottomRightRadius:4,
    },
    nameStyle:{
        fontSize:16,
        fontFamily:'PingFangSC-Medium',
        color:'#000000',
        marginRight:10,
    },
    subNameStyle:{
        fontSize:12,
        fontFamily:'PingFangSC-Regular',
        color:'rgba(0, 0, 0, 0.25)',
    },
    priceViewStyle:{
        flex:1,
        flexDirection:'row',
        alignItems:'center',
    },
    type1RedPriceStyle:{
        color:'rgba(215, 70, 41, 1)',
        fontSize:12,
        fontFamily:'PingFangSC-Regular',
    },
    price2ViewStyle:{
        flex:1,
        flexDirection:'column-reverse',
    },
});

export class ShopMallOtherCell extends Component{
    render(){
        const {data,imgName,viewLeft} = this.props;
        const contentData = data.slice(0,data.length-1);
        const bottomContent = data[data.length-1];
        return(
            <View style={{marginLeft:viewLeft,}}>
                <ImageBackground source={imgName} style={{width:PCH.width-(viewLeft*2),height:200,flexDirection:'row',justifyContent:'flex-end',borderRadius:4,}} imageStyle={{borderRadius:4,}}>
                    <Image source={require('../../WorkImgFolder/mallReserveStar.png')} style={{width:37,height:37,marginTop:11,marginRight:12}} source={require('../../WorkImgFolder/mallReserveStar.png')}/>
                </ImageBackground>
                {contentData.map((item,index)=>{
                    return(
                        <View key={index}>
                            <View style={{width:PCH.width-(viewLeft*2),paddingLeft:10,backgroundColor:'white'}} key={index}>
                                <Text style={[styles.nameStyle,{marginTop:10}]}>{item.title}</Text>
                                <View style={[styles.priceViewStyle]}>
                                    <Text style={[styles.type1RedPriceStyle,]}>¥</Text>
                                    <Text style={[styles.type1RedPriceStyle,{fontSize:20,}]}>{item.price}</Text>
                                    <Text style={[styles.type1RedPriceStyle,{color:'rgba(0, 0, 0, 0.25)',marginLeft:8,textDecorationLine:'line-through'}]}>{item.oldPrice}</Text>
                                </View>
                            </View>
                            <View style={{width:'100%',height:1,backgroundColor:'#F2F2F2'}}/>
                        </View>
                    );})
                }
                <View style={{width:PCH.width-(viewLeft*2),paddingLeft:10,backgroundColor:'white'}}>
                    <Text style={[styles.nameStyle,{marginTop:10}]}>{bottomContent.title}</Text>
                    <View style={[styles.priceViewStyle]}>
                        <Text style={[styles.type1RedPriceStyle,]}>¥</Text>
                        <Text style={[styles.type1RedPriceStyle,{fontSize:20,}]}>{bottomContent.price}</Text>
                        <Text style={[styles.type1RedPriceStyle,{color:'rgba(0, 0, 0, 0.25)',marginLeft:8,textDecorationLine:'line-through'}]}>{bottomContent.oldPrice}</Text>
                    </View>
                </View>
                <View style={{width:PCH.width,height:5,backgroundColor:'#FDE4C9'}}/>
            </View>
        );
    }
}
