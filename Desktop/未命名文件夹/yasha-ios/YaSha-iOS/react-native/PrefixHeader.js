import {Dimensions, Platform, StatusBar, } from 'react-native';
export const designWidth = 375.0;//UI设计的宽
export const designHeight = 667.0;//UI设计的高

export function isIphoneX() {
    const X_HEIGHT = 812;
    return Platform.OS === 'ios' &&  (Dimensions.get('window').height >= X_HEIGHT)
}

export function getStatusBarHeight() {
    if(Platform.OS === 'android') {
        return StatusBar.currentHeight;
    }
    if(isIphoneX()){
        return 44;
    }
    return 20;
}
export const statusBarHeight = getStatusBarHeight();
export const naviBarHeight = 44.0;//导航栏;

export default PCH = {
    width : Dimensions.get('window').width,
    height : Dimensions.get('window').height,
    scaleW : Dimensions.get('window').width/designWidth,//以375的屏宽为基准(IOS)
    scaleH : Dimensions.get('window').height/designHeight,//以667的屏高为基准(IOS)
    TopHeight : naviBarHeight + statusBarHeight,//导航栏+状态栏;

}
