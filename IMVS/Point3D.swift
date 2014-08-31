//
//  Point3D.swift
//  IMVS
//
//  Created by Allistair Crossley on 06/07/2014.
//  Copyright (c) 2014 Allistair Crossley. All rights reserved.
//

import Foundation

struct Point3D: Hashable {
    
    var x: Float = 0.0,
        y: Float = 0.0,
        z: Float = 0.0
    
    var hashValue : Int {
        get {
            return "\(self.x)\(self.y)\(self.z)".hashValue
        }
    }
    
    init(x: Float = 0.0, y: Float = 0.0, z: Float = 0.0) {
        self.x = x
        self.y = y
        self.z = z
    }
}

func ==(lhs: Point3D, rhs: Point3D) -> Bool {
    
    return lhs.hashValue == rhs.hashValue
}