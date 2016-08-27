//
//  DataLoadOperations.swift
//  ScratchingImageTableviews
//
//  Created by JAVIER CALATRAVA LLAVERIA on 15/08/16.
//  Copyright © 2016 JAVIER CALATRAVA LLAVERIA. All rights reserved.
//

import Foundation

class DataLoadOperation: ConcurrentOperation {
    
    private let url: NSURL
    private let completion: ((NSData?) -> ())?
    private var loadedData: NSData?
    
    init(url: NSURL, completion: ((NSData?) -> ())? = nil) {
        self.url = url
        self.completion = completion
        super.init()
    }
    
    override func main() {
        /*
        NetworkSimulator.asyncLoadDataAtURL(url) {
            data in
            self.loadedData = data
            self.completion?(data)
            self.state = .Finished
        }
 */
        if let _data = NSData(contentsOfURL: url){
            self.loadedData = _data
            self.completion?(_data)
            self.state = .Finished
            
        }
        
    }
}

extension DataLoadOperation: ImageThumbnalizerOperationDataProvider {
    var compressedData: NSData? { return loadedData }
}

