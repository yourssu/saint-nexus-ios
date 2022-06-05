//
//  SNPersonalInformation.swift
//  
//
//  Created by Gyuni on 2022/05/22.
//

import Foundation

public struct SNPersonalInformation: Codable {
    let yearOfAdmission: String
    let studentId: String
    let schoolYear: String
    let semester: String
    let name: String
    let college: String
    let department: String
    let major: String
    let classDivision: String
    let graduated: Bool
}
