//
//  ProfileModel.swift
//  Avito Trainee Task Dmitry Kuplinov
//
//  Created by Dmitry on 28.10.2022.
//

import Foundation

struct Profile {
    let name: String
    let number: String
    let skills: [String]
    
    init?(profile: Employee) {
        self.name = profile.name
        self.number = profile.phoneNumber
        self.skills = profile.skills
    }
    
}

func sortProfilesAz(profiles: [Employee]) -> [Employee] {
    var initialArray = profiles
    var names = [String]()
    var sortedProfiles = [Employee]()
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
