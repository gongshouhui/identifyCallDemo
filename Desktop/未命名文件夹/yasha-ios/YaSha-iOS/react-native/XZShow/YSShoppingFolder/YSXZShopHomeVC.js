/**
*@Created by GZL on 2019/09/24 14:01:15.
*/

'use strict';
import React, {PureComponent, Component} from 'react';
import {Text, View, StyleSheet, TouchableOpacity, Image, ScrollView, ImageBackground, } from 'react-native';


export default class ShopHomeVC extends PureComponent {
    static navigationOptions = ({navigation, navigationOptions}) => {
        return{
            title: '欢乐购',
        };
    };
    constructor(props) {
        super(props);
        this.state={
            leftData:[
                {
                    imgName:require('../../WorkImgFolder/shopMall.png'),
                    title:'商城',
                    imgStyle:{width:168*PCH.scaleW,height:168*PCH.scaleW,},
                },
                {
                    imgName:require('../../WorkImgFolder/shopTraffice.png'),
                    title:'交通',
                    imgStyle:{width:168*PCH.scaleW,height:69*PCH.scaleW,},
                },
                {
                    imgName:require('../../WorkImgFolder/medicalHallHo.png'),
                    title:'医疗',
                    imgStyle:{width:168*PCH.scaleW,height:168*PCH.scaleW,},
                },
                {
                    imgName:require('../../WorkImgFolder/shopHomeDecoration.png'),
                    title:'家装',
                    isPlaseholder:true,
                    imgStyle:{width:168*PCH.scaleW,height:168*PCH.scaleW,},
                },
            ],
            rightData:[
                {
                    imgName:require('../../WorkImgFolder/shopFood.png'),
                    title:'餐饮',
                    imgStyle:{width:168*PCH.scaleW,height:69*PCH.scaleW,},
                },
                {
                    imgName:require('../../WorkImgFolder/shopHotel.png'),
                    title:'酒店',
                    imgStyle:{width:168*PCH.scaleW,height:168*PCH.scaleW,},
                },
                {
                    imgName:require('../../WorkImgFolder/shopEducation.png'),
                    title:'教育',
                    isPlaseholder:true,
                    imgStyle:{width:168*PCH.scaleW,height:69*PCH.scaleW,},
                },
                {
                    imgName:require('../../WorkImgFolder/shopProHotel.png'),
                    title:'旅社',
                    isPlaseholder:true,
                    imgStyle:{width:168*PCH.scaleW,height:168*PCH.scaleW,},
                },
                {
                    imgName:require('../../WorkImgFolder/shopMessage.png'),
                    title:'通讯',
                    isPlaseholder:true,
                    imgStyle:{width:168*PCH.scaleW,height:69*PCH.scaleW,},
                },
            ],
        };
    }

    // 点击
    onPressItem=(title)=>{
        if(title==='商城'){
            this.props.navigation.push('MallListVC');
        }else if (title==='酒店'){
            this.props.navigation.push('ShopHotelVC');
        }else if(title==='餐饮'){
            this.props.navigation.push('ShopFoodHome');
        }else if(title==='交通'){
            this.props.navigation.push('ShopTrafficHomeVC');
        }else if(title==='医疗'){
            this.props.navigation.push('ShopMedicalHomeVC');
        }
    };
    render() {//shopHomeBackImg
        const {leftData, rightData} = this.state;
        return(
            <View style={styles.container}>
                <ScrollView style={styles.scrollViewStyle}>
                    <Image source={require('../../WorkImgFolder/shopHomeBackImgTop.png')} style={styles.backTopImgStyle}/>
                    <ImageBackground source={require('../../WorkImgFolder/shopHomeBackImgUnder.png')} style={styles.backImgStyle}>
                        <View style={styles.leftBackViewStyle}>
                            {leftData.map((item,index)=>{
                                return(
                                    <ItemCell title={item.title}
                                              onPressItem={this.onPressItem}
                                              imgName={item.imgName}
                                              isPlaseholder={item.isPlaseholder}
                                              imgStyle={item.imgStyle}
                                              key={index}
                                              index={index}
                                    />
                                );
                            })}
                        </View>
                        <View style={styles.rightBackViewStyle}>
                            {rightData.map((item,index)=>{
                                return(
                                    <ItemCell title={item.title}
                                              onPressItem={this.onPressItem}
                                              imgName={item.imgName}
                                              isPlaseholder={item.isPlaseholder}
                                              imgStyle={item.imgStyle}
                                              key={index}
                                              index={index}
                                    />
                                );
                            })}
                        </View>
                    </ImageBackground>
                </ScrollView>
            </View>
        );
    }
}
const styles = StyleSheet.create({
    container:{
        flex:1,
    },
    scrollViewStyle:{
        flex:1,
    },
    backTopImgStyle:{
        width:'100%',
        height:156*PCH.scaleW,
    },
    backImgStyle:{
        width:'100%',
        height:820*PCH.scaleW,
        // resizeMode:'stretch',
        flexDirection:'row',
        paddingTop:10*PCH.scaleH,
    },
    leftBackViewStyle:{
        width:'50%',
        height:640*PCH.scaleH,
        // marginTop:171*PCH.scaleH,
        //alignItems:'center',
        paddingLeft:(PCH.width-(168*PCH.scaleW*2))/3,
        //backgroundColor:'red',
    },
    rightBackViewStyle:{
        width:'50%',
        height:640*PCH.scaleH,
        // alignItems:'center',
        paddingLeft:(PCH.width-(168*PCH.scaleW*2))/6,
        //backgroundColor:'blue',
        // marginTop:171*PCH.scaleH,
    },
    itemTitleStyle:{
        fontFamily:'PingFangSC-Semibold',
        fontSize:16,
        color:'#4C4A4A',
    },
    placeHolderStyle:{
        fontSize:16,
        fontFamily:'PingFangSC-Medium',
        color:'rgba(255, 255, 255, 1)',
    },
});


class ItemCell extends Component {
    onPressItem = ()=>{
        this.props.onPressItem(this.props.title);
    }

    render(){
        const {imgStyle, title, imgName, isPlaseholder, index}=this.props;
        return(
            <View>
                <TouchableOpacity onPress={this.onPressItem}>
                    <ImageBackground source={imgName} style={[imgStyle,index!=0&&{marginTop:(PCH.width-(168*PCH.scaleW*2))/3}]}>
                        {isPlaseholder&&
                            <View style={[imgStyle,{backgroundColor:'rgba(0, 0, 0, 0.3)',alignItems:'center',justifyContent:'center'}]}>
                                <Text style={styles.placeHolderStyle}>频道建设中</Text>
                                <Text style={[styles.placeHolderStyle,{fontFamily:'PingFangSC-Light'}]}>敬请期待</Text>
                            </View>
                        }
                    </ImageBackground>
                    <View style={{backgroundColor:'white',width:168*PCH.scaleW,height:32*PCH.scaleH,alignItems:'center',justifyContent:'center'}}>
                        <Text style={styles.itemTitleStyle}>{title}</Text>
                    </View>
                </TouchableOpacity>
            </View>
        );
    }

}


