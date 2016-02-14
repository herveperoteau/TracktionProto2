//
//  SessionInterfaceController.swift
//  TracktionProto2
//
//  Created by Hervé PEROTEAU on 31/01/2016.
//  Copyright © 2016 Hervé PEROTEAU. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion

let kSavingSessionId="savingSessionId"
let kSavingTimestampAnchor="savingTimestampAnchor"
let kSavingFirstTimestamp="savingFirstTimestamp"
let kSavingCountSaving="savingCountSaving"
let kSavingFinished="savingFinished"
let kSavingChunkInProgress="savingChunkInProgress"

class SessionInterfaceController: WKInterfaceController {
  
  @IBOutlet var groupRecap: WKInterfaceGroup!
  @IBOutlet var lbSessionID: WKInterfaceLabel!
  @IBOutlet var lbSessionStart: WKInterfaceLabel!
  @IBOutlet var lbSessionEnd: WKInterfaceLabel!
  
  @IBOutlet var btSave: WKInterfaceButton!
  
  @IBOutlet var groupSaving: WKInterfaceGroup!
  @IBOutlet var lbAnchorSaving: WKInterfaceLabel!
  @IBOutlet var lbCountSaving: WKInterfaceLabel!
  
  var sessionManager : TrackSessionManager!
  var session : TrackSession!
  
