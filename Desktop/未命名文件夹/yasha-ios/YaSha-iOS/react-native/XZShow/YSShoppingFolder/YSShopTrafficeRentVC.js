/**
*@Created by GZL on 2019/10/08 13:19:23.
*/

'use strict';
import React, {PureComponent, Component} from 'react';
import {Text, View, StyleSheet, TouchableOpacity, Image, ScrollView,ImageBackground,NativeModules} from 'react-native';

var YSModules = NativeModules.YSReactNativeModel

export default class TrafficeRentVC extends PureComponent {
    static navigationOptions = ({navigation, navigationOptions}) => {
        return{
            title: '租车专场'
        };
    };
    constructor(props) {
        super(props);
    }
    clickDetail= ()=> {
        YSModules.pushWebViewInfo('http://file.chinayasha.com/oa/2019/09/10/car.pdf','0');
    }
    render() {
        return(
            <View style={styles.container}>
                <ScrollView>
                    <TouchableOpacity onPress={this.clickDetail} activeOpacity={1}>
                        <ImageBackground source={require('../../WorkImgFolder/TracyRentBackImg.png')} style={styles.backImgStyle}>
                            <Image source={require('../../WorkImgFolder/rentBusDetailContent.png')} style={styles.contentImgStyle}/>
                                <Image source={require('../../WorkImgFolder/rentBusDown.png')} style={styles.downImgStyle}/>
                        </ImageBackground>
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
    backImgStyle:{
        width:'100%',
        height:732*PCH.scaleW,
        alignItems:'center',
    },
    contentImgStyle:{
        width:305,
        height:310,
        marginTop:382*PCH.scaleW,
    },
    downImgStyle:{
        width:260,
        height:58,
        marginTop:-90*PCH.scaleH,
    },
});