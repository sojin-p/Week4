//
//  ViewController.swift
//  Week4
//
//  Created by 박소진 on 2023/08/07.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        callReauest()
    }
    
    func callReauest() {
        //왜 안될까 ? url이 https가 아니고 http임 - info에서 바꾸기 - ATS
        //인증키 관리 중요!!! -> .gitignore로 중요한 키 숨기기
        let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=f5eef3421c602c6cb7ea224104795888&targetDt=20120101"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
            case .failure(let error):
                print(error)
            }
        }
        
    }


}

