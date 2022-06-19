//
//  SNSemesterReportCard.swift
//  
//
//  Created by Gyuni on 2022/05/22.
//

import Foundation

public struct SNSemesterReportCard: Codable {
    public let year: String
    public let semester: String
    public let lectures: [SNLectureReportCard]
}

public struct SNLectureReportCard: Codable {
    public let code: String
    public let title: String
    public let credit: Double
    public let score: String
    public let grade: String
    public let professorName: String
}
