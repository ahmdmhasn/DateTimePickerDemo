//
//  AvaiableTimePicker.swift
//  DateTimePickerDemo
//
//  Created by Ahmed M. Hassan on 6/23/20.
//  Copyright © 2020 Ahmed M. Hassan. All rights reserved.
//

import UIKit

class AvaiableTimePicker: NSObject {
  
  typealias Completion = (Date) -> Void
  
  // MARK: - Properties
  var viewModel: AvaiableTimeViewModel! {
    didSet { configurePickers() }
  }
  
  private var time: Date? {
    didSet { didSetDateTime() }
  }
  
  private var date: Date? {
    didSet { configurePickers() }
  }
  
  private weak var presentationViewController: UIViewController?
  private let datePicker = DatePickerDialog()
  private let timePicker = DatePickerDialog()
  private var completion: Completion?
  
  // MARK: - Pickers
  
  init(presentationViewController: UIViewController) {
    self.presentationViewController = presentationViewController
    super.init()
  }
  
  func start(completion: Completion? = nil) {
    self.completion = completion
    showDatePicker()
  }
  
  private func showDatePicker() {
    datePicker.show("Date Picker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: datePickerMinimumDate ?? Date(), minimumDate: datePickerMinimumDate, maximumDate: nil, datePickerMode: .date) { [unowned self] date in
      if let date = date {
        self.date = date
        DispatchQueue.main.async {
          self.showTimePicker()
        }
      }
    }
  }
  
  private func showTimePicker() {
    timePicker.show("Time Picker", doneButtonTitle: "Done", cancelButtonTitle: "cancel", defaultDate: timePickerMinimumDate ?? Date(), minimumDate: timePickerMinimumDate, maximumDate: timePickerMaximumDate, datePickerMode: .time) { [unowned self] time in
      if let time = time {
        self.time = time
      } else {
        self.showTimePicker()
      }
    }
  }
  
  private func didSetDateTime() {
    if let date = date,
      let time = time,
      let resultDate = combine(date: date, time: time) {
      completion?(resultDate)
      completion = nil
    }
  }
  
}

// MARK: - Configureation
private extension AvaiableTimePicker {
  
  var timePickerMinimumDate: Date? {
    let isToday = viewModel.calendar.isDateInToday(date ?? Date())
    return (viewModel.canOrderToday && isToday) ? viewModel.currentOrderTime : viewModel.nextDayFromTime
  }
  
  var timePickerMaximumDate: Date? {
    return viewModel.calendar.date(bySetting: .hour, value: viewModel.data.wokingTo, of: timePickerMinimumDate ?? Date())
  }
  
  var datePickerMinimumDate: Date? {
    viewModel.canOrderToday ? viewModel.currentOrderTime : viewModel.nextDayFromTime
  }
  
  func configurePickers() {
    datePicker.datePicker.datePickerMode = .date
    
    timePicker.datePicker.minuteInterval = 15
    timePicker.datePicker.datePickerMode = .time
    
    if let viewModel = self.viewModel {
      configureAvaiableTimes(viewModel: viewModel)
    }
  }
  
  private func configureAvaiableTimes(viewModel: AvaiableTimeViewModel) {
//    guard let workingFromTime = viewModel.workingFromTime,
//      let workingToTime = viewModel.workingToTime
//      /*,
//      let nextDayStartTime = viewModel.nextDayStartTime*/ else {
//        print(#function, "Unable to get times from API")
//        return
//    }
//
    
//
//    if let nextDayStartTime = viewModel.nextDayStartTime {
//      timePicker.datePicker.minimumDate = calendar.date(
//        bySetting: .hour,
//        value: viewModel.data.wokingFrom,
//        of: nextDayStartTime
//      ) // workingFromTime
//      timePicker.datePicker.maximumDate = calendar.date(
//        bySetting: .hour,
//        value: viewModel.data.wokingTo,
//        of: nextDayStartTime
//      ) // workingToTime
//    }
//    if let selectedDate = self.date,
//      Calendar.current.isDateInToday(selectedDate) {
//      timePicker.datePicker.minimumDate = startOrderTime
//    }
  }
  
}

// MARK: - Helpers
private extension AvaiableTimePicker {
  
  /// Returns `Date` from date and time.
  func combine(date: Date, time: Date) -> Date? {
      let calendar = Calendar.current
      let dateComponents = calendar.dateComponents([.day, .month, .year], from: date)
      let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
      
      var newComponents = DateComponents()
      newComponents.timeZone = .current
      newComponents.day = dateComponents.day
      newComponents.month = dateComponents.month
      newComponents.year = dateComponents.year
      newComponents.hour = timeComponents.hour
      newComponents.minute = timeComponents.minute
      newComponents.second = timeComponents.second
      
      return calendar.date(from: newComponents)
  }

}
