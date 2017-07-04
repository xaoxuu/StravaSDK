//
//  StravaUpload.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/22/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

public enum UploadResourcePath: String {
    case Upload = "/api/v3/uploads"
    case CheckUpload = "/api/v3/uploads/:id"
}

public enum StravaParametersKey : String {
    case data_type = "data_type"
    case file = "file"
    
    case activity_type = "activity_type"
    case name = "name"
    case description = "description"
    case private1 = "private"
    case trainer = "trainer"
    case commute = "commute"
    
    case external_id = "external_id"
    
}

public enum StravaDataType : String {
    case fit = "fit"
}

/* Upload an activity
 
 activity_type:	string optional, case insensitive
 possible values: ride, run, swim, workout, hike, walk, nordicski, alpineski, backcountryski, iceskate, inlineskate, kitesurf, rollerski, windsurf, workout, snowboard, snowshoe, ebikeride, virtualride
 Type detected from file overrides, uses athlete’s default type if not specified
 
 name:	string optional
 if not provided, will be populated using start date and location, if available
 
 description:	string optional
 
 private:	integer optional
 set to 1 to mark the resulting activity as private, ‘view_private’ permissions will be necessary to view the activity
 If not specified, set according to the athlete’s privacy setting (recommended)
 
 trainer:	integer optional
 activities without lat/lng info in the file are auto marked as stationary, set to 1 to force
 
 commute:	integer optional
 set to 1 to mark as commute
 
 data_type:	string required case insensitive
 possible values: fit, fit.gz, tcx, tcx.gz, gpx, gpx.gz
 
 external_id:	string optional
 data filename will be used by default but should be a unique identifier
 
 file:	multipart/form-data required
 the actual activity data, if gzipped the data_type must end with .gz
 
 */


public extension Strava {
    
    public static func uploadFit(fileName: String, activityType: String, activityName: String, completionHandler: ((_ response: Any?, _ error: NSError?) -> ())?) {
        // file
        var filePath = Bundle.main.path(forResource: fileName, ofType: nil)
        if filePath == nil {
            filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/" + fileName
        }
        
        if let filePath = filePath {
            uploadFit(filePath: filePath, activityType: activityType, activityName: activityName, completionHandler: completionHandler)
        } else {
            debugPrint("文件不存在")
        }
        
    }
    
    public static func uploadFit(filePath: String, activityType: String, activityName: String, completionHandler: ((_ response: Any?, _ error: NSError?) -> ())?) {
        
        // api path
        let path = UploadResourcePath.Upload.rawValue
        // api params
        let params : [String : String]? = [
            StravaParametersKey.data_type.rawValue : StravaDataType.fit.rawValue,
            StravaParametersKey.activity_type.rawValue : activityType,
            
            StravaParametersKey.name.rawValue : activityName
        ]
        
        let url = URL.init(fileURLWithPath: filePath)
        request_upload(path, params: params, file: url, completionHandler: completionHandler)
        
    }
    
    public static func uploadFit(filePath: String, params: [String : String], completionHandler: ((_ response: Any?, _ error: NSError?) -> ())?) {
        
        // api path
        let path = UploadResourcePath.Upload.rawValue
        let url = URL.init(fileURLWithPath: filePath)
        request_upload(path, params: params, file: url, completionHandler: completionHandler)
        
    }

    
}


