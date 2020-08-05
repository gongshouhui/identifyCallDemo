/**
*@Created by GZL on 2019/09/12 15:30:29.
*/

import React, {PureComponent, Component} from 'react';
import {Text, View, StyleSheet, } from 'react-native';
import PCH from '../PrefixHeader';



export default class RegularShowCell extends Component {
    render() {
        const {data, title, sectionStyle, yellowLineStyle} = this.props;
        const bottomContent = data[data.length-1];
        const dataContent = data.slice(0, data.length-1);
        return(
            <View style={styles.detailViewStyle}>
                    <View style={styles.lineViewStyle}/>
                    <Text style={styles.detailTitleStyle}>{title}</Text>
                    <View style={[styles.lineViewStyle1, yellowLineStyle&&{width:yellowLineStyle}]}/>
                    {dataContent.map((item, index)=>(
                        <View key={index}>
                            <Text style={[styles.detailSectionStyle,sectionStyle&&{fontFamily:sectionStyle, marginLeft:10,marginTop:8,marginRight:10}]}>
                                {item.section}
                                <Text style={[styles.detailContentStyle, {fontFamily:'PingFangSC-Regular'}]}>
                                    {item.sectionContent}
                                </Text>
                            </Text>
                            {item.contentText.map((info,index)=>(
                                <Text style={styles.detailContentStyle} key={index}>{info}</Text>
                            ))}
                        </View>
                    ))}
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
        marginLeft: 15,
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
    detailSectionStyle:{
        color: '#333333',
        fontSize: 14,
        lineHeight:28,//行间距
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