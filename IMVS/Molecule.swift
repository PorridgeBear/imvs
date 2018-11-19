//
//  Model.swift
//  IMVS
//
//  Created by Allistair Crossley on 06/07/2014.
//  Copyright (c) 2014 Allistair Crossley. All rights reserved.
//

import Foundation

/**
 * Molecule
 * https://www.umass.edu/microbio/rasmol/rasbonds.htm#src
 */
class Molecule {
    
    var name: String = ""
    
    var center = Point3D()
    
    var minX: Float = 0.0,
        minY: Float = 0.0,
        minZ: Float = 0.0,
        maxX: Float = 0.0,
        maxY: Float = 0.0,
        maxZ: Float = 0.0,
        maxN: Float = 0.0
    
    var bonds: [Bond] = []
    
    var chains: [Chain] = []
    var chain: Chain = Chain()
    
    var helices: [SecondaryStructure] = []
    var sheets: [SecondaryStructure] = []
    var turns: [SecondaryStructure] = []
    
    var clouds: [AtomCloud] = []
        
    func addAtom(atom: Atom) {
        
        // Create new chains as they occur
        if chain.id != atom.chain {
            chain = Chain(id: atom.chain)
            chains.append(chain)
        }
        
        chain.addAtom(atom: atom)
    }
    
    func commit() {
        
        var pt = PeriodicTable() // replace with static
        var numAtoms = 0
        
        // Compute bounds and set additional atom meta
        for chain in chains {
            
            for residue in chain.residues {
                
                for atom in residue.atoms {
            
                    atom.valence = pt.getElementBySymbol(symbol: atom.element).valence
                    
                    if atom.position.x < minX {
                        minX = atom.position.x
                    }
                    
                    if atom.position.x > maxX {
                        maxX = atom.position.x
                    }
                    
                    if atom.position.y < minY {
                        minY = atom.position.y
                    }
                    
                    if atom.position.y > maxY {
                        maxY = atom.position.y
                    }
                    
                    if atom.position.z < minZ {
                        minZ = atom.position.z
                    }
                    
                    if atom.position.z > maxZ {
                        maxZ = atom.position.z
                    }
                    
                    center.x += atom.position.x
                    center.y += atom.position.y
                    center.z += atom.position.z
                    
                    numAtoms += 1
                }
            }
        }
        
        // Calculate the center
        center.x = center.x / Float(numAtoms)
        center.y = center.y / Float(numAtoms)
        center.z = center.z / Float(numAtoms)
        
        // Compute the max length on any side
        if maxX > maxN {
            maxN = maxX
        } else if maxY > maxN {
            maxN = maxY
        } else if maxZ > maxN {
            maxN = maxZ
        }
        
        // @TODO MoleculeViewController will need to show loading bonds screen
        // @TODO perhaps for huge molecules restrict display modes to those not needing bonds?
        //dispatch_async(dispatch_get_main_queue(), {
            self.createBonds()
        //});
    }
    
    /**
     * Tests if 2 atom distances are within their summed valence value
     * RasMol algorithms
     */
    func createBonds() {
        
        // Need to figure out better implementation, for now:
        // per-chain bonding, then other special bonds (disulphide bridges,
        // polypeptide chains and sugar phosphates)
        
        print("Creating bonds")
        
        for chain in chains {
            
            print("Chain \(chain.id)");
            
            var cloud = AtomCloud(cubeLength: 1.83)
            
            for residue in chain.residues {
                for i in 0..<residue.atoms.count {
                    cloud.insert(atom: residue.atoms[i])
                }
            }
            
            clouds.append(cloud)
            doBonds(cloud: cloud, chain: chain)
        }
        
        print("Created \(bonds.count) bonds.")
    }
    
    func doBonds(cloud: AtomCloud, chain: Chain) {

        for residue in chain.residues {
            
            for src in residue.atoms {
                
                let nearests = cloud.nearest(atom: src)
                
                for dst in nearests {
                
                    if doesBondExist(src: src, dst: dst) {
                        continue
                    }
                    
                    // Find distance between 2 atoms using Pythagoras
                    let a = src.position.x - dst.position.x
                    let b = src.position.y - dst.position.y
                    let c = src.position.z - dst.position.z
                    let d = sqrt(a * a + b * b + c * c)
                    
                    let max: Float = src.valence + dst.valence + 0.56
                    if d >= 0.4 && d <= max {
                        let bond = Bond(src: src, dst: dst)
                        bonds.append(bond)
                    }
                    
                    /* RasMol quick bonding method
                    var upperLimit: Float = doesBondIncludeHydrogen(src, dst: dst) ? 1.2 : 1.9
                    if d >= 0.4 && d <= upperLimit {
                    let bond = Bond(src: src, dst: dst)
                    bonds.append(bond)
                    }
                    */
                }
            }
        }
    }
    
    func doesBondIncludeHydrogen(src: Atom, dst: Atom) -> Bool {
    
        return src.element == "H" || dst.element == "H"
    }
    
    func doesBondExist(src: Atom, dst: Atom) -> Bool {
        
        for bond in bonds {
            
            if (bond.src.id == src.id && bond.dst.id == dst.id ||
                bond.src.id == dst.id && bond.dst.id == src.id) {
                return true
            }
        }
        
        return false
    }
}
