//
//  SNChapel.swift
//  
//
//  Created by Gyuni on 2022/10/10.
//

import Foundation

public struct SNChapel: Codable {
    let year: Int
    let semester: String
    let classCode: String
    let time: String
    let room: String
    let floor: String
    let seatCode: String
    let attendance: SNChapelAttendance
}

public struct SNChapelAttendance: Codable {
    let total: Int
    let attend: Int
    let absent: Int
}
