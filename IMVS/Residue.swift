//
//  Residue.swift
//  IMVS
//
//  Created by Allistair Crossley on 13/07/2014.
//  Copyright (c) 2014 Allistair Crossley. All rights reserved.
//

import Foundation

/**
 * Amino Acid Residue
 *
 * A protein chain will have somewhere in the range of 50 to 2000 amino acid residues. 
 * You have to use this term because strictly speaking a peptide chain isn't made up of amino acids. 
 * When the amino acids combine together, a water molecule is lost. The peptide chain is made up 
 * from what is left after the water is lost - in other words, is made up of amino acid residues.
 * http://www.chemguide.co.uk/organicprops/aminoacids/proteinstruct.html
 * C and N terminus
 */
class Residue {
    
    var id: String = ""
    var name: String = ""
    var atoms: [Atom] = []
    var isHelixPart: Bool = false
    var isSheetPart: Bool = false
    
    init(id: String, name: String) {
        
        self.id = id
        self.name = name
    }
    
    func addAtom(atom: Atom) {

        atoms.append(atom)
    }
    
    func getAlphaCarbon() -> Atom? {
        
        for atom in atoms {
            if atom.element == "C" && atom.remoteness == "A" {
                return atom
            }
        }
        
        return nil
    }
    
    /** TODO - Might not be 100% right grabbing the first O - check */
    func getCarbonylOxygen() -> Atom? {
        
        for atom in atoms {
            if atom.element == "O" {
                return atom
            }
        }
        
        return nil
    }
}
