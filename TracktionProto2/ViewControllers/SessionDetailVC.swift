//
//  SessionDetailVC.swift
//  TracktionProto2
//
//  Created by Hervé PEROTEAU on 29/02/2016.
//  Copyright © 2016 Hervé PEROTEAU. All rights reserved.
//

import UIKit
import RealmSwift

private let kCellTrackEventIdentifier = "CellTrackEvent"

class SessionDetailVC: UITableViewController {
  
  var events: Results<RMEvent>?
  var sessionId : Int=0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.estimatedRowHeight = 124
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    if events == nil {
      loadData()
    }
  }
  
  func loadData() {
    assert(sessionId>0, "Set sessionId before !")
    NSLog("loadData ...")
    self.events = RealmLayer().getEventsForSession(sessionId)
    NSLog("loadData ended (count=\(self.events?.count))")
    self.tableView.reloadData()
  }
}

// MARK: - TableViewDatasource

extension SessionDetailVC {
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let events = events {
      return events.count
    }
    return 0
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(kCellTrackEventIdentifier) as! CellTrackEvent
    let event = events![indexPath.row]
    cell.configureWithEventTrack(event)
    return cell
  }
}

