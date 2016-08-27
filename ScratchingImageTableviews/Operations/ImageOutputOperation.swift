//
//  ImageOutputOperation.swift
//  ScratchingImageTableviews
//
//  Created by JAVIER CALATRAVA LLAVERIA on 15/08/16.
//  Copyright © 2016 JAVIER CALATRAVA LLAVERIA. All rights reserved.
//


import UIKit

protocol ImageOutputOperationDataProvider {
    var inputImage: UIImage? { get }
}

class ImageOutputOperation: NSOperation {
    
    private let inputImage: UIImage?
    private let completion: ((UIImage?) -> ())?
    private var outputImage: UIImage?
    
    init(image: UIImage?, completion: ((UIImage?) -> ())? = nil) {
        inputImage = image
         self.completion = completion
        super.init()
    }
    
    override func main() {
        let processedImage: UIImage?
        if let _inputImage = inputImage {
            processedImage = _inputImage
        } else {
            let dataProvider = dependencies
                .filter { $0 is ImageOutputOperationDataProvider }
                .first as? ImageOutputOperationDataProvider
            processedImage = dataProvider?.inputImage
        }
        
        guard let data = processedImage else { return }
        
        print("todo");
        
        completion?(data)
        
        /*
         if let decompressedData = Compressor.decompressData(data) {
         outputImage = UIImage(data: decompressedData)
         }
         
         completion?(outputImage)
         */
        
        
    }
}