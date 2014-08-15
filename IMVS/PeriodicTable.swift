//
//  PeriodicTable.swift
//  IMVS
//
//  Created by Allistair Crossley on 16/07/2014.
//  Copyright (c) 2014 Allistair Crossley. All rights reserved.
//

import Foundation

class PeriodicTable {

    // class var HYDROGEN = "H"
    
    var table: [String: Element] = [
        "H":  Element(symbol: "H",  valence: 0.31),
        "He": Element(symbol: "He", valence: 0.28),
        "Li": Element(symbol: "Li", valence: 1.28),
        "Be": Element(symbol: "Be", valence: 0.96),
        "B":  Element(symbol: "B",  valence: 0.84),
        "C":  Element(symbol: "C",  valence: 0.69),
        "N":  Element(symbol: "N",  valence: 0.71),
        "O":  Element(symbol: "O",  valence: 0.66),
        "F":  Element(symbol: "F",  valence: 0.57),
        "Ne": Element(symbol: "Ne", valence: 0.58),
        "Na": Element(symbol: "Na", valence: 1.66),
        "Mg": Element(symbol: "Mg", valence: 1.41),
        "Al": Element(symbol: "Al", valence: 1.21),
        "Si": Element(symbol: "Si", valence: 1.11),
        "P":  Element(symbol: "P",  valence: 1.07),
        "S":  Element(symbol: "S",  valence: 1.05),
        "Cl": Element(symbol: "Cl", valence: 1.02),
        "Ar": Element(symbol: "Ar", valence: 1.06),
        "K":  Element(symbol: "K",  valence: 2.03),
        "Ca": Element(symbol: "Ca", valence: 1.76),
        "XX": Element(symbol: "XX", valence: 0.60)
    ]
    
    func getElementBySymbol(symbol: String) -> Element {
        
        var elem = table[symbol]!;
        
        if (elem == nil) {
            elem = table["XX"]!
        }
        
        return elem
    }
}

struct Element {
    
    var symbol: String
    var valence: Float
    
    init(symbol: String, valence: Float) {
        
        self.symbol = symbol
        self.valence = valence
    }
}