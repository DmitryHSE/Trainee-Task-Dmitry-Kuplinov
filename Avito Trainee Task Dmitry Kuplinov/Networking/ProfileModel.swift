//
//  ProfileModel.swift
//  Avito Trainee Task Dmitry Kuplinov
//
//  Created by Dmitry on 28.10.2022.
//

import Foundation

struct Profile {
    var name: String = ""
    var number: String = ""
    var skills: [String] = []
    
    init?(profile: Employee) {
        name = profile.name
        number = profile.phoneNumber
        skills = profile.skills
    }
    init() {
        
    }
}



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
