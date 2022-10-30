//
//  Extensions.swift
//  Avito Trainee Task Dmitry Kuplinov
//
//  Created by Dmitry on 28.10.2022.
//

import UIKit

// sort array from A to Z
func sortProfilesFromAToZ(profiles: [Profile]) -> [Profile] {
    var initialArray = profiles
    var names = [String]()
    var sortedProfiles = [Profile]()
    for (i, _) in initialArray.enumerated() {
        names.append(initialArray[i].name)
    }
    names.sort()
    for (i, _) in names.enumerated() {
        if let element = initialArray.firstIndex(where: {$0.name == names[i]}) {
            sortedProfiles.append(initialArray[element])
            initialArray.remove(at: element)
        }
    }
    return sortedProfiles
}

func timeInterval(lhs: Date, rhs: Date) -> TimeInterval {
    return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
}

// configure alert
func showAlert(view: UIViewController, name: String, message: String) {
    let alertController = UIAlertController(title: name, message: message, preferredStyle: .alert)
    let alertOk = UIAlertAction(title: "OK", style: .default)
    alertController.addAction(alertOk)
    view.present(alertController, animated: true, completion: nil )
}

