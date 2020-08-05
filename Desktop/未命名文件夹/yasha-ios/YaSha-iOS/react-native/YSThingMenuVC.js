/**
*@Created by GZL on 2019/09/17 11:41:41.
*/

import React, {PureComponent, Component} from 'react';
import {
    SectionList, View, StyleSheet, 
    Image, Text, FlatList,NativeModules, TouchableOpacity,
} from 'react-native';


import WorkCollectionCell from './XZShow/WorkCollectionCell';
import PCH from './PrefixHeader';

var YSModules = NativeModules.YSReactNativeModel
export default class MenuThingVC extends PureComponent {
    static navigationOptions = ({navigation, navigationOptions}) => {
        return{
            title: '行政服务',
            headerLeft:(
            <TouchableOpacity onPress={()=>YSModules.navigateBack()}>
                <View style={{width:40*PCH.scaleW,height:38*PCH.scaleH,justifyContent:'center'}}>
                    <Image source={require('./WorkImgFolder/backBlak.png')}
                           style={{width:10, height:19, marginLeft: 14}}
                    />
                </View>  
            </TouchableOpacity>), 
        };
    };
    constructor(props) {
        super(props);
        this.state={
            data:[
                {
                    sectionTitle:'出行手册',
                    data:[
                        {name:'公车预定',imgName:require('./WorkImgFolder/reservationBusPublic.png')},
                        {name:'亚厦班车',imgName:require('./WorkImgFolder/YSShuttleBus.png')},
                        {name:'地下停车',imgName:require('./WorkImgFolder/undergroundPark.png')},
                    ]
                },
                {
                    sectionTitle:'办公指南',
                    data:[
                        {name:'办公必备',imgName:require('./WorkImgFolder/OfficeNeed.png')},
                        {name:'餐饮会务',imgName:require('./WorkImgFolder/OfficeMeeting.png')},
                        {name:'档案用章',imgName:require('./WorkImgFolder/OfficeArchives.png')},
                        {name:'报修无忧',imgName:require('./WorkImgFolder/OfficeRepair.png')},
                        {name:'办公秩序',imgName:require('./WorkImgFolder/OfficeOrder.png')},
                    ]
                },
                {
                    sectionTitle:'亚厦+',
                    data:[
                        {name:'每周菜单',imgName:require('./WorkImgFolder/YSFoodMenu.png')},
                        {name:'欢乐购',imgName:require('./WorkImgFolder/YSShoping.png')},
                        //{name:'体检预约',imgName:require('./WorkImgFolder/YSMedical.png')},
                    ]
                },
            ],
        };
    }
    componentDidMount(){
        YSModules.hiddenLoading();
    }
    //sectionList的headerView
    listHeaderComponent = ()=>{
        return(
            <Image style={styles.topImgStyle} source={require('./WorkImgFolder/benner.png')}/>
        );
    };
    //区头
    renderSectionHeader = ({section})=>{
        return(
            <View>
                <View style={styles.sectionViewStyle}>
                    <Text style={styles.sectionTitleStyle}>{section.sectionTitle}</Text>
                </View>
                <FlatList data={section.data}
                          renderItem={this._renderItem}
                          keyExtractor={(item, index)=> String(index)}
                          horizontal={false} // 水平还是垂直
                          numColumns={4}//一行四个
                />
            </View>
        );
    };
    //FlatList的cell
    _renderItem = ({item,index})=>{
        return(
            <View>
                <WorkCollectionCell index={index}
                                    title={item.name}
                                    imgName={item.imgName}
                                    onPressItem={this._onPressItem}
                />
            </View>
        );
    };
    //点击跳转详情页
    _onPressItem = (index, title)=>{
        const {navigation} = this.props;
        if(title==='公车预定'){
            navigation.push('BusReservaVC',{title:'公车预定', name:'申请使用公车需要什么流程？', data:['1. 在OA系统中发起公车使用申请，车辆管理员会根据用车人实际情况合理派车。', '2. 进入路径：OA门户--通用流程--行政管理--公车使用申请。']});
        }else if(title==='亚厦班车'){
            navigation.push('RegularVC',{title:'亚厦班车', name:'班车有几条路线？班车乘坐的时间？'});
        }else if(title==='地下停车'){
            navigation.push('BusReservaVC',{title:'地下停车', name:'个人车辆驶入车库有什么手续吗？', data:['1、在OA系统中发起地下车位新增及取消申请流程，审批通过后次日即可进入地下车库；', '2、M6以下员工车辆停放地下二楼、三楼（无固定车位）；', '3、车辆审批后无法驶入，请至一楼物业前台咨询，若无法查询到相关信息请联系车辆管理员；', '4、进入路径：OA门户—通用流程—行政管理—地下车位新增及取消申请流程。']});
        }else if(title==='办公必备'){
            navigation.push('OfficeVC',{title:'办公必备'});
        }else if(title==='餐饮会务'){
            navigation.push('OfficeVC',{title:'餐饮会务'});
        }else if(title==='档案用章'){
            navigation.push('OfficeVC',{title:'档案用章'});
        }else if(title==='报修无忧'){
            navigation.push('OfficeVC',{title:'报修无忧'});
        }else if(title==='办公秩序'){
            navigation.push('OfficeVC',{title:'办公秩序'});
        }else if(title==='每周菜单'){
            navigation.push('FoodMenuVC');
        }else if(title==='欢乐购'){
            navigation.push('ShopHomeVC',{title:'欢乐购'});
        }else if(title==='体检预约'){
            navigation.push('');
        }
    };
    render() {
        const {data} = this.state;
        return(
            <View style={{flex:1}}>
                <Image style={styles.topImgStyle} source={require('./WorkImgFolder/benner.png')}/>
                <SectionList  renderSectionHeader={this.renderSectionHeader}
                              renderItem={()=>{return(<View/>)}}
                              sections={data}
                              keyExtractor={(item, index) => item + index}
                              //ListHeaderComponent={this.listHeaderComponent}
                />
            </View>
        );
    }
}
const styles = StyleSheet.create({
    topImgStyle:{
        width:PCH.width,
        height:147*PCH.scaleW,
    },
    sectionViewStyle:{
        width:PCH.width,
        height:44,
        flexDirection:'row',
        alignItems:'center',
    },
    sectionTitleStyle:{
        fontFamily:'PingFangSC-Medium',
        color:'#111A34',
        fontSize:15,
        marginLeft:15,
    },
});