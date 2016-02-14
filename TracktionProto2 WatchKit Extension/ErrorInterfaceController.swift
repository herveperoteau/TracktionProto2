//
//  ErrorInterfaceController.swift
//  TracktionProto2
//
//  Created by Hervé PEROTEAU on 06/02/2016.
//  Copyright © 2016 Hervé PEROTEAU. All rights reserved.
//

import WatchKit

class ErrorInterfaceController: WKInterfaceController {

  @IBOutlet var lbError: WKInterfaceLabel!
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)

    if let message = context as? String {
      lbError.setText(message)
    }
  }

}
