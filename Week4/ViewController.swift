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
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    
    //빈 배열에서 만든 구조체로 바꾸기
    var movieList: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //항상 뷰디드로드에 놓고 뭐가 문제인지 판단해가기
//        callReauest()
        
        movieTableView.rowHeight = 60
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
        
        searchBar.delegate = self
        
        indicatorView.isHidden = true
        
    }
    
    func callReauest(date: String) {
        //호출되면 요청 전에 보여짐
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        
        //왜 안될까 ? url이 https가 아니고 http임 - info에서 바꾸기 - ATS
        //인증키 관리 중요!!! -> .gitignore로 중요한 키 숨기기
        let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(APIKey.boxOfficeKey)&targetDt=\(date)"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                for i in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    let movieNm = i["movieNm"].stringValue
                    let openDt = i["openDt"].stringValue
                    
                    //스트링배열에 무비배열 담을 수 없으니
                    let data = Movie(title: movieNm, release: openDt)
                    
                    self.movieList.append(data)
                }
                
                self.indicatorView.stopAnimating()
                self.indicatorView.isHidden = true // 뷰에 보여주기 전에 다시 숨기기
                //뷰랑 따로 노니까 갱신
                self.movieTableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
        
    }

}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        movieList.removeAll()
        //20220101 > 1. 8글자만 가능 2. 20203333 올바른 날짜 형식인지 3. 날짜 범주(어제까지만 됨..)
        callReauest(date: searchBar.text!)
        
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

