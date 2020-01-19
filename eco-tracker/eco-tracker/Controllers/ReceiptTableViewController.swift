//
//  ReceiptTableViewController.swift
//  eco-tracker
//
//  Created by Benjamin Searle on 19/01/2020.
//  Copyright © 2020 Benjamin Searle. All rights reserved.
//

import UIKit
import Alamofire

class ReceiptTableViewController: UITableViewController {

    
    var products = [String]()
    var newProducts = [String]()
    var newScores = ["0.0", "0.0", "0.0"]
    var sumScores = 0.0
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! TestViewController
        controller.climateSum += self.sumScores
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("loading Receipt view controller with products: ", products.count)

        // Do any additional setup after loading the view.
        
        
        let url = "http://javine-101.appspot.com/receipt"
        
        if products.count >= 3 {
            newProducts.append(products[0])
            newProducts.append(products[1])
            newProducts.append(products[2])
        }
        
        if products.count >= 3{
            let parameters: Parameters = [
                "id_1": [
                    "receipt": newProducts[0]
                ],
                "id_2": [
                    "receipt": newProducts[1]
                ],
                "id_3": [
                    "receipt": newProducts[2]
                ]
            ]

            // Both calls are equivalent
            let request = AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { (response) in
                switch response.result {
                    case .success(let responseData):
                        guard let value = response.value as? [String: Any] else {
                            print("failed at 1")
                            return
                        }
                        print(value)
                        guard let id1 = value["id_1"] as? [String: Any] else {
                            print("failed at 2a")
                            return
                        }
                        
                        guard let id2 = value["id_2"] as? [String: Any] else {
                            print("failed at 2b")
                            return
                        }
                        
                        guard let id3 = value["id_3"] as? [String: Any] else {
                            print("failed at 2c")
                            return
                        }

                        guard let product_name1 = id1["product_name"] as? String else {
                            print("failed at 3a")
                            return
                        }
                    
                        guard let product_name2 = id2["product_name"] as? String else {
                            print("failed at 3b")
                            return
                        }
                    
                        guard let product_name3 = id3["product_name"] as? String else {
                            print("failed at 3c")
                            return
                        }
                    
                        guard let product_score1 = id1["product_score"] as? String else {
                            print("failed at 4a")
                            return
                        }
                    
                        guard let product_score2 = id2["product_score"] as? String else {
                            print("failed at 4b")
                            return
                        }
                    
                        guard let product_score3 = id3["product_score"] as? String else {
                            print("failed at 4c")
                            return
                        }
                        
                        self.newScores.append(product_score1)
                        self.newScores.append(product_score2)
                            self.newScores.append(product_score3)
                    
                        self.sumScores = Double(product_score1)! + Double(product_score2)! + Double(product_score3)!
                    
                        self.tableView.reloadData()
                    case .failure(let error):
                        print("error--->",error)
                    }
            }
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newProducts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ProductTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ProductTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ProductTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let product = self.newProducts[indexPath.row]
        let score = self.newScores[indexPath.row]
        
        cell.nameLabel.text = product
        cell.ratingLabel.text = score
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            products.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
