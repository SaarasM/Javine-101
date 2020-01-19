//
//  BarcodeViewController.swift
//  eco-tracker
//
//  Created by Benjamin Searle on 19/01/2020.
//  Copyright © 2020 Benjamin Searle. All rights reserved.
//

import UIKit
import Alamofire

class BarcodeViewController: UIViewController {
    
    var barcode: String = "default"
    var score = 0.0
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var carbonLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("loading Barcode view controller with Barcode: ", barcode)
        
//        barcode = "5000159461122"
        let url = "http://javine-101.appspot.com/barcode/" + barcode
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
                            
        AF.request(url, headers: headers).validate().responseJSON  { response in
           print(response)
            switch response.result {
            case .success(let responseData):
                print("hi")
                guard let value = response.value as? [String: Any] else {
                    print("failed at 1")
                    return
                }
                print(value)
                guard let product_name = value["product_name"] as? String else {
                    print("failed at 2")
                    return
                }
                
                guard let product_carbon = value["product_score"] as? String else {
                    print("failed at 3")
                    return
                }
                self.score = Double(product_carbon)!
                self.productNameLabel.text = product_name
                self.carbonLabel.text = product_carbon
                
            case .failure(let error):
                print("error--->",error)
            }
        }

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let newSender = sender as! UIBarButtonItem
        if newSender.title! == "Save" {
            let controller = segue.destination as! TestViewController
            controller.climateSum += self.score
            controller.climateSumLabel.text = String(controller.climateSum)
            if controller.climateSum < 500{
                controller.mainLogoImageView.image = imageNamed("1")
            }else if controller.climateSum < 1000{
                controller.mainLogoImageView.image = imageNamed("2")
            }else if controller.climateSum < 1500{
                controller.mainLogoImageView.image = imageNamed("3")
            }else if controller.climateSum < 2000{
                controller.mainLogoImageView.image = imageNamed("4")
            }else {
                controller.mainLogoImageView.image = imageNamed("5")
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


