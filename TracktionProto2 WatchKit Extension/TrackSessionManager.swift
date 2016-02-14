//
//  TrackSessionManager.swift
//  TracktionProto2
//
//  Created by Hervé PEROTEAU on 31/01/2016.
//  Copyright © 2016 Hervé PEROTEAU. All rights reserved.
//

import Foundation

class TrackSessionManager {
  
  func loadSession()->TrackSession {
    let session = TrackSession()
    let defaults = NSUserDefaults.standardUserDefaults()

    let durationMaxSaved = defaults.doubleForKey("durationMax")
    if durationMaxSaved > 0 {
      session.durationMax = durationMaxSaved
    }
    
    let dateStartSaved = defaults.objectForKey("dateStart")
    if let dateStart = dateStartSaved as? NSDate {
      session.dateStart = dateStart
      let dateStopSaved = defaults.objectForKey("dateStop")
      if let dateStop = dateStopSaved as? NSDate {
        session.dateStop = dateStop
      }
    }
    return session
  }
  
  func saveSession(session: TrackSession) {
    
    let defaults = NSUserDefaults.standardUserDefaults()

    if session.durationMax > 0 {
      defaults.setDouble(session.durationMax, forKey: "durationMax")
    }

    if let dateStart = session.dateStart {
      defaults.setObject(dateStart, forKey: "dateStart")
    }
    else {
      defaults.removeObjectForKey("dateStart")
    }
    
    if let dateStop = session.dateStop {
      defaults.setObject(dateStop, forKey: "dateStop")
    }
    else {
      defaults.removeObjectForKey("dateStop")
    }
    
    defaults.synchronize()
  }
  
  func dateDisplayedForDate(dateToDisplay: NSDate) -> String {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .NoStyle
    formatter.timeStyle = .MediumStyle
    return formatter.stringFromDate(dateToDisplay)
  }

  func fulldateDisplayedForDate(dateToDisplay: NSDate) -> String {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .ShortStyle
    formatter.timeStyle = .LongStyle
    return formatter.stringFromDate(dateToDisplay)
  }

}

