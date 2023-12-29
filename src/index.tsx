import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-biometric-next' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const BiometricNext = NativeModules.BiometricNext
  ? NativeModules.BiometricNext
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function enableBioMetric(title : string, subtitle: string, callback : (res:any)=>void) {
  return BiometricNext.enableBioMetric(title,subtitle,callback);
}

export function checkBiometricSupport(callback : (res : any) => void){
  return BiometricNext.checkBiometricEnrolledStatus(callback)
}

export function checkNewFingerPrintAdded(callback : (res : any)=>void){
  return BiometricNext.checkNewFingerPrintAdded(callback)
}
