//
//  SearchMoleculeController.swift
//  IMVS
//
//  Created by Allistair Crossley on 15/04/2015.
//  Copyright (c) 2015 Allistair Crossley. All rights reserved.
//

import Foundation
import UIKit

class SearchMoleculeController : UITableViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, RCSBSearchReceiverDelegate {
    
    var list: [PDBDescription] = []
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        let search = RCSBSearch()
        search.delegate = self
        search.search(searchBar.text)
    }
    
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
    
    func setList(list: [PDBDescription]) {

        self.list = list
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
}