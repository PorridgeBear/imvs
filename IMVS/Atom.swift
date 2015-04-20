//
//  Atom.swift
//  IMVS
//
//  Created by Allistair Crossley on 06/07/2014.
//  Copyright (c) 2014 Allistair Crossley. All rights reserved.
//

import Foundation

class Atom : Hashable {
    
    var id: String = ""
    var name: String?
    var symbol: String?
    var x: Float = 0.0
    var y: Float = 0.0
    var z: Float = 0.0
    
//    var residue: String  = ""
//    var residueId: String  = ""
//    var chain: String  = ""
//    var element: String  = ""
//     var position = Point3D()
//     var valence: Float = 0.0
//    var remoteness: String = "" // A, B, G, D, E, Z, H

    var hashValue : Int {
        get {
            return id!.hashValue
        }
    }
}

func ==(lhs: Atom, rhs: Atom) -> Bool {
    
    return lhs.hashValue == rhs.hashValue
}