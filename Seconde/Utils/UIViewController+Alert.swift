//
//  UIViewController+Alert.swift
//  Seconde
//
//  Created by 홍태희 on 2021/04/21.
//

import UIKit

//경고창 함수
extension UIViewController {
    func alert(title : String = "알림", message : String) {
        //preferredStyle : 경고문 팝업 스타일
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //handler : 버튼을 탭했을 때 실행될 코드설정
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        
        //경고창 화면에 표시
        present(alert, animated: true, completion: nil)
    }
}
