//
//  RenderFactory.swift
//  IMVS
//
//  Created by Allistair Crossley on 14/07/2014.
//  Copyright (c) 2014 Allistair Crossley. All rights reserved.
//

import Foundation
import SceneKit

/**
 * Factory class for creating SCNNode geometry for different molecule representations
 */
class RenderFactory {
    
    class func createBalls(colour: RenderColourEnumeration, molecule: Molecule, molNode: SCNNode, forceSize: Float) {
        let mode = BallsRenderMode()
        mode.create(colour, molecule: molecule, molNode: molNode, forceSize: forceSize)
    }
    
    class func createSticks(colour: RenderColourEnumeration, molecule: Molecule, molNode: SCNNode) {
        let mode = SticksRenderMode()
        mode.create(colour, molecule: molecule, molNode: molNode)
    }
    
    class func createCartoons(colour: RenderColourEnumeration, molecule: Molecule, molNode: SCNNode) {
        let mode = CartoonsRenderMode()
        mode.create(colour, molecule: molecule, molNode: molNode)
    }
    
    /**
     * Used by sticks mode to return 1/2 stick (bond) rotation/orientation and length
     */
    class func computeBondHeightAndTransform(f: Atom, t: Atom, m: Molecule) -> (height: Float, transform: SCNMatrix4) {

        let fToT = SCNVector3Make(t.position.x - f.position.x, t.position.y - f.position.y, t.position.z - f.position.z)
        let worldY = SCNVector3Make(0, 1, 0)
        
        var angle = acos(SCNVector3DotProduct(worldY, fToT.normalized()))
        if SCNVector3DotProduct(SCNVector3Make(fToT.x, 0, fToT.z), fToT) > 0 {
            angle = -angle;
        }
        
        let rotAxis = SCNVector3CrossProduct(fToT, worldY).normalized();

        let origin = SCNVector3(x: f.position.x - m.center.x + (fToT.x / 4),
                                y: f.position.y - m.center.y + (fToT.y / 4),
                                z: f.position.z - m.center.z + (fToT.z / 4))
        
        let translation = SCNMatrix4MakeTranslation(origin.x, origin.y, origin.z)
        let rotation = SCNMatrix4MakeRotation(angle, rotAxis.x, rotAxis.y, rotAxis.z)
        
        let m = SCNMatrix4Mult(rotation, translation)
        let d = fToT.length() / 2

        return (d, m)
    }
    
    /**
     * Used to visually debug the AtomCloud bonding method
     */
    class func overlayCubes(molecule: Molecule, molNode: SCNNode, forceSize: Float) {
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.redColor()
        material.lightingModelName = SCNLightingModelLambert
        material.locksAmbientWithDiffuse = true
        
        for cloud in molecule.clouds {
            
            for (index, cube) in cloud.grid {
                
                let cubeNode = SCNNode()
                cubeNode.opacity = 0.5
                cubeNode.position = SCNVector3(
                    x: cube.wx - molecule.center.x,
                    y: cube.wy - molecule.center.y,
                    z: cube.wz - molecule.center.z)
                cubeNode.geometry = SCNBox(width: CGFloat(cube.w), height: CGFloat(cube.h), length: CGFloat(cube.l), chamferRadius: 0.0)
                cubeNode.geometry!.firstMaterial = material
                molNode.addChildNode(cubeNode)

                /*
                for atom in cube.objects {
                    
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
                    atomNode.geometry = SCNSphere(radius: CGFloat(forceSize <= 0.0 ? SizeFactory.makeCovalentSize(atom) + 0.5 : forceSize))
                    atomNode.geometry.firstMaterial = material
                    molNode.addChildNode(atomNode)
                }
                */
            }
        }
    }    
}