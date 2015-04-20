//
//  Favourite.swift
//  IMVS
//
//  Created by Allistair Crossley on 17/04/2015.
//  Copyright (c) 2015 Allistair Crossley. All rights reserved.
//

import Foundation
import CoreData

class Favourite: NSManagedObject {

    @NSManaged var atoms: NSNumber
    @NSManaged var filePath: String
    @NSManaged var structureId: String
    @NSManaged var title: String

}
