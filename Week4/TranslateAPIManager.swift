//
//  TranslateAPIManager.swift
//  Week4
//
//  Created by 박소진 on 2023/08/11.
//

import Foundation
import Alamofire
import SwiftyJSON

class TranslateAPIManager { //파파고뷰컨
    
    static let shared = TranslateAPIManager()
    private init() { }
    
    func callRequest(text: String, resultString: @escaping (String) -> Void ) {
        
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": "RlwTxOqSWMaHHOAGCMH8",
            "X-Naver-Client-Secret": APIKey.naverKey
        ]
        let parameters: Parameters = [
            "source": "ko",
            "target": "en",
            "text": text //1.파파고뷰컨에 있으니까 매개변수로 빼기
        ]

        AF.request(url, method: .post, parameters: parameters, headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let data = json["message"]["result"]["translatedText"].stringValue

//                self.translateTextView.text = data
                resultString(data) //2.위를 전달하기위해 이렇게 매개변수로 빼기
                
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
