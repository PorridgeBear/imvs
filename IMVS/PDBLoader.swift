//
//  PDBLoader.swift
//  IMVS
//
//  Created by Allistair Crossley on 06/07/2014.
//  Copyright (c) 2014 Allistair Crossley. All rights reserved.
//

import Foundation

class PDBLoader {
    
    var molecule = Molecule()
    
    func loadMoleculeForPath(pdbFile: String) {
        
        let path = Bundle.main.path(forResource: pdbFile, ofType: "pdb")
        molecule.name = pdbFile

        do {
            let content = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            let lines = content.components(separatedBy: NSCharacterSet.newlines)
            
            for line in lines {
                readHEADERWithLine(line: line)
                readATOMWithLine(line: line)
            }
            
            molecule.commit()
        } catch {
            print(error)
        }
    }
    
    func getDataForColumnsInLine(line: String, from: Int, to: Int) -> String {
        let tmp = (line as NSString).substring(from: from - 1)
        return (tmp as NSString).substring(to: to - from + 1).trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    func isRecordTypeEqualTo(to: String, line: String) -> Bool {
        
        if line.isEmpty || line.count < 6 {
            return false
        }
        
        return getDataForColumnsInLine(line: line, from: 1, to: 6) == to
    }

    func readHEADERWithLine(line: String) {
        
        if isRecordTypeEqualTo(to: "HEADER", line: line) {
            // molecule.name = getDataForColumnsInLine(line, from: 11, to: 50)
        }
    }
    
    func readATOMWithLine(line: String) {
        
        if isRecordTypeEqualTo(to: "ATOM", line: line) {
            
            let id = getDataForColumnsInLine(line: line, from: 7, to: 11)
            
            let name = getDataForColumnsInLine(line: line, from: 13, to: 16)
            let element = getDataForColumnsInLine(line: line, from: 13, to: 14)
            let remoteness = getDataForColumnsInLine(line: line, from: 15, to: 15)
            
            let residue = getDataForColumnsInLine(line: line, from: 18, to: 20)
            let chain = getDataForColumnsInLine(line: line, from: 22, to: 22)

            let x = (getDataForColumnsInLine(line: line, from: 31, to: 38) as NSString).floatValue
            let y = (getDataForColumnsInLine(line: line, from: 39, to: 46) as NSString).floatValue
            let z = (getDataForColumnsInLine(line: line, from: 47, to: 54) as NSString).floatValue
            
            let atom = Atom(id: id, name: name, residue: residue, chain: chain, element: element, x: x, y: y, z: z, remoteness: remoteness)
            
            molecule.addAtom(atom: atom)
        }
    }
}
