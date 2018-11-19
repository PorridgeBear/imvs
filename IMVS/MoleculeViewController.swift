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
        
        print("MVC viewDidLoad \(pdbFile)")
        
        pdbLoader.loadMoleculeForPath(pdbFile: pdbFile)
        self.title = pdbLoader.molecule.name

        cameraNode.camera = SCNCamera()
        cameraNode.camera!.zNear = 0.1
        cameraNode.position = SCNVector3(x: 0, y: 0, z: pdbLoader.molecule.maxN * 3)
        scene.rootNode.addChildNode(cameraNode)
 
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLight.LightType.omni
        lightNode.position = SCNVector3(x: 0, y: 0, z: pdbLoader.molecule.maxN)
        scene.rootNode.addChildNode(lightNode)
        
        let lightNode2 = SCNNode()
        lightNode2.light = SCNLight()
        lightNode2.light!.type = SCNLight.LightType.omni
        lightNode2.position = SCNVector3(x: 0, y: 0, z: -pdbLoader.molecule.maxN)
        scene.rootNode.addChildNode(lightNode2)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        switch state.mode {
        case .Sticks:
            RenderFactory.createSticks(colour: state.colour, molecule: pdbLoader.molecule, molNode: molNode)
        default:
            RenderFactory.createBalls(colour: state.colour, molecule: pdbLoader.molecule, molNode: molNode, forceSize: 0.0)
        }
        
        scene.rootNode.addChildNode(molNode)
        
        let scnView = self.view as! SCNView
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.pointOfView = cameraNode
        // scnView.showsStatistics = true
        scnView.backgroundColor = UIColor.black
        
        // Controls
        let gestureRecognizers = NSMutableArray()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(tap:)))
        let pinchGesture = UIPinchGestureRecognizer(target:self, action: #selector(handlePinch(pinch:)));
        gestureRecognizers.add(tapGesture)
        gestureRecognizers.add(pinchGesture)
        gestureRecognizers.addObjects(from: scnView.gestureRecognizers!)
        scnView.gestureRecognizers = gestureRecognizers as? [UIGestureRecognizer]
    }
    
    /**
     * Tap to pick - just logs atom name to console currently
     */
    @objc func handleTap(tap: UITapGestureRecognizer) {
        
        let scnView = self.view as! SCNView
        
        var point = tap.location(in: scnView)
        var hitResults = scnView.hitTest(point, options: nil)
        
        if hitResults.count > 0 {
            
            var result: SCNHitTestResult = hitResults[0]
            print(result.node.name)
        }
    }
    
    /**
     * Pinch to zoom (move camera along Z)
     */
    @objc func handlePinch(pinch: UIPinchGestureRecognizer) {

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
            RenderFactory.createSticks(colour: state.colour, molecule: pdbLoader.molecule, molNode: molNode)
        default:
            RenderFactory.createBalls(colour: state.colour, molecule: pdbLoader.molecule, molNode: molNode, forceSize: 0.0)
        }
        
        scene.rootNode.addChildNode(molNode)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIInterfaceOrientationMask.allButUpsideDown
        } else {
            return UIInterfaceOrientationMask.all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
