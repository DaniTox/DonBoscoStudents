//
//  InfoApp.swift
//  iUtility
//
//  Created by Dani Tox on 25/03/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

/*
class AppInfo: NSObject {
    var appType = "Studenti"
    var appVersion = "v0.1 ALPHA"
    
    var thisDeviceModel = UIDevice.current.modelName
    var thisDeviceOS = UIDevice.current.systemName + UIDevice.current.systemVersion
    
}
*/
