//
//  ColourFactory.swift
//  IMVS
//
//  Created by Allistair Crossley on 13/07/2014.
//  Copyright (c) 2014 Allistair Crossley. All rights reserved.
//

import Foundation

class ColourFactory {
    
    class func makeCPKColour(atom: Atom) -> Colour {
        
        switch atom.element {
        case "C" :
            return Colour(r: 200, g: 200, b: 200) // Carbon
        case "O" :
            return Colour(r: 240, g:   0, b:   0) // Oxygen
        case "H" :
            return Colour(r: 255, g: 255, b: 255) // Hydrogen
        case "N" :
            return Colour(r: 143, g: 143, b: 255) // Nitrogen
        case "S" :
            return Colour(r: 255, g: 200, b:  50) // Sulphur
        case "Cl" :
            return Colour(r:   0, g: 255, b:   0) // Chlorine
        case "B" :
            return Colour(r:   0, g: 255, b:   0) // Boron
        case "P" :
            return Colour(r: 255, g: 165, b:   0) // Phosphorus
        case "P" :
            return Colour(r: 255, g: 165, b:   0) // Iron
        case "P" :
            return Colour(r: 255, g: 165, b:   0) // Barium
        case "Na" :
            return Colour(r:   0, g:   0, b: 255) // Sodium
        case "Mg" :
            return Colour(r:  34, g: 139, b:  34) // Magnesium
        case "Zn" :
            return Colour(r: 165, g:  42, b:  42) // ?
        case "Cu" :
            return Colour(r: 165, g:  42, b:  42) // ?
        case "Ni" :
            return Colour(r: 165, g:  42, b:  42) // ?
        case "Br" :
            return Colour(r: 165, g:  42, b:  42) // ?
        case "Ca" :
            return Colour(r: 128, g: 128, b: 144) // ?
        case "Mn" :
            return Colour(r: 128, g: 128, b: 144) // ?
        case "Al" :
            return Colour(r: 128, g: 128, b: 144) // ?
        case "Ti" :
            return Colour(r: 128, g: 128, b: 144) // ?
        case "Cr" :
            return Colour(r: 128, g: 128, b: 144) // ?
        case "Ag" :
            return Colour(r: 128, g: 128, b: 144) // ?
        case "F" :
            return Colour(r: 218, g: 165, b:  32) // ?
        case "Si" :
            return Colour(r: 218, g: 165, b:  32) // ?
        case "Au" :
            return Colour(r: 218, g: 165, b:  32) // ?
        case "I" :
            return Colour(r: 160, g:  32, b:  240) // Iodine
        case "Li" :
            return Colour(r: 178, g:  34, b:   34) // Lithium
        case "He" :
            return Colour(r: 255, g: 192, b: 203) // Lithium
        default:
            return Colour(r: 255, g:  20, b: 147) // Unknown
        }
    }
    
    /**
     * Amino acid residue colours (default)
     * http://life.nthu.edu.tw/~fmhsu/rasframe/COLORS.HTM
     */
    class func makeAminoColour(atom: Atom) -> Colour {
        
        switch atom.residue {
        case "ASP" :
            return Colour(r: 230, g:  10, b:  10)
        case "GLU" :
            return Colour(r: 230, g:  10, b:  10)
        case "LYS" :
            return Colour(r:  20, g:  90, b: 255)
        case "ARG" :
            return Colour(r:  20, g:  90, b: 255)
        case "PHE" :
            return Colour(r:  50, g:  50, b: 170)
        case "TYR" :
            return Colour(r:  50, g:  50, b: 170)
        case "GLY" :
            return Colour(r: 235, g: 235, b: 235)
        case "ALA" :
            return Colour(r: 200, g: 200, b: 200)
        case "HIS" :
            return Colour(r: 130, g: 130, b: 210)
        case "CYS" :
            return Colour(r: 230, g: 230, b:   0)
        case "MET" :
            return Colour(r: 230, g: 230, b:   0)
        case "SER" :
            return Colour(r: 250, g: 150, b:   0)
        case "THR" :
            return Colour(r: 250, g: 150, b:   0)
        case "ASN" :
            return Colour(r:   0, g: 220, b: 220)
        case "GLN" :
            return Colour(r:   0, g: 220, b: 220)
        case "LEU" :
            return Colour(r:  15, g: 130, b:  15)
        case "VAL" :
            return Colour(r:  15, g: 130, b:  15)
        case "ILE" :
            return Colour(r:  15, g: 130, b:  15)
        case "TRP" :
            return Colour(r: 180, g:  90, b: 180)
        case "PRO" :
            return Colour(r: 220, g: 150, b: 130)
        default:
            return Colour(r: 255, g:  20, b: 147) // Unknown
        }
    }
}