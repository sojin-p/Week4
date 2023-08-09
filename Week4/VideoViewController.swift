//
//  VideoViewController.swift
//  Week4
//
//  Created by 박소진 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Video {
    let title: String
    let author: String
    let date: String
    let time: Int
    let thumbnail: String
    let link: String
    
    var contents: String {
        "\(author) | \(time)회\n\(date)"
    }
}

class VideoViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var videoTableView: UITableView!
    
    var videoList: [Video] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoTableView.delegate = self
        videoTableView.dataSource = self
        videoTableView.rowHeight = 120
        
        searchBar.delegate = self
        

    }
    
    func callRequest(query: String) {
        guard let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = "https://dapi.kakao.com/v2/search/vclip?query=\(text)" //한글은 인식이 안됨, 한글에 대한 처리(인코딩) 필요
        let header: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakaoAK)"]
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                //상태코드 받아보기
                print(response.response?.statusCode)
                
                let statusCode = response.response?.statusCode ?? 500 //만약 statusCode가 닐이면 500으로.. 이거 나중에 바꿔야
                
                if statusCode == 200 {
                    for i in json["documents"].arrayValue {
                        
                        let title = i["title"].stringValue
                        let author = i["author"].stringValue
                        let date = i["datetime"].stringValue
                        let time = i["play_time"].intValue
                        let thumbnail = i["thumbnail"].stringValue
                        let link = i["url"].stringValue
                        
                        let data = Video(title: title, author: author, date: date, time: time, thumbnail: thumbnail, link: link)
                        
                        self.videoList.append(data)
                    }
                } else {
                    //나중에 번호마다 대응해야함
                    print("잠시 후 다시 시도해주세요!")
                }
                //갱신 필수
                self.videoTableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension VideoViewController: UISearchBarDelegate {
    
    //바뀔때마다 서버통신하면 위험..! 그래서 엔터 칠 때만 호출
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        videoList.removeAll()
        guard let query = searchBar.text else { return }
        callRequest(query: query)
        
    }
}

extension VideoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell") as? VideoTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = videoList[indexPath.row].title
        cell.contentLabel.text = videoList[indexPath.row].contents
        return cell
    }
    
}
