//
//  URL+Extension.swift
//  Week4
//
//  Created by 박소진 on 2023/08/11.
//

import Foundation

extension URL { //애플이 갖고있는 구조체 URL을 확장
    static let baseURL = "https://dapi.kakao.com/v2/search" //앞에 공통된거.. 인스타같은 경우 2-30개 불러야함 그러니 이렇게 하는게..
    
    static func makeEndPointString(_ endpoint: String) -> String {
        return baseURL + endpoint //그럼 나중에 앞에 붙일 수 있당
    }
}
