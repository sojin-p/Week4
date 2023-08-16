//
//  KakaoAPIManager.swift
//  Week4
//
//  Created by 박소진 on 2023/08/11.
//

import Foundation
import Alamofire
import SwiftyJSON

class KakaoAPIManager {
    
    static let shared = KakaoAPIManager()
    
    private init() { }
    
    let header: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakaoAK)"] //2. 공통으로 쓰니까 빼기
    
    func callRequest(type: Endpoint, query: String, completionHandler: @escaping (JSON) -> () ) { //4.클로저 매개변수 생성 //6. @escaping 붙이기
        
        //1. 쿼리 : 검색어 매개변수로 빼기
        guard let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let url = type.requestURL + text //3.타입매개변수 만들기 (사이즈, 페이지는 일단 생략)
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                completionHandler(json) // 5. 성공했을 때 제이슨을 보낼 수 있다.
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}
