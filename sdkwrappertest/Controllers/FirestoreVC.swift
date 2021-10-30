//
//  FirestoreVC.swift
//  sdkwrappertest
//
//  Created by Ruben Mimoun on 16/10/2021.
//

import Foundation
import UIKit
import FirebaseWrapperSPM

class FirestoreVC : TableViewController, Storyboarded{
    
    let firestoreWrapper = FiretoreWrapper()
    let user  = User(age: 29, name: "Jhon ", city: "London", food: "Couscous", gender: "mal", date: "02/03/1993", pets: [Pet(name: "Bounton"), Pet(name: "Tagada"), Pet(name: "Telma")])

    override func viewDidLoad() {
        self.title =  "FireStore Test"
       // addDocument()
       // addDocumentWithId()
       // updateData()
      //  retrieveDataOnce()
      initTableView()
      retrieveMultiple()
        
      //  retrieveAll()
    }
    
    
    func addDocument(){
        firestoreWrapper.addData(collectionName: "Users", data: user) { result in
            switch result{
            case .success(let documentId):
                print("ADD DOCUMENT" , documentId)
            case .failure(let error):
                print("ADD DOCUMENT", error.localizedDescription)
            }
        }
    }
    
    func addDocumentWithId(){
        firestoreWrapper.addDocumentWitId(collectionName: "Users", data: user, documentId: "Weirdo")
    }
    
    
    func updateData(){
        firestoreWrapper.updateData(for: "Weirdo", in: "Users", data: ["age":120]) { result in
            switch result{
            case .success(let documentId):
                print("UPDATE DATA" , "\(documentId) successfully updated")
            case .failure(let error):
                print("UPDATE DATA", error.localizedDescription)
            }
        }
    }
    
    func retrieveDataOnce(){
        firestoreWrapper.retrieveOnce(from: "Users", where: "Weirdo", decode: User.self) { result in
            switch result{
            case .success(let value):
                print("RETRIEVE DATA ONCE" , value)
            case .failure(let error):
                print("RETRIEVE DATA ONCE", error.localizedDescription)
            }
        }
    }
    
    func retrieveMultiple(){
        let query = firestoreWrapper.getQueryEqualTo(in: "Users", for: "city", value: "London")
        firestoreWrapper.retrieveMultipleOnce(from: query, decode: User.self) { [weak self]result in
            switch result{
            case .success(let values):
                print("RETRIEVE MULTIPLE ONCE", values)
                self?.dataSource = values
                DispatchQueue.main.async {
                    self?.tableView?.reloadData()
                }
            case .failure(let error):
                print("RETRIEVE MULTIPLE ONCE ", error.localizedDescription)
            }
        }
    }
    
    func retrieveAll(){
        firestoreWrapper.retrieveAllOnce(from: "Users", decode: User.self) { result in
            switch result{
            case .success(let values):
                values.forEach { user in
                    print("PETS RETRIEVED FROM ALL" , user?.pets ?? "NO PETS" )
                }
            case .failure(let error):
                print("RETRIEVE MULTIPLE", error.localizedDescription)
            }
        }
    }
    
    
    
}
