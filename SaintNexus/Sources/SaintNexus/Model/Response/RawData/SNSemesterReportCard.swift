//
//  SNSemesterReportCard.swift
//  
//
//  Created by Gyuni on 2022/05/22.
//

import Foundation

public struct SNSemesterReportCard: Codable {
    let year: String
    let semester: String
    let lectures: [SNLectureReportCard]
}

public struct SNLectureReportCard: Codable {
    let code: String
    let title: String
    let credit: Double
    let score: String
    let grade: String
    let professorName: String
}
