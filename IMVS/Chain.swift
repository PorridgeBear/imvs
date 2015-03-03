//
//  Chain.swift
//  IMVS
//
//  Created by Allistair Crossley on 13/07/2014.
//  Copyright (c) 2014 Allistair Crossley. All rights reserved.
//

import Foundation

class Chain {
    
    var id: String?
    var residues: [Residue] = []

    init(id: String) {
        
        self.id = id
    }
    
    func findResidueById(id: String, name: String) -> Residue {
        
        for residue in residues {
            if id == residue.id {
                return residue
            }
        }
        
        let residue = Residue(id: id, name: name)
        residues.append(residue)
        return residue
    }
    
    func addAtom(atom: Atom) {
        println(atom.residueId)
        findResidueById(atom.residueId, name: atom.residue).addAtom(atom)
    }
}