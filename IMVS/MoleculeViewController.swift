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
    
    var scene = SCNScene()
    var cameraNode = SCNNode()
    var molNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("MVC viewDidLoad \(pdbFile)")
        
        pdbLoader.loadMoleculeForPath(pdbFile)
        self.title = pdbLoader.molecule.name

        cameraNode.camera = SCNCamera()
        cameraNode.camera.zNear = 0.1
        cameraNode.position = SCNVector3(x: 0, y: 0, z: pdbLoader.molecule.maxN * 3)
        scene.rootNode.addChildNode(cameraNode)
 
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 0, z: pdbLoader.molecule.maxN)
        scene.rootNode.addChildNode(lightNode)
        
        let lightNode2 = SCNNode()
        lightNode2.light = SCNLight()
        lightNode2.light.type = SCNLightTypeOmni
        lightNode2.position = SCNVector3(x: 0, y: 0, z: -pdbLoader.molecule.maxN)
        scene.rootNode.addChildNode(lightNode2)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light.type = SCNLightTypeAmbient
        ambientLightNode.light.color = UIColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)
        
        RenderFactory.createBalls(pdbLoader.molecule, molNode: molNode, forceSize: 0.0)
        scene.rootNode.addChildNode(molNode)
        
        /* animate the 3d object
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "rotation")
        animation.toValue = NSValue(SCNVector4: SCNVector4(x: 1, y: 1, z: 0, w: Float(M_PI)*2))
        animation.duration = 5
        animation.repeatCount = MAXFLOAT //repeat forever
        boxNode.addAnimation(animation, forKey: nil)
        */
        
        let scnView = self.view as SCNView
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.pointOfView = cameraNode
        // scnView.showsStatistics = true
        scnView.backgroundColor = UIColor.blackColor()
        
        // Controls
        let gestureRecognizers = NSMutableArray()
        let tapGesture = UITapGestureRecognizer(target: self, action: "showControls")
        let pinchGesture = UIPinchGestureRecognizer(target:self, action: "handlePinch");
        gestureRecognizers.addObject(tapGesture)
        gestureRecognizers.addObject(pinchGesture)
        gestureRecognizers.addObjectsFromArray(scnView.gestureRecognizers)
        scnView.gestureRecognizers = gestureRecognizers
    }
    
    func showControls() {
//        let controlsVC = ControlsViewController()
//        self.presentViewController(controlsVC, animated: true, completion: nil)
        let vc : ControlsViewController = self.storyboard.instantiateViewControllerWithIdentifier("controlsVC") as ControlsViewController
        //self.showViewController(vc as UIViewController, sender: vc)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func handlePinch(pinch: UIPinchGestureRecognizer) {

        var z = (self.cameraNode.position.z) * (1 / Float(pinch.scale));
        z = fmaxf(1.0, z)
        z = fminf(4.0, z)
        self.cameraNode.position = SCNVector3Make(0, 0, z)
    }
    
    @IBAction func renderModeChanged(sender: UISegmentedControl) {
        
        // Remove current render
        molNode.removeFromParentNode()
        
        // Setup the new render
        molNode = SCNNode()
        
        switch sender.selectedSegmentIndex {
        case 1:
            RenderFactory.createSticks(pdbLoader.molecule, molNode: molNode)
        case 2:
            RenderFactory.createCartoons(pdbLoader.molecule, molNode: molNode)
        default:
            RenderFactory.createBalls(pdbLoader.molecule, molNode: molNode, forceSize: 0.0)
        }
        
        scene.rootNode.addChildNode(molNode)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
        } else {
            return Int(UIInterfaceOrientationMask.All.toRaw())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
