//
//  DataModel.swift
//  Avito Trainee Task Dmitry Kuplinov
//
//  Created by Dmitry on 28.10.2022.
//

import Foundation

struct DataModel: Codable {
    let company: Company
}


struct Company: Codable {
    let name: String
    let employees: [Employee]
}


struct Employee: Codable {
    let name, phoneNumber: String
    let skills: [String]

    enum CodingKeys: String, CodingKey {
        case name
        case phoneNumber = "phone_number"
        case skills
    }
}
