//
//  File.swift
//  StravaKit
//
//  Created by xaoxuu on 30/06/2017.
//  Copyright © 2017 SmallSharpTools LLC. All rights reserved.
//

import UIKit
import SafariServices

let rootVC = (UIApplication.shared.delegate as! UIResponder).value(forKeyPath: "window.rootViewController") as! UIViewController


public class StravaManager : NSObject {
    
    internal static let sharedInstance = StravaManager()
    
    fileprivate let ClientIDKey: String = "StravaClientID"
    fileprivate let ClientSecretKey: String = "StravaClientSecret"
    
    var vc = rootVC
    var clientId = "18583"
    var clientSecret = "a05fde98a830effde2e0f84cc39d76b040d4d67e"
    var appSchemes = "stravademo"
    var safariViewController: SFSafariViewController? = nil
    
    
    // MARK: authorize
    public var isAuthorized: Bool {
        let ud = UserDefaults.standard
        return ud.bool(forKey: getMonthOfYear())
    }
    
    
    
    public func authorizeStrava() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(StravaManager.stravaAuthorizationCompleted(_:)), name: NSNotification.Name(rawValue: StravaAuthorizationCompletedNotification), object: nil)
        
        
        storeDefaults()
        let redirectURI = appSchemes + "://localhost/oauth/signin"
        Strava.set(clientId: clientId, clientSecret: clientSecret, redirectURI: redirectURI)
        
        if let URL = Strava.userLogin(scope: .PrivateWrite) {
            let sf = SFSafariViewController(url: URL, entersReaderIfAvailable: false)
            self.vc.present(sf, animated: true, completion: nil)
            safariViewController = sf
        }
        
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: StravaAuthorizationCompletedNotification), object: nil)
    }
    
    public func deauthorizeStrava() {
        Strava.deauthorize { (success, error) in
            
            if success {
                debugPrint("Deauthorization successful!")
                // 取消授权成功 "Deauthorization successful!"
                let ud = UserDefaults.standard
                ud.set(false, forKey: self.getMonthOfYear())
                ud.synchronize()
            }
            else {
                // TODO: warn user
                if let error = error {
                    debugPrint("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    // MARK: open url
    public static func openURL(_ aURL: URL, sourceApplication: String?) -> Bool {
        return Strava.openURL(aURL, sourceApplication: sourceApplication)
    }
    
    // MARK: upload
    
    public func uploadFit(fileName: String, activityType: String, activityName: String, completionHandler: ((_ response: Any?, _ error: NSError?) -> ())?) {
        Strava.uploadFit(fileName: fileName, activityType: activityType, activityName: activityName, completionHandler: completionHandler)
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
        defaults.set(clientId, forKey: ClientIDKey)
        defaults.set(clientSecret, forKey: ClientSecretKey)
    }
    
//    internal func getDateString() -> String {
//        let currentdate = Date()
//        let dateformatter = DateFormatter()
//        dateformatter.dateStyle = .short;
//        dateformatter.timeStyle = .none;
//        let dateString = dateformatter.string(from: currentdate)
//        return dateString
//    }
    
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
