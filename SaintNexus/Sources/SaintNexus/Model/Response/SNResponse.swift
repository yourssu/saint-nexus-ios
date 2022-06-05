//
//  SNResponse.swift
//  
//
//  Created by Gyuni on 2022/05/22.
//

import Foundation

public struct SNResponse<T: Codable>: Codable {
    public let status: Int
    public let rdata: T?
    public let message: String?
}
