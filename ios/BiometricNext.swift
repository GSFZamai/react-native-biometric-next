import LocalAuthentication

let biometricKey = "BiometricsPolicyState"

@objc(BiometricNext)
class BiometricNext: NSObject {

    
    
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
    
    @objc func checkNewFingerPrintAdded(_ callback: @escaping RCTResponseSenderBlock) {
        if LAContext.biometricsChanged() {
            callback(["NEW_FINGERPRINT_ADDED"])
        }else {
            callback(["CONTINUE"])
        }
    }
}


extension LAContext {
    
    static var savedBiometricPolicyState: Data? {
        get {
            UserDefaults.standard.data(forKey: biometricKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: biometricKey)
        }
    }
    
    static func biometricsChanged() -> Bool {
        let context = LAContext()
        var error: NSError?
        
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if error == nil && LAContext.savedBiometricPolicyState == nil {
            LAContext.savedBiometricPolicyState = context.evaluatedPolicyDomainState
            return false
        }
        
        if let domainState = context.evaluatedPolicyDomainState, domainState != LAContext.savedBiometricPolicyState {
            return true
        }
        
        return false
    }
}
