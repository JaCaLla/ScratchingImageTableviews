//
//  ImageProvider.swift
//  ScratchingImageTableviews
//
//  Created by JAVIER CALATRAVA LLAVERIA on 15/08/16.
//  Copyright © 2016 JAVIER CALATRAVA LLAVERIA. All rights reserved.
//

import Foundation
import UIKit

class ImageProvider{
    
    let landscape:Landscape
      private let operationQueue = NSOperationQueue()
    
    
    init(landscape:Landscape, completion:(UIImage?) -> ()){
        self.landscape = landscape
        
        if let _url =  NSURL(string: self.landscape.url){
            // Create the separate operations
            let dataLoad = DataLoadOperation(url:_url)
            let imageThumbnalizer = ImageThumbnalizerOperation(data: nil)
            let imageOutputOp = ImageOutputOperation(image: nil, completion: completion)
            let operations = [dataLoad,imageThumbnalizer,imageOutputOp]
            
            // Add operation dependencies
            dataLoad |> imageThumbnalizer |> imageOutputOp
            //dataLoad |> imageDecompress |> tiltShift |> filterOutput
            
            operationQueue.addOperations(operations, waitUntilFinished: false)
        }
        

        
    }
    
    func cancel() {
        operationQueue.cancelAllOperations()
    }
}

extension ImageProvider: Hashable {
    var hashValue: Int {
        return (landscape.name + landscape.url).hashValue
    }
}

func ==(lhs: ImageProvider, rhs: ImageProvider) -> Bool {
    return lhs.landscape == rhs.landscape
}
