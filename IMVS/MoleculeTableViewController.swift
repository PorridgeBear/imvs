//
//  MainViewController.swift
//  IMVS
//
//  Created by Allistair Crossley on 13/07/2014.
//  Copyright (c) 2014 Allistair Crossley. All rights reserved.
//

import Foundation
import UIKit

class MoleculeTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    var pdbFileList: [String] = [
        "1crn", // Bonding needs fixes
        "ala",
        "atp",
        "benzene", // Aromatic bonds needed
        "cys",
        //"dna",
        "gc-zdna", // Bonding needs fixes
        "octane",
        "trp"
    ];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Molecules"
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
        
        cell.nameLabel!.text = pdbFileList[indexPath.row]
        
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