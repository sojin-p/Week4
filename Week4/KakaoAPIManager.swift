//
//  KakaoAPIManager.swift
//  Week4
//
//  Created by 박소진 on 2023/08/11.
//

import Foundation
import Alamofire

class KakaoAPIManager {
    
    static let shared = KakaoAPIManager()
    
    private init() { }
    
    let header: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakaoAK)"] //2. 공통으로 쓰니까 빼기
    
    func callTest(type: Endpoint, query: String, page: Int, completionHandler: @escaping (KakaoVideo) -> () ) {
        
        guard let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let url = type.requestURL + text + "&size=10" + "&page=\(page)"
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500)
            .responseDecodable(of: KakaoVideo.self) { response in
                guard let value = response.value else { return }
//                print(value.documents)
                completionHandler(value)
        }
    }
    
}
