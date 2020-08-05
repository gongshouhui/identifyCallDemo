import React from "react";
import {createStackNavigator, createAppContainer } from 'react-navigation'
import {Image,} from 'react-native';

import MenuVC from './YSThingMenuVC';//行政服务
import RegularVC from './XZShow/YSRegularBusVC';//亚厦班车
import BusReservaVC from './XZShow/YSBusReservationVC';//公车预定/地下停车

import OfficeVC from './XZShow/YSOfficeGuideVC';//办公详情选项
import OfficeDetialVC from './XZShow/YSGuideDetailVC';//办公详情展示
import TrainingCenterVC from './XZShow/YSTrainingCenterVC';//常规会议室/培训中心
import OfficeArchivesDetailVC from './XZShow/YSGuideOfficeArchivesDetailVC';//档案详情
import OfficeRepairDetailVC from './XZShow/YSOfficeRepairDetailVC';//报修无忧
import OfficeSectionDetailVC from './XZShow/YSGuideOfficeSectionDetailVC';//办公设备
import OfficeOrderDetailVC from './XZShow/YSGuideOfficeOrderDetailVC';//办公秩序详情

import FoodMenuVC from './XZShow/YSShoppingFolder/YSFoodMenuVC';//每周菜单
import ShopHomeVC from './XZShow/YSShoppingFolder/YSXZShopHomeVC';//欢乐购
import MallListVC from './XZShow/YSShoppingFolder/YSShopListVC';//商城
import ShopHotelVC from './XZShow/YSShoppingFolder/YSShopHotelVC';//酒店
import ShopFoodHome from './XZShow/YSShoppingFolder/YSShopFoodHomeVC';//餐饮
import ShopTrafficHomeVC from './XZShow/YSShoppingFolder/YSSHopTrafficHomeVC';//交通
import LobsterDetailVC from './XZShow/YSShoppingFolder/YSFoodLobsterDetailVC';//龙虾专场/中秋专场
import BuyBusVC from './XZShow/YSShoppingFolder/YSShopTrafficeBuyBusVC';//购车专场
import RentBusVC from './XZShow/YSShoppingFolder/YSShopTrafficeRentVC';//租车专场
import ShopMedicalHomeVC from './XZShow/YSShoppingFolder/YSShopMedicalHomeVC';//医疗


const defaultNavigationOptions = () => ({
  headerBackImage:<Image 
                          source={require('./WorkImgFolder/backBlak.png')}
                          style={{width:10, height:19, marginLeft: 14}}
                  />,//返回按钮的图标
  headerBackTitle: null,//次级页面的返回按钮没有标题
//头部栏样式  默认的
});

const AppNavigator = createStackNavigator({
  MenuVC:MenuVC,//行政服务
  BusReservaVC:{screen:BusReservaVC},//公车预定/地下停车
  RegularVC:{screen:RegularVC},//亚厦班车
  OfficeVC:{screen:OfficeVC},//办公详情
  OfficeDetialVC:{screen:OfficeDetialVC},//详情展示
  OfficeSectionDetailVC:{screen:OfficeSectionDetailVC},//办公设备
  TrainingCenterVC:{screen:TrainingCenterVC},//常规会议室/培训中心
  OfficeArchivesDetailVC:{screen:OfficeArchivesDetailVC},//档案详情
  OfficeRepairDetailVC:{screen:OfficeRepairDetailVC},//报修无忧
  OfficeOrderDetailVC:{screen:OfficeOrderDetailVC},//办公秩序详情

  ShopHomeVC:{screen:ShopHomeVC},//欢乐购物
  MallListVC:{screen:MallListVC},//商城
  FoodMenuVC:{screen:FoodMenuVC},//每周菜单
  ShopHotelVC:{screen:ShopHotelVC},//酒店
  ShopFoodHome:{screen:ShopFoodHome},//餐饮
  ShopTrafficHomeVC:{screen:ShopTrafficHomeVC},//交通
  ShopMedicalHomeVC:{screen:ShopMedicalHomeVC},//医疗
  LobsterDetailVC:{screen:LobsterDetailVC},//龙虾专场

  BuyBusVC:{screen:BuyBusVC},//购车专场
  RentBusVC:{screen:RentBusVC},//租车专场

},{
  defaultNavigationOptions: defaultNavigationOptions,//头部栏默认样式
});

const AppContainer = createAppContainer(AppNavigator);
export default class Navigator extends React.Component {
  render() {
    return <AppContainer />;
  }
}