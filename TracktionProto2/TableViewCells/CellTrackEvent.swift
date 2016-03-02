//
//  CellTrackEvent.swift
//  TracktionProto2
//
//  Created by Hervé PEROTEAU on 29/02/2016.
//  Copyright © 2016 Hervé PEROTEAU. All rights reserved.
//

import UIKit

class CellTrackEvent: UITableViewCell {

  @IBOutlet weak var xValueLabel: UILabel!
  @IBOutlet weak var yValueLabel: UILabel!
  @IBOutlet weak var zValueLabel: UILabel!
  @IBOutlet weak var dateEventValueLabel: UILabel!
  
  func configureWithEventTrack(event: RMEvent) {
    
    xValueLabel.text = "\(event.x)"
    yValueLabel.text = "\(event.y)"
    zValueLabel.text = "\(event.z)"

    let dateEvent: NSDate = NSDate(timeIntervalSince1970: event.dateEvent)
    let dateFormat = NSDateFormatter()
    dateFormat.dateFormat = "dd-MM-yyyy hh:mm:ss SSSS"
    dateEventValueLabel.text = "\(dateFormat.stringFromDate(dateEvent))"
  }
}
