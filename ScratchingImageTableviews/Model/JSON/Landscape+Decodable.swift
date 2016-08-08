//
//  Landscape+Decodable.swift
//  ScratchingImageTableviews
//
//  Created by JAVIER CALATRAVA LLAVERIA on 07/08/16.
//  Copyright © 2016 JAVIER CALATRAVA LLAVERIA. All rights reserved.
//

import Foundation

import Argo

extension Landscape : Decodable {
    typealias DecodedType = Landscape
    
    static func decode(json: JSON) -> Decoded<Landscape> {
        let landscape = Landscape()
        landscape.name = (json <| "name").value
        landscape.url = (json <| "url").value
        
        return .Success(landscape)
    }
}