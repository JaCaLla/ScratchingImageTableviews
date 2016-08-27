//
//  ImageThumbnalizerOperation.swift
//  ScratchingImageTableviews
//
//  Created by JAVIER CALATRAVA LLAVERIA on 15/08/16.
//  Copyright © 2016 JAVIER CALATRAVA LLAVERIA. All rights reserved.
//

import UIKit

protocol ImageThumbnalizerOperationDataProvider {
    var compressedData: NSData? { get }
}

class ImageThumbnalizerOperation: NSOperation {
    
    private let inputData: NSData?
    private let completion: ((UIImage?) -> ())?
    private var outputImage: UIImage?
    
    init(data: NSData?, completion: ((UIImage?) -> ())? = nil) {
        inputData = data
        self.completion = completion
        super.init()
    }
    
    override func main() {
       let compressedData: NSData?
        if let inputData = inputData {
            compressedData = inputData
        } else {
            let dataProvider = dependencies
                .filter { $0 is ImageThumbnalizerOperationDataProvider }
                .first as? ImageThumbnalizerOperationDataProvider
            
            
            compressedData = dataProvider?.compressedData
        }

        guard let data = compressedData else { return }
        
        let inputImage = UIImage(data: data)!
        outputImage = resizeImage(inputImage, newWidth: 1242)
        completion?(outputImage)
        
  /*
        if let decompressedData = Compressor.decompressData(data) {
            outputImage = UIImage(data: decompressedData)
        }
        
        completion?(outputImage)
 */
        
        
    }
    
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage
    {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}

extension ImageThumbnalizerOperation: ImageOutputOperationDataProvider {
    var inputImage: UIImage? { return outputImage }
}

 