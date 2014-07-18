//
//  SecondaryStructure.swift
//  IMVS
//
//  Created by Allistair Crossley on 14/07/2014.
//  Copyright (c) 2014 Allistair Crossley. All rights reserved.
//

import Foundation

class SecondaryStructure {
    
    var id: String = ""
    
    convenience init() {
        
        self.init(id: "NONE")
    }
    
    init(id:String) {
        
        self.id = id
    }
}