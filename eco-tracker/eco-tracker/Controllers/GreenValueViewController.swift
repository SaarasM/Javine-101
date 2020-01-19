//
//  GreenValueViewController.swift
//  eco-tracker
//
//  Created by Benjamin Searle on 18/01/2020.
//  Copyright © 2020 Benjamin Searle. All rights reserved.
//

import UIKit

class GreenValueViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var greenValuePicker: UIPickerView!
    
    var greenValuePickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.greenValuePicker.delegate = self
        self.greenValuePicker.dataSource = self

        // Input the data into the array
        greenValuePickerData = ["Level 1", "Level 2", "Level 3", "Level 4", "Level 5"]
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        greenValuePickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return greenValuePickerData[row]
    }

}
