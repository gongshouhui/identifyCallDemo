/**
*@Created by GZL on 2019/09/11 14:48:28.
*/

import React, {PureComponent, Component} from 'react';
import {Text, View, StyleSheet, Image, } from 'react-native';
import ShowCell from './YSShowCell';
import PCH from '../PrefixHeader';


export default class BusReservationVC extends PureComponent {
    static navigationOptions = ({navigation, navigationOptions}) => {
        return{
            title: navigation.getParam('title'),
        };
    };
    constructor(props) {
        super(props);
    }
    render() {
        const {navigation} = this.props;
        const title = navigation.getParam('title');
        return(
            <View style={styles.container}>
                <Text style={{color:'#8BB3F1',fontSize:12,marginTop:21}}>01</Text>
                <View style={styles.titleStyleView}>
                    <Image style={[styles.topImgStyle]} source={require('../WorkImgFolder/titleDivisionPoint.png')}/>
                    <Text style={{color:'#1768E4',fontSize:22, fontFamily:'PingFangSC-Semibold'}}>{title}</Text>
                    <Image style={[styles.topImgStyle]} source={require('../WorkImgFolder/titleDivisionPoint.png')}/>
                </View>
                <View style={{width:PCH.width, height:16, alignItems:'center',marginTop:7}}>
                    <Image source={require('../WorkImgFolder/titleTravelDown.png')} style={{width:16,height:16,}}/>
                </View>
                
                <ShowCell title={navigation.getParam('name')}
                          data={navigation.getParam('data')}
                          yellowLineStyle={PCH.scaleW*270}
                />
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
        height: 15*PCH.scaleW,
    },
    
});