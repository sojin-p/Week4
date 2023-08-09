//
//  WeatherViewController.swift
//  Week4
//
//  Created by 박소진 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController {

    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var humidLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callRequest()

    }
    
    func callRequest() {
        
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid=\(APIKey.weatherKey)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let temp = json["main"]["temp"].doubleValue - 273.15 //절대 온도라서 저만큼을 빼야 섭씨온도가 된다.
                let humidity = json["main"]["humidity"].intValue
                let id = json["weather"][0]["id"].intValue //대괄호있는거 놓치지 말기 - 803번
                
                switch id { //803을 그대로 보여줄 수 없으니까
                case 800: print("매우 맑음")
                case 801...809:
                    self.weatherLabel.text = "구름 낀 날씨입니다!"
                    self.view.backgroundColor = .systemGray5
                default: print("나머지는 생략")
                }
                
                self.tempLabel.text = "\(temp)도 입니다."
                self.humidLabel.text = "습도는 \(humidity)% 입니다."
                
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    

}
