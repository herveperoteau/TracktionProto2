//
//  InterfaceController.swift
//  TracktionProto2 WatchKit Extension
//
//  Created by Hervé PEROTEAU on 25/01/2016.
//  Copyright © 2016 Hervé PEROTEAU. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion

let kIncrement : Double = 10
let kDurationMin : Double = 10
let kDurationMax : Double = 60
let kSegueGetList = "getList"

class RecordingInterfaceController: WKInterfaceController {
  
  @IBOutlet var groupNone: WKInterfaceGroup!
  @IBOutlet var lbDuration: WKInterfaceLabel!
  
  @IBOutlet var groupRecording: WKInterfaceGroup!
  @IBOutlet var lbRecordingStart: WKInterfaceLabel!
  @IBOutlet var lbRecordingEnd: WKInterfaceLabel!
  
  @IBOutlet var groupEnd: WKInterfaceGroup!
  @IBOutlet var lbEndStart: WKInterfaceLabel!
  @IBOutlet var lbEndStop: WKInterfaceLabel!
  
  var session : TrackSession!
  var sessionManager : TrackSessionManager!
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    // Configure interface objects here.
    sessionManager = TrackSessionManager()
    session = sessionManager.loadSession()
    configureInterfaceWithCurrentSession()
    
    let dateBoot = NSDate(timeIntervalSince1970: NSProcessInfo().systemUptime)
    print("saveAccData systemUptime=\(NSProcessInfo().systemUptime) dateBoot=\(dateBoot)")
  }
  
 
  func configureInterfaceWithCurrentSession() {
    
    if let _ = session.dateStop, _ = session.dateStart {
      configureInterfaceAsEnd()
    }
    else if let dateStart = session.dateStart {      
      // check if maxTime !!
      let dateEnd = dateStart.dateByAddingTimeInterval(session.durationMax)
      let now = NSDate()
      if (dateEnd <= now) {
        // force to end
        session.dateStop = dateEnd
        configureInterfaceAsEnd()
      }
      else {
        configureInterfaceAsRecording()
      }
    }
    else {
      configureInterfaceAsNone()
    }
  }
  
  func configureInterfaceAsNone() {
    
    assert(session.dateStart == nil, "dateStart is not nil ???")
    assert(session.dateStop == nil, "dateStop is not nil ???")
    
    lbDuration.setText("\(session.durationMax)");
    animateWithDuration(0.5) {
      self.groupNone.setRelativeHeight(1, withAdjustment: 0)
      self.groupRecording.setHeight(0)
      self.groupEnd.setHeight(0)
    }
  }
  
  func configureInterfaceAsRecording() {
    
    assert(session.dateStart != nil , "dateStart is nil ???")
    assert(session.dateStop == nil, "dateStop is not nil ???")
    
    if let dateStart = session.dateStart {
      lbRecordingStart.setText(sessionManager.dateDisplayedForDate(dateStart))
      let dateEnd = dateStart.dateByAddingTimeInterval(session.durationMax)
      lbRecordingEnd.setText(sessionManager.dateDisplayedForDate(dateEnd))
      animateWithDuration(0.5) {
        self.groupNone.setHeight(0)
        self.groupRecording.setRelativeHeight(1, withAdjustment: 0)
        self.groupEnd.setHeight(0)
      }
    }
  }
  
  func configureInterfaceAsEnd() {
    
    assert(session.dateStart != nil , "dateStart is nil ???")
    assert(session.dateStop != nil, "dateStop is nil ???")
    
    if let dateStart = session.dateStart, dateStop = session.dateStop {
      lbEndStart.setText(sessionManager.dateDisplayedForDate(dateStart))
      lbEndStop.setText(sessionManager.dateDisplayedForDate(dateStop))
      animateWithDuration(0.5) {
        self.groupNone.setHeight(0)
        self.groupRecording.setHeight(0)
        self.groupEnd.setRelativeHeight(1, withAdjustment: 0)
      }
    }
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
  
  @IBAction func decrementDuration() {
    if (session.durationMax >= kDurationMin+kIncrement) {
      session.durationMax-=kIncrement
      TrackSessionManager().saveSession(session)
      configureInterfaceWithCurrentSession()
    }
  }
  
  @IBAction func incrementDuration() {
    if (session.durationMax <= kDurationMax-kIncrement) {
      session.durationMax+=kIncrement
      TrackSessionManager().saveSession(session)
      configureInterfaceWithCurrentSession()
    }
  }
  
  @IBAction func startAction() {
    if Platform.isSimulator {
      print("isSiumlator : not used CMSensorRecorder")
    }
    else {
      // sync request authorization on iPhone
      if !CMSensorRecorder.isAccelerometerRecordingAvailable() {
        presentError("Authorization required!\nGo on your iPhone in Settings > Privacy > Motion & Fitness")
        return
      }
      
      session.dateStart = NSDate()
      let recorder = CMSensorRecorder()
      recorder.recordAccelerometerForDuration(session.durationMax)
    }
    
    TrackSessionManager().saveSession(session)
    configureInterfaceWithCurrentSession()
  }
  
  func presentError(message: String?) {
    presentControllerWithName("ErrorInterfaceController", context: message)
  }
  
  @IBAction func stopAction() {
    session.dateStop = NSDate()
    let dateEnd = session.dateStart!.dateByAddingTimeInterval(session.durationMax)
    if (session.dateStop! > dateEnd) {
      // force to end
      session.dateStop = dateEnd
    }

    configureInterfaceWithCurrentSession()
    TrackSessionManager().saveSession(session)
  }
  
  @IBAction func resetAction() {
    session.dateStart = nil
    session.dateStop = nil
    TrackSessionManager().saveSession(session)
    configureInterfaceWithCurrentSession()
  }
  
  override func contextForSegueWithIdentifier(segueIdentifier: String) -> AnyObject? {
    if segueIdentifier == kSegueGetList {
      return session
    }
    else {
      return nil
    }
  }
}
