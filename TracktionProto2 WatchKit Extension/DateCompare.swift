//
//  DateCompare.swift
//  TracktionProto2
//
//  Created by Hervé PEROTEAU on 31/01/2016.
//  Copyright © 2016 Hervé PEROTEAU. All rights reserved.
//

import Foundation

func <=(lhs: NSDate, rhs: NSDate) -> Bool {
  return lhs.timeIntervalSince1970 <= rhs.timeIntervalSince1970
}
func >=(lhs: NSDate, rhs: NSDate) -> Bool {
  return lhs.timeIntervalSince1970 >= rhs.timeIntervalSince1970
}
func >(lhs: NSDate, rhs: NSDate) -> Bool {
  return lhs.timeIntervalSince1970 > rhs.timeIntervalSince1970
}
func <(lhs: NSDate, rhs: NSDate) -> Bool {
  return lhs.timeIntervalSince1970 < rhs.timeIntervalSince1970
}
func ==(lhs: NSDate, rhs: NSDate) -> Bool {
  return lhs.timeIntervalSince1970 == rhs.timeIntervalSince1970
}