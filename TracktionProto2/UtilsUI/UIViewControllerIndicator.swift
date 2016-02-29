//
//  ViewControllerHelperUI.swift
//  TracktionProto2
//
//  Created by Hervé PEROTEAU on 29/02/2016.
//  Copyright © 2016 Hervé PEROTEAU. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController {
  
  func startLoadingIndicator()->NVActivityIndicatorView {
    
    let sizeIndicator: CGFloat = 40;
    let rect = CGRectMake((CGFloat)((self.view.frame.size.width/2)-(sizeIndicator/2)),
      (CGFloat)((self.view.frame.size.height/2)-(sizeIndicator/2)),
      sizeIndicator,
      sizeIndicator)
    
    let indicator = NVActivityIndicatorView(frame: rect, type:.BallGridBeat, color: UIColor.orangeColor())
    view.addSubview(indicator)
    indicator.startAnimation()
    
    return indicator
  }
  
  func finishLoading(indicator: NVActivityIndicatorView) {
    
    indicator.stopAnimation()
    indicator.removeFromSuperview()
  }  
}