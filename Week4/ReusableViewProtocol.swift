//
//  ReusableViewProtocol.swift
//  Week4
//
//  Created by 박소진 on 2023/08/11.
//

import UIKit

protocol ReusableViewProtocol { //보통 이름은 형용사
    static var identifier: String { get }
}

//이렇게하면 VC마다 identifier를 쓸 필요가 없음! 프로토콜은 없어도 되지만, 좀 더 구조적으로....무튼 더 좋은가봄
extension UIViewController: ReusableViewProtocol {
    
    static var identifier: String {
        return String(describing: self)
    }
    
}

extension UITableViewCell: ReusableViewProtocol {
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
