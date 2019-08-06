//
//  WSClient.swift
//  Alamofier

import UIKit
import Alamofire
import AlamofireImage
import SystemConfiguration
import CoreLocation
import TrustKit

enum WSRequestType : Int {
    case WSRequestTypeAppSettings = 0
    case WSRequestTypeLogIn
    case WSRequestTypeForgotPassword
    case WSRequestTypeCheckUniqeUser
    case WSRequestTypeCreateAccount
    case WSRequestTypeActivateAccount
//    case WSRequestTypeResendOTP
    case WSRequestTypeDoctorsSearch
    case WSRequestTypeDoctorProfile
    case WSRequestTypeDoctorReview
    case WSRequestTypeGetDoctorList
    case WSRequestTypeLogOut
    case WSRequestTypeVerifyOTP
    case WSRequestTypeChangePSWD
    case WSRequestTypeUpdateProfile
    case WSRequestTypeGetDocAppoinmentList
    case WSRequestTypeGetPatientAppoinmentList
    case WSRequestTypeGetDoctorAppointmentDetail
    case WSRequestTypeGetPatientAppointmentDetail
    case WSRequestTypeAppointmentBooking
    case WSRequestTypeAddAppointmentDetail
    case WSRequestTypeAddAppointmentPhotos
    case WSRequestTypeDeleteAppointmentPhotos
    case WSRequestTypeCancelAppointment
    case WSRequestTypeDeleteAppointment
    case WSRequestTypeGetMessageList
    case WSRequestTypeMessageAction
    case WSRequestTypeGetPaymentCardList
    case WSRequestTypeGenerateClientToken
    case WSRequestTypeUserCardAction
    case WSRequestTypeAddCard
    case WSRequestTypeAddNonWorkingDays
    case WSRequestTypeAddReview
    case WSRequestTypeGetPatientPastvisits
    case WSRequestTypeRequestPrescription
    case WSRequestTypeAddPrescription
    case WSRequestTypeAddDoctorNote
    case WSRequestTypeTransactionHistory
    case WSRequestTypeGetHealthProfile
}

enum WSAPI : String {
    case AppSettings                = "user/appsettinglist"
    case LogIn                      = "user/login"
    case ForgotPassword             = "user/forgotpassword"
    case CheckUniqueUser            = "user/checkuniqueuser"
    case CreateAccount              = "user/createaccount"
    case ActivateAccount            = "user/activateaccount"
//    case ResendOTP                  = "user/resendotp"
    case GetDoctorSearch            = "user/getdoctorsearchlist"
    case DoctorProfile              = "user/doctorprofileview"
    case DoctorReview               = "user/doctorreview"
    case GetDoctorList              = "user/getdoctorlist"
    case LogOut                     = "user/logout"
    case VerifyOTP                  = "user/verifyotpforgotpassword"
    case ChangePassword             = "user/changepassword"
    case ProfileUpdate              = "user/userprofileupdate"
    case GetDocAppoinmentList       = "user/getdoctorappointmentlisting"
    case GetPatientAppoinmentList   = "user/getpatientappointmentlisting"
    case GetDoctorAppointmentDetail = "user/getdoctorappointmentdetail"
    case GetPatientAppointmentDetail = "user/getpatientappointmentdetail"
    case AppointmentBooking         = "user/orderbooking"
    case AddAppointmentDetail       = "user/addpatientappointmentdetails"
    case AddAppointmentPhotos       = "user/addpatientappointmentphotos"
    case CancelAppointment          = "user/cancelappointment"
    case deleteAppointment          = "user/deleteappointment"
    case GetMessagesList            = "user/getmessageslist"
    case messageAction              = "user/messageaction"
    case GetPaymentCardList         = "user/paymentcardget"
    case GenerateClientToken        = "user/paymentgenerateclienttoken"
    case UserCardAction             = "user/paymentusercardaction"
    case AddCard                    = "user/paymentaddcard"
    case AddNonWorkingDays          = "user/addnonworkingday"
    case AddReview                  = "user/addreview"
    case getpatientpastvisits       = "user/getpatientpastvisits"
    case requestForPrescription     = "user/requestprescription"
    case addPrescription            = "user/orderbookingcomplete"
    case transactionhistory         = "user/transactionhistory"
    case adddoctornote              = "user/adddoctornote"
    case getHealthProfile           = "user/getpatienthealthprofile"
}

enum UploadImgType : Int {
    case profilePic = 1
    case coverPic
}

enum ImgPath : String {
    case ProfilePicPath = "user/updateuser"
    case CoverPicPath   = "Cover"
}

enum MultipartUploadStatus {
    case success(progress : Float, response : AnyObject?)
    case uploading(progress: Float)
    case failure(error : NSError?)
}

struct SearchResultsData {
    var placeId : String = ""
    var searchAddress : String = ""
}

struct DoctorRegistrationImgData {
    var image : UIImage!
    var imgName : Constant.DocRegImgName = .profImg
}

struct AppointmentImgData {
    var image : UIImage!
    var imgName : String = ""
    var imgIdx : Int = 0
}

struct InsuranceImgData {
    var image : UIImage!
    var imgName : String = ""
}

//MARK:- Base URL
struct URLData {
    //Base URLs
    static let baseURL_SandBox_Dev : String = "http://52.1.7.60/" //Sandbox Development Server
    
    static let zoomBaseUserURL = "https://api.zoom.us/v2/users"
    static let zoomBaseMeetingURL = "https://api.zoom.us/v2/meetings/"
}

class WSClient: NSObject {
    
    static let sharedInstance : WSClient = {
        let instance = WSClient()
        return instance
    }()
    
    //API Base URL
    let BaseURL = DocURLData.baseURL_Live

    //Params Key
    let ParameterKey = "params"
    
    //Session Manager
    var sessionMngr : SessionManager!
    
