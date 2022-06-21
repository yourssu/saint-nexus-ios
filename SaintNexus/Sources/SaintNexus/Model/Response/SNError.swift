//
//  SNError.swift
//  
//
//  Created by Gyuni on 2022/05/22.
//

import Foundation

/**
 SNError는 파싱 과정에서 클라이언트 단독으로 발생한 에러만을 다룹니다.
 
 클라이언트 - Web 사이 error code로 약속 된 에러는 SNResponse의 status 코드를 통해 다뤄집니다.
 */
public enum SNError: Error {
    //  외부의 개입으로 데이터를 가져오기 전 VC가 닫힘
    case dismissed
        
    //  String -> URL 형 변환에 실패함
    case invalidURL(url: String)
    
    //  서버로 부터 ActionItems 혹은 JSCode를 가져오는 것에 실패함
    case failedToLoadDataFromServer
    
    //  Data를 ActionItem으로 디코딩에 실패함
    case failedToDecodeDataToActionItems(dataDescription: String)
    
    //  Data를 의도된 타입으로 디코딩에 실패함
    case failedToDecodeDataToIntendedType(dataDescription: String)
    
    //  웹뷰로부터 받은 값의 status code가 200번 대가 아님
    case invalidData(status: Int, message: String?)
    
    //  마지막 스크립트가 실행된 후 일정 시간이 지남
    case clientTimeout
}
