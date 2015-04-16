//
//  PDBLoader.swift
//  IMVS
//
//  Created by Allistair Crossley on 06/07/2014.
//  Copyright (c) 2014 Allistair Crossley. All rights reserved.
//

import Foundation

struct SecondaryStructureRange {
    var chainId: String
    var initSeqNum: Int
    var endSeqNum: Int
}

class PDBLoader {
    
    var molecule = Molecule()
    var helices: [SecondaryStructureRange] = []
    var sheets: [SecondaryStructureRange] = []
    
    func loadMoleculeForPath(pdbFile: String) {
        
        //let path = NSBundle.mainBundle().pathForResource(pdbFile, ofType: "pdb")
        molecule.name = pdbFile

        let content = String(contentsOfFile: pdbFile, encoding: NSUTF8StringEncoding, error: nil)
        let lines = content!.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
       
        for line in lines {
            readHEADERWithLine(line)
            readATOMWithLine(line)
            readHELIXWithLine(line)
            readSHEETWithLine(line)
        }
        
        assignHelices()
        assignSheets()
        
        molecule.commit()
    }
    
    func getDataForColumnsInLine(line: String, from: Int, to: Int) -> String {
        let tmp = (line as NSString).substringFromIndex(from - 1)
        return (tmp as NSString).substringToIndex(to - from + 1).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    func isRecordTypeEqualTo(to: String, line: String) -> Bool {
        
        if line.isEmpty || count(line) < 6 {
            return false
        }
        
        return getDataForColumnsInLine(line, from: 1, to: 6) == to
    }

    func readHEADERWithLine(line: String) {
        
        if isRecordTypeEqualTo("HEADER", line: line) {
            // molecule.name = getDataForColumnsInLine(line, from: 11, to: 50)
        }
    }
    
    func readATOMWithLine(line: String) {
        
        if isRecordTypeEqualTo("ATOM", line: line) {
            
            let id = getDataForColumnsInLine(line, from: 7, to: 11)
            
            let name = getDataForColumnsInLine(line, from: 13, to: 16)
            let element = getDataForColumnsInLine(line, from: 13, to: 14)
            let remoteness = getDataForColumnsInLine(line, from: 15, to: 15)
            
            let residue = getDataForColumnsInLine(line, from: 18, to: 20)
            let chain = getDataForColumnsInLine(line, from: 22, to: 22)
            let resSeq = getDataForColumnsInLine(line, from: 23, to: 26)

            let x = (getDataForColumnsInLine(line, from: 31, to: 38) as NSString).floatValue
            let y = (getDataForColumnsInLine(line, from: 39, to: 46) as NSString).floatValue
            let z = (getDataForColumnsInLine(line, from: 47, to: 54) as NSString).floatValue
            
            let atom = Atom(id: id, name: name, residue: residue, resId: resSeq, chain: chain, element: element, x: x, y: y, z: z, remoteness: remoteness)
            
            molecule.addAtom(atom)
        }
    }
    
    func readHELIXWithLine(line: String) {
        
        if isRecordTypeEqualTo("HELIX", line: line) {
            
            let initChainID = getDataForColumnsInLine(line, from: 20, to: 20);
            let initSeqNum = getDataForColumnsInLine(line, from: 22, to: 25).toInt();
            let endChainID = getDataForColumnsInLine(line, from: 32, to: 32);
            let endSeqNum = getDataForColumnsInLine(line, from: 34, to: 37).toInt();
            
            // keep helices in the same chain
            if (initChainID != endChainID) {
                return;
            }
            
            helices.append(SecondaryStructureRange(chainId: initChainID, initSeqNum: initSeqNum!, endSeqNum: endSeqNum!))
        }
    }
    
    func assignHelices() {
        
        for helix in helices {
            let chain = molecule.findChainById(helix.chainId)
            if chain != nil {
                for residue in chain!.residues {
                    if inRange(residue.id, rangeInit: helix.initSeqNum, rangeEnd: helix.endSeqNum) {
                        residue.isHelixPart = true
                    }
                }
            }
        }
    }
    
    func readSHEETWithLine(line: String) {
        
        if isRecordTypeEqualTo("SHEET", line: line) {

            let initChainID = getDataForColumnsInLine(line, from: 22, to: 22);
            let initSeqNum = getDataForColumnsInLine(line, from: 23, to: 26).toInt();
            let endChainID = getDataForColumnsInLine(line, from: 33, to: 33);
            let endSeqNum = getDataForColumnsInLine(line, from: 34, to: 37).toInt();
            
            // keep sheets in the same chain
            if (initChainID != endChainID) {
                return;
            }
            
            sheets.append(SecondaryStructureRange(chainId: initChainID, initSeqNum: initSeqNum!, endSeqNum: endSeqNum!))
        }
    }
    
    func assignSheets() {
        
        for sheet in sheets {
            let chain = molecule.findChainById(sheet.chainId)
            if chain != nil {
                for residue in chain!.residues {
                    if inRange(residue.id, rangeInit: sheet.initSeqNum, rangeEnd: sheet.endSeqNum) {
                        residue.isSheetPart = true
                    }
                }
            }
        }
    }

    
    func inRange(n: String, rangeInit: Int, rangeEnd: Int) -> Bool {

        let i = n.toInt()
        
        if i == nil {
            return false
        }
    
        if i >= rangeInit && i <= rangeEnd {
            return true
        }
    
        return false
    }
}