    //MARK:- Get API
    func getAPI(apiType : WSRequestType) -> String {
        switch apiType {
        case .WSRequestTypeAppSettings:
            return BaseURL+WSAPI.AppSettings.rawValue
        case .WSRequestTypeLogIn:
            return BaseURL+WSAPI.LogIn.rawValue
        case .WSRequestTypeForgotPassword:
            return BaseURL+WSAPI.ForgotPassword.rawValue
        case .WSRequestTypeCreateAccount:
            return BaseURL+WSAPI.CreateAccount.rawValue
        case .WSRequestTypeActivateAccount:
            return BaseURL+WSAPI.ActivateAccount.rawValue
        case .WSRequestTypeDoctorsSearch:
            return BaseURL+WSAPI.GetDoctorSearch.rawValue
        case .WSRequestTypeCheckUniqeUser:
            return BaseURL+WSAPI.CheckUniqueUser.rawValue
        case .WSRequestTypeDoctorProfile:
            return BaseURL+WSAPI.DoctorProfile.rawValue
        case .WSRequestTypeDoctorReview:
            return BaseURL+WSAPI.DoctorReview.rawValue
        case .WSRequestTypeGetDoctorList:
            return BaseURL+WSAPI.GetDoctorList.rawValue
        case .WSRequestTypeLogOut:
            return BaseURL+WSAPI.LogOut.rawValue
        case .WSRequestTypeVerifyOTP:
            return BaseURL+WSAPI.VerifyOTP.rawValue
        case .WSRequestTypeChangePSWD:
            return BaseURL+WSAPI.ChangePassword.rawValue
        case .WSRequestTypeUpdateProfile:
            return BaseURL+WSAPI.ProfileUpdate.rawValue
        case . WSRequestTypeGetDocAppoinmentList:
            return BaseURL+WSAPI.GetDocAppoinmentList.rawValue
        case .WSRequestTypeGetPatientAppoinmentList:
            return BaseURL+WSAPI.GetPatientAppoinmentList.rawValue
        case .WSRequestTypeGetDoctorAppointmentDetail:
            return BaseURL+WSAPI.GetDoctorAppointmentDetail.rawValue
        case .WSRequestTypeGetPatientAppointmentDetail:
            return BaseURL+WSAPI.GetPatientAppointmentDetail.rawValue
        case .WSRequestTypeAppointmentBooking:
            return BaseURL+WSAPI.AppointmentBooking.rawValue
        case .WSRequestTypeAddAppointmentDetail:
            return BaseURL+WSAPI.AddAppointmentDetail.rawValue
        case .WSRequestTypeAddAppointmentPhotos:
            return BaseURL+WSAPI.AddAppointmentPhotos.rawValue
        case .WSRequestTypeCancelAppointment:
            return BaseURL+WSAPI.CancelAppointment.rawValue
        case .WSRequestTypeDeleteAppointment:
            return BaseURL+WSAPI.deleteAppointment.rawValue
        case .WSRequestTypeGetMessageList:
            return BaseURL+WSAPI.GetMessagesList.rawValue
        case .WSRequestTypeMessageAction:
            return BaseURL+WSAPI.messageAction.rawValue
//        case .WSRequestTypeResendOTP:
//            return BaseURL+WSAPI.ResendOTP.rawValue
        case .WSRequestTypeGenerateClientToken:
            return BaseURL+WSAPI.GenerateClientToken.rawValue
        case .WSRequestTypeUserCardAction:
            return BaseURL+WSAPI.UserCardAction.rawValue
        case .WSRequestTypeAddCard:
            return BaseURL+WSAPI.AddCard.rawValue
        case .WSRequestTypeGetPaymentCardList:
            return BaseURL+WSAPI.GetPaymentCardList.rawValue
        case .WSRequestTypeAddNonWorkingDays:
            return BaseURL+WSAPI.AddNonWorkingDays.rawValue
        case .WSRequestTypeAddReview:
            return BaseURL+WSAPI.AddReview.rawValue
        case .WSRequestTypeGetPatientPastvisits:
            return BaseURL+WSAPI.getpatientpastvisits.rawValue
        case .WSRequestTypeRequestPrescription:
            return BaseURL+WSAPI.requestForPrescription.rawValue
        case .WSRequestTypeAddPrescription:
            return BaseURL+WSAPI.addPrescription.rawValue
        case .WSRequestTypeTransactionHistory:
            return BaseURL+WSAPI.transactionhistory.rawValue
        case .WSRequestTypeDeleteAppointmentPhotos:
            return BaseURL+WSAPI.AddAppointmentPhotos.rawValue
        case .WSRequestTypeAddDoctorNote:
            return BaseURL+WSAPI.adddoctornote.rawValue
        case .WSRequestTypeGetHealthProfile:
            return BaseURL+WSAPI.getHealthProfile.rawValue
        }
    }
    
    //MARK:- Check SSL Pinning
    func checkSSLPinning(completion:(() -> Void)?) {
       /*
         CERTIFICATE INFO
         ----------------
         subject= /CN=docapp.com
         issuer= /C=US/O=Amazon/OU=Server CA 1B/CN=Amazon
         SHA1 Fingerprint=91:A5:18:25:2A:98:83:99:FD:9F:B5:47:87:21:33:C9:44:D1:25:FB
         
         TRUSTKIT CONFIGURATION
         ----------------------
         kTSKPublicKeyHashes: @[@"kGVk9fFZTwtM7fHft4dQVFnBER50rTQmTi1NEZ/AcUk="] // You will also need to configure a backup pin
         kTSKPublicKeyAlgorithms: @[kTSKAlgorithmRsa2048]
         */
        
        let fakeKey : String = "lJqgaL1BxI+pFO2Jc3Q+vMPT0wHSFWl3OROLy1Ra1jE="
        let sslKey : String = CommonUnit.stringFromAny(Constant.Models.appSettings?.sslKey)
        let appDomain : String = (BaseURL == DocURLData.baseURL_Live) ? "docapp.com" : "staging.docapp.com"
 
        TrustKitSSLValidator.sharedClient().callSSlPinning(withDomain: appDomain, publicKey: sslKey, andBackupKey: fakeKey) { isCompelete in
            if isCompelete {
                completion!()
            }
        }
    }
    
    //MARK:- Convert Dictionary to Json
    func convertDictToJson(dict : NSDictionary) -> NSDictionary? {
        var jsonDict : NSDictionary!
        do {
            let jsonData = try JSONSerialization.data(withJSONObject:dict, options:[])
            let jsonDataString = String(data: jsonData, encoding: String.Encoding.utf8)!
            print("Post Request Params : \(jsonDataString)")
            jsonDict = [ParameterKey : jsonDataString]
            return jsonDict
        } catch {
            print("JSON serialization failed:  \(error)")
            jsonDict = nil
        }
        return jsonDict
    }
    
    //MARK:- Convert Array to Json
    func convertArrayToJson(array : NSArray, parameterKey : String) -> [String : AnyObject]? {
        var jsonDict : [String : AnyObject]?
        do {
            let jsonData = try JSONSerialization.data(withJSONObject:array, options:[])
            let jsonDataString = String(data: jsonData, encoding: String.Encoding.utf8)!
            jsonDict = [parameterKey : jsonDataString as AnyObject]
            return jsonDict
        } catch {
            print("JSON serialization failed:  \(error)")
            jsonDict = nil
        }
        return jsonDict
    }
    
    //MARK:- Cancel All Previous Request
    func cancelAllPreviousRequest() {        
        self.sessionMngr.session.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
    }
    
