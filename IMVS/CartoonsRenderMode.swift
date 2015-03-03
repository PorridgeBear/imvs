//
//  CartoonsRenderMode.swift
//  IMVS
//
//  Created by Allistair Crossley on 17/02/2015.
//  Copyright (c) 2015 Allistair Crossley. All rights reserved.
//

import Foundation
import SceneKit

class CartoonsRenderMode {
    
    /**
     * Work in progress!
     * Currently just ribbons (algorithm by Carson & Bugg 1986)
     */
    func create(colour: RenderColourEnumeration, molecule: Molecule, molNode: SCNNode) {
        
        // TODO:
        
        var cartoons = SCNNode()
        
        var a = SCNVector3Zero,
        b = SCNVector3Zero,
        c = SCNVector3Zero,
        d = SCNVector3Zero,
        dPrev = SCNVector3Zero
        var normals: [SCNVector3] = []
        
        for model in molecule.models {
            for chain in model.chains {
                
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
                    
                    b.x = oxCurr!.position.x - caCurr!.position.x
                    b.y = oxCurr!.position.y - caCurr!.position.y
                    b.z = oxCurr!.position.z - caCurr!.position.z
                    
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
                    
                    // translate helices away from axis for more room
                    if resCurr.isHelixPart {
                        c = c * 3.0
                        p = p + c
                    }
                    
                    // scale sheets down
                    if resCurr.isSheetPart {
                        d = d * (1 / 3);
                    }
                    
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
                    
                    var pP = SCNVector3(x: p.x + d2.x, y: p.y, z: p.z) + SCNVector3Make(1, 1, 1) // + d2
                    var pN = SCNVector3(x: p.x, y: p.y, z: p.z) - SCNVector3Make(1, 1, 1) // - d2
                    
                    pP.x -= molecule.center.x
                    pP.y -= molecule.center.y
                    pP.z -= molecule.center.z
                    pN.x -= molecule.center.x
                    pN.y -= molecule.center.y
                    pN.z -= molecule.center.z
                    
                    guideCoordsN.append(pN)
                    guideCoordsP.append(pP)

                } // end residue
                
                // 3. construct ribbon geometry
                
                let resolution = 1000
                let c1 = Spline3D(controlPoints: guideCoordsN, n: guideCoordsN.count - 1, t: 5, r: resolution)
                let c3 = Spline3D(controlPoints: guideCoordsP, n: guideCoordsP.count - 1, t: 5, r: resolution)
                let splineN = c1.getPoints()
                let splineP = c3.getPoints()
                
                
                let material = SCNMaterial()
                material.diffuse.contents = UIColor(red: CGFloat(155) / 255.0, green: CGFloat(155) / 255.0, blue: CGFloat(155) / 255.0, alpha: 1)
                material.lightingModelName = SCNLightingModelLambert
                material.locksAmbientWithDiffuse = true
                material.doubleSided = true // @TODO 
                
                var verts: [SCNVector3] = []
                var indices: [CInt] = []
                
                // Vertex buffer (zig zag through N and P sides)
                
                var sideLength = guideCoordsN.count
                if sideLength % 2 != 0 {
                    sideLength--
                }
                
                for var i = 0; i < sideLength; i++ {
                    //println("sN \(splineN[i].x),\(splineN[i].y),\(splineN[i].z)")
                    verts.append(guideCoordsN[i])
                    verts.append(guideCoordsP[i])
                }
                
                for var i = 1; i < sideLength; i++ {
                    
                    /*
                    N1 N2
                    | /|
                    |/ |
                    P1 P2
                    */
                    
                    let u: SCNVector3, v: SCNVector3
                    if i % 2 != 0 { // 1st tri of quad
                        u = guideCoordsP[i] - guideCoordsN[i]
                        v = guideCoordsN[i + 1] - guideCoordsN[i]
                    } else { // 2nd tri of quad
                        u = guideCoordsP[i - 1] - guideCoordsN[i]
                        v = guideCoordsP[i] - guideCoordsP[i - 1]
                    }
                    
                    var n = u.cross(v)
                    n.normalize()
                    normals.append(n)
                    normals.append(n)
                }

                /*
                Vector3d vec1 = new Vector3d(v3.x - v1.x, v3.y - v1.y, v3.z - v1.z);
                Vector3d vec2 = new Vector3d(v2.x - v1.x, v2.y - v1.y, v2.z - v1.z);
                Vector3d vn = new Vector3d();
                vn.cross(vec1, vec2);
                vn.normalize();
                geometry.setNormal(coord, new Vector3f((float) vn.x,(float) vn.y,(float) vn.z));
                geometry.setNormal(coord, new Vector3f((float) vn.x,(float) vn.y,(float) vn.z));
                geometry.setNormal(coord, new Vector3f((float) vn.x,(float) vn.y,(float) vn.z));
                geometry.setNormal(coord, new Vector3f((float) vn.x,(float) vn.y,(float) vn.z));
                */

                // Index buffer

                for var i = 0; i < verts.count; i++ {
                    indices.append(CInt(i))
                }
                
                println("verts=\(verts.count), normals=\(normals.count), indices=\(indices.count)")
                
                var src: SCNGeometrySource = SCNGeometrySource(vertices: verts, count: verts.count)
                var nrm: SCNGeometrySource = SCNGeometrySource(normals: normals, count: normals.count)
                var dat: NSData = NSData(bytes: indices, length: sizeof(CInt) * indices.count)
                var ele: SCNGeometryElement = SCNGeometryElement(data: dat, primitiveType: SCNGeometryPrimitiveType.TriangleStrip, primitiveCount: verts.count, bytesPerIndex: sizeof(CInt))
                var geo: SCNGeometry = SCNGeometry(sources: [src, nrm], elements: [ele])
                var node: SCNNode = SCNNode(geometry: geo)
                node.geometry!.firstMaterial = material
                
                cartoons.addChildNode(node)
            }
        }
        
        molNode.addChildNode(cartoons)
    }
}