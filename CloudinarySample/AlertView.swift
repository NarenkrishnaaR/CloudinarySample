//
//  AlertView.swift
//  CloudinarySample
//
//  Created by Naren on 29/05/18.
//  Copyright © 2018 naren. All rights reserved.
//

import Foundation
import UIKit

class AlertView {
  
  init() {
    
  }
  
  public static func alertFunc (viewController:UIViewController,title : String , message :String , buttonTitle : String){
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: buttonTitle, style: .cancel, handler: nil)
    alertController.addAction(alertAction)
    viewController.present(alertController, animated: true, completion: nil)
  }
}
