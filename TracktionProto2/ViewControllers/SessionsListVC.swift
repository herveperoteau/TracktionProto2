//
//  SessionsListVC.swift
//  TracktionProto2
//
//  Created by Hervé PEROTEAU on 29/02/2016.
//  Copyright © 2016 Hervé PEROTEAU. All rights reserved.
//

import UIKit
import RealmSwift

private let kCellSessionIdentifier = "CellSession"
private let kSegueShowDetailSession = "showDetailSession"

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
    self.sessions = RealmLayer().getListSessions()
    NSLog("loadData ended (count=\(self.sessions?.count))")
    self.tableView.reloadData()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == kSegueShowDetailSession {
      let destVC = segue.destinationViewController as! SessionDetailVC;
      let session = sender as! RMSession
      destVC.sessionId = session.sessionId
    }
  }
}

// MARK: - TableViewDatasource

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
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let session = sessions![indexPath.row]
    performSegueWithIdentifier(kSegueShowDetailSession, sender: session)
  }
}
