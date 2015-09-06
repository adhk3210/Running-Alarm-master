//
//  AlarmTableViewCell.swift
//  Running-Alarm
//
//  Created by Edward Yoo on 9/5/15.
//  Copyright (c) 2015 Hohun Yoo. All rights reserved.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {

  @IBOutlet weak var alarmTimeListingLabel: UILabel!
  
  var alarm: Alarm? {
    didSet {
      if let alarm = alarm, alarmTimeListingLabel = alarmTimeListingLabel {
        self.alarmTimeListingLabel.text = alarm.timeString
      }
    }
  }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
