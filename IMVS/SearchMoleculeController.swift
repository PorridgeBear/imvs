//
//  SearchMoleculeController.swift
//  IMVS
//
//  Created by Allistair Crossley on 15/04/2015.
//  Copyright (c) 2015 Allistair Crossley. All rights reserved.
//

import Foundation
import UIKit

/**
 * Search for a molecule (just RCSB PDB databank for now)
 */
class SearchMoleculeController : UITableViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, RCSBSearchServiceDelegate {
    
    // Search implementation to use (can be made protocol and swapped out later for others)
    let search = RCSBSearchService()
    
    var list: [MoleculeSummary] = []
    
    var loadingView: LoadingView?
    
    override func viewDidLoad() {

        title = "Search"
        loadingView = LoadingView(frame: UIScreen.mainScreen().bounds)
    }
    
    // MARK: Search
    
    /** User search */
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        think()
        search.delegate = self
        search.search(searchBar.text)
    }
    
    func think() {
        loadingView!.start()
        tableView.addSubview(loadingView!)
    }
    
    func unthink() {
        loadingView!.stop()
    }
    
    // MARK: Table
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return list.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PDBCell", forIndexPath: indexPath) as! UITableViewCell
        
        if list.count > 0 {
            let molSumm = list[indexPath.row]
            // cell.textLabel?.text = (molSumm.id) (\(molSumm.atoms))"
            cell.textLabel?.text = molSumm.id
            cell.detailTextLabel?.text = molSumm.title
        }
        
        return cell
    }
    
    /** Set next controller's molecule from this selection */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewController: MoleculeDetailView = segue.destinationViewController as! MoleculeDetailView
        viewController.molecule = list[tableView.indexPathForSelectedRow()!.row]
    }
    
    // MARK: RCSBSearchReceiverDelegate
    
    /** Called when search is complete */
    func setMoleculeList(list: [MoleculeSummary]) {

        self.list = list
        
        dispatch_async(dispatch_get_main_queue(), {
            self.unthink()
            self.tableView.reloadData()
        })
    }
}