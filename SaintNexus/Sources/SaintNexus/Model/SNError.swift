//
//  SNError.swift
//  
//
//  Created by Gyuni on 2022/05/22.
//

import Foundation

public enum SNError: Error {
    //  외부의 개입으로 데이터를 가져오기 전 VC가 닫힘
    case dismissed
        
    //  String -> URL 형 변환에 실패함
    case invalidURL
    
    //  서버로 부터 ActionItems 혹은 JSCode를 가져오는 것에 실패함
    case failedToLoadDataFromServer
    
    //  String을 Data 타입으로 전환에 실패함
    case failedToConvertStringToData
    
    //  Data를 ActionItem으로 디코딩에 실패함
    case failedToDecodeDataToActionItems
    
    //  Data를 의도된 타입으로 디코딩에 실패함
    case failedToDecodeDataToIntendedType
    
    //  웹뷰로부터 받은 값의 status code가 200번 대가 아님
    case invalidData(data: Any)
    
    //  마지막 스크립트가 실행된 후 일정 시간이 지남
    case timeout
}
