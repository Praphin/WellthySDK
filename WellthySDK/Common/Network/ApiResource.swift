//
//  ApiResource.swift
//  WellthySDK
//
//  Created by Praphin SP on 03/02/22.
//

import Foundation
import Alamofire

class InternetConnectivity {
    class var isConnected:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

let concurrentQueue = DispatchQueue(label: "com.queue.Concurrent", attributes: .concurrent)
var workItems = [DispatchWorkItem]()

class ApiResource: NSObject {
    
    static var isTokenRefreshing = false
    static var isTokenUpdated = false
    

    func apiRequest(urlStr : String, method: HTTPMethod, header : [String:String]?, parameters: [String:Any]?, completion:@escaping ((_ code: Int, _ response: Any?, _ error: Error?)->Void)) {
        
        let headers: HTTPHeaders = [
//            "x-id-token": AppVariable.shared.getValueFromUserDefault(key: DataKey.idToken) as? String ?? "",
//            "x-access-token": UserData.shared?.token ?? ""
                "x-id-token":  "",
                "x-access-token":  ""
        ]
        
        do {
            
            guard let url = try urlStr.addingUrlPercentEncoding()?.asURL() else { return
                DebugLogger().log("not valid url : \(urlStr)")
            }
            
            let dataRequest = AF.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            dataRequest.responseJSON { (response) in
                
                DispatchQueue.main.async {
                    
                    if method == .head {
                        let value: Any? = response.response?.allHeaderFields
                        completion(response.response?.statusCode ?? 600, value,nil)
                    } else {
                        switch response.result {
                        case .success(let value):
                            completion(response.response?.statusCode ?? 600, value,nil)
                        case .failure(let error):
                            completion(response.response?.statusCode ?? 600, nil,error)
                        }
                    }
                }
            }
            
        }catch {
            DebugLogger().log("not valid url : \(urlStr)")
        }
    }
    
    func getApiCall(url : String, headers : [String:String]?, completion:@escaping ((_ code: Int, _ response: Any?, _ error: Error?)->Void))  {
        self.apiCallWithToken(urlStr: url, method: .get, header: headers, parameters: nil) { (code, response, error) in
            DispatchQueue.main.async {
                completion(code, response , error)
            }
        }
    }
    
    func postApiCall(url : String, parameters: [String:Any], headers : [String:String]?, completion:@escaping ((_ code: Int, _ response: Any?, _ error: Error?)->Void))  {
        
        self.apiCallWithToken(urlStr: url, method: .post, header: headers, parameters: parameters) { (code, response, error) in
            DispatchQueue.main.async {
                completion(code, response, error)
            }
        }
        
    }
    
    func deleteApiCall(url : String, parameters: [String:Any]?, headers : [String:String]?, completion:@escaping ((_ code: Int, _ response: Any?, _ error: Error?)->Void))  {
        
        self.apiCallWithToken(urlStr: url, method: .delete, header: headers, parameters: parameters) { (code, response, error) in
            DispatchQueue.main.async {
                completion(code, response, error)
            }
        }
        
    }
    
    func patchApiCall(url : String, parameters: [String:Any], headers : [String:String]?, completion:@escaping ((_ code: Int, _ response: Any?, _ error: Error?)->Void))  {
        
        self.apiCallWithToken(urlStr: url, method: .patch, header: headers, parameters: parameters) { (code, response, error) in
            DispatchQueue.main.async {
                completion(code, response, error)
            }
        }
        
    }

    
    func headApiCall(url : String, headers : [String:String]?, completion:@escaping ((_ code: Int, _ response: Any?, _ error: Error?)->Void))  {
        
        self.apiCallWithToken(urlStr: url, method: .head, header: headers, parameters: nil) { (code, response, error) in
            DispatchQueue.main.async {
                completion(code, response, error)
            }
        }
        
    }
    