    //MARK:- Set Login screen after header token expire
    func setLogInAfterTokenExpire(errorMsg : String) {
        CommonUnit.progressHUD(.dismiss)
        CommonUnit.showAlertController(Constant.GlobalVars.navVC.visibleViewController!, Constant.LocalizationKey.OopsWithExclamation, message: errorMsg.isEmpty ? Constant.LocalizationKey.ErrorHeaderTokenExpire : errorMsg, cancelTitle: nil, cancelCompletion: nil, okTitle: Constant.LocalizationKey.OK, okCompletion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                CommonUnit.setLandingScreenAfterLogOut()
            }
        })
    }
    
    //MARK:- Post Request
    func postRequestForAPI(apiType : WSRequestType, parameters : [String : AnyObject]? = nil, completionHandler:@escaping (_ responseObject : NSDictionary?, _ error : NSError?) -> Void) {
        if !isConnectedToNetwork(){
            if apiType == .WSRequestTypeLogIn || apiType == .WSRequestTypeAppSettings {
                let error = NSError(domain: "", code: 555555, userInfo: [NSLocalizedDescriptionKey: Constant.LocalizationKey.NoNetworkMsg])
                completionHandler(nil,error)
                return
            }
            CommonUnit.progressHUD(.dismiss)
            CommonUnit.showAlertController(Constant.GlobalVars.navVC.visibleViewController!, Constant.LocalizationKey.Error, message: Constant.LocalizationKey.NoNetworkMsg, cancelTitle: Constant.LocalizationKey.Cancel, cancelCompletion: nil, okTitle: Constant.LocalizationKey.OK, okCompletion: nil)
            return
        }
        
        let configuration : URLSessionConfiguration = URLSessionConfiguration.default
        sessionMngr = SessionManager.init(configuration: configuration)
        
        //--------------------- Request API ------------------------------
        func requestAPI(strApiPath : String, params : Parameters?, reqHeaders : HTTPHeaders){
            self.sessionMngr.request(strApiPath, method: .post, parameters: params, headers: reqHeaders) .responseJSON { response in
                switch(response.result) {
                case .success(_):
                    do {
                        let JSON = try JSONSerialization.jsonObject(with: response.data! as Data, options:JSONSerialization.ReadingOptions(rawValue: 0))
                        
                        guard let JSONDictionary: NSDictionary = JSON as? NSDictionary else {
                            print("Not a Dictionary")
                            return
                        }
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: JSONDictionary, options: .prettyPrinted)
                        if let json = String(data: jsonData, encoding: .utf8){
                            print("Post json Response: \(json)")
                        }
                        
                        if let status = Int(CommonUnit.stringFromAny(JSONDictionary[Constant.APIKeys.status] as AnyObject)){
                            switch status {
                            case Constant.APIStatusCode.success:
                                if let badge = Int(CommonUnit.stringFromAny(JSONDictionary[Constant.APIKeys.badge_count] as AnyObject)){
                                    CommonUnit.setBadgeCount(badgeCount: badge)
                                }
                                break
                            case Constant.APIStatusCode.headerTokenExpire:
                                switch apiType {
                                    case .WSRequestTypeAppSettings,
                                         .WSRequestTypeLogIn:
                                    break
                                default:
                                    self.setLogInAfterTokenExpire(errorMsg: CommonUnit.stringFromAny(JSONDictionary[Constant.APIKeys.message]))
                                    return
                                }
                            default:
                                break
                            }
                        }
                        
                        completionHandler(JSONDictionary,nil)
                    }
                    catch let JSONError as NSError {
                        print("\(JSONError)")
                    }
                    break
                case .failure(_):
                    print("failure Http: \(String(describing: response.result.error?.localizedDescription))")
                    if let error = response.result.error as NSError? {
                        switch error.code {
                        case -1005:
                            print("Status Code - > \(error.code)\n")
                            print("Connection Error - > \(error.localizedDescription) \n")
                            CommonUnit.setNetworkConnectionLostLog(error)
                            requestAPI(strApiPath: strApiPath, params: params, reqHeaders: reqHeaders)
                            return
                        default:
                            break
                        }
                    }
                    completionHandler(nil,response.result.error! as NSError)
                    break
                }
            }
        }
        
        //----------------------------------------------------------------
        
        let apipath : String = getAPI(apiType: apiType)
        
        do{
            if parameters != nil {
                let paramsData = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
                if let params = String(data: paramsData, encoding: .utf8) {
                    print("Post Requset json Params: \(params)")
                }
            }
        }
        catch let JSONError as NSError {
            print("\(JSONError)")
        }
        
        var apiParams : NSDictionary!
        
        if (parameters != nil){
            apiParams = convertDictToJson(dict: parameters! as NSDictionary)
        }
        
        print("Post Requset URL : \(apipath)")
        
        var appVersion: String? = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }
        
        var strHeaderToken : String? = ""
        var strDeviceToken : String? = ""
        
        CommonUnit.globalValues(.headerToken, .get) { (headerToken) in
            strHeaderToken = CommonUnit.stringFromAny(headerToken)
        }
        
        CommonUnit.globalValues(.deviceToken, .get) { (deviceToken) in
            strDeviceToken = CommonUnit.stringFromAny(deviceToken)
        }
        
        let requestHeader: HTTPHeaders = ["header_token": strHeaderToken!,
                                          "device_type": "1",
                                          "device_token": strDeviceToken!,
                                          "app_version": appVersion!,
                                          "Accept": "application/json"]
        
        print("Post Request Header : \(String(describing: requestHeader))")
        
        if Constant.Models.appSettings != nil {
            if (Constant.Models.appSettings?.sslKey?.isEmpty)! {
                requestAPI(strApiPath: apipath, params: apiParams as? Parameters, reqHeaders: requestHeader)
            }else{
                self.checkSSLPinning {
                    self.sessionMngr.delegate.sessionDidReceiveChallengeWithCompletion = {session, challenge, completionHandler in
                        print("session is \(session), challenge is \(challenge.protectionSpace.authenticationMethod) and handler is \(completionHandler)")
                        if  !TrustKit.sharedInstance().pinningValidator .handle(challenge, completionHandler: completionHandler){
                            // TrustKit did not handle this challenge: perhaps it was not for server trust
                            // or the domain was not pinned. Fall back to the default behavior
                            completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
                        }
                    }
                    requestAPI(strApiPath: apipath, params: apiParams as? Parameters, reqHeaders: requestHeader)
                }
            }
        }else{
            requestAPI(strApiPath: apipath, params: apiParams as? Parameters, reqHeaders: requestHeader)
        }
    }
    
    
    //MARK:- Post Request for Zoom API
    func postRequestForScheduleZoomMeeting(userid : String? = nil, parameters : [String : AnyObject]? = nil, completionHandler:@escaping (_ responseObject : NSDictionary?, _ error : NSError?) -> Void) {
        if !isConnectedToNetwork(){
            CommonUnit.progressHUD(.dismiss)
            CommonUnit.showAlertController(Constant.GlobalVars.navVC.visibleViewController!, Constant.LocalizationKey.Error, message: Constant.LocalizationKey.NoNetworkMsg, cancelTitle: Constant.LocalizationKey.Cancel, cancelCompletion: nil, okTitle: Constant.LocalizationKey.OK, okCompletion: nil)
            return
        }
        
        let apipath : String = DocURLData.zoomBaseUserURL+"/"+userid!+"/meetings" // append : /userid/meetings
        
        do{
            if parameters != nil {
                let paramsData = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
                if let params = String(data: paramsData, encoding: .utf8) {
                    print("Post Requset json Params: \(params)")
                }
            }
        }
        catch let JSONError as NSError {
            print("\(JSONError)")
        }
        
        
        print("Post Requset URL : \(apipath)")
        
        let requestHeader: HTTPHeaders = ["Authorization": String(format : "Bearer %@",CommonUnit.stringFromAny(Constant.Models.appSettings?.zoomKeys?.token)),
                                          "Accept": "application/json, application/xml",
                                          "Content-Type": "application/json"]
        
        print("Post Request Header : \(String(describing: requestHeader))")
        
        
        Alamofire.request(apipath, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: requestHeader)
            .responseJSON { response in
                switch(response.result) {
                case .success(_):
                    do {
                        let JSON = try JSONSerialization.jsonObject(with: response.data! as Data, options:JSONSerialization.ReadingOptions(rawValue: 0))
                        
                        if response.response?.statusCode != 201 {
                            if response.response?.statusCode == 401 {
                                let error1 = NSError(domain: "", code: (response.response?.statusCode)!, userInfo: [NSLocalizedDescriptionKey: Constant.LocalizationKey.ErrorInvalidToken])
                                completionHandler(nil,error1)
                            }else{
                                let error1 = NSError(domain: "", code: 555555, userInfo: [NSLocalizedDescriptionKey: Constant.LocalizationKey.ErrorBlankZoomId])
                                completionHandler(nil,error1)
                            }
                            return
                        }
                        
                        guard let JSONDictionary: NSDictionary = JSON as? NSDictionary else {
                            print("Not a Dictionary")
                            return
                        }
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: JSONDictionary, options: .prettyPrinted)
                        if let json = String(data: jsonData, encoding: .utf8){
                            print("Post json Response: \(json)")
                        }
                        completionHandler(JSONDictionary,nil)
                    }
                    catch let JSONError as NSError {
                        print("\(JSONError)")
                    }
                    break
                case .failure(_):
                    print("failure Http: \(String(describing: response.result.error?.localizedDescription))")
                    completionHandler(nil,response.result.error! as NSError)
                    break
                }
        }
    }
    
    func postRequestForDeleteZoomMeeting(meetingId : String?, completionHandler:@escaping (_ responseObject : NSDictionary?, _ error : NSError?) -> Void) {
        
        if (meetingId?.isEmpty)! {
            return
        }
        
        if !isConnectedToNetwork(){
            CommonUnit.progressHUD(.dismiss)
            CommonUnit.showAlertController(Constant.GlobalVars.navVC.visibleViewController!, Constant.LocalizationKey.Error, message: Constant.LocalizationKey.NoNetworkMsg, cancelTitle: Constant.LocalizationKey.Cancel, cancelCompletion: nil, okTitle: Constant.LocalizationKey.OK, okCompletion: nil)
            return
        }
        
        let apipath : String = DocURLData.zoomBaseMeetingURL+meetingId!
        print("Post Requset URL : \(apipath)")
        
        let requestHeader: HTTPHeaders = ["Authorization": String(format : "Bearer %@",CommonUnit.stringFromAny(Constant.Models.appSettings?.zoomKeys?.token)),
                                          "Accept": "application/json, application/xml",
                                          "Content-Type": "application/json"]
        
        print("Post Request Header : \(String(describing: requestHeader))")
        
        
        Alamofire.request(apipath, method: .delete, encoding: JSONEncoding.default, headers: requestHeader)
            .responseJSON { response in
                switch(response.result) {
                case .success(_):
                    do {
                        if response.response?.statusCode == 204 {
                            
                            let JSON = try JSONSerialization.jsonObject(with: response.data! as Data, options:JSONSerialization.ReadingOptions(rawValue: 0))
                            
                            guard let JSONDictionary: NSDictionary = JSON as? NSDictionary else {
                                print("Not a Dictionary")
                                return
                            }
                            
                            let jsonData = try JSONSerialization.data(withJSONObject: JSONDictionary, options: .prettyPrinted)
                            if let json = String(data: jsonData, encoding: .utf8){
                                print("Post json Response: \(json)")
                            }
                            completionHandler(JSONDictionary,nil)
                        }
                    }
                    catch let JSONError as NSError {
                        print("\(JSONError)")
                    }
                    break
                case .failure(_):
                    print("failure Http: \(String(describing: response.result.error?.localizedDescription))")
                    completionHandler(nil,response.result.error! as NSError)
                    break
                }
        }
    }
    
    //MARK:- Get Request
    func getRequestForAPI(apiType : WSRequestType, completionHandler:@escaping (_ responseObject : NSDictionary?, _ error : NSError?) -> Void) {
        if !isConnectedToNetwork(){
            CommonUnit.progressHUD(.dismiss)
            CommonUnit.showAlertController(Constant.GlobalVars.navVC.visibleViewController!, Constant.LocalizationKey.Error, message: Constant.LocalizationKey.NoNetworkMsg, cancelTitle: Constant.LocalizationKey.Cancel, cancelCompletion: nil, okTitle: Constant.LocalizationKey.OK, okCompletion: nil)
            return
        }
        
        let configuration : URLSessionConfiguration = URLSessionConfiguration.default
        sessionMngr = SessionManager.init(configuration: configuration)
        
        //--------------------- Request API ------------------------------
        func requestAPI(strApiPath : String, reqHeaders : HTTPHeaders){
            self.sessionMngr.request(strApiPath, method: .get, parameters: nil, encoding: URLEncoding.default, headers: reqHeaders)
                .responseJSON { response in
                    switch(response.result) {
                    case .success(_):
                        do {
                            let JSON = try JSONSerialization.jsonObject(with: response.data! as Data, options:JSONSerialization.ReadingOptions(rawValue: 0))
                            guard let JSONDictionary: NSDictionary = JSON as? NSDictionary else {
                                print("Not a Dictionary")
                                return
                            }
                            
                            let jsonData = try JSONSerialization.data(withJSONObject: JSONDictionary, options: .prettyPrinted)
                            if let json = String(data: jsonData, encoding: .utf8){
                                print("Get json Response: \(json)")
                            }
                            
                            completionHandler(JSONDictionary,nil)
                        }
                        catch let JSONError as NSError {
                            print("\(JSONError)")
                        }
                        break
                    case .failure(_):
                        print("failure Http: \(String(describing: response.result.error?.localizedDescription))")
                        completionHandler(nil,response.result.error! as NSError)
                        break
                    }
            }
        }
        
        //----------------------------------------------------------------
        
        let apipath : String = getAPI(apiType: apiType)
        
        print("Get Requset URL : \(apipath)")
        
        var appVersion: String? = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }
        
        var strHeaderToken : String? = ""
        var strDeviceToken : String? = ""
        
        CommonUnit.globalValues(.headerToken, .get) { (headerToken) in
            strHeaderToken = CommonUnit.stringFromAny(headerToken)
        }
        
        CommonUnit.globalValues(.deviceToken, .get) { (deviceToken) in
            strDeviceToken = CommonUnit.stringFromAny(deviceToken)
        }
        
        let requestHeader: HTTPHeaders = ["header_token": strHeaderToken!,
                                          "device_type": "1",
                                          "device_token": strDeviceToken!,
                                          "app_version": appVersion!,
                                          "Accept": "application/json"]
        print("Get Request Header : \(String(describing: requestHeader))")
        
        if Constant.Models.appSettings != nil {
            if (Constant.Models.appSettings?.sslKey?.isEmpty)! {
                requestAPI(strApiPath: apipath, reqHeaders: requestHeader)
            }else{
                self.checkSSLPinning {
                    self.sessionMngr.delegate.sessionDidReceiveChallengeWithCompletion = {session, challenge, completionHandler in
                        print("session is \(session), challenge is \(challenge.protectionSpace.authenticationMethod) and handler is \(completionHandler)")
                        if  !TrustKit.sharedInstance().pinningValidator .handle(challenge, completionHandler: completionHandler){
                            // TrustKit did not handle this challenge: perhaps it was not for server trust
                            // or the domain was not pinned. Fall back to the default behavior
                            completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
                        }
                    }
                    requestAPI(strApiPath: apipath, reqHeaders: requestHeader)
                }
            }
        }else{
            requestAPI(strApiPath: apipath, reqHeaders: requestHeader)
        }
    }
    
    //MARK:- Get Image Upload Path
    func getImgUploadPath(imgType : UploadImgType) -> String{
        switch imgType{
        case .coverPic:
            return BaseURL+"Api/"+ImgPath.CoverPicPath.rawValue
        case .profilePic:
            return BaseURL+"Api/"+ImgPath.ProfilePicPath.rawValue
        }
    }
    
    //MARK:- Image Upload multipart
    func imageUploadFromURL(imgType: UploadImgType, strImage : String, parameter: [String:String]? = nil, completionHandler: @escaping (_ uploadStatus : MultipartUploadStatus) -> Void) {
        downloadImage(url: strImage) { (_ error : NSError?, _ image : UIImage?) -> Void in
            self.imageUpload(imgType: imgType, image: image!, parameter: parameter) { (_ imgUploadStatus) in
                completionHandler(imgUploadStatus)
            }
        }
    }
    
    func doctorSignUpAPI(imgArray : [DoctorRegistrationImgData], parameter: [String:AnyObject]? = nil, completionHandler: @escaping (_ uploadStatus : MultipartUploadStatus) -> Void) {
        
        if !isConnectedToNetwork(){
            CommonUnit.progressHUD(.dismiss)
            CommonUnit.showAlertController(Constant.GlobalVars.navVC.visibleViewController!, Constant.LocalizationKey.Error, message: Constant.LocalizationKey.NoNetworkMsg, cancelTitle: Constant.LocalizationKey.Cancel, cancelCompletion: nil, okTitle: Constant.LocalizationKey.OK, okCompletion: nil)
            return
        }
        
        let configuration : URLSessionConfiguration = URLSessionConfiguration.default
        sessionMngr = SessionManager.init(configuration: configuration)
        
        //--------------------- Request API ------------------------------
        func requestAPI(strUploadPath : String, params : Parameters?, reqHeaders : HTTPHeaders){
            self.sessionMngr.upload(multipartFormData: { (multipartFormData) in
                
                for (_,docImgData) in imgArray.enumerated() {
                    let imgData : Data = docImgData.image.resizedTo200Kb()!
                    multipartFormData.append(imgData, withName: docImgData.imgName.rawValue, fileName: "filedata.jpg", mimeType: "image/jpeg")
                }
                
                print("mutlipart 1st \(multipartFormData)")
                if (params != nil){
                    for (key, value) in params! {
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
                    print("mutlipart 2nd \(multipartFormData)")
                }
            }, to:strUploadPath, method:.post, headers:reqHeaders)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        completionHandler(.uploading(progress: Float(Progress.fractionCompleted)))
                    })
                    
                    upload.responseJSON { response in
                        
                        if let JSON = response.result.value {
                            completionHandler(.success(progress: 1.0, response: JSON as! NSDictionary))
                            let JSONDictionary = JSON as! NSDictionary
                            if let status = Int(CommonUnit.stringFromAny(JSONDictionary[Constant.APIKeys.status] as AnyObject)){
                                switch status {
                                case Constant.APIStatusCode.success:
                                    if let badge = Int(CommonUnit.stringFromAny(JSONDictionary[Constant.APIKeys.badge_count] as AnyObject)){
                                        CommonUnit.setBadgeCount(badgeCount: badge)
                                    }
                                    break
                                case Constant.APIStatusCode.headerTokenExpire:
                                    self.setLogInAfterTokenExpire(errorMsg: CommonUnit.stringFromAny(JSONDictionary[Constant.APIKeys.message]))
                                    return
                                default:
                                    break
                                }
                            }
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    completionHandler(.failure(error: encodingError as NSError))
                }
            }
        }
        //----------------------------------------------------------------
        
        
        let uploadPath : String = getAPI(apiType: .WSRequestTypeCreateAccount)
        
        var appVersion: String? = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }
        
        var strHeaderToken : String? = ""
        var strDeviceToken : String? = ""
        
        CommonUnit.globalValues(.headerToken, .get) { (headerToken) in
            strHeaderToken = CommonUnit.stringFromAny(headerToken)
        }
        
        CommonUnit.globalValues(.deviceToken, .get) { (deviceToken) in
            strDeviceToken = CommonUnit.stringFromAny(deviceToken)
        }
        
        let requestHeader: HTTPHeaders = ["header_token": strHeaderToken!,
                                          "device_type": "1",
                                          "device_token": strDeviceToken!,
                                          "app_version": appVersion!,
                                          "Accept": "application/json"]
        
        var apiParams : NSDictionary!
        
        if (parameter != nil){
            apiParams = convertDictToJson(dict: parameter! as NSDictionary)
        }
        
        print("Request Header : \(requestHeader)")
        
        if Constant.Models.appSettings != nil {
            if (Constant.Models.appSettings?.sslKey?.isEmpty)! {
                requestAPI(strUploadPath: uploadPath, params: apiParams as? Parameters, reqHeaders: requestHeader)
            }else{
                self.checkSSLPinning {
                    self.sessionMngr.delegate.sessionDidReceiveChallengeWithCompletion = {session, challenge, completionHandler in
                        print("session is \(session), challenge is \(challenge.protectionSpace.authenticationMethod) and handler is \(completionHandler)")
                        if  !TrustKit.sharedInstance().pinningValidator .handle(challenge, completionHandler: completionHandler){
                            // TrustKit did not handle this challenge: perhaps it was not for server trust
                            // or the domain was not pinned. Fall back to the default behavior
                            completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
                        }
                    }
                    requestAPI(strUploadPath: uploadPath, params: apiParams as? Parameters, reqHeaders: requestHeader)
                }
            }
        }else{
            requestAPI(strUploadPath: uploadPath, params: apiParams as? Parameters, reqHeaders: requestHeader)
        }
    }
    
    func doctorProfileUpdateAPI(imgArray : [DoctorRegistrationImgData], parameter: [String:AnyObject]? = nil, completionHandler: @escaping (_ uploadStatus : MultipartUploadStatus) -> Void) {
        
        if !isConnectedToNetwork(){
            CommonUnit.progressHUD(.dismiss)
            CommonUnit.showAlertController(Constant.GlobalVars.navVC.visibleViewController!, Constant.LocalizationKey.Error, message: Constant.LocalizationKey.NoNetworkMsg, cancelTitle: Constant.LocalizationKey.Cancel, cancelCompletion: nil, okTitle: Constant.LocalizationKey.OK, okCompletion: nil)
            return
        }
        
        let configuration : URLSessionConfiguration = URLSessionConfiguration.default
        sessionMngr = SessionManager.init(configuration: configuration)
        
        //--------------------- Request API ------------------------------
        func requestAPI(strUploadPath : String, params : Parameters?, reqHeaders : HTTPHeaders){
            self.sessionMngr.upload(multipartFormData: { (multipartFormData) in
                
                for (_,docImgData) in imgArray.enumerated() {
                    let imgData : Data = docImgData.image.resizedTo200Kb()!
                    multipartFormData.append(imgData, withName: docImgData.imgName.rawValue, fileName: "filedata.jpg", mimeType: "image/jpeg")
                }
                
                print("mutlipart 1st \(multipartFormData)")
                if (params != nil){
                    for (key, value) in params! {
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                    }
                    print("mutlipart 2nd \(multipartFormData)")
                }
            }, to:strUploadPath, method:.post, headers:reqHeaders)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        completionHandler(.uploading(progress: Float(Progress.fractionCompleted)))
                    })
                    
                    upload.responseJSON { response in
                        
                        if let JSON = response.result.value {
                            completionHandler(.success(progress: 1.0, response: JSON as! NSDictionary))
                            let JSONDictionary = JSON as! NSDictionary
                            if let status = Int(CommonUnit.stringFromAny(JSONDictionary[Constant.APIKeys.status] as AnyObject)){
                                switch status {
                                case Constant.APIStatusCode.success:
                                    if let badge = Int(CommonUnit.stringFromAny(JSONDictionary[Constant.APIKeys.badge_count] as AnyObject)){
                                        CommonUnit.setBadgeCount(badgeCount: badge)
                                    }
                                    break
                                case Constant.APIStatusCode.headerTokenExpire:
                                    self.setLogInAfterTokenExpire(errorMsg: CommonUnit.stringFromAny(JSONDictionary[Constant.APIKeys.message]))
                                    return
                                default:
                                    break
                                }
                            }
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    completionHandler(.failure(error: encodingError as NSError))
                }
            }
        }
        //----------------------------------------------------------------
        
        let uploadPath : String = getAPI(apiType: .WSRequestTypeUpdateProfile)
        
        var appVersion: String? = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }
        
        var strHeaderToken : String? = ""
        var strDeviceToken : String? = ""
        
        CommonUnit.globalValues(.headerToken, .get) { (headerToken) in
            strHeaderToken = CommonUnit.stringFromAny(headerToken)
        }
        
        CommonUnit.globalValues(.deviceToken, .get) { (deviceToken) in
            strDeviceToken = CommonUnit.stringFromAny(deviceToken)
        }
        
        let requestHeader: HTTPHeaders = ["header_token": strHeaderToken!,
                                          "device_type": "1",
                                          "device_token": strDeviceToken!,
                                          "app_version": appVersion!,
                                          "Accept": "application/json"]
        
        var apiParams : NSDictionary!
        
        if (parameter != nil){
            apiParams = convertDictToJson(dict: parameter! as NSDictionary)
        }
        
        print("Request Header : \(requestHeader)")
        
        if Constant.Models.appSettings != nil {
            if (Constant.Models.appSettings?.sslKey?.isEmpty)! {
                requestAPI(strUploadPath: uploadPath, params: apiParams as? Parameters, reqHeaders: requestHeader)
            }else{
                self.checkSSLPinning {
                    self.sessionMngr.delegate.sessionDidReceiveChallengeWithCompletion = {session, challenge, completionHandler in
                        print("session is \(session), challenge is \(challenge.protectionSpace.authenticationMethod) and handler is \(completionHandler)")
                        if  !TrustKit.sharedInstance().pinningValidator .handle(challenge, completionHandler: completionHandler){
                            // TrustKit did not handle this challenge: perhaps it was not for server trust
                            // or the domain was not pinned. Fall back to the default behavior
                            completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
                        }
                    }
                    requestAPI(strUploadPath: uploadPath, params: apiParams as? Parameters, reqHeaders: requestHeader)
                }
            }
        }else{
            requestAPI(strUploadPath: uploadPath, params: apiParams as? Parameters, reqHeaders: requestHeader)
        }
    }
    
    func AppointmentAddPhotoAPI(appointmentImgData : AppointmentImgData, parameter: [String:AnyObject]? = nil, completionHandler: @escaping (_ uploadStatus : MultipartUploadStatus) -> Void) {
        
        if !isConnectedToNetwork(){
            CommonUnit.progressHUD(.dismiss)
            CommonUnit.showAlertController(Constant.GlobalVars.navVC.visibleViewController!, Constant.LocalizationKey.Error, message: Constant.LocalizationKey.NoNetworkMsg, cancelTitle: Constant.LocalizationKey.Cancel, cancelCompletion: nil, okTitle: Constant.LocalizationKey.OK, okCompletion: nil)
            return
        }
        
        let configuration : URLSessionConfiguration = URLSessionConfiguration.default
        sessionMngr = SessionManager.init(configuration: configuration)
        
        //--------------------- Request API ------------------------------
        func requestAPI(strUploadPath : String, params : Parameters?, reqHeaders : HTTPHeaders){
            self.sessionMngr.upload(multipartFormData: { (multipartFormData) in
                
                let imgData : Data = appointmentImgData.image.resizedTo200Kb()!
                multipartFormData.append(imgData, withName: appointmentImgData.imgName, fileName: "filedata.jpg", mimeType: "image/jpeg")
                
                print("mutlipart 1st \(multipartFormData)")
                if (params != nil){
                    for (key, value) in params! {
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                    }
                    print("mutlipart 2nd \(multipartFormData)")
                }
            }, to:strUploadPath, method:.post, headers:reqHeaders)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        completionHandler(.uploading(progress: Float(Progress.fractionCompleted)))
                    })
                    
                    upload.responseJSON { response in
                        
                        if let JSON = response.result.value {
                            completionHandler(.success(progress: 1.0, response: JSON as! NSDictionary))
                            let JSONDictionary = JSON as! NSDictionary
                            if let status = Int(CommonUnit.stringFromAny(JSONDictionary[Constant.APIKeys.status] as AnyObject)){
                                switch status {
                                case Constant.APIStatusCode.success:
                                    if let badge = Int(CommonUnit.stringFromAny(JSONDictionary[Constant.APIKeys.badge_count] as AnyObject)){
                                        CommonUnit.setBadgeCount(badgeCount: badge)
                                    }
                                    break
                                case Constant.APIStatusCode.headerTokenExpire:
                                    self.setLogInAfterTokenExpire(errorMsg: CommonUnit.stringFromAny(JSONDictionary[Constant.APIKeys.message]))
                                    return
                                default:
                                    break
                                }
                            }
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    completionHandler(.failure(error: encodingError as NSError))
                }
            }
        }
        //----------------------------------------------------------------
        
        let uploadPath : String = getAPI(apiType: .WSRequestTypeAddAppointmentPhotos)
        
        var appVersion: String? = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }
        
        var strHeaderToken : String? = ""
        var strDeviceToken : String? = ""
        
        CommonUnit.globalValues(.headerToken, .get) { (headerToken) in
            strHeaderToken = CommonUnit.stringFromAny(headerToken)
        }
        
        CommonUnit.globalValues(.deviceToken, .get) { (deviceToken) in
            strDeviceToken = CommonUnit.stringFromAny(deviceToken)
        }
        
        let requestHeader: HTTPHeaders = ["header_token": strHeaderToken!,
                                          "device_type": "1",
                                          "device_token": strDeviceToken!,
                                          "app_version": appVersion!,
                                          "Accept": "application/json"]
        
        var apiParams : NSDictionary!
        
        if (parameter != nil){
            apiParams = convertDictToJson(dict: parameter! as NSDictionary)
        }
        
        print("Request Header : \(requestHeader)")
        
        if Constant.Models.appSettings != nil {
            if (Constant.Models.appSettings?.sslKey?.isEmpty)! {
                requestAPI(strUploadPath: uploadPath, params: apiParams as? Parameters, reqHeaders: requestHeader)
            }else{
                self.checkSSLPinning {
                    self.sessionMngr.delegate.sessionDidReceiveChallengeWithCompletion = {session, challenge, completionHandler in
                        print("session is \(session), challenge is \(challenge.protectionSpace.authenticationMethod) and handler is \(completionHandler)")
                        if  !TrustKit.sharedInstance().pinningValidator .handle(challenge, completionHandler: completionHandler){
                            // TrustKit did not handle this challenge: perhaps it was not for server trust
                            // or the domain was not pinned. Fall back to the default behavior
                            completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
                        }
                    }
                    requestAPI(strUploadPath: uploadPath, params: apiParams as? Parameters, reqHeaders: requestHeader)
                }
            }
        }else{
            requestAPI(strUploadPath: uploadPath, params: apiParams as? Parameters, reqHeaders: requestHeader)
        }
    }
    
    func bookOrderAPI(imgArray : [InsuranceImgData], parameter: [String:AnyObject]? = nil, completionHandler: @escaping (_ uploadStatus : MultipartUploadStatus) -> Void) {
        
        if !isConnectedToNetwork(){
            CommonUnit.progressHUD(.dismiss)
            CommonUnit.showAlertController(Constant.GlobalVars.navVC.visibleViewController!, Constant.LocalizationKey.Error, message: Constant.LocalizationKey.NoNetworkMsg, cancelTitle: Constant.LocalizationKey.Cancel, cancelCompletion: nil, okTitle: Constant.LocalizationKey.OK, okCompletion: nil)
            return
        }
        
        let configuration : URLSessionConfiguration = URLSessionConfiguration.default
        sessionMngr = SessionManager.init(configuration: configuration)
        
        //--------------------- Request API ------------------------------
        func requestAPI(strUploadPath : String, params : Parameters?, reqHeaders : HTTPHeaders){
            self.sessionMngr.upload(multipartFormData: { (multipartFormData) in
                
                for (_,insuranceImgData) in imgArray.enumerated() {
                    let imgData : Data = insuranceImgData.image.resizedTo200Kb()!
                    multipartFormData.append(imgData, withName: insuranceImgData.imgName, fileName: "filedata.jpg", mimeType: "image/jpeg")
                }
                
                print("mutlipart 1st \(multipartFormData)")
                if (params != nil){
                    for (key, value) in params! {
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                    }
                    print("mutlipart 2nd \(multipartFormData)")
                }
            }, to:strUploadPath, method:.post, headers:reqHeaders)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        completionHandler(.uploading(progress: Float(Progress.fractionCompleted)))
                    })
                    
                    upload.responseJSON { response in
                        
                        if let JSON = response.result.value {
                            completionHandler(.success(progress: 1.0, response: JSON as! NSDictionary))
                            let JSONDictionary = JSON as! NSDictionary
                            if let status = Int(CommonUnit.stringFromAny(JSONDictionary[Constant.APIKeys.status] as AnyObject)){
                                switch status {
                                case Constant.APIStatusCode.success:
                                    if let badge = Int(CommonUnit.stringFromAny(JSONDictionary[Constant.APIKeys.badge_count] as AnyObject)){
                                        CommonUnit.setBadgeCount(badgeCount: badge)
                                    }
                                    break
                                case Constant.APIStatusCode.headerTokenExpire:
                                    self.setLogInAfterTokenExpire(errorMsg: CommonUnit.stringFromAny(JSONDictionary[Constant.APIKeys.message]))
                                    return
                                default:
                                    break
                                }
                            }
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    completionHandler(.failure(error: encodingError as NSError))
                }
            }
        }
        //----------------------------------------------------------------
        
        let uploadPath : String = getAPI(apiType: .WSRequestTypeAppointmentBooking)
        
        var appVersion: String? = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }
        
        var strHeaderToken : String? = ""
        var strDeviceToken : String? = ""
        
        CommonUnit.globalValues(.headerToken, .get) { (headerToken) in
            strHeaderToken = CommonUnit.stringFromAny(headerToken)
        }
        
        CommonUnit.globalValues(.deviceToken, .get) { (deviceToken) in
            strDeviceToken = CommonUnit.stringFromAny(deviceToken)
        }
        
        let requestHeader: HTTPHeaders = ["header_token": strHeaderToken!,
                                          "device_type": "1",
                                          "device_token": strDeviceToken!,
                                          "app_version": appVersion!,
                                          "Accept": "application/json"]
        
        var apiParams : NSDictionary!
        
        if (parameter != nil){
            apiParams = convertDictToJson(dict: parameter! as NSDictionary)
        }
        
        print("Request Header : \(requestHeader)")
        
        if Constant.Models.appSettings != nil {
            if (Constant.Models.appSettings?.sslKey?.isEmpty)! {
                requestAPI(strUploadPath: uploadPath, params: apiParams as? Parameters, reqHeaders: requestHeader)
            }else{
                self.checkSSLPinning {
                    self.sessionMngr.delegate.sessionDidReceiveChallengeWithCompletion = {session, challenge, completionHandler in
                        print("session is \(session), challenge is \(challenge.protectionSpace.authenticationMethod) and handler is \(completionHandler)")
                        if  !TrustKit.sharedInstance().pinningValidator .handle(challenge, completionHandler: completionHandler){
                            // TrustKit did not handle this challenge: perhaps it was not for server trust
                            // or the domain was not pinned. Fall back to the default behavior
                            completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
                        }
                    }
                    requestAPI(strUploadPath: uploadPath, params: apiParams as? Parameters, reqHeaders: requestHeader)
                }
            }
        }else{
            requestAPI(strUploadPath: uploadPath, params: apiParams as? Parameters, reqHeaders: requestHeader)
        }
    }
    
    func imageUpload(imgType: UploadImgType, image : UIImage, parameter: [String:String]? = nil, completionHandler: @escaping (_ uploadStatus : MultipartUploadStatus) -> Void) {
        
        if !isConnectedToNetwork(){
            CommonUnit.progressHUD(.dismiss)
            CommonUnit.showAlertController(Constant.GlobalVars.navVC.visibleViewController!, Constant.LocalizationKey.Error, message: Constant.LocalizationKey.NoNetworkMsg, cancelTitle: Constant.LocalizationKey.Cancel, cancelCompletion: nil, okTitle: Constant.LocalizationKey.OK, okCompletion: nil)
            return
        }
        
        let configuration : URLSessionConfiguration = URLSessionConfiguration.default
        sessionMngr = SessionManager.init(configuration: configuration)
        
        //--------------------- Request API ------------------------------
        func requestAPI(strUploadPath : String, imageData : Data, params : Parameters?, reqHeaders : HTTPHeaders){
            self.sessionMngr.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(imageData, withName: "filedata", fileName: "filedata.jpg", mimeType: "image/jpeg")
                print("mutlipart 1st \(multipartFormData)")
                if (params != nil){
                    for (key, value) in params! {
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                    }
                    print("mutlipart 2nd \(multipartFormData)")
                }
            }, to:strUploadPath, method:.post, headers:reqHeaders)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        completionHandler(.uploading(progress: Float(Progress.fractionCompleted)))
                    })
                    
                    upload.responseJSON { response in
                        
                        if let JSON = response.result.value {
                            completionHandler(.success(progress: 1.0, response: JSON as! NSDictionary))
                            let JSONDictionary = JSON as! NSDictionary
                            if let status = Int(CommonUnit.stringFromAny(JSONDictionary[Constant.APIKeys.status] as AnyObject)){
                                switch status {
                                case Constant.APIStatusCode.success:
                                    if let badge = Int(CommonUnit.stringFromAny(JSONDictionary[Constant.APIKeys.badge_count] as AnyObject)){
                                        CommonUnit.setBadgeCount(badgeCount: badge)
                                    }
                                    break
                                case Constant.APIStatusCode.headerTokenExpire:
                                    self.setLogInAfterTokenExpire(errorMsg: CommonUnit.stringFromAny(JSONDictionary[Constant.APIKeys.message]))
                                    return
                                default:
                                    break
                                }
                            }
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    completionHandler(.failure(error: encodingError as NSError))
                }
            }
        }
        //----------------------------------------------------------------
        
        let uploadPath : String = getImgUploadPath(imgType: imgType)
        let imgData : Data = UIImageJPEGRepresentation(image, 1.0)!
        
        var appVersion: String? = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }
        
        var strHeaderToken : String? = ""
        var strDeviceToken : String? = ""
        
        CommonUnit.globalValues(.headerToken, .get) { (headerToken) in
            strHeaderToken = CommonUnit.stringFromAny(headerToken)
        }
        
        CommonUnit.globalValues(.deviceToken, .get) { (deviceToken) in
            strDeviceToken = CommonUnit.stringFromAny(deviceToken)
        }
        
        let requestHeader: HTTPHeaders = ["header_token": strHeaderToken!,
                                          "device_type": "1",
                                          "device_token": strDeviceToken!,
                                          "app_version": appVersion!,
                                          "Accept": "application/json"]
        
        var apiParams : NSDictionary!
        
        if (parameter != nil)
        {
            apiParams = convertDictToJson(dict: parameter! as NSDictionary)
        }
        
        print("Params : \(String(describing: apiParams)) and Header : \(requestHeader)")
        
        if Constant.Models.appSettings != nil {
            if (Constant.Models.appSettings?.sslKey?.isEmpty)! {
                requestAPI(strUploadPath: uploadPath, imageData: imgData, params: apiParams as? Parameters, reqHeaders: requestHeader)
            }else{
                self.checkSSLPinning {
                    self.sessionMngr.delegate.sessionDidReceiveChallengeWithCompletion = {session, challenge, completionHandler in
                        print("session is \(session), challenge is \(challenge.protectionSpace.authenticationMethod) and handler is \(completionHandler)")
                        if  !TrustKit.sharedInstance().pinningValidator .handle(challenge, completionHandler: completionHandler){
                            // TrustKit did not handle this challenge: perhaps it was not for server trust
                            // or the domain was not pinned. Fall back to the default behavior
                            completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
                        }
                    }
                    requestAPI(strUploadPath: uploadPath, imageData: imgData, params: apiParams as? Parameters, reqHeaders: requestHeader)
                }
            }
        }else{
            requestAPI(strUploadPath: uploadPath, imageData: imgData, params: apiParams as? Parameters, reqHeaders: requestHeader)
        }
    }
    
    //MARK:- Image Downloader
    func downloadImage(url: String, completionHandler: @escaping (_ error: NSError?, _ image:UIImage?)-> Void)
    {
        if url.isEmpty {
            completionHandler(nil,nil)
            return
        }
        
        if !isConnectedToNetwork(){
            CommonUnit.progressHUD(.dismiss)
            CommonUnit.showAlertController(Constant.GlobalVars.navVC.visibleViewController!, Constant.LocalizationKey.Error, message: Constant.LocalizationKey.NoNetworkMsg, cancelTitle: Constant.LocalizationKey.Cancel, cancelCompletion: nil, okTitle: Constant.LocalizationKey.OK, okCompletion: nil)
            return
        }
        
        let configuration : URLSessionConfiguration = URLSessionConfiguration.default
        sessionMngr = SessionManager.init(configuration: configuration)
        
        //--------------------- Request API ------------------------------
        func requestAPI(){
            self.sessionMngr.request(url)
                .downloadProgress { progress in
                    print("Download Progress: \(progress.fractionCompleted)")
                }
                .responseData { response in
                    if let data = response.result.value {
                        let image = UIImage(data: data)
                        completionHandler(nil,image)
                    }else{
                        completionHandler(nil,nil)
                    }
            }
        }
        //----------------------------------------------------------------
        
        if Constant.Models.appSettings != nil {
            if (Constant.Models.appSettings?.sslKey?.isEmpty)! {
                requestAPI()
            }else{
                self.checkSSLPinning {
                    self.sessionMngr.delegate.sessionDidReceiveChallengeWithCompletion = {session, challenge, completionHandler in
                        print("session is \(session), challenge is \(challenge.protectionSpace.authenticationMethod) and handler is \(completionHandler)")
                        if  !TrustKit.sharedInstance().pinningValidator .handle(challenge, completionHandler: completionHandler){
                            // TrustKit did not handle this challenge: perhaps it was not for server trust
                            // or the domain was not pinned. Fall back to the default behavior
                            completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
                        }
                    }
                    requestAPI()
                }
            }
        }else{
            requestAPI()
        }
    }
    
    //MARK:- Get location from address
    ///
    /// - Returns: Returns location, latitude, longitude, city, state, zipcode
    func getLocationFromAddress(address : String, completionHandler:@escaping (_ locationData : LocationData) -> Void) {
        CLGeocoder().geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error as Any)
            }
            
            var locData = LocationData.init()
            
            if let placemark = placemarks?.first {
                
                locData.address = address
                locData.latitude = String(format: "%.2f", Double(CommonUnit.stringFromAny((placemark.location?.coordinate.latitude)))!)
                locData.longitude = String(format: "%.2f", Double(CommonUnit.stringFromAny((placemark.location?.coordinate.longitude)))!)
                
                if let city = placemark.addressDictionary?["City"] as? String {
                    locData.city = city
                }
                
                if let state = placemark.addressDictionary?["State"] as? String {
                    locData.state = state
                }
                
                if let country = placemark.country {
                    locData.country = String(format: "%@", country)
                }
                
                if let postalCode = placemark.postalCode {
                    locData.postalCode = String(format: "%@", postalCode)
                }
                
                completionHandler(locData)
            }
        })
    }
    
    //MARK:- Get Auto complete address from google place API
    ///
    /// - Returns: Returns search Address array
    func getAddressWithSearchTxt(_ searchTxt : String, completionHandler:@escaping (_ arrSearchResults : [SearchResultsData]) -> Void) {
        if !isConnectedToNetwork(){
            CommonUnit.progressHUD(.dismiss)
            CommonUnit.showAlertController(Constant.GlobalVars.navVC.visibleViewController!, Constant.LocalizationKey.Error, message: Constant.LocalizationKey.NoNetworkMsg, cancelTitle: Constant.LocalizationKey.Cancel, cancelCompletion: nil, okTitle: Constant.LocalizationKey.OK, okCompletion: nil)
            return
        }
        
        let str = searchTxt.replacingOccurrences(of: " ", with: "+")
        let strURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?&key=\(Constant.GoogleAPIs.PlaceAPIKey)&input=\(str)"
        
        let searchUrl : URL = URL(string: strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        
        Alamofire.request(searchUrl, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                switch(response.result) {
                case .success(_):
                    do {
                        let JSON = try JSONSerialization.jsonObject(with: response.data! as Data, options:JSONSerialization.ReadingOptions(rawValue: 0))
                        
                        guard let JSONDictionary: NSDictionary = JSON as? NSDictionary else {
                            print("Not a Dictionary")
                            return
                        }
                        
                        var arrSearchResults = [SearchResultsData]()
                        for (_,prediction) in (JSONDictionary.value(forKey: searchDictKeys.predictions.rawValue) as! NSArray).enumerated(){
                            let searchData = SearchResultsData(placeId: ((prediction as AnyObject).value(forKey: searchDictKeys.place_id.rawValue) as? String)!, searchAddress: ((prediction as AnyObject).value(forKey: searchDictKeys.description.rawValue) as? String)!)
                            arrSearchResults.append(searchData)
                        }
                        
                        completionHandler(arrSearchResults)
                    }
                    catch let JSONError as NSError {
                        print("\(JSONError)")
                    }
                    break
                case .failure(_):
                    print("failure Http: \(String(describing: response.result.error?.localizedDescription))")
                    break
                }
        }
    }
    
    //MARK:- Get Location Lat/Lng
    ///
    /// - Returns: Returns location lat/lng
    func getLocationCoordinatesFromPlaceId(_ placeId : String,_ address : String, completionHandler:@escaping (_ locationData : LocationData) -> Void) {
        if !isConnectedToNetwork(){
            CommonUnit.progressHUD(.dismiss)
            CommonUnit.showAlertController(Constant.GlobalVars.navVC.visibleViewController!, Constant.LocalizationKey.Error, message: Constant.LocalizationKey.NoNetworkMsg, cancelTitle: Constant.LocalizationKey.Cancel, cancelCompletion: nil, okTitle: Constant.LocalizationKey.OK, okCompletion: nil)
            return
        }
        
        func getGooglePathURL(_ selectedPlace : String) -> NSURL{
            return NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?place_id=\(selectedPlace)&sensor=false&key=\(Constant.GoogleAPIs.PlaceAPIKey)")!
        }
        
        let correctedAddress :String! = placeId.addingPercentEncoding(withAllowedCharacters: (NSCharacterSet.symbols))
        Alamofire.request(getGooglePathURL(correctedAddress) as URL, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                switch(response.result) {
                case .success(_):
                    do {
                        let JSON = try JSONSerialization.jsonObject(with: response.data! as Data, options:JSONSerialization.ReadingOptions(rawValue: 0))
                        
                        guard let JSONDictionary: NSDictionary = JSON as? NSDictionary else {
                            print("Not a Dictionary")
                            return
                        }
                        
                        print("Dict : \(JSONDictionary)")
                        
                        
                        if ((JSONDictionary as NSDictionary).value(forKey: "results") as! NSArray).count > 0 {
                            
                            let results = (JSONDictionary as NSDictionary).value(forKey: "results") as! NSArray
                            
                            var locationData = LocationData.init()
                            let locationDict : NSDictionary = (results.object(at: 0) as! NSDictionary).value(forKeyPath: "geometry.location") as! NSDictionary
                            
                            locationData.latitude = String(format: "%.2f", Double(CommonUnit.stringFromAny(locationDict["lat"]))!)
                            locationData.longitude = String(format: "%.2f", Double(CommonUnit.stringFromAny(locationDict["lng"]))!)
                            locationData.address = address
                            
                            let address_components = (results.object(at: 0) as! NSDictionary).value(forKeyPath: "address_components") as! NSArray
                            
                            for i in 0..<address_components.count {
                                
                                let component = address_components.object(at: i) as! NSDictionary
                                let typeKey = CommonUnit.stringFromAny((component.value(forKey: "types") as! NSArray).object(at: 0))
                                
                                switch typeKey {
                                case "administrative_area_level_2":
                                    //City
                                    locationData.city = CommonUnit.stringFromAny(component["long_name"])
                                    break
                                case "administrative_area_level_1":
                                    //State
                                    locationData.state = CommonUnit.stringFromAny(component["long_name"])
                                    break
                                case "country":
                                    //Country
                                    locationData.country = CommonUnit.stringFromAny(component["long_name"])
                                    break
                                case "postal_code":
                                    //Postal Code
                                    locationData.postalCode = CommonUnit.stringFromAny(component["long_name"])
                                    break
                                default:
                                    break
                                }
                            }
                            
                            completionHandler(locationData)
                        }
                    }
                    catch let JSONError as NSError {
                        print("\(JSONError)")
                    }
                    break
                case .failure(_):
                    print("failure Http: \(String(describing: response.result.error?.localizedDescription))")
                    break
                }
        }
    }
    
    //MARK:- Check Network Reachability
    /// Check if user is connected to internet or not
    ///
    /// - Returns: Returns true if connected else returns false
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
}


extension UIImage {
    
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resizedTo200Kb() -> Data? {
        CommonUnit.progressHUD(.show)
        guard let imageData = UIImagePNGRepresentation(self) else { return nil }
        
        var resizingImage = self
        var finalImgData : Data? = UIImagePNGRepresentation(resizingImage)
        var imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
        
        while imageSizeKB > 200 { // ! Or use 1024 if you need KB but not kB
            guard let resizedImage = resizingImage.resized(withPercentage: 0.9),
                let imageData = UIImagePNGRepresentation(resizedImage)
                else { return nil }
            
            resizingImage = resizedImage
            finalImgData = imageData
            imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
        }
        
        CommonUnit.progressHUD(.dismiss)
        return finalImgData
    }
}
