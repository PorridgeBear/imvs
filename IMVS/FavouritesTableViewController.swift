//
//  MainViewController.swift
//  IMVS
//
//  Created by Allistair Crossley on 13/07/2014.
//  Copyright (c) 2014 Allistair Crossley. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MoleculeTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var molecules = [Molecule]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Molecules"
    }
    
    override func viewDidAppear(animated: Bool) {
        loadMolecules()
    }
    
    func loadMolecules() {
        
        let fetchRequest = NSFetchRequest(entityName: "Molecule")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Molecule] {
            
            molecules = fetchResults
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return molecules.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("MolCell", forIndexPath: indexPath) as! UITableViewCell
        
        let molecule = molecules[indexPath.row]
        cell.textLabel?.text = "\(molecule.structureId) (\(molecule.atoms))"
        cell.detailTextLabel?.text = molecule.title
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "RenderMolecule") {
            
            let viewController:MoleculeViewController = segue.destinationViewController as! MoleculeViewController
            let indexPath = self.tableView.indexPathForSelectedRow()
            viewController.pdbFile = molecules[indexPath!.row].filePath
        }
    }
}