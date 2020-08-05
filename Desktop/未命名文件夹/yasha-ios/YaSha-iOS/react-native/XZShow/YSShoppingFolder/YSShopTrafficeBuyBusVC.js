/**
*@Created by GZL on 2019/10/08 13:41:45.
*/

'use strict';
import React, {PureComponent, Component} from 'react';
import {Text, View, StyleSheet, TouchableOpacity, Image, ScrollView,ImageBackground,} from 'react-native';


export default class TrafficeBuyBusVC extends PureComponent {
    static navigationOptions = ({navigation, navigationOptions}) => {
        return{
            title: '购车专场'
        };
    };
    constructor(props) {
        super(props);
    }
    render() {
        return(
            <View style={styles.container}>
                <ScrollView>
                    <Image source={require('../../WorkImgFolder/buyBusDetail.png')} style={styles.topImgStyle}/>
                </ScrollView>
            </View>
        );
    }
}
const styles = StyleSheet.create({
    container:{
        flex:1,
    },
    topImgStyle:{
        width:'100%',
        height:1700*PCH.scaleW,
    },
});