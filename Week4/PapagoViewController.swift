//
//  PapagoViewController.swift
//  Week4
//
//  Created by 박소진 on 2023/08/10.
//

import UIKit

class PapagoViewController: UIViewController {

    @IBOutlet var originTextView: UITextView!
    @IBOutlet var translateTextView: UITextView!
    @IBOutlet var requestButton: UIButton!
    
    //1. 갖고온다.(나중에 5번으로 뺌)
//    let helper = UserDefaultsHelper()
//    //결국 이것도 뷰컨마다 쓰임(생성할 때 마다 공간 생김. 낭비임) -> 그래서 헬퍼 클래스 안에 타입 프로퍼티 생성(5번) 한 공간만 사용! - 싱글턴 패턴
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //2.이것이 곧.. 밑에 주석처리한 유저디폴트 부르기 //6.
        UserDefaultsHelper.standard.nickname
        UserDefaultsHelper.standard.age
//        helper.nickname
//        helper.age

        //3. 이런식으로 적용 //7.
        originTextView.text = UserDefaultsHelper.standard.nickname
//        originTextView.text = helper.nickname
        
        //4. 저장을 하고싶다 //8.
        UserDefaultsHelper.standard.nickname = "칙촉"
//        helper.nickname = "칙촉"
        
//        UserDefaults.standard.set("고래밥", forKey: "nickname")
//        UserDefaults.standard.set(33, forKey: "age")
//
//        //닐 값이..들어갈 수 있어서 강제해제하면 앱 꺼질 수 있음...
//        UserDefaults.standard.string(forKey: "nickname")
//        UserDefaults.standard.integer(forKey: "age")
        
        translateTextView.isEditable = false //수정 안되게
        
    }
    
    @IBAction func requestButtonClicked(_ sender: UIButton) {
        
        TranslateAPIManager.shared.callRequest(text: originTextView.text ?? "") { result in //번역한 결과에 대한 스트링 값 result (in 앞의 이름은 내가 짓는 것)
            self.translateTextView.text = result //이렇게 했으면 상단에 임폴트 없애도 됨!
        }
    
    }
    
}
