//
//  SNJSInterface.swift
//  
//
//  Created by Gyuni on 2022/05/01.
//

import Foundation

class SNJSInterface {
    func replaceRequiredTemplates(jsCode inputCode: String,
                                  requiredTemplates: [String]) -> String {
        var outputCode: String = inputCode
        
        requiredTemplates.forEach { key in
            if let value = SaintNexus.shared.userData[key] {
                outputCode = outputCode.replacingOccurrences(of: "{{\(key)}}", with: value)
            }
        }
        return outputCode
    }
    
    deinit {
        print("SaintNexus JSInterface deinit")
    }
}
