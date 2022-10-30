//
//  CachingManager.swift
//  Avito Trainee Task Dmitry Kuplinov
//
//  Created by Dmitry on 28.10.2022.
//

import Foundation

//MARK: - Saving and loading data

func cachedData(profiles: [Profile]) {
    let userDefaults = UserDefaults.standard
    if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: profiles, requiringSecureCoding: false) {
        userDefaults.set(savedData, forKey: "profiles")
    }
}


func loadingCachedData() -> [Profile] {
    var data = [Profile]()
    let userDefaults = UserDefaults.standard
    if let savedData = userDefaults.object(forKey: "profiles") as? Data {
        if let decodedProfiles = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [Profile] {
            data = decodedProfiles
        }
    }
    return data
}


func clearCache() {
    let emptyArray = [Profile]()
    cachedData(profiles: emptyArray)
}

func saveCurrentTime(currentTime: Date) {
    let userDefaults = UserDefaults.standard
    userDefaults.set(currentTime, forKey: "currentTime")
    
}

func loadSavedTime() -> Date? {
    if let savedTime = UserDefaults.standard.object(forKey: "currentTime") as? Date {
        return savedTime
    } else {
        return nil
    }
}



