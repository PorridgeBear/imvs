//
//  GameViewController.swift
//  IMVS
//
//  Created by Allistair Crossley on 05/07/2014.
//  Copyright (c) 2014 Allistair Crossley. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class MoleculeViewController: UIViewController {

    let pdbLoader = PDBLoader()
    var pdbFile: String = ""
    
    var state = State()
    var scene = SCNScene()
    var cameraNode = SCNNode()
    var molNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("MVC viewDidLoad \(pdbFile)")
        
        pdbLoader.loadMoleculeForPath(pdbFile)
        self.title = pdbLoader.molecule.name
        
        cameraNode.camera = SCNCamera()
        cameraNode.camera!.zNear = 0.1
        cameraNode.position = SCNVector3(x: 0, y: 0, z: pdbLoader.molecule.maxN * 3)
        scene.rootNode.addChildNode(cameraNode)
 
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 0, z: pdbLoader.molecule.maxN)
        scene.rootNode.addChildNode(lightNode)
        
        let lightNode2 = SCNNode()
        lightNode2.light = SCNLight()
        lightNode2.light!.type = SCNLightTypeOmni
        lightNode2.position = SCNVector3(x: 0, y: 0, z: -pdbLoader.molecule.maxN)
        scene.rootNode.addChildNode(lightNode2)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)
        
        switch state.mode {
        case .Sticks:
            RenderFactory.createSticks(state.colour, molecule: pdbLoader.molecule, molNode: molNode)
        default:
            RenderFactory.createBalls(state.colour, molecule: pdbLoader.molecule, molNode: molNode, forceSize: 0.0)
            // RenderFactory.createCartoons(state.colour, molecule: pdbLoader.molecule, molNode: molNode)
        }
        
        scene.rootNode.addChildNode(molNode)
        
        let scnView = self.view as! SCNView
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.pointOfView = cameraNode
        // scnView.showsStatistics = true
        scnView.backgroundColor = UIColor.whiteColor()
        
        // Controls
        let gestureRecognizers = NSMutableArray()
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        let pinchGesture = UIPinchGestureRecognizer(target:self, action: "handlePinch:");
        gestureRecognizers.addObject(tapGesture)
        gestureRecognizers.addObject(pinchGesture)
        gestureRecognizers.addObjectsFromArray(scnView.gestureRecognizers!)
        scnView.gestureRecognizers = gestureRecognizers as [AnyObject]?
    }
    
    /**
     * Tap to pick - just logs atom name to console currently
     */
    func handleTap(tap: UITapGestureRecognizer) {
        
        let scnView = self.view as! SCNView
        
        var point = tap.locationInView(scnView)
        var hitResults = scnView.hitTest(point, options: nil)
        
        if hitResults!.count > 0 {
            
            var result: SCNHitTestResult = hitResults![0] as! SCNHitTestResult
            println(result.node.name)
        }
    }
    
    /**
     * Pinch to zoom (move camera along Z)
     */
    func handlePinch(pinch: UIPinchGestureRecognizer) {

        var z = (self.cameraNode.position.z) * (1 / Float(pinch.scale));
        z = fmaxf(1.0, z)
        z = fminf(4.0, z)
        self.cameraNode.position = SCNVector3Make(0, 0, z)
    }
    
    /**
     * Callback from ControlsViewController to notify that state was modified (possibly)
     * Need to check if state was changed to prevent wasted computation
     */
    func stateChanged() {
        
        // Remove current render
        molNode.removeFromParentNode()
        
        // Setup the new render
        molNode = SCNNode()

        // Render
        switch state.mode {
        case .Sticks:
            RenderFactory.createSticks(state.colour, molecule: pdbLoader.molecule, molNode: molNode)
        default:
            RenderFactory.createBalls(state.colour, molecule: pdbLoader.molecule, molNode: molNode, forceSize: 0.0)
        }
        
        scene.rootNode.addChildNode(molNode)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
