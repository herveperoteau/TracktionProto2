//
//  TrackDataItem.swift
//  TracktionProto1
//
//  Created by Hervé PEROTEAU on 03/01/2016.
//  Copyright © 2016 Hervé PEROTEAU. All rights reserved.
//

import Foundation

let infoEndSession = "END"

let keyTrackSessionId = "tSId"
let keyDateStart = "DS"
let keyDateEnd = "DE"

let keyTimeStamp = "TS"
let keyAccelerationX = "X"
let keyAccelerationY = "Y"
let keyAccelerationZ = "Z"
let keyInfo = "I"

class TrackSession {
  
  var trackSessionId: Int = 0
  var dateStart: Double = 0.0
  var dateEnd: Double = 0.0
  var info: String = ""

  static func fromDictionary(userInfo: [String : AnyObject]) -> TrackSession {
    let item = TrackSession()
    item.trackSessionId = userInfo[keyTrackSessionId] as! Int
    item.dateStart = userInfo[keyDateStart] as! Double
    item.dateEnd = userInfo[keyDateEnd] as! Double
    item.info = userInfo[keyInfo] as! String
    return item
  }
  
  func toDictionary() -> [String : AnyObject] {
    var userInfo = [String : AnyObject]()
    userInfo[keyTrackSessionId] = trackSessionId
    userInfo[keyDateStart] = dateStart
    userInfo[keyDateEnd] = dateEnd
    userInfo[keyInfo] = info
    return userInfo
  }
}

class TrackDataItem {
	
	var trackSessionId: Int = 0
	var timeStamp: Double = 0.0
	var accelerationX: Double = 0.0
	var accelerationY: Double = 0
	var accelerationZ: Double = 0
	
	static func fromDictionary(userInfo: [String : AnyObject]) -> TrackDataItem {
		let item = TrackDataItem()
		item.trackSessionId = userInfo[keyTrackSessionId] as! Int
		item.timeStamp = userInfo[keyTimeStamp] as! Double
		item.accelerationX = userInfo[keyAccelerationX] as! Double
		item.accelerationY = userInfo[keyAccelerationY] as! Double
		item.accelerationZ = userInfo[keyAccelerationZ] as! Double
		return item
	}
	
	func toDictionary() -> [String : AnyObject] {
		var userInfo = [String : AnyObject]()
		userInfo[keyTrackSessionId] = trackSessionId
		userInfo[keyTimeStamp] = timeStamp
		userInfo[keyAccelerationX] = accelerationX
		userInfo[keyAccelerationY] = accelerationY
		userInfo[keyAccelerationZ] = accelerationZ
		return userInfo
	}
}