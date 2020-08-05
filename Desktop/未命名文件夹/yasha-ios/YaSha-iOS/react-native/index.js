/**
 * @format
 */

import {AppRegistry} from 'react-native';
import App from './App';
import Navigator from './Navigator';
import {name as appName} from './app.json';
import PCH from './PrefixHeader';


AppRegistry.registerComponent(appName, () => Navigator);
