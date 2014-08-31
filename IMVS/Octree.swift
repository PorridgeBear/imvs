//
//  Octree.swift
//  IMVS
//
//  Created by Allistair Crossley on 29/08/2014.
//  Copyright (c) 2014 Allistair Crossley. All rights reserved.
//

import Foundation

class OctreeNode {
    
    // All OctNodes will be leaf nodes at first, ten subdivided later as more objects get added
    var isLeaf: Bool = true
    
    // Possible 8 branches
    var branches: [OctreeNode?] = [nil, nil, nil, nil, nil, nil, nil, nil]
    
    var ldb: [Float]
    var ruf: [Float]
    
    // OctreeNode cubes have a position and size
    // position is related to, but not the same as the objects the node contains.
    var position: [Float]
    var size: Float = 0.0

    // Data to store
    var objects: [AnyObject?]?
    
    init(position: [Float], size: Float, objects: [AnyObject?]) {
        
        self.position = position
        self.size = size
        self.objects = objects
        
        var half: Float = (size / 2.0)
        
        // The cube's bounding coordinates -- Not currently used
        self.ldb = [position[0] - half, position[1] - half, position[2] - half]
        self.ruf = [position[0] + half, position[1] + half, position[2] + half]
    }
}

/** 
 * A Swift Octree implementation based on
 * http://code.activestate.com/recipes/498121-python-octree-implementation/
 * Not tested and not currently used. Class AtomCloud is used instead.
 * No nearest neighbour routines exist in this implementation.
 */
class Octree {

    var MAX_OBJECTS_PER_NODE = 10
    var DIR_LOOKUP = ["3": 0, "2": 1, "-2": 2, "-1": 3, "1": 4, "0": 5, "-4":6, "-3": 7]
    
    var worldSize: Float = 0.0
    var root: OctreeNode?
    
    /**
     * Init the world bounding root cube all world geometry is inside this
     * it will first be created as a leaf node (i.e., without branches)
     * this is because it has no objects, which is less than MAX_OBJECTS_PER_CUBE
     * if we insert more objects into it than MAX_OBJECTS_PER_CUBE, then it will subdivide itself.
     */
    init(worldSize: Float) {
        
        self.worldSize = worldSize
        var position = [Float(0.0), Float(0.0), Float(0.0)]
        self.root = addNode(position, size: worldSize, objects: [])
    }
    
    func addNode(position: [Float], size: Float, objects: [AnyObject?]) -> OctreeNode {
        
        return OctreeNode(position: position, size: size, objects: objects)
    }
    
    func insertNode(root: OctreeNode?, size: Float, parent: OctreeNode, object: Atom)
        -> OctreeNode {
        
        let objectPosition = [object.position.x, object.position.y, object.position.z]
            
        if root == nil {
            
            var pos = parent.position
            var offset = size / 2
            var branch = findBranch(parent, position: objectPosition)
            
            var newCenter: [Float]?
            
            if branch == 0 {
                // left down back
                newCenter = [pos[0] - offset, pos[1] - offset, pos[2] - offset]
            } else if branch == 1 {
                // left down forwards
                newCenter = [pos[0] - offset, pos[1] - offset, pos[2] + offset]
            } else if branch == 2 {
                // right down forwards
                newCenter = [pos[0] + offset, pos[1] - offset, pos[2] + offset]
            } else if branch == 3 {
                // right down back
                newCenter = [pos[0] + offset, pos[1] - offset, pos[2] - offset]
            } else if branch == 4 {
                // left up back
                newCenter = [pos[0] - offset, pos[1] + offset, pos[2] - offset]
            } else if branch == 5 {
                // left up forward
                newCenter = [pos[0] - offset, pos[1] + offset, pos[2] + offset]
            } else if branch == 6 {
                // right up forward
                newCenter = [pos[0] + offset, pos[1] - offset, pos[2] + offset]
            } else if branch == 7 {
                // right up back
                newCenter = [pos[0] + offset, pos[1] + offset, pos[2] - offset]
            }
            
            return addNode(newCenter!, size: size, objects: [object])
            
        } else if root!.position != objectPosition && !root!.isLeaf {
            
            // we're in an octNode still, we need to traverse further
            var branch: Int = findBranch(root!, position: objectPosition)
            // Find the new scale we working with
            let newSize: Float = Float(root!.size / 2)
            // Perform the same operation on the appropriate branch recursively
            root!.branches[branch] = insertNode(root!.branches[branch], size: newSize, parent: root!, object: object)
            
        } else if root!.isLeaf {
            
            if root!.objects!.count < MAX_OBJECTS_PER_NODE {
                
                root!.objects!.append(object)
                
            } else if root!.objects!.count == MAX_OBJECTS_PER_NODE {
                
                root!.objects!.append(object)
                var objects = root!.objects!
                root!.objects = nil
                root!.isLeaf = false
                let newSize: Float = Float(root!.size / 2)
                
                for obj in objects {
                    
                    let atom = obj as Atom
                    let objPosition = [atom.position.x, atom.position.y, atom.position.z]
                    let branch: Int = findBranch(root!, position: objPosition)
                    root!.branches[branch] = insertNode(root!.branches[branch], size: newSize, parent: root!, object: atom)
                }
            }
        }
            
        return root!
    }
    
    /**
     * Basic collision lookup that finds the leaf node containing the specified position
     * Returns the child objects of the leaf, or None if the leaf is empty or none
     *
    func findPosition(root: OctreeNode?, position: [Float]) -> OctreeNode? {
        
        if root == nil {
            return nil
        } else if root!.isLeaf {
            return root!.objects
        } else {
            branch = findBranch(root, position)
            return findPosition(root.branches[branch], position)
        }
    }
    */

    /**
     * helper function
     * returns an index corresponding to a branch
     * pointing in the direction we want to go
     */
    func findBranch(root: OctreeNode, position: [Float]) -> Int {

        let vec1: [Float] = root.position
        let vec2: [Float] = position
        var result: Int = 0
        
        // Equation created by adding nodes with known branch directions
        // into the tree, and comparing results.
        // See DIR_LOOKUP above for the corresponding return values and branch indices
        for i in 0...2 {
            
            if vec1[i] <= vec2[i] {
                result += (-4 / (i + 1) / 2)
            } else {
                result += (4 / (i + 1) / 2)
            }
        }
        
        result = DIR_LOOKUP[String(result)]!
        return result
    }
    
    func display() {
        displayNode(root!, depth: 1)
    }
    
    func displayNode(node: OctreeNode?, depth: Int) {
        
        if node != nil {
            for branch in node!.branches {
                let indent = String(count: depth, repeatedValue: Character("-"))
                println("\(indent)>\(branch) has \(branch?.objects!.count)")
                displayNode(branch, depth: depth + 1)
            }
        }
    }
}