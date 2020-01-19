//
//  PeoplePickerViewController.swift
//  eco-tracker
//
//  Created by Benjamin Searle on 18/01/2020.
//  Copyright © 2020 Benjamin Searle. All rights reserved.
//

import UIKit

class PeoplePickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var peoplePicker: UIPickerView!
    
    var peoplePickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.peoplePicker.delegate = self
        self.peoplePicker.dataSource = self

        // Input the data into the array
        peoplePickerData = ["1", "2", "3", "4", "5", "6", "7", "8"]
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        peoplePickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return peoplePickerData[row]
    }

}
