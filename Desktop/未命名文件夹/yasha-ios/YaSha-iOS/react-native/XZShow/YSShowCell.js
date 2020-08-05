/**
*@Created by GZL on 2019/09/12 10:08:49.
*/

import React, {PureComponent, Component} from 'react';
import {Text, View, StyleSheet, TouchableOpacity, Image} from 'react-native';
import PCH from '../PrefixHeader';



export default class ShowCell extends Component {
    downImgTimePress = ()=>{
        if(this.props.downImg) {
            this.props.onClickCellBtn();
        }
    }
    render() {
        const {data, title, viewStyle, yellowLineStyle,downImg} = this.props;
        const bottomContent = data[data.length-1];
        const dataContent = data.slice(0, data.length-1);
        return(
            <View style={[styles.detailViewStyle, viewStyle&&{marginLeft:viewStyle}]}>
                    <View style={styles.lineViewStyle}/>
                    <Text style={styles.detailTitleStyle}>{title}</Text>
                    <View style={[styles.lineViewStyle1,yellowLineStyle&&{width:yellowLineStyle}]}/>
                    {dataContent.map((info,index)=>{
                        return (
                        <Text style={styles.detailContentStyle} key={index}>{info}</Text>
                        );
                    })}
                    {downImg&&
                    <TouchableOpacity onPress={this.downImgTimePress}>
                        <Image source={require('../WorkImgFolder/busTimeDown.png')} style={styles.downImgStyle}/>
                    </TouchableOpacity>
                    }
                    <Text style={[styles.detailContentStyle, {marginBottom:8}]}>{bottomContent}</Text>
                </View>
        );
    }
}
const styles = StyleSheet.create({
    detailViewStyle:{//流程白色背景图
        width: PCH.scaleW*345,
        //height: 177*PCH.scaleH,//为了让他被内容撑开
        backgroundColor: '#FFFFFF',
        borderRadius: 4,
        marginTop:7,
        //borderTopRightRadius
    },
    lineViewStyle:{//蓝线
        width: PCH.scaleW*345,
        height: 4*PCH.scaleH,
        backgroundColor: '#1768E4',
        borderTopRightRadius: 4,
        borderTopLeftRadius: 4,
    },
    detailTitleStyle:{
        fontSize: 16,
        color: '#1768E4',
        marginTop: 20,
        marginLeft: 10,
        fontFamily:'PingFangSC-Semibold',
    },
    lineViewStyle1: {//黄线
        marginLeft: 10,
        marginTop: -8,
        width: PCH.scaleW*186,
        height: 8*PCH.scaleH,
        backgroundColor: 'rgba(247, 181, 0, 0.3)',
        borderRadius: 4,
    },
    downImgStyle:{//附件
        width:325,
        height:58,
        marginTop:10,
        marginLeft: 10,
    },
    detailContentStyle:{
        marginTop: 8,
        marginRight: 10,
        marginLeft: 10,
        color: '#333333',
        fontSize: 14,
        lineHeight:28,//行间距
    },
});