//
//  TableViewParent.swift
//  sdkwrappertest
//
//  Created by Ruben Mimoun on 23/10/2021.
//

import Foundation
import UIKit

class TableViewController : UIViewController{
    
    var tableView : UITableView?
    var dataSource : [Any] = []
    let cellIdentifier = "cell"
    
    override func viewDidLoad() {
    }
    
    
    func initTableView(){
        tableView =  UITableView()
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        guard let tableView = tableView else {
            return
        }

        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}


extension TableViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell  = tableView.dequeueReusableCell(withIdentifier: cellIdentifier){
            let label =  UILabel()
            cell.addSubview(label)
            label.frame = cell.bounds
            label.text =  String(describing:dataSource[indexPath.row])
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    
}
