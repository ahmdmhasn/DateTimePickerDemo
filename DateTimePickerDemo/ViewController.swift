//
//  ViewController.swift
//  DateTimePickerDemo
//
//  Created by Ahmed M. Hassan on 6/23/20.
//  Copyright © 2020 Ahmed M. Hassan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  lazy var picker = AvaiableTimePicker(presentationViewController: self)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    picker.viewModel = AvaiableTimeViewModel(data: .demo)
    picker.start { date in
      print(date)
    }
    
  }
}
