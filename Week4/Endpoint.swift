//
//  Endpoint.swift
//  Week4
//
//  Created by 박소진 on 2023/08/11.
//

import Foundation

enum Endpoint {
    case blog
    case cafe
    case video
    
    //어떤 url로 요청할래?
    var requestURL: String {
        switch self { //근데 앞에 공통 url이 있고 뒤에 달라지는 url이 있음. -> URL+Extension 생성
        case .blog: return URL.makeEndPointString("블로그일 때 사용할 링크 : blog?query=")
        case .cafe: return URL.makeEndPointString("카페일 때 사용할 링크 : cafe?query=")
            
        case .video: return URL.makeEndPointString("vclip?query=")
        //let url = "https://dapi.kakao.com/v2/search/vclip?query=\(text)&size=10&page=\(page)" <- 원래 이거
        }
    }
}
