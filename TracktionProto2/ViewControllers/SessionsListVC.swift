//
//  SessionsListVC.swift
//  TracktionProto2
//
//  Created by Hervé PEROTEAU on 29/02/2016.
//  Copyright © 2016 Hervé PEROTEAU. All rights reserved.
//

import UIKit
import RealmSwift
import NVActivityIndicatorView

let kCellSessionIdentifier = "CellSession"

class SessionsListVC: UITableViewController {

  var sessions: Results<RMSession>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.estimatedRowHeight = 198
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    if sessions == nil {
      loadData()
    }
  }
  
  func loadData() {
    NSLog("loadData ...")
    self.sessions = try! Realm().objects(RMSession)
    NSLog("loadData ended (count=\(self.sessions?.count))")
    self.tableView.reloadData()
  }
}

extension SessionsListVC {
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let sessions = sessions {
      return sessions.count
    }
    return 0
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier(kCellSessionIdentifier) as! CellSession

    let sessionTrack = sessions![indexPath.row]
    cell.configureWithSessionTrack(sessionTrack)
    return cell
  }
}
