//
//  Atom.swift
//  IMVS
//
//  Created by Allistair Crossley on 06/07/2014.
//  Copyright (c) 2014 Allistair Crossley. All rights reserved.
//

import Foundation

class Atom {
    
    var id: String  = ""
    var name: String  = ""
    var residue: String  = ""
    var chain: String  = ""
    var element: String  = ""
    var position = Point3D()
    var valence: Float = 0.0
    var remoteness: String = "" // A, B, G, D, E, Z, H
    
    init(id: String, name: String, residue: String, chain: String, element: String, x: Float, y: Float, z: Float, remoteness: String) {
        
        self.id = id
        self.name = name
        self.residue = residue
        self.chain = chain
        self.element = element
        
        position.x = x
        position.y = y
        position.z = z
        
        self.remoteness = remoteness
    }
}