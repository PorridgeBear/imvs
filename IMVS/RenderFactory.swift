//
//  RenderFactory.swift
//  IMVS
//
//  Created by Allistair Crossley on 14/07/2014.
//  Copyright (c) 2014 Allistair Crossley. All rights reserved.
//

import Foundation
import SceneKit

class RenderFactory {
    
    class func createBalls(molecule: Molecule) -> SCNNode {
        
        let molNode = SCNNode()
        
        for chain in molecule.chains {
            
            for residue in chain.residues {
                
                for atom in residue.atoms {
                    
                    let material = SCNMaterial()
                    let colour = ColourFactory.makeCPKColour(atom)
                    material.diffuse.contents = UIColor(red: CGFloat(colour.r) / 255.0, green: CGFloat(colour.g) / 255.0, blue: CGFloat(colour.b) / 255.0, alpha: 1)
                    material.lightingModelName = SCNLightingModelLambert
                    material.locksAmbientWithDiffuse = true
                    
                    let atomNode = SCNNode()
                    atomNode.position = SCNVector3(
                        x: atom.position.x - molecule.center.x,
                        y: atom.position.y - molecule.center.y,
                        z: atom.position.z - molecule.center.z)
                    atomNode.geometry = SCNSphere(radius: CGFloat(SizeFactory.makeCovalentSize(atom) + 0.5))
                    atomNode.geometry.firstMaterial = material
                    molNode.addChildNode(atomNode)
                }
            }
        }
        
        return molNode
    }
    
    class func createSticks(molecule: Molecule) -> SCNNode {
        
        let molNode = SCNNode()
        
        for chain in molecule.chains {
            
            for residue in chain.residues {
                
                for atom in residue.atoms {
                    
                    let material = SCNMaterial()
                    let colour = ColourFactory.makeCPKColour(atom)
                    material.diffuse.contents = UIColor(red: CGFloat(colour.r) / 255.0, green: CGFloat(colour.g) / 255.0, blue: CGFloat(colour.b) / 255.0, alpha: 1)
                    material.lightingModelName = SCNLightingModelLambert
                    material.locksAmbientWithDiffuse = true
                    
                    let atomNode = SCNNode()
                    let r = SCNVector4(x: 2, y: 3, z: 4, w: 5)
                    atomNode.rotation = r
                    atomNode.position = SCNVector3(
                        x: atom.position.x - molecule.center.x,
                        y: atom.position.y - molecule.center.y,
                        z: atom.position.z - molecule.center.z)
                    atomNode.geometry = SCNTube(innerRadius: 0.25, outerRadius: 0.25, height: 2)
                    atomNode.geometry.firstMaterial = material
                    molNode.addChildNode(atomNode)
                }
            }
        }
        
        return molNode
    }
}