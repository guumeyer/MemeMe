//
//  Alerts.swift
//  MemeMe
//
//  Created by Meyer, Gustavo on 2/4/19.
//  Copyright © 2019 Meyer. All rights reserved.
//

import UIKit

/// Represents alert view
struct Alerts {

    static let DismissAlert = "Dismiss"
    static let GenerateMemeFailedTitle = "Generate Meme Failed"
    static let GenerateMemeFailedMessage = "Something went wrong."

    static func showAlert(_ viewController: UIViewController, _ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
