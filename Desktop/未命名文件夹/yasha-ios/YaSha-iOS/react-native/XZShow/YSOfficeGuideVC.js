/**
*@Created by GZL on 2019/09/18 10:54:40.
*/

import React, {PureComponent, Component} from 'react';
import {Text, View, StyleSheet, SectionList, Image, TouchableOpacity,} from 'react-native';
import PCH from '../PrefixHeader';

//办公必备/餐饮会务/档案用章/报修无忧/办公秩序
export default class OfficeGuideVC extends PureComponent {
    static navigationOptions = ({navigation, navigationOptions}) => {
        return{
            title: navigation.getParam('title'),
        };
    };
    constructor(props) {
        super(props);
        if(this.props.navigation.getParam('title')==='办公必备'){
            this.state={
                data:[
                    {
                        title:'图文寄件',
                        data:[{name:'· 蓝钻打印需要走什么流程？'}, {name:'· 顺丰寄件怎么寄？'}]
                    },
                    {
                        title:'办公设备',
                        data:[{name:'· 办公固定资产如何申请？'}, {name:'· 如何申请电脑？'}, {name:'· 鼠标键盘U盘如何申请？'}, {name:'· 如何申请考勤机？'}]
                    },
                    {
                        title:'办公用品、礼品',
                        data:[{name:'· 申请办公用品走什么流程？'}, {name:'· 申请礼品走什么流程？'}, {name:'· 需求流程发起之后，什么时候可以领取物品？'}]
                    },
                ],
                initImgArray:[true,true,true],//是否为初始图片
                initImgName:[require('../WorkImgFolder/OfficeUpImg.png'), require('../WorkImgFolder/OfficeUpImg.png'), require('../WorkImgFolder/OfficeUpImg.png')],
            };
        }else if(this.props.navigation.getParam('title')==='餐饮会务'){
            this.state={
                data:[
                    {
                        title:'常规会议室/培训中心',
                        data:[{name:'· 5F-11F会议室及培训中心如何预订/取消？'},]
                    },
                    {
                        title:'12F会议室及用餐',
                        data:[{name:'· 如何预定12F会议室？'}, {name:'· 12F会所预定包厢需要走什么流程？'}, {name:'· 请客户在外用餐，可否在会所申领酒水？'}]
                    },
                ],
                initImgArray:[true,true],//是否为初始图片
                initImgName:[require('../WorkImgFolder/OfficeUpImg.png'), require('../WorkImgFolder/OfficeUpImg.png'),],
            };
        }else if(this.props.navigation.getParam('title')==='档案用章'){
            this.state={
                data:[
                    {
                        title:'档案',
                        data:[
                            {name:'· 证件类及执业印章借用/归还需要走什么流程？'},
                            {name:'· 项目印章借用归还需要走什么流程？'},
                            {name:'· 借阅需要走什么流程？'},
                            {name:'· 加盖执业印章需要走什么流程？'},
                            {name:'· 离职时本人证件移出需要走什么流程？'},
                            {name:'· 工程合同移出，需要走什么流程？'},
                            {name:'· 移交需要走什么流程？'},
                            {name:'· 续借需要走什么流程？'},
                        ]
                    },
                    {
                        title:'用章',
                        data:[{name:'· 各类印章需要走什么流程？'}, {name:'· 需要刻制印章应走什么流程？'},]
                    },
                ],
                initImgArray:[true,true],//是否为初始图片
                initImgName:[require('../WorkImgFolder/OfficeUpImg.png'), require('../WorkImgFolder/OfficeUpImg.png'),],
            };
        }else if(this.props.navigation.getParam('title')==='报修无忧'){
            this.state={
                data:[
                    {
                        title:'报修无忧',
                        data:[
                            {name:'· 手机移动信号不好？'},
                            {name:'· 打印机坏了要找谁？'},
                            {name:'· 钥匙哪里借？'},
                            {name:'· 工位跳闸要找谁？'},
                            {name:'· 办公柜门打不开找谁？'},
                            {name:'· 电脑网络不行怎么办？'},
                        ]
                    },
                ],
                initImgArray:[true,],//是否为初始图片
                initImgName:[require('../WorkImgFolder/OfficeUpImg.png'),],
            };
        }else if(this.props.navigation.getParam('title')==='办公秩序'){
            this.state={
                data:[
                    {
                        title:'办公秩序',
                        data:[
                            {name:'· 文明乘梯'},
                            {name:'· 员工餐厅用餐规范'},
                            {name:'· 公共区域禁止吸烟'},
                            {name:'· 禁用自备电器'},
                            {name:'· 卫生及物品摆放'},
                        ]
                    },
                ],
                initImgArray:[true,],//是否为初始图片
                initImgName:[require('../WorkImgFolder/OfficeUpImg.png'),],
            };
        }
        
    }
    //区头
    renderSectionHeader = ({section})=>{
        const index = this.state.data.map(item => item.title).indexOf(section.title);
        const imgArray = this.state.initImgName;
        return(
            <TouchableOpacity onPress={()=>{this._onPressHeaderView(section)}}>
                <View style={{height:54,backgroundColor:'white'}}>
                    <View style={[styles.cellViewStyle, {height:53}]}>
                        <Image source={require('../WorkImgFolder/OfficeMenuImg.png')} style={styles.headrImgStyle}/>
                        <Text style={styles.headerTextStyle}>{section.title}</Text>
                        <View style={{flex:1, justifyContent:'flex-end',flexDirection:'row'}}>
                            <Image source={imgArray[index]} style={{width:12,height:6,marginRight:18}}/>
                        </View>
                    </View>
                    <View style={{height:1,marginLeft:20,marginRight:20,marginBottom:0,backgroundColor:'#E2E4EA'}}/>
                </View>
            </TouchableOpacity>
        );
    };
    //点击区头
    _onPressHeaderView = (section)=>{
        //indexPath.section
        const index = this.state.data.map(item => item.title).indexOf(section.title);
        let initImgArray = this.state.initImgArray.slice(0,this.state.initImgArray.length);
        let initImgName = this.state.initImgName.slice(0,this.state.initImgName.length);
        if(initImgArray[index]){//展开-->收起
            initImgArray.splice(index,1,!initImgArray[index]);
            initImgName.splice(index,1,require('../WorkImgFolder/OfficeUnderImg.png'));
        }else {//收起来-->展开
            initImgArray.splice(index,1,!initImgArray[index]),
            initImgName.splice(index,1,require('../WorkImgFolder/OfficeUpImg.png'))
        }
        this.setState({
            initImgArray:initImgArray,
            initImgName:initImgName,
        });
    }

