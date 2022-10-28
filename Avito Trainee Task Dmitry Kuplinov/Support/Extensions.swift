//
//  Extensions.swift
//  Avito Trainee Task Dmitry Kuplinov
//
//  Created by Dmitry on 28.10.2022.
//

import UIKit


extension UIViewController {
    func alert(name: String, message: String) {
        let alertController = UIAlertController(title: name, message: message, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alertOk)
        present(alertController, animated: true, completion: nil )
       
    }
}
