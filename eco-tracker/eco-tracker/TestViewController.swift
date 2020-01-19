//
//  ViewController.swift
//  eco-tracker
//
//  Created by Benjamin Searle on 18/01/2020.
//  Copyright © 2020 Benjamin Searle. All rights reserved.
//

import UIKit
import Vision

final class TestViewController: UIViewController {
    var barcode: String = "default"
    var products = [String]()
    var climateRating = 1
    var climateSum = 0.0
    
    @IBOutlet var presentScannerButton: UIButton!
    @IBOutlet weak var mainLogoImageView: UIImageView!
    @IBOutlet weak var climateSumLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        climateSumLabel.text = String(climateSum)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let imageName = String(climateRating)
        mainLogoImageView.image = imageNamed(imageName)
        print("climate sum is ", climateSum)
    }

    @IBAction func handleScannerPresent(_ sender: Any, forEvent event: UIEvent) {
        let viewController = makeBarcodeScannerViewController()
        viewController.title = "Barcode Scanner"
        present(viewController, animated: true, completion: nil)
    }

    @IBAction func handleScannerPush(_ sender: Any, forEvent event: UIEvent) {
        let viewController = makeBarcodeScannerViewController()
        viewController.title = "Barcode Scanner"
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func makeBarcodeScannerViewController() -> BarcodeScannerViewController {
        let viewController = BarcodeScannerViewController()
        viewController.codeDelegate = self
        viewController.textDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        return viewController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Segue.Barcode" {
            let controller = segue.destination as! BarcodeViewController
            controller.barcode = barcode
        }
        
        if segue.identifier == "Segue.Receipt" {
            let controller = segue.destination as! ReceiptTableViewController
            controller.products = products
        }
    }
}

// MARK: - BarcodeScannerCodeDelegate
extension TestViewController: BarcodeScannerCodeDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print("Barcode Data: \(code)")
        print("Symbology Type: \(type)")
        
        self.barcode = code
                
        controller.dismiss(animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.performSegue(withIdentifier: "Segue.Barcode", sender: self)
        }
    }
}
    
extension TestViewController: BarcodeScannerTextDelegate {
    func scannerDidDismiss(_ controller: BarcodeScannerViewController, didCaptureText text: [VNRecognizedTextObservation]) {
        print("Text Data: \(text)")
        
        var strings = [String]()
        
        for observation in text {
            guard let bestCandidate = observation.topCandidates(1).first else {
                print("No candidate")
                continue
            }
            strings.append(bestCandidate.string)
            print(bestCandidate.string)
        }
        
        self.products = strings
                        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.performSegue(withIdentifier: "Segue.Receipt", sender: self)
        }
    }
}

// MARK: - BarcodeScannerErrorDelegate
extension TestViewController: BarcodeScannerErrorDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
}

// MARK: - BarcodeScannerDismissalDelegate
extension TestViewController: BarcodeScannerDismissalDelegate {
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension TestViewController {
  @IBAction func cancelReceipt(_ segue: UIStoryboardSegue) {
    print("canceling Receipt")
  }

  @IBAction func saveReceipt(_ segue: UIStoryboardSegue) {
    print("saving Receipt")
  }
}

extension TestViewController {
  @IBAction func canelBarcode(_ segue: UIStoryboardSegue) {
    print("cancelling Barcode")
  }

  @IBAction func saveBarcode(_ segue: UIStoryboardSegue) {
    print("saving Barcode")
  }
}
