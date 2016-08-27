//
//  Landscape.swift
//  ScratchingImageTableviews
//
//  Created by JAVIER CALATRAVA LLAVERIA on 07/08/16.
//  Copyright © 2016 JAVIER CALATRAVA LLAVERIA. All rights reserved.
//

import Foundation

struct Landscape {
    var name:String
    var url:String
}

extension Landscape: Equatable { }

func ==(lhs: Landscape, rhs: Landscape) -> Bool {
    return lhs.name == rhs.name && lhs.url == rhs.url
}