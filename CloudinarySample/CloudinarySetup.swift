//
//  CloudinarySetup.swift
//  CloudinarySample
//
//  Created by Naren on 30/05/18.
//  Copyright © 2018 naren. All rights reserved.
//

import Foundation
import Cloudinary

class CloudinaryMethods{
  
  let cloudinary : CLDCloudinary?
  
  init() {
    let config = CLDConfiguration(cloudName: CloudinarySetup.USER_NAME.rawValue)
     cloudinary = CLDCloudinary(configuration: config)
  }
}
