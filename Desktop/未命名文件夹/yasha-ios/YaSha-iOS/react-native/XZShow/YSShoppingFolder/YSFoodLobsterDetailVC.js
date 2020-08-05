/**
*@Created by GZL on 2019/09/30 11:21:53.
*/

'use strict';
import React, {PureComponent, Component} from 'react';
import {NativeModules, View, StyleSheet, ScrollView, Image, TouchableOpacity, } from 'react-native';

var YSModules = NativeModules.YSReactNativeModel
export default class LobsterDetailVC extends PureComponent {
    static navigationOptions = ({navigation, navigationOptions}) => {
        return{
            title: navigation.getParam('title'),
        };
    };
    constructor(props){
        super(props);
        this.state={
            index:this.props.navigation.getParam('index'),
        };
    }
    MiddAutumnSpecial=()=>{
        if(this.state.index===1){
            YSModules.pushWebViewInfo('http://file.chinayasha.com/oa/2019/09/10/mouth.pdf','0')
        }
    }
    render() {
        const {index} = this.state;
        let imgName = require('../../WorkImgFolder/lobsterDetail.jpg');
        if(index===1){
            imgName=require('../../WorkImgFolder/MiddAutumnSpecial.png');
        }
        console.log(index);
        return(
            <View style={styles.container}>
                <ScrollView style={styles.container} automaticallyAdjustContentInsets={false}>
                    <TouchableOpacity onPress={this.MiddAutumnSpecial} activeOpacity={1}>
                    <Image source={imgName} style={[styles.imgStyle,index===1&&{height:811*PCH.scaleH}]}/>
                    </TouchableOpacity>
                </ScrollView>
            </View>
        );
    }
}
const styles = StyleSheet.create({
    container:{
        flex:1,
    },
    imgStyle:{
        width:'100%',
        height:733*PCH.scaleW,
        resizeMode:'stretch',
        justifyContent:'flex-end',
        alignItems:'center',
    },
});