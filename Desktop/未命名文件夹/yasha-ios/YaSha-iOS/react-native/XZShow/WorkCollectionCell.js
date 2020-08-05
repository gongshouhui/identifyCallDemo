/**
*@Created by GZL on 2019/08/22 16:56:01.
*/

import React, {PureComponent, Component} from 'react';
import {Text, View, StyleSheet,TouchableOpacity, Image, } from 'react-native';
import PCH from '../PrefixHeader';


export default class WorkCollectionCell  extends PureComponent {
    _onPress = () => {
        this.props.onPressItem(this.props.index, this.props.title);
    };
    render() {
        return(
            <TouchableOpacity onPress={this._onPress}
            >
                <View style={styles.container}>
                    <Image style={styles.imgStyle}
                           source={this.props.imgName}
                    />
                    <Text style={styles.titleStyle}>{this.props.title}</Text>
                </View>
            </TouchableOpacity>
        );
    }
}
const styles=StyleSheet.create({
    container:{
        width: PCH.width/4,
        height: 85,
        flexDirection: 'column',
        alignItems: 'center',
        //backgroundColor:'red',
    },
    imgStyle:{
        width:33,
        height:33,
        marginTop:10,
    },
    titleStyle:{
        fontFamily:'PingFangSC-Regular',
        marginTop:7,
        color:'#030303',
        fontSize:12,
    },
});


