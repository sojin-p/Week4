//
//  AsyncViewController.swift
//  Week4
//
//  Created by 박소진 on 2023/08/11.
//

import UIKit

class AsyncViewController: UIViewController {

    @IBOutlet var first: UIImageView!
    @IBOutlet var second: UIImageView!
    @IBOutlet var third: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        first.backgroundColor = .systemPink
        print("1")
        
        DispatchQueue.main.async {
            
            self.first.layer.cornerRadius = self.first.frame.width / 2 //정원 만드는 수식
            //근데 디바이스마다 다 정 원이 되지않음.. 그래서 메인.어싱크에 넣어주면..? 잘 나옴.
            //왜 일까..? 스토리보드에 디자인된 기준으로 나누기때문에,,(시점이 안 맞아서)
            //그래서 비율로 나누는 시점을 늦춘 것. 가장늦게 실행되는 게 어싱크 구문이다.
            
            print("2")
        }
        print("3") // 1 -> 3 -> 2 가장늦게 실행되는 게 어싱크 구문이다.
        
    }
    
    //sync, async, serial, concurrent
    //UI Freezing
    @IBAction func buttonClicked(_ sender: UIButton) {
        
        let url = URL(string: "https://api.nasa.gov/assets/img/general/apod.jpg")!
        
        DispatchQueue.global().async { //다른 알바한테 나눠줌 왜? 오래걸리니까(작업크니까) 시간아껴야지
            let data = try! Data(contentsOf: url) //이미지를 0101같은 거로 변환해주는 코드
            
            DispatchQueue.main.async { //UI가 젤 중요하니까(사용자와 맞닿아있음) 메인으로 우선순위를 높여야 함.
                self.first.image = UIImage(data: data)
            }
        }
        
    }
    
}
