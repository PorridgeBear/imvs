//
//  RadiusFactory.swift
//  IMVS
//
//  Created by Allistair Crossley on 14/07/2014.
//  Copyright (c) 2014 Allistair Crossley. All rights reserved.
//

import Foundation

class SizeFactory {
    
    class func makeCovalentSize(atom: Atom) -> Float {
        
        switch atom.element {
        case "H" :
            return 0.25
        case "Li" :
            return 1.45
        case "Be" :
            return 1.05
        case "B" :
            return 0.85
        case "C" :
            return 0.70
        case "N" :
            return 0.65
        case "O" :
            return 0.60
        case "F" :
            return 0.50
        case "Na" :
            return 1.80
        case "Mg" :
            return 1.50
        case "Al" :
            return 1.25
        case "Si" :
            return 1.10
        case "S" :
            return 1.00
        case "Cl" :
            return 1.00
        case "K" :
            return 2.20
        case "Ca" :
            return 1.80
        default :
            return 1.0
        }
    }
}
            