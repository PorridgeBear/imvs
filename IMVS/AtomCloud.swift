//
//  AtomCloud.swift
//  IMVS
//
//  Created by Allistair Crossley on 30/08/2014.
//  Copyright (c) 2014 Allistair Crossley. All rights reserved.
//

import Foundation

/**
 * A rudimentary approach to speeding up bond creation between atoms.
 * An Octree/KD-Tree implementation is likely to speed this further.
 * The approach taken here is to divide the molecule into cubes of the same
 * wxhxl which is set to be the max bonding distance that 2 atoms would ever have.
 * Atoms are inserted into the cloud and associated with a cube at an index.
 * Cubes are indexed in a hash. 
 * 
 * Lookups are performed by determining the query atom's cube which is then taken 
 * as the center cube of a 27-cube cube. All neighbour's atoms are accumulated into 
 * the result set.
 */
class AtomCloud {
    
    // Set this to the largest possible distance 2 points would
    // be separated by
    var cubeLength: Float

    // Hashed cubes
    var grid: [String: AtomCloudCube] = [:]
    
    init(cubeLength: Float) {
        
        self.cubeLength = cubeLength
    }
    
    /**
     * Insert an Atom into this cloud.
     */
    func insert(atom: Atom) {
        
        // Convert the point to a cube coordinate
        var cx = floor(atom.position.x / cubeLength)
        var cy = floor(atom.position.y / cubeLength)
        var cz = floor(atom.position.z / cubeLength)
        
        // Create cube coordinate index
        var index = String("\(cx),\(cy),\(cz)")
        
        // Add the point to an existing or new cube
        if var cube = grid[index] {
            
            cube.objects.append(atom)
            
        } else {

            var cube: AtomCloudCube = AtomCloudCube(x: cx, y: cy, z: cz, w: cubeLength, h: cubeLength, l: cubeLength)
            cube.objects.append(atom)
            grid[index] = cube
        }
    }
    
    /**
     * Finds nearest neighbour Atoms by finding the cube owning the query atom
     * and then looking at all 27 cubes around it.
     */
    func nearest(atom: Atom) -> [Atom] {
        
        var result: [Atom] = []
        
        // Convert the point to a cube coordinate
        var cx = floor(atom.position.x / cubeLength)
        var cy = floor(atom.position.y / cubeLength)
        var cz = floor(atom.position.z / cubeLength)
        
        // Top layer
        findObjectsInCube(cx - 1, y: cy + 1, z: cz, result: &result)
        findObjectsInCube(cx - 1, y: cy + 1, z: cz - 1, result: &result)
        findObjectsInCube(cx, y: cy + 1, z: cz - 1, result: &result)
        findObjectsInCube(cx + 1, y: cy + 1, z: cz - 1, result: &result)
        findObjectsInCube(cx + 1, y: cy + 1, z: cz, result: &result)
        findObjectsInCube(cx + 1, y: cy + 1, z: cz + 1, result: &result)
        findObjectsInCube(cx, y: cy + 1, z: cz + 1, result: &result)
        findObjectsInCube(cx - 1, y: cy + 1, z: cz + 1, result: &result)
        findObjectsInCube(cx, y: cy + 1, z: cz, result: &result)
        
        // Center layer
        findObjectsInCube(cx - 1, y: cy, z: cz, result: &result)
        findObjectsInCube(cx - 1, y: cy, z: cz - 1, result: &result)
        findObjectsInCube(cx, y: cy, z: cz - 1, result: &result)
        findObjectsInCube(cx + 1, y: cy, z: cz - 1, result: &result)
        findObjectsInCube(cx + 1, y: cy, z: cz, result: &result)
        findObjectsInCube(cx + 1, y: cy, z: cz + 1, result: &result)
        findObjectsInCube(cx, y: cy, z: cz + 1, result: &result)
        findObjectsInCube(cx - 1, y: cy, z: cz + 1, result: &result)
        findObjectsInCube(cx, y: cy, z: cz, result: &result)

        // Bottom layer
        findObjectsInCube(cx - 1, y: cy - 1, z: cz, result: &result)
        findObjectsInCube(cx - 1, y: cy - 1, z: cz - 1, result: &result)
        findObjectsInCube(cx, y: cy - 1, z: cz - 1, result: &result)
        findObjectsInCube(cx + 1, y: cy - 1, z: cz - 1, result: &result)
        findObjectsInCube(cx + 1, y: cy - 1, z: cz, result: &result)
        findObjectsInCube(cx + 1, y: cy - 1, z: cz + 1, result: &result)
        findObjectsInCube(cx, y: cy - 1, z: cz + 1, result: &result)
        findObjectsInCube(cx - 1, y: cy - 1, z: cz + 1, result: &result)
        findObjectsInCube(cx, y: cy - 1, z: cz, result: &result)
        
        return result
    }
    
    /** Helper to return objects in a cube */
    func findObjectsInCube(x: Float, y: Float, z: Float, inout result: [Atom]) {
        
        // Create cube coordinate index
        var index = String("\(x),\(y),\(z)")
        
        // Add atoms
        if var cube = grid[index] {
            
            for atom in cube.objects {
                result.append(atom)
            }
        }
    }
}

/**
 * A cube in the cloud. The only important property here for the cloud and nearest
 * is objects. The coordinate and dimension properties are only used to draw the cubes
 * when debugging in the view.
 */
class AtomCloudCube {
    
    var objects: [Atom] = []
    
    var x: Float, y: Float, z: Float, w: Float, h: Float, l: Float
    var wx: Float, wy: Float, wz: Float
    
    init(x: Float, y: Float, z: Float, w: Float, h: Float, l: Float) {
        
        self.x = x
        self.y = y
        self.z = z
        self.w = w
        self.h = h
        self.l = l
        
        wx = x * w
        wy = y * h
        wz = z * l
    }
}