    renderItem = ({item,index,section})=>{
        const indexPath_section = this.state.data.map(o => o.title).indexOf(section.title);
        const isShow = this.state.initImgArray[indexPath_section];
        if(!isShow){
            return(<View/>);
        }else{
        return(
            <TouchableOpacity onPress={()=>{this._onPressCell(item,index,section)}}>
                <View style={{height:54, backgroundColor:'white'}}>
                    <View style={[styles.cellViewStyle, {height:53}]}>
                        <Text style={styles.cellTextStyle}>{item.name}</Text>
                    </View>
                    <View style={{height:1,marginLeft:20,marginRight:20,marginBottom:0,backgroundColor:'#E2E4EA'}}/>
                </View>
            </TouchableOpacity>
        );
        }
    }
    //点击cell
    _onPressCell = (item,index,section)=>{//index只是index.row 还需要获取index.section
        const indexPath_section = this.state.data.map(o => o.title).indexOf(section.title);
        if(this.props.navigation.getParam('title')==='办公必备'){
            switch(indexPath_section) {
                case 0:{//图文寄件
                    this.props.navigation.push('OfficeDetialVC',{title:'图文寄件',index:index});
                }
                break;
                case 1:{//办公设备
                    this.props.navigation.push('OfficeSectionDetailVC',{title:'办公设备',index:index});
                }
                break;
                case 2:{//办公用品、礼品
                    this.props.navigation.push('OfficeDetialVC',{title:'办公用品、礼品',index:index});
                }
                break;
            }
        }else if(this.props.navigation.getParam('title')==='档案用章'){
            let data;
            if(indexPath_section===1){//用章
                data=[
                    {
                        sectionTitle:'用章',
                        title:'各类印章需要走什么流程？',
                        data:[
                            '1. 文件盖章需等到流程节点到印章专员处，才能携带文件到印章专员处盖章。如本人不能来盖章，可委托同事盖章，但需在流程中写明委托人姓名。',
                            '2. 涉及合同协议类文件，需走对应合同流程，有关收入证明、工作证明、业绩证明、职称评审等资料需走人事证明流程；',
                            '3. 合同协议类涉及自营项目，需公司条线领导（总监及以上）签字；考核项目可由项目经理签字。其中信息化建设、行政采购、知识产权类、租赁类、配套服务类、项目部行政类物资合同盖章审批流程需在纸质合同上签字并将签字版上传至流程。',
                            '4 . 如有疑问，请联系印章专员：',
                            '李梦婷 15757827113，王喆丞 18262884858。'
                        ],
                    },
                    {
                        sectionTitle:'刻章',
                        title:'需要刻制印章应走什么流程？',
                        data:[
                            '1. 刻制公章、法人章等印章应走印章刻制销毁流程，项目上申请刻制项目章应走项目部技术资料专用章刻制申请流程（装饰）、项目部技术资料专用章刻制申请流程（幕墙） 。',
                            '2. 进入路径：OA—通用流程—行政管理—印章刻制销毁流程。',
                        ],
                    },
                ];
                this.props.navigation.push('OfficeDetialVC',{title:'用章',data:data,index:index});
            }else if (indexPath_section===0){//档案 OfficeArchivesDetailVC
                this.props.navigation.push('OfficeArchivesDetailVC',{title:'档案',index:index});
            }

        }else if(this.props.navigation.getParam('title')==='餐饮会务'){
            if(indexPath_section===0){//常规会议室/培训中心
                this.props.navigation.push('TrainingCenterVC',{inde:index});
            }else if(indexPath_section===1){//12F会议室及用餐
                this.props.navigation.push('RegularVC',{title:'12F会议室及用餐',index:index});
            }
            
        }else if(this.props.navigation.getParam('title')==='报修无忧'){
            this.props.navigation.push('OfficeRepairDetailVC',{index:index});
        }else if(this.props.navigation.getParam('title')==='办公秩序'){
            this.props.navigation.push('OfficeOrderDetailVC',{index:index});
        }
        
    };
    render() {
        const {data} = this.state;
        return(
            <View style={{backgroundColor:'#FAFAFA'}}>
                <SectionList  sections={data}
                              renderItem={this.renderItem}
                              keyExtractor={(item, index) => item + index}
                              stickySectionHeadersEnabled={false}
                              renderSectionHeader={this.renderSectionHeader}
                              renderSectionFooter={()=>{return(<View style={{width:PCH.width, backgroundColor:'#FAFAFA',height:10}}/>);}}
                />
            </View>
        );
    }
}
const styles = StyleSheet.create({
    cellViewStyle:{
        width:PCH.width,
        height:54,
        flexDirection:'row',
        alignItems:'center',
    },
    headrImgStyle:{
        width:16,
        height:16,
        marginLeft:24,
    },
    headerTextStyle:{
        fontSize:16,
        fontFamily:'PingFangSC-Medium',
        marginLeft:10,
        color:'#111A34',
    },
    cellTextStyle:{
        fontSize:16,
        fontFamily:'PingFangSC-Regular',
        marginLeft:20,
        color:'#000000',
    },
});