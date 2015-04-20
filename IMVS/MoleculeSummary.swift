//
//  MoleculeSummary.swift
//  IMVS
//
//  Created by Allistair Crossley on 18/04/2015.
//  Copyright (c) 2015 Allistair Crossley. All rights reserved.
//

import Foundation

/**
 * As lightweight molecule summary for e.g. table views, instructing vis. etc.
 */
class MoleculeSummary {
    
    var id: String
    var title: String?
    var atoms: String?
    var path: String?
    
    init(id: String, title: String?, atoms: String?) {
        self.id = id
        self.title = title
        self.atoms = atoms
    }
}