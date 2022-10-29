//
//  ProfileModel.swift
//  Avito Trainee Task Dmitry Kuplinov
//
//  Created by Dmitry on 28.10.2022.
//

import Foundation
 
@objc(_TtCC34Avito_Trainee_Task_Dmitry_Kuplinov13UsersProfiles7Profile)class Profile: NSObject, NSCoding {
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(number, forKey: "number")
        coder.encode(skills, forKey: "skills")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        number = coder.decodeObject(forKey: "number") as? String ?? ""
        skills = coder.decodeObject(forKey: "skills") as? [String] ?? []
    }
    
    var name: String = ""
    var number: String = ""
    var skills: [String] = []
    
    init?(profile: Employee) {
        name = profile.name
        number = profile.phoneNumber
        skills = profile.skills
    }
}



