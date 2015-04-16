//
//  RCSBSearchReceiverDelegate.swift
//  IMVS
//
//  Created by Allistair Crossley on 15/04/2015.
//  Copyright (c) 2015 Allistair Crossley. All rights reserved.
//

import Foundation

protocol RCSBServiceDelegate {
    func setList(list: [PDBDescription])
    func didDownloadFile(pdb: PDBDescription, path: String)
}