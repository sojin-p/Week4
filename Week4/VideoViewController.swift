//
//  VideoViewController.swift
//  Week4
//
//  Created by 박소진 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

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
    var page = 1
    var isEnd = false //현재 페이지가 마지막 페이지인지 점검하는 프로퍼티

    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoTableView.delegate = self
        videoTableView.dataSource = self
        videoTableView.prefetchDataSource = self
        videoTableView.rowHeight = 120
        
        searchBar.delegate = self
        

    }
    
    func callRequest(query: String, page: Int) {
        guard let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = "https://dapi.kakao.com/v2/search/vclip?query=\(text)&size=10&page=\(page)" //한글은 인식이 안됨, 한글에 대한 처리(인코딩) 필요
        let header: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakaoAK)"]
        
//        print(url)
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                //상태코드 받아보기
                print(response.response?.statusCode)
                
                let statusCode = response.response?.statusCode ?? 500 //만약 statusCode가 닐이면 500으로.. 이거 나중에 바꿔야
                
                if statusCode == 200 {
                    
                    self.isEnd = json["meta"]["is_end"].boolValue //페이지 관리
                    
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
        page = 1 //검색하면 페이지도 다시 1부터 시작해야하니까
        videoList.removeAll()
        
        guard let query = searchBar.text else { return }
        callRequest(query: query, page: page)
        
        view.endEditing(true)
    }
}

extension VideoViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell") as? VideoTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = videoList[indexPath.row].title
        cell.contentLabel.text = videoList[indexPath.row].contents
        
        if let url = URL(string: videoList[indexPath.row].thumbnail) {
            cell.thumnailImgeView.kf.setImage(with: url)
        }
        
        return cell
    }
    
    //UITableViewDataSourcePrefetching: iOS10 이상 사용 가능한 프로토콜,
    //cellForRowAt 메서드 호출 전에 미리 호출됨
    
    //셀이 화면에 보이기 직전에 필요한 리소스를 미리 다운받는 기능
    //videolist 갯수와 indexPath.row 위치를 비교해 마지막 스크롤 시점을 확인 -> 네트워크 요청 시도
    //page count 체크
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            //셀의 마지막이란, 배열 갯수와 셀의 인덱스가 같아지는 시점. (인덱스는 0부터니까 배열갯수-1)
            if videoList.count - 1 == indexPath.row && page < 15 && !isEnd { //맥스페이지 이상 넘어가면 안되니까, 페이지가 끝인지 아닌지
                page += 1 //페이지수 올리고
                callRequest(query: searchBar.text!, page: page) //기존 글자 기준으로 서버통신 해달라
            }
        }
        
    }
    
    //취소 기능: 직접 취소하는 기능을 구현해야 함!
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        //프리패칭을 하다가 사용자가 스크롤 엄청 내리면 지나간 건 사진 등을 다운할 필요가 없으니까 취소를 해줘
        print("====취소: \(indexPaths)")
    }
}
