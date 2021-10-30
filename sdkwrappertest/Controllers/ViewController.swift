//
//  ViewController.swift
//  sdkwrappertest
//
//  Created by Ruben Mimoun on 24/09/2021.
//

import UIKit
import Firebase
import FirebaseWrapperSPM

class ViewController:  TableViewController  {

    weak var coordinator: MainCoordinator?
    let db = DBWrapper()
    var ref : DatabaseReference!
    var refJon : DatabaseReference!
    var user  = User(age: 29, name: "Bob ", city: "London", food: "Couscous", gender: "mal", date: "22/03/1994", pets: [Pet(name: "Bounton"), Pet(name: "Tagada"), Pet(name: "Telma")])
    var toFirestoreButton : UIBarButtonItem?
    var toStorageButton : UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initTableView()
        initNavigationBar()
        self.title = "DBWrapper Example"
        ref = db.getRef().child("Users/friends/")
        refJon = db.getRef().child("Users/friends/JonDo")
        dbWrapperTest()
       // writeToDb()
    }

    func initNavigationBar(){
        toFirestoreButton = UIBarButtonItem(title : "Firestore", style: .plain, target: self, action: #selector(toFirestore))

        toStorageButton = UIBarButtonItem(title : "Storage", style: .plain, target: self, action: #selector(toStorage))
        navigationItem.leftBarButtonItem = toStorageButton
        navigationItem.rightBarButtonItem = toFirestoreButton
    }
    
    func dbWrapperTest(){

//        db.observe(for: ref, eventType: .childAdded, valueType: User.self) {[weak self] result in
//            switch result{
//            case .failure(let error):
//                print(error)
//            case .success(let decodable):
//                print("OBSERVE", decodable.self)
//                self?.dataSource.append(decodable)
//                DispatchQueue.main.async {
//                    self?.tableView?.reloadData()
//                }
//            }
//        }

        
        db.getData(for: ref, decode: User.self) {[weak self] result  in
            switch result{
            case .failure(let error):
                print(error)
            case .success(let decodable):
                print("getData", decodable.self)
                self?.dataSource = decodable
                DispatchQueue.main.async {
                    self?.tableView?.reloadData()
                }
            }
        }
        

        db.getData(for: ref){result in
            switch result{
            case .failure(let error):
                print(error)
            case .success(let data):
                print("GETDATA", data)

            }
        }



        db.getData(for: "name", in: refJon) { result in
            switch result {
            case .failure(let error):
            print(error)
            case .success(let data):
            print("GETDATA FOR VALUE", data)
            }
        }
        
        db.getDataOnceForEvent(event: .childAdded) { result in
            switch result{
            case .failure(let error):
            print(error)
            case .success(let data):
            print("GET DATA ONCE FOR EVENT CHILD ADDED",data)
            }
        }
        
        db.getDataOnceForEvent(for: ref, event: .childAdded,decode: User.self) { result in
            switch result{
            case .failure(let error):
            print(error)
            case .success(let data):
            print("GET DATA ONCE FOR EVENT CHILD CHANGED - decodable ",data)
            }
        }
        
        db.updateChildrenValues(in: refJon, paths: "name", "food", values: "ruben","merguez")
        
        user.name = "Yael"
        writeToDb()
        
    }
    
    
    func writeToDb(){
        let date =  Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        let strDate = dateFormatter.string(from: date)

        db.write(at: "Users/friends/\(user.name)", value: user.toDict())
    }
    
    @IBAction func ToFirestoreAction(_ sender: Any) {
        print(coordinator == nil)
       toFirestore()
    }
    
    @IBAction func toStorageAction(_ sender: Any) {
       toStorage()
    }
    
    @objc func toFirestore() {
        let vc = FirestoreVC.instantiate()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func toStorage() {
        let vc = StorageVC.instantiate()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ViewController : Storyboarded{
    
}
