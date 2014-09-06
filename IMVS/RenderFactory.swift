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
    
    /**
     * Render molecule atoms as balls of radius  according to their covalent radius + 0.5A
     */
    class func createBalls(colour: RenderColourEnumeration, molecule: Molecule, molNode: SCNNode, forceSize: Float) {
        
        for chain in molecule.chains {
            
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
    
    /**
     * Render molecules as balls of same radius, and bonds as sticks connecting the balls.
     */
    class func createSticks(colour: RenderColourEnumeration, molecule: Molecule, molNode: SCNNode) {
        
        RenderFactory.createBalls(colour, molecule: molecule, molNode: molNode, forceSize: 0.3)
        
        println("Draw \(molecule.bonds.count) bonds")
        
        for bond in molecule.bonds {
            
            // Bond src half
            
            var bondNodeSrc = SCNNode()
            let bondHeightAndTSrc = computeBondHeightAndTransform(bond.src, t: bond.dst, m: molecule)
            bondNodeSrc.transform = bondHeightAndTSrc.transform
            
            let materialSrc = SCNMaterial()
            
            var colSrc: Colour
            switch colour {
            case RenderColourEnumeration.Amino:
                colSrc = ColourFactory.makeAminoColour(bond.src)
                break
            default:
                colSrc = ColourFactory.makeCPKColour(bond.src)
            }
            
            materialSrc.diffuse.contents = UIColor(red: CGFloat(colSrc.r) / 255.0, green: CGFloat(colSrc.g) / 255.0, blue: CGFloat(colSrc.b) / 255.0, alpha: 1)
            materialSrc.lightingModelName = SCNLightingModelLambert
            materialSrc.locksAmbientWithDiffuse = true
            
            bondNodeSrc.geometry = SCNTube(innerRadius: 0.1, outerRadius: 0.1, height: CGFloat(bondHeightAndTSrc.height))
            bondNodeSrc.geometry!.firstMaterial = materialSrc
            
            molNode.addChildNode(bondNodeSrc)
            
            // Bond dst half

            var bondNodeDst = SCNNode()
            let bondHeightAndTDst = computeBondHeightAndTransform(bond.dst, t: bond.src, m: molecule)
            bondNodeDst.transform = bondHeightAndTDst.transform
            
            let materialDst = SCNMaterial()
            
            var colDst: Colour
            switch colour {
            case RenderColourEnumeration.Amino:
                colDst = ColourFactory.makeAminoColour(bond.dst)
                break
            default:
                colDst = ColourFactory.makeCPKColour(bond.dst)
            }

            materialDst.diffuse.contents = UIColor(red: CGFloat(colDst.r) / 255.0, green: CGFloat(colDst.g) / 255.0, blue: CGFloat(colDst.b) / 255.0, alpha: 1)
            materialDst.lightingModelName = SCNLightingModelLambert
            materialDst.locksAmbientWithDiffuse = true
            
            bondNodeDst.geometry = SCNTube(innerRadius: 0.1, outerRadius: 0.1, height: CGFloat(bondHeightAndTDst.height))
            bondNodeDst.geometry!.firstMaterial = materialDst

            molNode.addChildNode(bondNodeDst)
        }
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
    
    /**
    * Work in progress!
    * Currently just ribbons (algorithm by Carson & Bugg 1986)
    */
    class func createCartoons(colour: RenderColourEnumeration, molecule: Molecule, molNode: SCNNode) {
        
        // TODO:
        
        var cartoons = SCNNode()
        
        var a = SCNVector3Zero,
        b = SCNVector3Zero,
        c = SCNVector3Zero,
        d = SCNVector3Zero,
        dPrev = SCNVector3Zero
        
        for chain in molecule.chains {
            
            var guideCoordsN: [SCNVector3] = [],
            guideCoordsP: [SCNVector3] = []
            
            println("Num residues \(chain.residues.count)")
            
            for var ri = 0; ri < chain.residues.count - 1; ri++ {
                
                let resCurr = chain.residues[ri];
                let resNext = chain.residues[ri + 1];
                
                // 1. Define the peptide plane
                
                let caCurr = resCurr.getAlphaCarbon()
                let oxCurr = resCurr.getCarbonylOxygen()
                let caNext = resNext.getAlphaCarbon()
                let oxNext = resNext.getCarbonylOxygen()
                
                if caCurr == nil || oxCurr == nil || caNext == nil || oxNext == nil {
                    continue
                }
                
                a.x = caNext!.position.x - caCurr!.position.x
                a.y = caNext!.position.y - caCurr!.position.y
                a.z = caNext!.position.z - caCurr!.position.z
                
                // c = normal to peptide plane pointing away from helix axis
                c = a.cross(b)
                
                // d = lies parallel to peptide plane and perpendicular to a
                d = c.cross(a)
                
                c.normalize()
                d.normalize()
                
                // 2. Generate guide coordinates
                
                var p = SCNVector3(
                    x: (caCurr!.position.x + caNext!.position.x) / 2.0,
                    y: (caCurr!.position.y + caNext!.position.y) / 2.0,
                    z: (caCurr!.position.z + caNext!.position.z) / 2.0)
                
                /* translate helices away from axis for more room
                if (residueThis.isHelixPart()) {
                c.scale(RIBBON_WIDTH_HELIX);
                p.add(c);
                }
                */
                
                /* scale sheets down
                if (residueThis.isSheetPart()) {
                d.scale(1 / RIBBON_WIDTH_SHEET);
                }
                */
                
                // handle carbonyl oxygen flip
                var d2 = SCNVector3Zero
                
                if ri > 0 && dPrev.dot(d) < 0 {
                    d2.x = -d.x
                    d2.y = -d.y
                    d2.z = -d.z
                } else {
                    d2.x = d.x
                    d2.y = d.y
                    d2.z = d.z
                }
                
                dPrev.x = d2.x
                dPrev.y = d2.y
                dPrev.z = d2.z
                
                // create and store points
                
                var pP = SCNVector3(x: p.x, y: p.y, z: p.z) + SCNVector3Make(1, 1, 1) // + d2
                var pN = SCNVector3(x: p.x, y: p.y, z: p.z) - SCNVector3Make(1, 1, 1) // - d2
                
                guideCoordsN.append(pN)
                guideCoordsP.append(pP)
                
                // 3. construct ribbon geometry
                
                for p in guideCoordsN {
                    
                    let material = SCNMaterial()
                    material.diffuse.contents = UIColor(red: CGFloat(155) / 255.0, green: CGFloat(155) / 255.0, blue: CGFloat(155) / 255.0, alpha: 1)
                    material.lightingModelName = SCNLightingModelLambert
                    material.locksAmbientWithDiffuse = true
                    
                    let atomNode = SCNNode()
                    atomNode.position = SCNVector3(
                        x: p.x - molecule.center.x,
                        y: p.y - molecule.center.y,
                        z: p.z - molecule.center.z)
                    atomNode.geometry = SCNSphere(radius: 0.2)
                    atomNode.geometry!.firstMaterial = material
                    cartoons.addChildNode(atomNode)
                }
                
                for p in guideCoordsP {
                    
                    let material = SCNMaterial()
                    material.diffuse.contents = UIColor(red: CGFloat(0) / 255.0, green: CGFloat(155) / 255.0, blue: CGFloat(155) / 255.0, alpha: 1)
                    material.lightingModelName = SCNLightingModelLambert
                    material.locksAmbientWithDiffuse = true
                    
                    let atomNode = SCNNode()
                    atomNode.position = SCNVector3(
                        x: p.x - molecule.center.x,
                        y: p.y - molecule.center.y,
                        z: p.z - molecule.center.z)
                    atomNode.geometry = SCNSphere(radius: 0.2)
                    atomNode.geometry!.firstMaterial = material
                    cartoons.addChildNode(atomNode)
                }
                
            }
        }
        
        molNode.addChildNode(cartoons)
    }
}