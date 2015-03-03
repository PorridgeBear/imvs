//
//  StickRenderMode.swift
//  IMVS
//
//  Created by Allistair Crossley on 17/02/2015.
//  Copyright (c) 2015 Allistair Crossley. All rights reserved.
//

import Foundation
import SceneKit

class SticksRenderMode {
    
    /**
    * Render molecules as balls of same radius, and bonds as sticks connecting the balls.
    */
    func create(colour: RenderColourEnumeration, molecule: Molecule, molNode: SCNNode) {
        
        RenderFactory.createBalls(colour, molecule: molecule, molNode: molNode, forceSize: 0.3)
        
        println("Draw \(molecule.bonds.count) bonds")
        
        for bond in molecule.bonds {
            
            // Bond src half
            
            var bondNodeSrc = SCNNode()
            let bondHeightAndTSrc = RenderFactory.computeBondHeightAndTransform(bond.src, t: bond.dst, m: molecule)
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
            let bondHeightAndTDst = RenderFactory.computeBondHeightAndTransform(bond.dst, t: bond.src, m: molecule)
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
}