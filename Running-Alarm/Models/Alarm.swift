//
//  Alarm.swift
//  Running-Alarm
//
//  Created by Edward Yoo on 9/5/15.
//  Copyright (c) 2015 Hohun Yoo. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit
import AudioToolbox

class Alarm: Object {
  dynamic var timeString: String = ""
  dynamic var setDate = NSDate()
  dynamic var modificationDate = NSDate()
  
  var interval: Double = 0.0

  
  func findDifferenceBetweenTimesAndSetTimer(timeModified: NSDate, timeSet: NSDate) {
    interval = timeModified.timeIntervalSinceDate(timeSet)
    var timer = NSTimer()
    timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("counting"), userInfo: nil, repeats: true)
  }
  
  func counting() {
    
    if interval < 0 {
    interval++
    println(interval)
    } else {
      vibratePhone()
    }
  }
  
  func vibratePhone() {
    AudioServicesPlaySystemSound(1151)
//      SystemSoundID(kSystemSoundID_Vibrate))
    println("VRRM VRRM")
  }
  
}