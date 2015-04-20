//
//  LoadingView.swift
//  IMVS
//
//  Created by Allistair Crossley on 20/04/2015.
//  Copyright (c) 2015 Allistair Crossley. All rights reserved.
//

import Foundation
import UIKit

class LoadingView : UIView {

    let spinnerView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        spinnerView.center = center
        addSubview(spinnerView)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Custom
    
    func start() {
        spinnerView.startAnimating()
    }
    
    func stop() {
        spinnerView.stopAnimating()
        removeFromSuperview()
    }
}