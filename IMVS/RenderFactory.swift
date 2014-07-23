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
                    atomNode.geometry = SCNSphere(radius: CGFloat(SizeFactory.makeCovalentSize(atom) + 0.5) * 0.3)
                    atomNode.geometry.firstMaterial = material
                    molNode.addChildNode(atomNode)
                }
            }
        }
        
        return molNode
    }
    
    class func createSticks(molecule: Molecule) -> SCNNode {
        
        let molNode = SCNNode()
        
        println("Draw \(molecule.bonds.count) bonds")
        
        for bond in molecule.bonds {
            
            // Bond src half
            
            var bondNodeSrc = SCNNode()
            bondNodeSrc.position = SCNVector3(x: bond.src.position.x, y: bond.src.position.y, z: bond.src.position.z)
            let bondHeightAndTSrc = computeBondHeightAndTransform(bond.src, t: bond.dst, m: molecule)
            bondNodeSrc.transform = bondHeightAndTSrc.transform
            
            let materialSrc = SCNMaterial()
            let colourSrc = ColourFactory.makeCPKColour(bond.src)
            materialSrc.diffuse.contents = UIColor(red: CGFloat(colourSrc.r) / 255.0, green: CGFloat(colourSrc.g) / 255.0, blue: CGFloat(colourSrc.b) / 255.0, alpha: 1)
            materialSrc.lightingModelName = SCNLightingModelLambert
            materialSrc.locksAmbientWithDiffuse = true
            
            bondNodeSrc.geometry = SCNTube(innerRadius: 0.1, outerRadius: 0.1, height: bondHeightAndTSrc.height)
            bondNodeSrc.geometry.firstMaterial = materialSrc
            
            // Bond dst half
            /*
            var bondNodeDst = SCNNode()
            bondNodeDst.position = SCNVector3(x: bond.dst.position.x, y: bond.dst.position.y, z: bond.dst.position.z)
            let bondHeightAndTDst = computeBondHeightAndTransform(bond.dst, t: bond.src)
            //bondNodeDst.transform = bondHeightAndTDst.transform
            
            let materialDst = SCNMaterial()
            let colourDst = ColourFactory.makeCPKColour(bond.dst)
            materialDst.diffuse.contents = UIColor(red: CGFloat(colourDst.r) / 255.0, green: CGFloat(colourDst.g) / 255.0, blue: CGFloat(colourDst.b) / 255.0, alpha: 1)
            materialDst.lightingModelName = SCNLightingModelLambert
            materialDst.locksAmbientWithDiffuse = true
            
            bondNodeDst.geometry = SCNTube(innerRadius: 0.1, outerRadius: 0.1, height: bondHeightAndTDst.height)
            bondNodeDst.geometry.firstMaterial = materialDst
            */
            // Add to molecule
            
            molNode.addChildNode(bondNodeSrc)
        }
        
        return molNode
    }

    class func computeBondHeightAndTransform(f: Atom, t: Atom, m: Molecule) -> (height: Float, transform: SCNMatrix4) {

        let fToT = SCNVector3Make(t.position.x - f.position.x, t.position.y - f.position.y, t.position.z - f.position.z)
        let worldY = SCNVector3Make(0, 1, 0)
        
        var angle = acos(SCNVector3DotProduct(worldY, fToT.normalized()))
        if( SCNVector3DotProduct(SCNVector3Make(fToT.x, 0, fToT.z), fToT) > 0) {
            angle = -angle;
        }
        let rotAxis = SCNVector3CrossProduct(fToT, worldY).normalized();

        var origin = SCNVector3(x: f.position.x - m.center.x + (fToT.x / 2),
                                y: f.position.y - m.center.y + (fToT.y / 2),
                                z: f.position.z - m.center.z + (fToT.z / 2))
        var translation = SCNMatrix4MakeTranslation(origin.x, origin.y, origin.z)
        var rotation = SCNMatrix4MakeRotation(angle, rotAxis.x, rotAxis.y, rotAxis.z)
        let m = SCNMatrix4Mult(rotation, translation)
        
        let d = fToT.length()

        return (d, m)
    }
    
//    class func computeBondHeightAndTransform(f: Atom, t: Atom) -> (height: Float, transform: SCNMatrix4) {
//        
//        var yAxis = SCNVector3(x: 0, y: 1, z: 0)
//        var cross = SCNVector3(x: 0, y: 0, z: 0)
//        
//        let x = f.position.x + t.position.x
//        let y = f.position.y + t.position.z
//        let z = f.position.z + t.position.z
//        
//        let dx = f.position.x - t.position.x
//        let dy = f.position.y - t.position.y
//        var dz = f.position.z - t.position.z
//        
//        let d = sqrt(dx * dx + dy * dy + dz * dz);
//        
//        // Axis of rotation
//        var dv = SCNVector3(x: dx, y: dy, z: dz)
//        dv.normalize()
//        var aor = yAxis.cross(dv)
//        
//        // Angle of rotation
//        let angle = acos(yAxis.dot(dv))
//        
////        let rm = SCNMatrix4MakeRotation(angle, aor.x, aor.y, aor.z)
////        let tm = SCNMatrix4MakeTranslation(x / 2, y / 2, z / 2)
////        let m = SCNMatrix4Mult(rm, tm)
//        let m = SCNMatrix4MakeTranslation(x, y, z)
//        
//        return (d, m)
//    }
}