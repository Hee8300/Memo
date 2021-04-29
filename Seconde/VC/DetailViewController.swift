//
//  DetailViewController.swift
//  Seconde
//
//  Created by 홍태희 on 2021/04/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var memoTableView: UITableView!
    
    var memo : Memo?
    
    let formatter : DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr") //월(April)을 한글로
        return f
    }()
    
    @IBAction func share(_ sender: Any) {
        
        guard let memo = memo?.content else { return }
        
        //공유
        let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
        present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func deleteMemo(_ sender: Any) {
        let alert = UIAlertController(title: "삭제 확인", message: "메모를 삭제할까요?", preferredStyle: .alert)
        
        //style - destructive : 빨강색으로 표시
        let okAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] (action) in
            DataManager.shared.deleteMemo(self?.memo)
            
            //메모창을 pop 하기위해서 navigationController 호출
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.children.first as? ComposeViewController {
            vc.editTarget = memo
        }
    }
    
    //Notification 토큰 저장
    var token : NSObjectProtocol?
    
    //옵저버 해제 코드
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //옵저버 추가
        token = NotificationCenter.default.addObserver(forName: ComposeViewController.memoDidChange, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            //테이블뷰 리로드
            self?.memoTableView.reloadData()
        })
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

extension DetailViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 테이블뷰가 표시할 셀 숫자
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 테이블뷰가 어떤 셀을 표시할지
        // row 속성으로 접근시 무슨 셀인지 알 수 있다.
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath)
            
            cell.textLabel?.text = memo?.content
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
            
            cell.textLabel?.text = formatter.string(for: memo?.insertDate)
            
            return cell
            
        default:
            fatalError()
        }
    }
    
    
}
