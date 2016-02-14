//
//  TrackSession.swift
//  TracktionProto2
//
//  Created by Hervé PEROTEAU on 31/01/2016.
//  Copyright © 2016 Hervé PEROTEAU. All rights reserved.
//

import Foundation

class TrackSession {
  
  var durationMax: NSTimeInterval = 30
  var dateStart: NSDate?
  var dateStop: NSDate?
  var sessionId : Int {
    get {
      if (dateStart == nil) {
        return 0
      }
      return Int(floor(dateStart!.timeIntervalSince1970))
    }
  }
}