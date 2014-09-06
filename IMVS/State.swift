//
//  State.swift
//  IMVS
//
//  Created by Allistair Crossley on 06/09/2014.
//  Copyright (c) 2014 Allistair Crossley. All rights reserved.
//

import Foundation

enum RenderModeEnumeration {

    case Balls
    case Sticks
}

enum RenderColourEnumeration {
    
    case CPK
    case Amino
}

class State {
    
    var mode: RenderModeEnumeration = RenderModeEnumeration.Balls
    var colour: RenderColourEnumeration = RenderColourEnumeration.CPK
}