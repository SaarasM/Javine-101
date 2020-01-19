//
//  AgePickerViewController.swift
//  eco-tracker
//
//  Created by Benjamin Searle on 18/01/2020.
//  Copyright © 2020 Benjamin Searle. All rights reserved.
//

import UIKit
import Alamofire

class AgePickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var agePicker: UIPickerView!
    
    var agePickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.agePicker.delegate = self
        self.agePicker.dataSource = self
        
        // Input the data into the array
        var intData = [Int]()
        intData += 1...100
        agePickerData = intData.map{ String($0)}
                
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        agePickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return agePickerData[row]
    }

}
