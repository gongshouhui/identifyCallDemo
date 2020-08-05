/**
*@Created by GZL on 2019/12/10 11:04:20.
*/

'use strict';
import React, {PureComponent, Component} from 'react';
import {
    Text, View, StyleSheet,
    TouchableOpacity, Image, ScrollView,
} from 'react-native';


export default class ShopMedicalHomeVC extends PureComponent {
    static navigationOptions = ({navigation, navigationOptions}) => {
        return{
            title: '医疗'
        };
    };
    constructor(props) {
        super(props);
    }
    render() {
        return(
            <View style={styles.container}>
                <ScrollView>
                <Image source={require('../../WorkImgFolder/MedicalHomeAWKQ01.png')} style={{width:'100%',height:512*PCH.scaleW}}/>
                <Image source={require('../../WorkImgFolder/MedicalHomeAWKQ02.png')} style={{width:'100%',height:400*PCH.scaleW}}/>
                <Image source={require('../../WorkImgFolder/MedicalHomeAWKQ03.png')} style={{width:'100%',height:568*PCH.scaleW}}/>
                </ScrollView> 
            </View>
        );
    }
}
const styles = StyleSheet.create({
    container:{
        flex:1,
    },
});