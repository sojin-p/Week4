//
//  UserdefaultHelper.swift
//  Week4
//
//  Created by 박소진 on 2023/08/11.
//

import Foundation

class UserDefaultsHelper {
    
    //5.
    static let standard = UserDefaultsHelper() //싱글턴 패턴
    
    //9. 위를 해둬도 다른VC에서 초기화 됨. 그럼 의미가 없어지니까 안되게 제약걸기!
    private init() { } //접근 제어자 (싱글턴 패턴과 세트~!)
    
    let userDefaults = UserDefaults.standard
    
    //enum이 왜 클래스 안에 있는가? -> 다른 파일에서 쓸 일 없고 이 안에서만 쓸 거니까! (컴파일 최적화)
    enum Key: String {
        case nickname, age
    }
    
    //PropertyWrapper(이런 게 여러 개면? 다 비슷하게 생겼는데.. 그걸 또 개선하는 개념) - 나중에 배울 것
    var nickname: String {
        get {
            return userDefaults.string(forKey: Key.nickname.rawValue) ?? "대장"
        }
        set {
            return userDefaults.set(newValue, forKey: Key.nickname.rawValue)
        }
    }
    
    var age: Int {
        get {
            return userDefaults.integer(forKey: Key.age.rawValue)
        }
        set {
            return userDefaults.set(newValue, forKey: Key.age.rawValue)
        }
    }
    
}
