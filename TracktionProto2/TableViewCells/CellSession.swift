//
//  CellSession.swift
//  TracktionProto2
//
//  Created by Hervé PEROTEAU on 29/02/2016.
//  Copyright © 2016 Hervé PEROTEAU. All rights reserved.
//

import UIKit

class CellSession: UITableViewCell {

  @IBOutlet weak var sessionIdValueLabel: UILabel!
  @IBOutlet weak var sessionStateValueLabel: UILabel!
  @IBOutlet weak var sessionCountValueLabel: UILabel!
  @IBOutlet weak var sessionDateStartValueLabel: UILabel!
  @IBOutlet weak var sessionDateEndValueLabel: UILabel!
  
  func configureWithSessionTrack(session: RMSession) {

    sessionIdValueLabel.text = "\(session.sessionId)"
    sessionStateValueLabel.text = session.stateStr()
    sessionCountValueLabel.text = "\(session.countEvents)"
    
    let dateFormat = NSDateFormatter()
    dateFormat.dateStyle = .ShortStyle
    dateFormat.timeStyle = .ShortStyle
    
    let dateStart = NSDate(timeIntervalSince1970: session.dateStart)
    let dateEnd = NSDate(timeIntervalSince1970: session.dateEnd)
    
    sessionDateStartValueLabel.text = "\(dateFormat.stringFromDate(dateStart))"
    sessionDateEndValueLabel.text = "\(dateFormat.stringFromDate(dateEnd))"
  }
  
}
