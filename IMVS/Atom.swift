//
//  Atom.swift
//  IMVS
//
//  Created by Allistair Crossley on 06/07/2014.
//  Copyright (c) 2014 Allistair Crossley. All rights reserved.
//

import Foundation

class Atom : Hashable {
    
    var id: String  = ""
    var name: String  = ""
    var residue: String  = ""
    var residueId: String  = ""
    var chain: String  = ""
    var element: String  = ""
    var position = Point3D()
    var valence: Float = 0.0
    var remoteness: String = "" // A, B, G, D, E, Z, H
    
    var hashValue : Int {
        get {
            return "\(self.position.x)\(self.position.y)\(self.position.z)".hashValue
        }
    }
    
    init(id: String, name: String, residue: String, resId: String, chain: String, element: String, x: Float, y: Float, z: Float, remoteness: String) {
        
        self.id = id
        self.name = name
        self.residue = residue
        self.residueId = resId
        self.chain = chain
        self.element = element
        
        position.x = x
        position.y = y
        position.z = z
        
        self.remoteness = remoteness
    }
}

func ==(lhs: Atom, rhs: Atom) -> Bool {
    
    return lhs.hashValue == rhs.hashValue
}