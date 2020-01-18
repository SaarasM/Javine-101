//
//  ViewController.swift
//  eco-tracker
//
//  Created by Benjamin Searle on 18/01/2020.
//  Copyright © 2020 Benjamin Searle. All rights reserved.
//

import UIKit

final class TestViewController: UIViewController {
    @IBOutlet var presentScannerButton: UIButton!
    @IBOutlet var pushScannerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        return viewController
    }
}

// MARK: - BarcodeScannerCodeDelegate
extension TestViewController: BarcodeScannerCodeDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print("Barcode Data: \(code)")
        print("Symbology Type: \(type)")
        
//        controller.dismiss(animated: true, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            controller.resetWithError(message: "Barcode Data: \(code)")
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

