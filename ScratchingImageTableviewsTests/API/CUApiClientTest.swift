//
//  CUApiClientTest.swift
//  currTV
//
//  Created by JAVIER CALATRAVA LLAVERIA on 05/05/16.
//  Copyright © 2016 JAVIER CALATRAVA LLAVERIA. All rights reserved.
//
import Foundation
import XCTest
import Argo

@testable import ScratchingImageTableviews

class CUApiClientTest: XCTestCase {
    
    var apiClient: CUFixerApiClient!
    
    override func setUp() {
        apiClient = CUFixerApiClient.sharedApiClient
        apiClient.loggingEnabled = true
    }

    
    func test_fetchLandscapes() {
        let expectation = expectationWithDescription("api  response received")
        
        apiClient.fetchLandscapes { result  in
            expectation.fulfill()
            
            switch result {
            case .Success(let landscapes):
                print("\(landscapes.first!.count)")
                break
            default:
                XCTFail()
            }
        }
        
        /*
        apiClient.fetchLandscapes() { result in
            expectation.fulfill()
            
            switch result {
            case .Success(let landscapes):
             print("")
                break
            default:
                XCTFail()
            }
        }
 */
        waitForExpectationsWithTimeout(30, handler: nil)
        
    }
    
    /*
    func test_fetchLatestRates() {
        
        let expectation = expectationWithDescription("api  response received")
        apiClient.fetchLatestRates() { result in
            expectation.fulfill()
            
            switch result {
            case .Success(let dateRates):
                XCTAssertEqual("EUR", dateRates.base)
                break
            default:
                XCTFail()
            }
        }
        waitForExpectationsWithTimeout(30, handler: nil)
        
    }
    
    func test_fetchAllLatestFromJSON(){
        
        let expectation = expectationWithDescription("api  response received")
        let currencies:Decoded<[CUCurrency]> = decode(JSONFromFile("Currency")!)
        
        switch currencies {
        case .Success(let currenciesFetched):
            var onlineCurr:[String] = []
            for currency in currenciesFetched {
                apiClient.fetchLatestRates(currency.iso4217Code!) { result in
                    switch result {
                    case .Success:
                        onlineCurr.append(currency.iso4217Code!)
                        break
                    default:
                        print("not found: \(currency.iso4217Code!)")
                        break
                    }
                    
                    if currency == currenciesFetched.last{
                        print("all:\(currenciesFetched.count) available: \(onlineCurr.count>0)")
                        XCTAssertTrue(onlineCurr.count>0)
                        expectation.fulfill()
                    }
                }
            }
        default: break
        }
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    
  
    func test_fetchLatestRatesBase() {
        
        let expectation = expectationWithDescription("api  response received")
        apiClient.fetchLatestRates("USD") { result in
            expectation.fulfill()
            
            switch result {
            case .Success(let dateRates):
                XCTAssertEqual("USD", dateRates.base)
                let today = NSDate().YYYYMMDD
                let yesterday = NSDate().daysOffset(-1)!.YYYYMMDD
                let dayBefYesterday = NSDate().daysOffset(-2)!.YYYYMMDD //Case weekends
                
                XCTAssertTrue(today == dateRates.date ||
                    yesterday == dateRates.date ||
                    dayBefYesterday == dateRates.date)
                
                if let rates = dateRates.rates,
                    let EUR = rates.EUR  ,
                    let GBP = rates.GBP {
                    
                    XCTAssertTrue(Float(EUR) > 0)
                    XCTAssertTrue(Float(GBP) > 0)
                    
                }else{
                    XCTFail()
                }
                
                break
            default:
                XCTFail()
            }
            
        }
        waitForExpectationsWithTimeout(30, handler: nil)
        
        
    }
    
    func test_fetchLatestRatesBaseDate() {
        
        let expectation = expectationWithDescription("api  response received")
        apiClient.fetchLatestRates("USD",date: NSDate().daysOffset(-30)!) { result in
            expectation.fulfill()
            
            switch result {
            case .Success(let dateRates):
                XCTAssertEqual("USD", dateRates.base)
                let day = NSDate().daysOffset(-30)!.YYYYMMDD
                let dayPrev = NSDate().daysOffset(-31)!.YYYYMMDD
                let dayBefPrev = NSDate().daysOffset(-32)!.YYYYMMDD //Case weekends
                
                XCTAssertTrue(day == dateRates.date ||
                    dayPrev == dateRates.date ||
                    dayBefPrev == dateRates.date)
                
                if let rates = dateRates.rates,
                    let EUR = rates.EUR  ,
                    let GBP = rates.GBP {
                    
                    XCTAssertTrue(Float(EUR) > 0)
                    XCTAssertTrue(Float(GBP) > 0)
                    
                }else{
                    XCTFail()
                }
                
                break
            default:
                XCTFail()
            }
            
        }
        waitForExpectationsWithTimeout(30, handler: nil)
    }
   */ 
    
    
}
