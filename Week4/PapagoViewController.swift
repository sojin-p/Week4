//
//  PapagoViewController.swift
//  Week4
//
//  Created by 박소진 on 2023/08/10.
//

import UIKit
import Alamofire
import SwiftyJSON

class PapagoViewController: UIViewController {

    @IBOutlet var originTextView: UITextView!
    @IBOutlet var translateTextView: UITextView!
    @IBOutlet var requestButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        translateTextView.isEditable = false //수정 안되게
        
    }
    
    @IBAction func requestButtonClicked(_ sender: UIButton) {
        
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": "RlwTxOqSWMaHHOAGCMH8",
            "X-Naver-Client-Secret": APIKey.naverKey
        ]
        let parameters: Parameters = [
            "source": "ko", //pickerView 같은 거 활용해도 됨
            "target": "en",
            "text": originTextView.text ?? ""
        ]

        AF.request(url, method: .post, parameters: parameters, headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let data = json["message"]["result"]["translatedText"].stringValue
                
                self.translateTextView.text = data
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
