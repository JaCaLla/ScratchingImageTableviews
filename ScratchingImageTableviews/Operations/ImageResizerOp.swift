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

class ImageResizerOp: NSOperation {
    
    private let inputData: NSData?
    private let completion: ((UIImage?) -> ())?
    private var outputImage: UIImage?
    private let newWidth: CGFloat
    
    init(width:CGFloat, data: NSData?, completion: ((UIImage?) -> ())? = nil) {
        newWidth=width
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
        outputImage = resizeImage(inputImage, newWidth: newWidth)
        completion?(outputImage)
        
        
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



 