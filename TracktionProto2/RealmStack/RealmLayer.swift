//
//  DataModel.swift
//  TracktionProto2
//
//  Created by Hervé PEROTEAU on 14/02/2016.
//  Copyright © 2016 Hervé PEROTEAU. All rights reserved.
//

import Foundation
import RealmSwift

let SessionStateInit = 0
let SessionStateKeepData = 1
let SessionStateDataComplete = 2

class RMSession: Object {
  
  dynamic var sessionId:Int = 0
  dynamic var dateStart: Double = 0 // dateunix
  dynamic var dateEnd: Double = 0   // dateunix
  dynamic var countEvents = 0;
  dynamic var state: Int = SessionStateInit
  
  let events = List<RMEvent>()
  
  override static func primaryKey() -> String? {
    return "sessionId"
  }
  
  func stateStr()->String {
    switch(state) {
    case SessionStateInit:
      return "INIT"
    case SessionStateKeepData:
      return "KEEPDATA"
    case SessionStateDataComplete:
      return "DATACOMPLETE"
    default :
      return "???"
    }
  }
}

class RMEvent: Object {
  
  dynamic var sessionId: Int = 0
  dynamic var x: Double = 0
  dynamic var y: Double = 0
  dynamic var z: Double = 0
  dynamic var dateEvent: Double = 0  // dateunix
}

class RealmLayer {
  
  // MARK: - Mocks
  
  func createMockDatas() {

    // Get the default Realm
    let realm = try! Realm()
    
    let sessions = realm.objects(RMSession)

    if (sessions.count == 0) {
      
      var dateStart = NSDate(timeIntervalSinceNow: -86400).timeIntervalSince1970
      var dateEnd = dateStart + 60.0
      
      for (var sessionId=1; sessionId<20; sessionId++) {

        // Create fake session
        let trackSession = TrackSession()
        trackSession.trackSessionId = sessionId
        trackSession.dateStart = dateStart
        trackSession.dateEnd = dateEnd
        saveTrackSession(trackSession)
        
        // Create fake events
        for (var eventId=0; eventId<1000; eventId++) {
          let item = TrackDataItem()
          item.trackSessionId = sessionId
          item.timeStamp = dateStart + (Double)(eventId)/50.0
          item.accelerationX = 0.1
          item.accelerationY = 0.2
          item.accelerationZ = 0.3
          saveTrackDataItem(item)
        }
        
        // Update END session
        trackSession.info = infoEndSession
        saveTrackSession(trackSession)

        // Prepare next fake session
        dateStart = dateEnd + 600
        dateEnd = dateStart + 60
      }
    }
  }
  
  // MARK: - Save

  func saveTrackSession(trackSession: TrackSession) -> RMSession {
    
    // Get the default Realm
    let realm = try! Realm()

    if (trackSession.info == infoEndSession) {
      
      // Query if session exist
      let session = realm.objects(RMSession).filter("sessionId == \(trackSession.trackSessionId)").first
      assert(session != nil, "Session \(trackSession.trackSessionId) not exist in Realm !")

      // Update an object with a transaction
      try! realm.write {
        session!.state = SessionStateDataComplete
      }
      
      return session!
    }
      
    // New session
    let newSession = RMSession()
    newSession.sessionId = trackSession.trackSessionId
    newSession.dateStart = trackSession.dateStart
    newSession.dateEnd = trackSession.dateEnd
    newSession.state = SessionStateInit
    
    // Add to the Realm inside a transaction
    try! realm.write {
      realm.add(newSession)
    }
    
    return newSession
  }
  
  func saveTrackDataItem(item: TrackDataItem) {
    
    // Get the default Realm
    let realm = try! Realm()

    // Query if session exist
    let session = realm.objects(RMSession).filter("sessionId == \(item.trackSessionId)").first
    assert(session != nil, "Session \(item.trackSessionId) not exist in Realm !")
    
    let eventTrack = RMEvent()
    eventTrack.sessionId = item.trackSessionId
    eventTrack.dateEvent = item.timeStamp
    eventTrack.x = item.accelerationX
    eventTrack.y = item.accelerationY
    eventTrack.z = item.accelerationZ

    // Add to the Realm inside a transaction
    try! realm.write {
      
      // add event
      realm.add(eventTrack)
      
      // Update session event count
      session!.countEvents++
      
      if (session!.state == SessionStateInit) {
        session!.state = SessionStateKeepData
      }
    }
  }

  // MARK: - Query

  func getListSessions() -> Results<RMSession> {
    return try! Realm().objects(RMSession)
  }
  
  func getEventsForSession(sessionId: Int) -> Results<RMEvent> {    
    return try! Realm().objects(RMEvent).filter("sessionId == \(sessionId)")
  }
}


