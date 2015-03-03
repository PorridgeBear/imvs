//
//  Model.swift
//  IMVS
//
//  Created by Allistair Crossley on 23/02/2015.
//  Copyright (c) 2015 Allistair Crossley. All rights reserved.
//

import Foundation

class Model {
    
    var id: String = ""
    var chains: [Chain] = []
    
    func findChainById(id: String) -> Chain? {

        for chain in chains {
            if id == chain.id {
                return chain
            }
        }
        
        let chain = Chain(id: id)
        chains.append(chain)
        return chain
    }
    
    func addAtom(atom: Atom) {
        println("Model.addAtom chain=\(atom.chain)")
        
        let chain = findChainById(atom.chain)
        if chain != nil {
            chain!.addAtom(atom)
        }
    }
}