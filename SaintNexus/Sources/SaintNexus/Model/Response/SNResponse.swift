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
    
    init(from string: String) throws {
        print(string)
        let data = Data(string.utf8)
        var parsedData: SNResponse<T>
        
        do {
            parsedData = try JSONDecoder().decode(SNResponse<T>.self, from: data)
        } catch {
            throw SNError.failedToDecodeDataToIntendedType
        }
        
        if !(parsedData.status >= 200 && parsedData.status < 300) {
            throw SNError.invalidData(data: parsedData)
        }
        
        self.status = parsedData.status
        self.rdata = parsedData.rdata
        self.message = parsedData.message
    }
    
    init(
        status: Int,
        rdata: T?,
        message: String?
    ) {
        self.status = status
        self.rdata = rdata
        self.message = message
    }
}
