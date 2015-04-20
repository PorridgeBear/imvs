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

class FavouritesTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var faves = [Favourite]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Favourites"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        loadFavourites()
    }
    
    /** Load Favourites from Core Data */
    func loadFavourites() {
        
        let fetchRequest = NSFetchRequest(entityName: "Favourite")
        
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Favourite] {
        
            faves = fetchResults
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: Table
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        println("numberOfRowsInSection")
        return faves.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        println("cellForRowAtIndexPath")
        let cell = tableView.dequeueReusableCellWithIdentifier("FaveCell", forIndexPath: indexPath) as! UITableViewCell
        
        let fav = faves[indexPath.row]
        cell.textLabel?.text = "\(fav.structureId) (\(fav.atoms))"
        cell.detailTextLabel?.text = fav.title
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        var delete = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Delete") { (action, indexpath) -> Void in
            
        }
        
        delete.backgroundColor = UIColor.redColor()
        
        return [delete]
    }
    
    // MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        let viewController: MoleculeViewController = segue.destinationViewController as! MoleculeViewController
        let indexPath = self.tableView.indexPathForSelectedRow()
        viewController.title = faves[indexPath!.row].structureId
        viewController.pdbFile = faves[indexPath!.row].filePath
    }
}