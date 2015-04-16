//
//  SearchMoleculeController.swift
//  IMVS
//
//  Created by Allistair Crossley on 15/04/2015.
//  Copyright (c) 2015 Allistair Crossley. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SearchMoleculeController : UITableViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, RCSBServiceDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let search = RCSBService()
    
    var list: [PDBDescription] = []
    
    var loadingView: UIView?
    let spinnerView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    override func viewDidLoad() {

        loadingView = UIView(frame: UIScreen.mainScreen().bounds)
        loadingView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        spinnerView.center = loadingView!.center
        loadingView?.addSubview(spinnerView)
    }
    
    // MARK: Search
    
    /** User search */
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        spinnerView.startAnimating()
        tableView.addSubview(loadingView!)
        
        search.delegate = self
        search.search(searchBar.text)
    }
    
    // MARK: Table
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return list.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PDBCell", forIndexPath: indexPath) as! UITableViewCell

        if list.count > 0 {
            let pdbDesc = list[indexPath.row]
            cell.textLabel?.text = "\(pdbDesc.structureId) (\(pdbDesc.atoms))"
            cell.detailTextLabel?.text = pdbDesc.title
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let pdbDesc = list[indexPath.row]
        search.downloadFile(pdbDesc)
    }
    
    // MARK: RCSBSearchReceiverDelegate
    
    func setList(list: [PDBDescription]) {

        self.list = list
        
        dispatch_async(dispatch_get_main_queue(), {
            self.spinnerView.stopAnimating()
            self.loadingView?.removeFromSuperview()
            self.tableView.reloadData()
        })
    }
    
    func didDownloadFile(pdb: PDBDescription, path: String) {
        
        println("open PDB \(pdb.structureId)")
        
        let molecule: Molecule = NSEntityDescription.insertNewObjectForEntityForName("Molecule", inManagedObjectContext: managedObjectContext!) as! Molecule
        molecule.filePath = path
        molecule.structureId = pdb.structureId
        molecule.title = pdb.title
        molecule.atoms = pdb.atoms.toInt()!
    }
}