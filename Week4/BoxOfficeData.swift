//
//  BoxOfficeData.swift
//  Week4
//
//  Created by 박소진 on 2023/08/14.
//

import Foundation

// MARK: - BoxOffice
struct BoxOffice: Codable {
    let boxOfficeResult: BoxOfficeResult
}

// MARK: - BoxOfficeResult
struct BoxOfficeResult: Codable {
    let showRange: String
    let dailyBoxOfficeList: [DailyBoxOfficeList]
    let boxofficeType: String
}

// MARK: - DailyBoxOfficeList
struct DailyBoxOfficeList: Codable {
    let salesAmt, salesAcc, audiCnt, salesInten: String
    let scrnCnt: String
    let rankOldAndNew: RankOldAndNew
    let audiChange, audiInten, showCnt, movieNm: String
    let rnum, openDt, salesChange, rankInten: String
    let salesShare, movieCD, rank, audiAcc: String

    enum CodingKeys: String, CodingKey {
        case salesAmt, salesAcc, audiCnt, salesInten, scrnCnt, rankOldAndNew, audiChange, audiInten, showCnt, movieNm, rnum, openDt, salesChange, rankInten, salesShare
        case movieCD = "movieCd"
        case rank, audiAcc
    }
}

enum RankOldAndNew: String, Codable {
    case old = "OLD"
}
