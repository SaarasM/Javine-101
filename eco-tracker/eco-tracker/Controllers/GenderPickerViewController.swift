//
//  GenderPickerViewController.swift
//  eco-tracker
//
//  Created by Benjamin Searle on 18/01/2020.
//  Copyright © 2020 Benjamin Searle. All rights reserved.
//

import UIKit

class GenderPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var genderPicker: UIPickerView!
    
    var genderPickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.genderPicker.delegate = self
        self.genderPicker.dataSource = self
        
        // Input the data into the array
        genderPickerData = ["Male", "Female", "Non-binary", "Prefer Not to Say"]

        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        genderPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderPickerData[row]
    }

}
