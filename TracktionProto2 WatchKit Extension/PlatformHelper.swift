//
//  PlatformHelper.swift
//  TracktionProto2
//
//  Created by Hervé PEROTEAU on 06/02/2016.
//  Copyright © 2016 Hervé PEROTEAU. All rights reserved.
//

import Foundation

struct Platform {
  static let isSimulator: Bool = {
    var isSim = false
    #if arch(i386) || arch(x86_64)
      isSim = true
    #endif
    return isSim
  }()
}