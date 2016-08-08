//
//  Landscape+Decodable.swift
//  ScratchingImageTableviews
//
//  Created by JAVIER CALATRAVA LLAVERIA on 07/08/16.
//  Copyright © 2016 JAVIER CALATRAVA LLAVERIA. All rights reserved.
//

import Foundation

import Argo

extension Landscapes : Decodable {
    typealias DecodedType = Landscapes
    
    static func decode(json: JSON) -> Decoded<Landscapes> {
        let landscapes = Landscapes()
        landscapes.list = (json <|| "landscapes").value
        
        return .Success(landscapes)
    }
}