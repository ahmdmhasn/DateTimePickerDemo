//
//  UserAvaiableTime.swift
//  DateTimePickerDemo
//
//  Created by Ahmed M. Hassan on 6/23/20.
//  Copyright © 2020 Ahmed M. Hassan. All rights reserved.
//

import Foundation

// MARK: - User Available times
struct AvailableTimeModel: Codable/*GeneralM*/ {
  var message: String!
  let innerData: AvailableTimeData
}

// MARK: - InnerDatum
struct AvailableTimeData: Codable {
  let serverDateTime: String
  let wokingFrom, wokingTo: Int
    
  static let demo = AvailableTimeData(
//    serverDateTime: "22 Jun, 2020 22:33",
    serverDateTime: "23 Jun, 2020 13:43",
    wokingFrom: 9,
    wokingTo: 18
  )
  
}

// MARK: - AvaiableTimeViewModel
struct AvaiableTimeViewModel {
  
  let data: AvailableTimeData
  
  /// Allowed hours since the current time
  private let allowanceHours: Int = 2
  
  let calendar = Calendar.current
  
  /// Current date
  private var currentDate: Date {
    data.serverDateTime.serverDate ?? Date()
  }
  
  /// Returns the current time in addition to the allowance time
  var currentOrderTime: Date {
    currentDate.addingTimeInterval(Double(allowanceHours * 3600))
  }
  
  var canOrderToday: Bool {
    if let workingFromTime = workingFromTime,
      let workingToTime = workingToTime {
      return currentOrderTime >= workingFromTime
        && currentOrderTime <= workingToTime
    } else {
      return false
    }
  }

  var workingFromTime: Date? {
    calendar.date(bySettingHour: data.wokingFrom, minute: .zero, second: .zero, of: currentDate, direction: .backward)
  }
  
  var workingToTime: Date? {
    if let workingFromTime = workingFromTime {
      return calendar.date(bySetting: .hour, value: data.wokingTo, of: workingFromTime)
    }
    return nil
  }
  
  var nextDayFromTime: Date? {
    if let workingFromTime = workingFromTime {
      let isBeforeWorking = currentOrderTime < workingFromTime
      let shiftingDays = isBeforeWorking ? 0 : 1
      return calendar.date(byAdding: .day, value: shiftingDays, to: workingFromTime)
    }
    return nil
  }
  
}

// MARK: - String to Date
private extension String {
    /// Get `Date` object from API's string.
    var serverDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, yyyy HH:mm"
        return dateFormatter.date(from: self)
    }
}