    func apiCallWithToken(urlStr : String, method: HTTPMethod, header : [String:String]?, parameters: [String:Any]?, encoding: ParameterEncoding = JSONEncoding.default, completion:@escaping ((_ code: Int, _ response: Any?, _ error: Error?)->Void)) {

        let u = urlStr
        let callWithDelay: (()->Void) = {
            self.apiCallWithToken(urlStr: urlStr, method: method, header: header, parameters: parameters) { (code, response, error) in
                completion(code, response, error)
            }
        } // in case token refreshing
        
        var headerData = [String: String]()
        if let header = header {
            headerData = header
        }
  
        headerData["Content-Type"] = "application/x-www-form-urlencoded"
        
        if let token = SDKVariables.shared.authToken() {
            headerData["x-access-token"] = token
        }

        DebugLogger().log("URL: \(urlStr)")
        DebugLogger().log("headers: \(headerData)")
        DebugLogger().log("Paramters: \(parameters)")

        self.apiCall(urlStr: urlStr, method: method, header: headerData, parameters: parameters, encoding: encoding) { (code, response, error) in
            
            DebugLogger().log("Response: \(response)")

            if code == 401 {
                
                completion(code, response, error)
                
//                let work: DispatchWorkItem? = DispatchWorkItem {
//
//                    var isTokenExist = false
//
//                    if  isTokenExist {
//                        if ApiResource.isTokenUpdated {
//                           DebugLogger().log("token-> token updated by another api: \(u)")
//                            workItems.removeAll()
//                            callWithDelay()
//                        }
//                        else if ApiResource.isTokenRefreshing == false {
//                            DebugLogger().log("token-> updating token: \(u)")
//                            ApiResource.isTokenRefreshing = true
//                            var dict = [String: String]()
//                            dict["token"] = UserData.shared?.token
//                            dict["refreshtoken"] = UserData.shared?.refreshtoken
//                            self.apiCall(urlStr: URLConstants.refreshTokenURL, method: .post, header: nil, parameters: dict) { (code, response, error) in
//                                if code == 200, let response = response as? [String:Any], let dataDict = response["data"] as? [String:Any] {
//                                    DebugLogger().log("token-> token updated: \(u)")
//                                    let newToken = dataDict["token"]
//                                    let newRefreshtoken = dataDict["refreshtoken"]
//                                    UserData.shared?.token = newToken as? String
//                                    UserData.shared?.refreshtoken = newRefreshtoken as? String
//                                    UserData.shared?.save()
//                                    ApiResource.isTokenRefreshing = false
//                                    ApiResource.isTokenUpdated = true
//                                    workItems.removeAll()
//                                    callWithDelay()
//                                }
//                                else {
//                                    DebugLogger().log("token-> token expired need to logout: \(u)")
//                                    for work in workItems {
//                                        work.cancel()
//                                    }
//                                    workItems.removeAll()
//                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                                        ApiResource.isTokenRefreshing = false
//                                        if !appDelegate!.isSplashRunning {
//                                            AppRouter.loadSessionExpiredView()
//                                        }
//                                        //clear scheduled/ fired notification
//                                        LocalNotificationManager.shared.deleteAll()
//                                        completion(code, response, error)
//                                    }
//                                }
//                            }
//                        }
//                        else {
//                            completion(code, response, error)
//                        }
//                    }
//                    else {
//                        DebugLogger().log("token-> token expired need to logout: \(u)")
//                        for work in workItems {
//                            work.cancel()
//                        }
//                        workItems.removeAll()
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                            ApiResource.isTokenRefreshing = false
//                        }
//                    }
//                }
//                if let work = work {
//                    workItems.append(work)
//                }
//                concurrentQueue.async(flags: .barrier) {
//                    work?.perform()
//                }
            }
            else {
                completion(code, response, error)
            }
        }
    }
    
    func apiCall(urlStr : String, method: HTTPMethod, header : [String:String]?, parameters: [String:Any]?, encoding: ParameterEncoding = JSONEncoding.default, completion:@escaping ((_ code: Int, _ response: Any?, _ error: Error?)->Void)) {
        if let r = NetworkReachabilityManager(), !r.isReachable {
            completion(600, nil,nil)
            return
        }
        
        do {
            let completeUrlStr = urlStr.addingUrlPercentEncoding()
            guard let url = try completeUrlStr?.asURL() else { return
                DebugLogger().log("not valid url : \(urlStr)")
            }
            
            guard let url = URL(string: urlStr) else {
                return
            }

            var headers: HTTPHeaders?
            
            if let header = header {
                headers = HTTPHeaders(header)
            }
            
            
            let dataRequest = AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            dataRequest.responseJSON { (response) in
                             
                DispatchQueue.main.async {
                    if method == .head {
                        let value: Any? = response.response?.allHeaderFields
                        completion(response.response?.statusCode ?? 600, value,nil)
                    }
                    else {
                        switch response.result {
                        case .success(let value):
                            completion(response.response?.statusCode ?? 600, value,nil)
                        case .failure(let error):
                            completion(response.response?.statusCode ?? 600, nil,error)
                        }

                    }
                }
            }
        } catch {
            DebugLogger().log("not valid url : \(urlStr)")
        }
    }
    
    func fileUpload(urlStr : String, data: Data, param: [String:String], completion:@escaping ((_ code: Int, _ response: Any?, _ error: Error?)->Void)) {
        let headers: HTTPHeaders? = HTTPHeaders(param)

        let uploadRequest = AF.upload(data, to: urlStr, method: .put, headers: headers)
        uploadRequest.response(queue: DispatchQueue.global()) { (response) in
            if response.response?.statusCode == 200 {
                completion(response.response?.statusCode ?? 600, nil ,nil)
            }
            else {
                completion(response.response?.statusCode ?? 600, nil,response.error)
            }
        }
    }
    
    func fileDownload(urlStr : String, fileName: String, completion:@escaping ((_ code: Int, _ response: Any?, _ error: Error?)->Void)) {
        
    
        let destination: DownloadRequest.Destination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent(fileName)
            return (documentsURL, [.removePreviousFile])
        }
        
        AF.download(urlStr, to: destination).response { response in

            if response.fileURL != nil {
                DebugLogger().log(response.fileURL!)

                completion(response.response?.statusCode ?? 200, nil ,nil)
            } else {
                completion(response.response?.statusCode ?? 600, nil ,nil)
            }
        }
    }
    
}
