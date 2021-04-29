//
//  DataManager.swift
//  Seconde
//
//  Created by 홍태희 on 2021/04/22.
//

import Foundation
import CoreData

class DataManager {
    static let shared = DataManager()
    private init() {
        //Singleton PATTERN 알아보기.
        
    }
    
    //context 객체 사용
    var mainContenxt : NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var memoList = [Memo]()
    
    func fetchMemo() {
        let request : NSFetchRequest<Memo> = Memo.fetchRequest()
        
        //날짜 내림차순 정렬
        let sortByDataDesc = NSSortDescriptor(key: "insertDate", ascending: false)
        request.sortDescriptors = [sortByDataDesc]
        
        //실행하고 데이터를 가져온다 (뒤에 throw가 있으면 예외 사항이 있다는것 - do catch 선언)
        do {
            memoList = try mainContenxt.fetch(request)
        } catch {
            print(error)
        }
    }
    
    //비어있는 인스턴스 생성
    func addNewMemo(_ memo : String?) {
        let newMemo = Memo(context: mainContenxt)
        
        //값채우기
        newMemo.content = memo
        newMemo.insertDate = Date()
        
        //memoList 배열에 바로저장 (가장 앞부분에 저장)
        memoList.insert(newMemo, at: 0)
        
        //데베에 저장하려면 context에 저장해야함
        saveContext()
    }
    
    //옵셔널로 선언했지만 실제로 메모가 전달된 경우에만 삭제
    func deleteMemo(_ memo : Memo?) {
        if let memo = memo {
            mainContenxt.delete(memo)
            saveContext()
        }
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Seconde")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
