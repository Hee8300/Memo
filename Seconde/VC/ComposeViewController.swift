//
//  ComposeViewController.swift
//  Seconde
//
//  Created by 홍태희 on 2021/04/20.
//

import UIKit

class ComposeViewController: UIViewController {

    //편집모드
    var editTarget : Memo?
    //편집 이전의 메모내용 저장
    var originalMemoContent : String?
    
    @IBAction func Close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var memoTextView: UITextView!
    
    
    @IBAction func Save(_ sender: Any) {
        guard let memo = memoTextView.text, memo.count > 0 else {
            alert(message: "메모를 입력하세요")
            
            return
        }
        
//        let newMemo = Memo(content: memo)
//        Memo.dummyMemoList.append(newMemo)
        
        if let target = editTarget {
            //텍스트뷰에 입력된 값으로 메모를 변경
            target.content = memo
            //saveContext 메소드 호출
            DataManager.shared.saveContext()
            
            NotificationCenter.default.post(name: ComposeViewController.memoDidChange, object: nil)
        } else {
            //쓰기모드라면
            DataManager.shared.addNewMemo(memo)
            
            //앱을 구성하는 모든 객체로 전달 (Notification)
            NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)
        }
        
        //새로 만든 창 닫기
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //초기화 코드 구현
        if let memo = editTarget {
             //전달된 메모존재
            navigationItem.title = "메모 편집"
            memoTextView.text = memo.content
            
            originalMemoContent = memo.content
        } else {
            //없을시
            navigationItem.title = "새 메모"
            memoTextView.text = ""
        }
        
        memoTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.presentationController?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.presentationController?.delegate = nil
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ComposeViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        //원본과 다른지 비교
        if let original = originalMemoContent, let edited = textView.text {
            if #available(iOS 13.0, *) {
                isModalInPresentation = original != edited
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

extension ComposeViewController : UIAdaptivePresentationControllerDelegate {
    //위의 시트에서 풀다운시 호출
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        //경고창
        let alert = UIAlertController(title: "알림", message: "편집한 내용을 저장할까요?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] (action) in
            self?.Save(action)
        }
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { [weak self] (action) in
            self?.Close(action)
        }
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension ComposeViewController {
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
    static let memoDidChange = Notification.Name(rawValue: "memoDidChange")
}
