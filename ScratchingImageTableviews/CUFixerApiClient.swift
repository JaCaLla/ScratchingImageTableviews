//
//  NSScreencastApiClient.swift
//  nsscreencast-tvdemo
//
//  Created by Ben Scheirman on 1/11/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Foundation
import SystemConfiguration



class CUFixerApiClient : CUApiClient {
    
    static let notNoReacheableNetwork = "NoReacheableNetworkNotification"
    
    static let baseURL = "http://celeri.es/scratching_image_tableviews"
    
    //"http://api.fixer.io"
    
    
    static var sharedApiClient: CUFixerApiClient = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.HTTPAdditionalHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        return CUFixerApiClient(configuration: config)
    }()
    
    enum Endpoints {
        
        case Landscapes()
        /*
         case LatestRatesDefault()
        case LatestRatesBase(String)
        
        case LatestRatesBaseDate(String,NSDate)
        */
        var url: NSURL {
            let path: String
            switch self {
               /*
            case .LatestRatesDefault():
                path = "/latest"
                return NSURL(string: CUFixerApiClient.baseURL + path)!
                
            case .LatestRatesBase(let iso4712Code):
                path = "/latest"
                return NSURL(string: CUFixerApiClient.baseURL + path + "?base=" + iso4712Code)!
                
            case .LatestRatesBaseDate(let iso4712Code,let date):
                path = "/"  ///+ date.YYYYMMDD
                return NSURL(string: CUFixerApiClient.baseURL + path + "?base=" + iso4712Code)!
                */
            case .Landscapes():
                path = "/landscapes"
                return NSURL(string: CUFixerApiClient.baseURL + path)!
            }
        }
    }

    func fetchLandscapes(completion: CUApiClientResult<[Landscape]> -> Void) {
        if(!_isConnectedToNetwork()){
            NSNotificationCenter.defaultCenter().postNotificationName(CUFixerApiClient.notNoReacheableNetwork, object: nil)
            return
        }
        
        let url = Endpoints.Landscapes().url
        let request = NSURLRequest(URL: url)
        fetchCollection(request, rootKey: nil, completion: completion)
        //fetchResource(request, rootKey: "landscapes", completion: completion)
    }
 /*
    func fetchLatestRates(completion: CUApiClientResult<CUDateRates> -> Void) {
        if(!_isConnectedToNetwork()){
            NSNotificationCenter.defaultCenter().postNotificationName(CUFixerApiClient.notNoReacheableNetwork, object: nil)
            return
        }
        
        let url = Endpoints.LatestRatesDefault().url
        let request = NSURLRequest(URL: url)
        fetchResource(request, rootKey: nil, completion: completion)
    }
    
    func fetchLatestRates(iso4217Code:String,completion: CUApiClientResult<CUDateRates> -> Void){
        
        if(!_isConnectedToNetwork()){
            NSNotificationCenter.defaultCenter().postNotificationName(CUFixerApiClient.notNoReacheableNetwork, object: nil)
            return
        }
        
        let url = Endpoints.LatestRatesBase(iso4217Code).url
        let request = NSURLRequest(URL: url)
        fetchResource(request, rootKey: nil, completion: completion)
    }
    
    func fetchLatestRates(iso4217Code:String,date:NSDate,completion: CUApiClientResult<CUDateRates> -> Void){
        
        if(!_isConnectedToNetwork()){
            NSNotificationCenter.defaultCenter().postNotificationName(CUFixerApiClient.notNoReacheableNetwork, object: nil)
            return
        }
        
        let url = Endpoints.LatestRatesBaseDate(iso4217Code,date).url
        let request = NSURLRequest(URL: url)
        fetchResource(request, rootKey: nil, completion: completion)
    }
    
*/
    private func _isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
}