  let chunckInterval : NSTimeInterval = 5
  let chunckMarg : NSTimeInterval = 0.1
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    sessionManager = TrackSessionManager()
    if let session = context as? TrackSession {
      self.session = session
    }
    configureInterfaceWithCurrentSession()
  }
  
  override func willActivate() {
    
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
    
    // continue the saving process ...
    let defaults = NSUserDefaults.standardUserDefaults()
    let sessionIdSaving = defaults.integerForKey(kSavingSessionId)
    if sessionIdSaving == session.sessionId {
      let finished = defaults.boolForKey(kSavingFinished)
      let savingInProgress = defaults.boolForKey(kSavingChunkInProgress)
      print("finished=\(finished) savingInProgress=\(savingInProgress)")
      if (finished) {
        let count = defaults.integerForKey(kSavingCountSaving)
        let anchor = defaults.integerForKey(kSavingTimestampAnchor)
        self.lbAnchorSaving.setText("\(anchor)")
        self.lbCountSaving.setText("\(count) END")
      }
      else {
        if (!savingInProgress) {
          startQuery()
        }
      }
    }
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
  
  func configureInterfaceWithCurrentSession() {

    lbSessionID.setText("\(session.sessionId)")
    lbSessionStart.setText(sessionManager.dateDisplayedForDate(session.dateStart!))
    lbSessionEnd.setText(sessionManager.dateDisplayedForDate(session.dateStop!))

    // check if session saving in progress
    let defaults = NSUserDefaults.standardUserDefaults()
    let sessionIdSaving = defaults.integerForKey(kSavingSessionId)
    if sessionIdSaving == session.sessionId {
      print("saving \(sessionIdSaving) in progress ...")
      btSave.setHidden(true)
      groupSaving.setHidden(false)
    }
    else {
      print("Not session saving in progress ...")
      btSave.setHidden(false)
      groupSaving.setHidden(true)
    }
  }
  
  @IBAction func saveDataAction() {
  
    let defaults = NSUserDefaults.standardUserDefaults()
    
    defaults.setInteger(session.sessionId, forKey: kSavingSessionId)
    defaults.setDouble(0, forKey: kSavingTimestampAnchor);
    defaults.setDouble(0, forKey: kSavingFirstTimestamp);
    defaults.setInteger(0, forKey: kSavingCountSaving)
    defaults.setBool(false, forKey: kSavingFinished)
    defaults.synchronize()
    
    configureInterfaceWithCurrentSession()
    startQuery()
  }
  
  func startQuery() {
    
    print("startQuery ...")
    
    if Platform.isSimulator {
      dispatch_async(dispatch_get_main_queue()) {
        self.lbAnchorSaving.setText("startQuery")
        self.lbCountSaving.setText("Not on Simulator")
      }
      
      return
    }
    
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setBool(true, forKey: kSavingChunkInProgress)
    defaults.synchronize()

    dispatch_async(dispatch_get_main_queue()) {
      self.lbAnchorSaving.setText("...")
      self.lbCountSaving.setText("...")
    }
    
    let priority = DISPATCH_QUEUE_PRIORITY_HIGH
    dispatch_async(dispatch_get_global_queue(priority, 0)) {
      
      let recorder = CMSensorRecorder()
      let defaults = NSUserDefaults.standardUserDefaults()
      
      var dateStart = self.session.dateStart
      
      let anchorTimeStamp : NSTimeInterval = defaults.doubleForKey(kSavingTimestampAnchor)
      
      print("dateStart=\(dateStart) anchorTimeStamp=\(anchorTimeStamp)")
      
      if (anchorTimeStamp > 0) {

        let firstTimeStamp = defaults.doubleForKey(kSavingFirstTimestamp)
        print("firstTimeStamp=\(firstTimeStamp)")
        
        let offset = anchorTimeStamp - firstTimeStamp
        
        print("offset=\(offset)")
        assert(offset>0, "Bad anchor \(anchorTimeStamp) < firstTimeStamp \(firstTimeStamp)")

        // -0.5 seconds : marg of security to not loose data
        dateStart = self.session.dateStart!.dateByAddingTimeInterval(offset - self.chunckMarg)
      }
      
      if let dateStart = dateStart {
        var dateEndBlock = dateStart.dateByAddingTimeInterval(self.chunckInterval+self.chunckMarg)
        if (dateEndBlock >= self.session.dateStop!) {
          dateEndBlock = self.session.dateStop!
        }
        
        dispatch_async(dispatch_get_main_queue()) {
          self.lbAnchorSaving.setText("GET ...")
        }
        
        print("accelerometerDataFromDate(\(dateStart) toDate:\(dateEndBlock) ...")
        let accDataList = recorder.accelerometerDataFromDate(dateStart, toDate: dateEndBlock)
        
        dispatch_async(dispatch_get_main_queue()) {
          self.lbAnchorSaving.setText("GET OK.")
        }
        
        if let accDataList = accDataList {
          self.saveListDatas(accDataList)
        }
        else {
          defaults.setBool(false, forKey: kSavingChunkInProgress)
          defaults.synchronize()

          NSLog("AccDataList empty with dateStart:\(dateStart) dateEndBlock:\(dateEndBlock)")
          dispatch_async(dispatch_get_main_queue()) {
            let count = defaults.integerForKey(kSavingCountSaving)
            if (count == 0) {
              self.lbAnchorSaving.setText("Empty: Retry later")
              self.lbCountSaving.setText("0")
            }
            else {
              let anchor = defaults.integerForKey(kSavingTimestampAnchor)
              self.lbAnchorSaving.setText("\(anchor)")
              self.lbCountSaving.setText("\(count) END")
              defaults.setBool(true, forKey: kSavingFinished)
              defaults.synchronize()
            }
          }
        }
      }
      else {
        dispatch_async(dispatch_get_main_queue()) {
          self.lbAnchorSaving.setText("BAD ANCHOR")
        }
      }
    }
  }
  
  func saveListDatas(list: CMSensorDataList!) {
    
    NSProcessInfo().performExpiringActivityWithReason("saveListDatas") { expired in
      
      let defaults = NSUserDefaults.standardUserDefaults()

      if !expired {
        NSLog("saveListDatas : \(list)")
        var count=0
        for data in list {
          if let accData = data as? CMRecordedAccelerometerData {
            if (self.saveAccData(accData)) {
              count++
            }
          }
        }
        
        // chunck ended
        defaults.setBool(false, forKey: kSavingChunkInProgress)

        if (count==0) {
          dispatch_async(dispatch_get_main_queue()) {
            let count = defaults.integerForKey(kSavingCountSaving)
            self.lbCountSaving.setText("\(count) END")
            defaults.setBool(true, forKey: kSavingFinished)
          }
        }
      }
      else {
        print("No more background activity permitted")
        defaults.setBool(false, forKey: kSavingChunkInProgress)
      }
      
      defaults.synchronize()
    }
  }

  func saveAccData(data: CMRecordedAccelerometerData)->Bool {
    
    let startDateStr = sessionManager.fulldateDisplayedForDate(data.startDate)

    if (data.startDate < self.session.dateStart!) {
      print("Obsolete data.startDate=\(startDateStr) data.timestamp=\(data.timestamp) !!!")
      return false;
    }
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var count = defaults.integerForKey(kSavingCountSaving)
    var firstTimeStamp = defaults.doubleForKey(kSavingFirstTimestamp)
    if (count == 0) {
      defaults.setDouble(data.timestamp, forKey: kSavingFirstTimestamp)
      firstTimeStamp = data.timestamp
    }
    else {
      let anchor = defaults.doubleForKey(kSavingTimestampAnchor)
      if (data.timestamp <= anchor) {
        print("data.timestamp=\(data.timestamp) is already saved (marg)")
        return false;
      }
    }
    
    let offset = data.timestamp - firstTimeStamp
    let dateEvent = self.session.dateStart!.dateByAddingTimeInterval(offset)
    
    let dateEventStr = sessionManager.fulldateDisplayedForDate(dateEvent)
    
    count++
    
    defaults.setInteger(count, forKey: kSavingCountSaving)
    defaults.setObject(data.timestamp, forKey: kSavingTimestampAnchor)
    defaults.synchronize()

    print("saveAccData start=\(startDateStr) timestamp=\(data.timestamp) offsetTimeStamp=\(offset) (dateEvent=\(dateEventStr)) x=\(data.acceleration.x) y=\(data.acceleration.y) z=\(data.acceleration.z)")
    
    dispatch_async(dispatch_get_main_queue()) {

      self.lbAnchorSaving.setText("\(data.timestamp)")
      self.lbCountSaving.setText("\(count)")
    }
    
    return true
  }
}

extension CMSensorDataList: SequenceType {
  public func generate() -> NSFastGenerator {
    return NSFastGenerator(self)
  }
}
