//
//  ActivityIndicator.swift
//  CloudinarySample
//
//  Created by Naren on 29/05/18.
//  Copyright © 2018 naren. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicator {
  
  init() {
    
  }
  
  
  public static func viewLoader(view: UIView,startAnimating: Bool) {
    let activityLoader = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    activityLoader.hidesWhenStopped = true;
    activityLoader.activityIndicatorViewStyle  = .gray
    activityLoader.center = view.center
    if startAnimating == true{
      activityLoader.startAnimating()
      activityLoader.isHidden = false
    }else{
      activityLoader.stopAnimating()
      activityLoader.isHidden = true
    }
    view.addSubview(activityLoader)
  }
}
