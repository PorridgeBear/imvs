//
//  ControlsViewController.swift
//  IMVS
//
//  Created by Allistair Crossley on 06/09/2014.
//  Copyright (c) 2014 Allistair Crossley. All rights reserved.
//

import UIKit

class ControlsViewController: UIViewController {
    
    func getMoleculeViewController() -> MoleculeViewController {
        var nc = (self.presentingViewController as! UINavigationController)
        return nc.viewControllers[1] as! MoleculeViewController
    }
    
    func finish() {
        getMoleculeViewController().stateChanged()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func modeBalls(sender: AnyObject) {

        getMoleculeViewController().state.mode = RenderModeEnumeration.Balls
        finish()
    }
    
    @IBAction func modeSticks(sender: AnyObject) {
        
        getMoleculeViewController().state.mode = RenderModeEnumeration.Sticks
        finish()
    }
    
    @IBAction func colourCPK(sender: AnyObject) {
        
        getMoleculeViewController().state.colour = RenderColourEnumeration.CPK
        finish()
    }
    
    @IBAction func colourAmino(sender: AnyObject) {
        
        getMoleculeViewController().state.colour = RenderColourEnumeration.Amino
        finish()
    }
}