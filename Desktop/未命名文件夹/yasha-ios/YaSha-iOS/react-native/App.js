
import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View,NativeModules,InteractionManager,Alert} from 'react-native';

const instructions = Platform.select({
    ios: 'Press Cmd+R to reload,\n' + 'Cmd+D or shake for dev menu',
    android:
        'Double tap R on your keyboard to reload,\n' +
        'Shake or press menu button for dev menu',
});

var Push = NativeModules.PushNative;
type Props = {};
export default class Five extends Component<Props> {
    render() {
        return (
            <View style={styles.container}>
                <Text style={styles.welcome}>Welcome to React Native!</Text>
                <Text style={styles.instructions}>To get started, edit App.js</Text>
                {/*<Text style={styles.instructions} onPress={() => {*/}
                    {/*Push.addEventWithString('junjie',{'key':'ios engineer'});*/}
                {/*}}>show detail</Text>*/}
                {/*<Text style={styles.instructions} onPress={() =>this.callBackArray()}>block</Text>*/}
                {/*<Text style={styles.instructions} onPress={() =>{*/}
                    {/*Alert.alert(Push.customDicKey);*/}
                {/*}}>customDic</Text>*/}
            </View>
        );
    }

    // callBackArray = () => {
    //     Push.TestWithCallBackOne('junjie',(error,events) => {
    //         if (error) {
    //             console.log(error);
    //         }  else  {
    //             Alert.alert(events[0]);
    //         }
    //     })
    // }
}



const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#F5FCFF',
    },
    welcome: {
        fontSize: 20,
        textAlign: 'center',
        margin: 10,
    },
    instructions: {
        textAlign: 'center',
        color: '#333333',
        marginBottom: 5,
    },
});
