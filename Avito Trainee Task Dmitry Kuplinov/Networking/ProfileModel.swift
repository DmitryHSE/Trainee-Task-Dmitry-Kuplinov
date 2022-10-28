//
//  ProfileModel.swift
//  Avito Trainee Task Dmitry Kuplinov
//
//  Created by Dmitry on 28.10.2022.
//

import Foundation
 
struct Profile { //struct
   
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


