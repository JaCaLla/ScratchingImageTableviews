//
//  ImageTableViewCell.swift
//  ScratchingImageTableviews
//
//  Created by JAVIER CALATRAVA LLAVERIA on 09/08/16.
//  Copyright © 2016 JAVIER CALATRAVA LLAVERIA. All rights reserved.
//

import Foundation

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    var landscape: Landscape? {
        didSet {
            if let _landscape = landscape {
                lblLandscape.text = _landscape.name
                updateImageViewWithImage(nil)
            }
        }
    }
    
    @IBOutlet weak var imvLandscape: UIImageView!
    @IBOutlet weak var lblLandscape: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func updateImageViewWithImage(image: UIImage?) {
        if let image = image {
            imvLandscape.image = image
            imvLandscape.alpha = 0
            UIView.animateWithDuration(0.3, animations: {
                self.imvLandscape.alpha = 1.0
                self.activityIndicator.alpha = 0
                }, completion: {
                    _ in
                    self.activityIndicator.stopAnimating()
            })
            
        } else {
            imvLandscape.image = nil
            imvLandscape.alpha = 0
            activityIndicator.alpha = 1.0
            activityIndicator.startAnimating()
        }
    }
    

}