//
//  BallRenderMode.swift
//  IMVS
//
//  Created by Allistair Crossley on 17/02/2015.
//  Copyright (c) 2015 Allistair Crossley. All rights reserved.
//

import Foundation
import SceneKit

class BallsRenderMode {
    
    /**
    * Render molecule atoms as balls of radius  according to their covalent radius + 0.5A
    */
    func create(colour: RenderColourEnumeration, molecule: Molecule, molNode: SCNNode, forceSize: Float) {
        
        for model in molecule.models {
            for chain in model.chains {
                
                for residue in chain.residues {
                    
                    for atom in residue.atoms {
                        
                        let material = SCNMaterial()
                        
                        var col: Colour
                        switch colour {
                        case RenderColourEnumeration.Amino:
                            col = ColourFactory.makeAminoColour(atom)
                            break
                        default:
                            col = ColourFactory.makeCPKColour(atom)
                        }
                        
                        material.diffuse.contents = UIColor(red: CGFloat(col.r) / 255.0, green: CGFloat(col.g) / 255.0, blue: CGFloat(col.b) / 255.0, alpha: 1)
                        material.lightingModelName = SCNLightingModelLambert
                        material.locksAmbientWithDiffuse = true
                        
                        let atomNode = SCNNode()
                        atomNode.name = "id=\(atom.id) \(atom.name)"
                        atomNode.position = SCNVector3(
                            x: atom.position.x - molecule.center.x,
                            y: atom.position.y - molecule.center.y,
                            z: atom.position.z - molecule.center.z)
                        atomNode.geometry = SCNSphere(radius: CGFloat(forceSize <= 0.0 ? SizeFactory.makeCovalentSize(atom) + 0.5 : forceSize))
                        atomNode.geometry!.firstMaterial = material
                        molNode.addChildNode(atomNode)
                    }
                }
            }
        }
    }
}