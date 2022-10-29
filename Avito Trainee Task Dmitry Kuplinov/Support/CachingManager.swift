//
//  CachingManager.swift
//  Avito Trainee Task Dmitry Kuplinov
//
//  Created by Dmitry on 28.10.2022.
//

import Foundation

func cachedData(profiles: [UsersProfiles.Profile]) {
    let userDefaults = UserDefaults.standard
    if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: profiles, requiringSecureCoding: false) {
        userDefaults.set(savedData, forKey: "profiles")
        print("УСПЕШНО!")
    }
}


func loadedCachedData() {
    let userDefaults = UserDefaults.standard
    if let savedData = userDefaults.object(forKey: "profiles") as? Data {
        if let decodedProfiles = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [UsersProfiles.Profile] {
            print("Cached array is emty: ",decodedProfiles.isEmpty)
//            for i in decodedProfiles {
//                print(i.skills)
//            }
        }
    }
}

func saveCurrentTime(currentTime: Date) {
    let userDefaults = UserDefaults.standard
    userDefaults.set(currentTime, forKey: "currentTime")
    print(currentTime)
}

func loadSavedTime() {
    let savedTime = UserDefaults.standard.object(forKey: "currentTime") as! Date
    print(savedTime)
}

/* if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
 let defaults = UserDefaults.standard
 defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
}*/
