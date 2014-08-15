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
    
    /*
    var cdstore: CoreDataStore {
    if !_cdstore {
        _cdstore = CoreDataStore()
        }
        return _cdstore!
    }
    var _cdstore: CoreDataStore? = nil
    
    var cdh: CoreDataHelper {
    if !_cdh {
        _cdh = CoreDataHelper()
        }
        return _cdh!
    }
    var _cdh: CoreDataHelper? = nil
    */
    
    var defaultMolecules: [Molecule] = []
    
    var pdbFileList: [String] = [
        "1crn",
        "ala",
        "atp",
        "benzene",
        "cys",
        "dna",
        "octane",
        "trp"
    ];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Molecules"
        
        /* Core Data
        println("Load default molecules")
        var error: NSError? = nil
        var fReq: NSFetchRequest = NSFetchRequest(entityName: "Molecule")
        
        // fReq.predicate = NSPredicate(format:"name CONTAINS 'B' ")
        
        var sorter: NSSortDescriptor = NSSortDescriptor(key: "vendorId" , ascending: true)
        fReq.sortDescriptors = [sorter]
        
        var result = self.cdh.managedObjectContext.executeFetchRequest(fReq, error:&error)
        
        for resultItem : AnyObject in result {
            var mol = resultItem as Molecule
            NSLog("Fetched Molecule \(mol.vendorId)")
        }
        */
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return pdbFileList.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {

        var cell: MoleculeTableViewCell = tableView.dequeueReusableCellWithIdentifier("MolCell") as MoleculeTableViewCell
        
        if cell == nil {
            cell = MoleculeTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "MolCell")
        }
        
        cell.nameLabel!.text = self.pdbFileList[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 50.0;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        
        if (segue.identifier == "RenderMolecule") {
            
            let viewController:MoleculeViewController = segue!.destinationViewController as MoleculeViewController
            let indexPath = self.tableView.indexPathForSelectedRow()
            viewController.pdbFile = self.pdbFileList[indexPath.row]
        }
    }
}