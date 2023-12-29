import LocalAuthentication
@objc(BiometricNext)
class BiometricNext: NSObject {

  @objc(multiply:withB:withResolver:withRejecter:)
  func multiply(a: Float, b: Float, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
    resolve(a*b)
  }
    
    @objc func enableBioMetric(_ title: String,subtitle: String, callback: @escaping RCTResponseSenderBlock) -> Void {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = title
        var authError: NSError?
        let reasonString = subtitle
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
          
          localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reasonString) { success, evaluateError in
            if success {
                callback([success])
            } else {
              guard let error = evaluateError else {
                return
              }
              callback([error])
            }
          }
        } else {
            if let laError = authError as? LAError {
                switch laError.code {
                case .biometryNotAvailable:
                    callback(["Biometric authentication not available on the device"])
                    break
                case .biometryLockout:                callback(["Biometric authentication is locked due to too many failed attempts"])
                    break
                case .biometryNotEnrolled:
                    //
                    callback(["Biometric authentication is not enrolled"])
                    break
                default:
                    callback(["BIOMETRIC_STATUS_UNKNOWN"])
                }
            }
            callback([authError ?? "Something went wrong"])
        }
    }
}
