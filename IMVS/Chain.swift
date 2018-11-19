//
//  Chain.swift
//  IMVS
//
//  Created by Allistair Crossley on 13/07/2014.
//  Copyright (c) 2014 Allistair Crossley. All rights reserved.
//

import Foundation

class Chain {
    
    var id: String = ""
    var residues: [Residue] = []
    var residue: Residue = Residue()

    convenience init() {
        
        self.init(id: "NONE")
    }

    init(id:String) {
        
        self.id = id
    }
    
    func addAtom(atom: Atom) {
        
        // Create new residues as they occur
        if residue.name != atom.residue {
            residue = Residue(name: atom.residue)
            residues.append(residue)
        }
        
        residue.addAtom(atom: atom)
    }
}
