//
//  Extensions.swift
//  Avito Trainee Task Dmitry Kuplinov
//
//  Created by Dmitry on 28.10.2022.
//

import UIKit

func loadDataFromStorage(key: String, completion: @escaping([String]) -> Void) {
    let defaults = UserDefaults.standard
    if let array = defaults.stringArray(forKey: key) {
     completion(array)
    }
}

// сортировка массива по алфавиту
func sortProfilesFromAToZ(profiles: [UsersProfiles.Profile]) -> [UsersProfiles.Profile] {
    var initialArray = profiles
    var names = [String]()
    var sortedProfiles = [UsersProfiles.Profile]()
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


