/**
*@Created by GZL on 2019/09/29 17:21:13.
*/

'use strict';
import React, {PureComponent, Component} from 'react';
import {
    AlertIOS, View, StyleSheet, 
    TouchableOpacity, Image, ImageBackground,
    ScrollView,} from 'react-native';


export default class TrafficHomeVC extends PureComponent {
    static navigationOptions = ({navigation, navigationOptions}) => {
        return{
            title: '交通'
        };
    };
    constructor(props) {
        super(props);
    }
    clickedItem=(index)=>{
        switch (index){
            case 0:{
                this.props.navigation.push("BuyBusVC");//购车专场
            }
            break;
            case 1:{
                AlertIOS.alert('提示','敬请期待',);
            }
            break;
            case 2:{
                this.props.navigation.push('RentBusVC');//租车专场
            }
            break;
            case 3:{
                AlertIOS.alert('提示','敬请期待',);
            }
            break;
        }
    }
    render() {
        return(
            <View style={styles.container}>
                <ScrollView>
                    <View style={{width:'100%',height:732*PCH.scaleW}}>
                        <ImageBackground source={require('../../WorkImgFolder/trafficHomeBackImg.png')} style={styles.backImgStyle}>
                            <View style={{width:'100%',height:302*PCH.scaleW}}/>
                            <ImgBtnItem imgName={require('../../WorkImgFolder/trafficHomeImg01.png')} 
                                        itemStyle={{marginLeft:38*PCH.scaleW,}} 
                                        index={0}
                                        clickedItem={this.clickedItem}
                            />
                            <ImgBtnItem imgName={require('../../WorkImgFolder/trafficHomeImg02.png')} 
                                        itemStyle={{marginLeft:10*PCH.scaleW,}} 
                                        index={1}
                                        clickedItem={this.clickedItem}
                            />
                            <ImgBtnItem imgName={require('../../WorkImgFolder/trafficHomeImg03.png')} 
                                        itemStyle={{marginLeft:38*PCH.scaleW,marginTop:10}} 
                                        index={2}
                                        clickedItem={this.clickedItem}
                            />
                            <ImgBtnItem imgName={require('../../WorkImgFolder/trafficHomeImg04.png')} 
                                        itemStyle={{marginLeft:10*PCH.scaleW,marginTop:10}} 
                                        index={3}
                                        clickedItem={this.clickedItem}
                            />
                        </ImageBackground>
                    </View>
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
        flexDirection:"row",
        flexWrap:'wrap',
    },
    itemStyle:{
        width:148,
        height:191,
    },
});


class ImgBtnItem extends Component{
    clickedItem=()=>{
        this.props.clickedItem(this.props.index);
    }
    render(){
        const {imgName,itemStyle} = this.props;
        return(
            <View>
                <TouchableOpacity activeOpacity={1} onPress={this.clickedItem}>
                    <Image source={imgName} style={[styles.itemStyle,itemStyle]}/>
                </TouchableOpacity>
            </View>
        );
    }
}