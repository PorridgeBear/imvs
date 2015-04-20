//
//  MoleculeDetailView.swift
//  IMVS
//
//  Created by Allistair Crossley on 20/04/2015.
//  Copyright (c) 2015 Allistair Crossley. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MoleculeDetailView : UIViewController, RCSBGetDescServiceDelegate, RCSBDownloadServiceDelegate {

    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let getDescService = RCSBGetDescService()
    let downloadService = RCSBDownloadService()
    
    var molecule: MoleculeSummary?
    var loadingView: LoadingView?

    @IBOutlet weak var lblName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDescService.delegate = self
        downloadService.delegate = self
        
        loadingView = LoadingView(frame: UIScreen.mainScreen().bounds)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        title = molecule!.id
        getDescService.loadMolecule(molecule!)
    }
    
    func think() {
        loadingView!.start()
        view.addSubview(loadingView!)
    }
    
    func unthink() {
        loadingView!.stop()
    }

    @IBAction func onAddClick(sender: AnyObject) {
        think()
        downloadService.downloadFile(molecule!)
    }
    
    // MARK: RCSBGetDescServiceDelegate
    
    func setMolecule(molSumm: MoleculeSummary) {

        molecule = molSumm
        
        dispatch_async(dispatch_get_main_queue(), {
            // self.unthink()
            self.lblName.text = self.molecule!.title
        })
    }
    
    // MARK: RCSBDownloadServiceDelegate
    
    func didDownloadMoleculeFile(molSumm: MoleculeSummary) {
        
        println("Save fave: \(molSumm.id)")
        
        let fav: Favourite = NSEntityDescription.insertNewObjectForEntityForName("Favourite", inManagedObjectContext: managedObjectContext!) as! Favourite
        fav.structureId = molSumm.id
        fav.title = molSumm.title!
        fav.atoms = molSumm.atoms!.toInt()!
        fav.filePath = molSumm.path!
        
        dispatch_async(dispatch_get_main_queue(), {
            
            self.unthink()
            
            // Show downloaded alert
            var alert = UIAlertController(title: "Downloaded", message: "\(fav.structureId) was saved to your Favourites", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
}