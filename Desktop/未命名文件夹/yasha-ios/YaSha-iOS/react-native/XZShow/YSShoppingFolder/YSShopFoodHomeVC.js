/**
*@Created by GZL on 2019/09/29 17:18:25.
*/

'use strict';
import React, {PureComponent, Component} from 'react';
import {Text, View, StyleSheet, TouchableOpacity, Image, ScrollView, FlatList,ImageBackground,} from 'react-native';
import Swiper from 'react-native-swiper';

let old_offsetX = PCH.width;
export default class FoodHomeVC extends PureComponent {
    static navigationOptions = ({navigation, navigationOptions}) => {
        return{
            title: '餐饮'
        };
    };
    constructor(props) {
        super(props);
    }
    //点击cell
    onClickedCell=(index)=>{
        if(index===0){//小龙虾
            this.props.navigation.push('LobsterDetailVC',{title:'龙虾专场',index:0});
        }else if(index===1){//中秋
            this.props.navigation.push('LobsterDetailVC',{title:"中秋专场",index:1});
        }
    }


    render() {
        const data=[
            {imgName:require('../../WorkImgFolder/lobsterFoodHomeImg.png')},
            {imgName:require('../../WorkImgFolder/mooncakeFoodHomeImg.png')},
        ];
        return(
            <View style={styles.container}>
                <ScrollView style={styles.scrollViewStyle}>
                    <ImageBackground style={styles.backImgStyle} source={require('../../WorkImgFolder/shopFoodBackImg.jpg')}>
                        <View style={{width:PCH.width,height:460,marginTop:280*PCH.scaleW}}>
                            <Swiper activeDot={<View style={[styles.pointViewStyle,{backgroundColor:'#ffffff'},]}/>}
                                    paginationStyle={{marginTop:10}}
                            >
                                {data.map((item,index)=>{
                                    return(
                                        <ScrollCell index={index} 
                                                    imgName={item.imgName}
                                                    key={index}
                                                    onClickedCell={this.onClickedCell}
                                        />
                                    );
                                })}
                            </Swiper>
                        </View>
                        <View style={{height:20,}}/>
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
    backImgStyle:{
        width:'100%',
        height:732*PCH.scaleW,
    },
    pointBackViewStyle:{//点的背景视图
        flexDirection:'row',
        alignItems:'center',
        justifyContent:'center',
        height:30,
        width:PCH.width,
    },
    pointViewStyle:{//点
        height:8,
        width:8,
        backgroundColor:'#000000',
        borderRadius:4,
        marginLeft:8,
    },
});

class ScrollCell extends Component{
    onClickedCell = ()=>{
        this.props.onClickedCell(this.props.index);
    }
    render(){
        const {imgName} = this.props;
        return(
            <TouchableOpacity onPress={this.onClickedCell} activeOpacity={1}>
                <View style={{width:PCH.width,height:420,alignItems:'center'}}>
                    <Image style={{width:301,height:420}} source={imgName}/>
                </View>
            </TouchableOpacity>
        );
    }

}

class PointBtnView extends Component{
    constructor(props){
        super(props);
        this.state={
            pointColor:this.props.pointColor?this.props.pointColor:'#000000',
        };
    }
    _onPress = ()=>{
        this.props.onClickPointBtn(this.props.index);
    }
    changePointStyle = (pointColor)=>{
        this.setState({
            pointColor:pointColor,
        });
    }
    render(){
        const {pointColor,} = this.state;
        return(
            <TouchableOpacity onPress={this._onPress}>
                <View style={[styles.pointViewStyle,pointColor&&{backgroundColor:pointColor},]}/>
            </TouchableOpacity>
        );
    }
}