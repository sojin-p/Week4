//
//  ViewController.swift
//  Week4
//
//  Created by 박소진 on 2023/08/07.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Movie {
    var title: String
    var release: String
}

class ViewController: UIViewController {

    @IBOutlet var movieTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    //빈 배열에서 만든 구조체로 바꾸기
    var movieList: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callReauest()
        
        movieTableView.rowHeight = 60
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
        
    }
    
    func callReauest() {
        //왜 안될까 ? url이 https가 아니고 http임 - info에서 바꾸기 - ATS
        //인증키 관리 중요!!! -> .gitignore로 중요한 키 숨기기
        let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(APIKey.boxOfficeKey)&targetDt=20120101"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                //차근차근 접근. 중간에 대괄호 있을 땐 인덱스..
//                let name1 = json["boxOfficeResult"]["dailyBoxOfficeList"][0]["movieNm"].stringValue
//                let name2 = json["boxOfficeResult"]["dailyBoxOfficeList"][1]["movieNm"].stringValue
//                let name3 = json["boxOfficeResult"]["dailyBoxOfficeList"][2]["movieNm"].stringValue
                
//                //리스트에 넣기
//                self.movieList.append(contentsOf: [name1, name2, name3])
                
                for i in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue { //arrayValue: 접근 전까지 돌겠다.
                    let movieNm = i["movieNm"].stringValue
                    let openDt = i["openDt"].stringValue
                    
                    //스트링배열에 무비배열 담을 수 없으니
                    let data = Movie(title: movieNm, release: openDt)
                    
                    self.movieList.append(data)
                }
                
                //뷰랑 따로 노니까 갱신
                self.movieTableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
        
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell")!
        
        cell.textLabel?.text = movieList[indexPath.row].title
        cell.detailTextLabel?.text = movieList[indexPath.row].release
        
        return cell
    }
    
    
    
}
