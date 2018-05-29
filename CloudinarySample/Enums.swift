//
//  Enums.swift
//  CloudinarySample
//
//  Created by Naren on 29/05/18.
//  Copyright © 2018 naren. All rights reserved.
//

import Foundation
import UIKit

enum CloudinarySetup: String {
  case USER_NAME = "dlw7ygwlp"
  case API_KEY = "454153526561491"
}

extension  UIImage{
  enum JPEGQuality: CGFloat {
    case lowest  = 0
    case low     = 0.25
    case medium  = 0.5
    case high    = 0.75
    case highest = 1
  }
  
  /// Returns the data for the specified image in JPEG format.
  /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
  /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
  func jpeg(_ quality: JPEGQuality) -> Data? {
    return UIImageJPEGRepresentation(self, quality.rawValue)
  }
}
