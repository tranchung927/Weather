//
//  Reachability.swift
//  WeathersDemo
//
//  Created by Tran Chung on 7/18/17.
//  Copyright © 2017 Tran Chung. All rights reserved.
//

import Foundation
import SystemConfiguration

let ReachabilityStatusChangedNotification = Notification.Name.init(rawValue: "ReachabilityStatusChangedNotification")

enum ReachabilityType: CustomStringConvertible {
    case wwan
    case wifi
    var description: String {
        switch self {
        case .wwan: return "WWAN"
        case .wifi: return "WIFI"
        }
    }
}
enum ReachabilityStatus: CustomStringConvertible {
    case offline
    case online(ReachabilityType)
    case unknow
    var description: String {
        switch self {
        case .offline: return "Offline"
        case .online(let type): return "Online \(type)"
        case .unknow: return "Unknow"
        }
    }
}

public class Reach {
    func connnectionStatus() -> ReachabilityStatus {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouterReachabilitu = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1){
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .unknow
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouterReachabilitu, &flags) {
            return .unknow
        }
        
        return ReachabilityStatus(reachabilityFlags: flags)
    }
    
    func monitorReachabilityChanges(host: String) {
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        let reachability = SCNetworkReachabilityCreateWithName(nil, host)
        
        SCNetworkReachabilitySetCallback(reachability!, { (_, _, _) in
            let dispatchTime = DispatchTime.now() + DispatchTimeInterval.seconds(2)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                NotificationCenter.default.post(name: ReachabilityStatusChangedNotification, object: nil)
            }
        }, &context)
        
        SCNetworkReachabilityScheduleWithRunLoop(reachability!, CFRunLoopGetMain(), RunLoopMode.commonModes as CFString)
    }
}

extension ReachabilityStatus {
    init(reachabilityFlags flags: SCNetworkReachabilityFlags) {
        let connectionRequired = flags.contains(.connectionRequired)
        let isReachable = flags.contains(.reachable)
        let isWWAN = flags.contains(.isWWAN)
        
        if !connectionRequired && isReachable {
            if isWWAN {
                self = .online(.wwan)
            } else {
                self = .online(.wifi)
            }
        } else {
            self = .offline
        }
    }
}

