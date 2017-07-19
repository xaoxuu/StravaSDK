//
//  File.swift
//  StravaKit
//
//  Created by xaoxuu on 30/06/2017.
//  Copyright © 2017 SmallSharpTools LLC. All rights reserved.
//

import UIKit
import SafariServices


public class StravaSDK : NSObject {
    
    internal static let sharedInstance = StravaSDK()
    
    var vc = (UIApplication.shared.delegate as! UIResponder).value(forKeyPath: "window.rootViewController") as! UIViewController
    var clientId = "18583"
    var clientSecret = "a05fde98a830effde2e0f84cc39d76b040d4d67e"
    var appSchemes = "stravasdk"
    var safariViewController: SFSafariViewController? = nil
    
    
    // MARK: 配置环境
    
    /// 配置环境
    ///
    /// - Parameters:
    ///   - clientId: 客户端Id
    ///   - clientSecret: 客户端私钥
    ///   - appSchemes: app的URL Schemes
    public func config(clientId: String, clientSecret: String, appSchemes: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.appSchemes = appSchemes
    }
    
    // MARK: 授权
    
    /// 是否已经授权
    public var isAuthorized: Bool {
        let ud = UserDefaults.standard
        return ud.bool(forKey: getMonthOfYear())
    }
    
    /// 授权
    public func authorize() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(StravaSDK.stravaAuthorizationCompleted(_:)), name: NSNotification.Name(rawValue: StravaAuthorizationCompletedNotification), object: nil)
        
        storeDefaults()
        let redirectURI = appSchemes + "://localhost/oauth/signin"
        Strava.set(clientId: clientId, clientSecret: clientSecret, redirectURI: redirectURI)
        
        if let URL = Strava.userLogin(scope: .PrivateWrite) {
            let sf = SFSafariViewController(url: URL, entersReaderIfAvailable: false)
            self.vc.present(sf, animated: true, completion: nil)
            safariViewController = sf
        }
        
    }
    
    /// 取消授权
    public func deauthorize() {
        // 清除缓存
        let ud = UserDefaults.standard
        ud.set(false, forKey: self.getMonthOfYear())
        ud.synchronize()
        // 取消授权
        Strava.deauthorize { (success, error) in
            if success {
                debugPrint("Deauthorization successful!")
                // 取消授权成功 "Deauthorization successful!"
                
            }
            else {
                // TODO: warn user
                if let error = error {
                    debugPrint("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: 上传fit文件
    
    /// 上传活动数据fit文件
    ///
    /// - Parameters:
    ///   - path: 文件路径
    ///   - activityType: 活动类型
    ///   - activityName: 活动名称
    ///   - completionHandler: 完成回调
    public func uploadActivity(path: String, type: String, name: String, completionHandler: ((_ response: Any?, _ error: NSError?) -> ())?) {
        Strava.uploadFit(filePath: path, activityType: type, activityName: name, completionHandler: completionHandler)
    }
    
    /// 上传fit文件（自定义params）
    ///
    /// - Parameters:
    ///   - path: 文件路径
    ///   - params: 参数
    ///   - completionHandler: 完成回调
    public func uploadActivity(path: String, params: [String : String], completionHandler: ((_ response: Any?, _ error: NSError?) -> ())?) {
        Strava.uploadFit(filePath: path, params: params, completionHandler: completionHandler)
    }
    
    
    // MARK: open url
    public static func openURL(_ aURL: URL, sourceApplication: String?) -> Bool {
        return Strava.openURL(aURL, sourceApplication: sourceApplication)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: StravaAuthorizationCompletedNotification), object: nil)
    }
    
    // MARK: internal
    internal func stravaAuthorizationCompleted(_ notification: Notification?) {
        assert(Thread.isMainThread, "Main Thread is required")
        safariViewController?.dismiss(animated: true, completion: nil)
        safariViewController = nil
        
        guard let userInfo = notification?.userInfo,
            let status = userInfo[StravaStatusKey] as? String else {
                return
        }
        if status == StravaStatusSuccessValue {
            debugPrint("Authorization successful!")
            // 授权成功 "Authorization successful!"
            let ud = UserDefaults.standard
            ud.set(true, forKey: getMonthOfYear())
            ud.synchronize()
        }
        else if let error = userInfo[StravaErrorKey] as? NSError {
            debugPrint("Error: \(error.localizedDescription)")
        }
    }
    
    internal func storeDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(clientId, forKey: StravaUserDefaultKey.clientId.rawValue)
        defaults.set(clientSecret, forKey: StravaUserDefaultKey.clientSecret.rawValue)
    }
    
    internal func getMonthOfYear() -> String {
        let currentdate = Date()
        let dateformatter = DateFormatter()
        let week = dateformatter.calendar.ordinality(of: .month, in: .year, for: currentdate)
        return String(describing: week)
    }
    
    private override init() {
        debugPrint("init")
    }
    
}
